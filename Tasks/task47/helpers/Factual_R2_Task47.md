There is **no code snippet** in this response to compile or run verbatim. The fair way to test it is a **cloud benchmark**, and AWS’s own Lambda testing guide says **cloud-based tests provide the most accurate measure** for serverless applications. Between your two options, use **GitHub Codespaces** for repeatable CLI work, but for the actual latency comparison use a small **EC2 instance in the same AWS Region** as your services. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/dotnet-csharp-testing.html?utm_source=chatgpt.com))

Install these before testing:

* AWS CLI v2  
* `jq`  
* `curl`  
* one load tool: `k6` or `vegeta`

## **Claim breakdown**

1. Claim: **"Yes — a \~40 % end-to-end latency drop is possible"**  
   Assessment: **Possible in principle, but not an AWS-documented general fact.** I did not find an official AWS source promising any universal percentage reduction for this migration. AWS’s own testing guidance says you need cloud-based tests to determine real behavior for your application. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/dotnet-csharp-testing.html?utm_source=chatgpt.com))  
2. Claim: **"In practice most workloads see *no change* or a *slight increase* due to Lambda cold-starts, SDK marshalling, and the fact that containers that stay warm already handle lightweight requests in under 10 ms."**  
   Assessment: **Not supported as written.** AWS docs confirm cold starts exist and that provisioned concurrency and SnapStart help, but I did **not** find an official AWS source saying “most workloads” behave this way or that warm containers “already handle lightweight requests in under 10 ms.” AWS only documents that provisioned concurrency is designed for **double-digit millisecond** response times and SnapStart can reduce startup from **several seconds to as low as sub-second** in optimal cases. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html?utm_source=chatgpt.com))  
3. Claim: **"enable provisioned concurrency or SnapStart for Java \+ .NET (if available)"**  
   Assessment: **Supported in direction, but underspecified.** Current AWS docs say SnapStart is available for **Java 11+**, **Python 3.12+**, and **.NET 8+** managed runtimes. Provisioned concurrency is documented as reducing cold-start latency and making functions available with **double-digit millisecond** response times. So “if available” is now outdated for supported .NET 8+ managed runtimes. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/snapstart.html?utm_source=chatgpt.com))  
4. Claim: **"replace an Aurora read-heavy workload with DynamoDB/Global Tables or DAX-accelerated tables"**  
   Assessment: **Supported as a plausible optimization direction, but not as a guaranteed latency outcome.** AWS docs say DynamoDB is designed for **single-digit millisecond performance**, DAX can improve eventually consistent read latency by **an order of magnitude** from milliseconds to microseconds, and DynamoDB global tables typically replicate changes within about **a second or less**. None of that guarantees your full request latency will improve by a fixed amount. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))  
5. Claim: **"rewire front-end requests to use Lambda Function URLs or an ALB target group (avoiding the “Classic” API Gateway overhead), *you can cut average request latency by \~30–50 %*"**  
   Assessment: **Partly supported, partly unsupported.** AWS docs confirm Lambda Function URLs exist, ALB can target Lambda, and API Gateway exposes `Latency` and `IntegrationLatency` so you can measure gateway overhead. But I did **not** find an official AWS source promising a general **30–50%** latency reduction from that routing change, and “Classic API Gateway” is not AWS’s current official product naming. AWS’s official comparison is **REST APIs** vs **HTTP APIs**. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/urls-configuration.html?utm_source=chatgpt.com))  
6. Claim: **"Compute (app logic \+ framework init) | 5–20 ms (ALB→container)"**  
   Assessment: **Not supported by primary AWS docs as a general number.** I did not find an official AWS source establishing **5–20 ms** as a normal ALB-to-container compute range across workloads. ([AWS Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/lambda-functions.html?utm_source=chatgpt.com))  
7. Claim: **"\~1 ms when a Lambda is *warm*; adds \~10–20 ms for invocation overhead but can be mitigated by *minimal APIs* or *plain Lambda handlers*."**  
   Assessment: **Not supported as written.** AWS docs do not publish a universal **\~1 ms warm compute** figure or a universal **10–20 ms invocation overhead** figure. AWS does document minimal APIs on Lambda and documents provisioned concurrency / SnapStart, but not those exact timings. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/csharp-package-asp.html?utm_source=chatgpt.com))  
8. Claim: **"DB access (single-row lookup) | 20–50 ms (Aurora @ql) | 5–10 ms (DynamoDB)"**  
   Assessment: **Mixed.** DynamoDB’s **single-digit millisecond** performance is documented. I did **not** find an official AWS source giving **20–50 ms** as a general Aurora latency or **5–10 ms** as a guaranteed DynamoDB latency range for all cases. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))  
9. Claim: **"Network (ALB/APIGW ↔ Lambda) | 10–30 ms | Skip the “classic” API Gateway overhead by using Lambda Function URLs or ALB target group → 0–5 ms."**  
   Assessment: **Not supported as written.** AWS docs let you measure API Gateway overhead using `Latency` and `IntegrationLatency`, and they document Function URLs and ALB Lambda targets. I did **not** find an official AWS source for the fixed **10–30 ms** and **0–5 ms** numbers. ([AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html?utm_source=chatgpt.com))  
10. Claim: **"Cold-start (first invocation) | 1–3 s (Lambda), 0–10 ms (container) | Eliminated by Provisioned Concurrency or SnapStart (Java)."**  
    Assessment: **Partly supported, partly unsupported.** AWS does say provisioned concurrency removes cold-start behavior for invocations that use it, and SnapStart can reduce startup to **sub-second** in optimal cases. But current official AWS guidance does **not** establish **1–3 s** as the general Lambda cold-start range here; AWS’s current Fargate-vs-Lambda guide gives Lambda cold starts as roughly **100 ms to 2 seconds**. I also did not find an official AWS source for **0–10 ms** containers. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html?utm_source=chatgpt.com))  
11. Claim: **"VPC attachment (ENI creation) | 5–15 s (when Lambda in VPC) | Avoid VPC entirely (public DynamoDB endpoint or VPC endpoint without ENI creation)."**  
    Assessment: **Not supported, and partly contradicted by current docs.** Current AWS docs explain that VPC-attached Lambda functions use **Hyperplane ENIs**. AWS docs do **not** give a standard **5–15 second** penalty here. AWS also says DynamoDB **gateway endpoints** let you avoid internet gateways and NAT, but gateway endpoints do **not** use AWS PrivateLink. So the response mixes together Lambda VPC attachment, DynamoDB gateway endpoints, and interface endpoints in a way that is not accurate as a single claim. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html?utm_source=chatgpt.com))  
12. Claim: **"Use *Provisioned Concurrency* (or *SnapStart* if you can convert to Java)."**  
    Assessment: **Supported in principle, but incomplete.** Provisioned concurrency is officially documented for reducing cold-start latency. SnapStart is not only for Java anymore; AWS now documents support for **.NET 8+** and **Python 3.12+** managed runtimes too. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html?utm_source=chatgpt.com))  
13. Claim: **"Access DynamoDB via a *VPC endpoint* that uses a PrivateLink with no ENI creation, or simply use the public endpoint."**  
    Assessment: **Contradicted by current AWS docs as written.** AWS docs say **gateway endpoints** for DynamoDB do **not** use AWS PrivateLink, while **interface endpoints** do use AWS PrivateLink and are represented by one or more **ENIs**. So “PrivateLink with no ENI creation” is not correct. ([AWS Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html?utm_source=chatgpt.com))  
14. Claim: **"DynamoDB returns \~5 ms under 1 MB payload; no per-row join cost."**  
    Assessment: **Partly supported, partly unsupported.** DynamoDB docs do support the broader idea that DynamoDB omits JOINs and is designed for single-digit millisecond performance. I did **not** find an official AWS source for the exact **\~5 ms under 1 MB payload** wording. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))  
15. Claim: **"Workload that is high-concurrency but not so high you saturate the Lambda concurrency allotments (e.g. \< 50 k concurrent invocations per account)."**  
    Assessment: **Not supported as a general default, and misleading without quota context.** AWS’s default account concurrency limit is **1,000 concurrent executions per Region**, not 50,000. Quotas can be raised, but **\<50k** is not the documented default baseline. AWS also documents a concurrency scaling rate of **1,000 additional concurrent executions every 10 seconds** for each synchronously invoked function. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html?utm_source=chatgpt.com))  
16. Claim: **"Framework bootstrap (ASP.NET, entity-framework) can cost 5–10 ms; eliminating it brings Lambda closer to native env."**  
    Assessment: **Not supported by official AWS docs as a fixed number.** AWS docs do support ASP.NET minimal APIs on Lambda, but I did **not** find an official AWS source for the exact **5–10 ms** bootstrap figure here. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/csharp-package-asp.html?utm_source=chatgpt.com))  
17. Claim: **"Cuts per-item latency from \~5 ms to 0.1–0.9 ms."**  
    Assessment: **Directionally supported, exact numbers unsupported.** AWS docs say DAX provides **microsecond latency** and can reduce eventually consistent read latency by **an order of magnitude** from single-digit milliseconds to microseconds. I did **not** find an official AWS source for the exact **0.1–0.9 ms** range. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html?utm_source=chatgpt.com))  
18. Claim: **"If you meet the conditions above and get a *37–42 %* drop in P95/P99, you have hit the 40 % target."**  
    Assessment: **This is arithmetic framing, not an AWS factual claim.** There is nothing to verify here beyond your own benchmark results.  
19. Claim: **"Energy-heavy cold starts (5–15 s) will dominate latency surges."**  
    Assessment: **Not supported by current AWS docs as written.** AWS docs describe cold starts, provisioned concurrency, and SnapStart, but I did **not** find an official AWS source establishing **5–15 seconds** as a standard cold-start range here. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html?utm_source=chatgpt.com))  
20. Claim: **"Large payloads | \> 6 MB | Lambda sync payload restriction; fallback to S3 or API Gateway binary mode adds \> 30 ms."**  
    Assessment: **Partly supported, partly unsupported.** AWS docs do confirm the Lambda invocation payload limits: **6 MB synchronous**, **1 MB asynchronous**, and **200 MB** for streamed synchronous responses. I did **not** find an official AWS source saying that the fallback path adds **\>30 ms**. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html?utm_source=chatgpt.com))  
21. Claim: **"DynamoDB’s transactional APIs are slower; you fall back to Aurora or a secondary store."**  
    Assessment: **Not supported by current AWS docs as a universal latency rule.** AWS docs document DynamoDB transactions, but I did **not** find an official AWS source claiming they are generally slower than Aurora transactions in the blanket way this response states. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/metrics-dimensions.html?utm_source=chatgpt.com))  
22. Claim: **"Warm invocation still starts the Core host (12–15 ms)."**  
    Assessment: **Not supported by official AWS docs.** I did **not** find a primary AWS source giving a universal **12–15 ms** warm ASP.NET Core host startup overhead in Lambda. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/csharp-package-asp.html?utm_source=chatgpt.com))  
23. Claim: **"ENI creation \+ slow EFS read can add 50-200 ms."**  
    Assessment: **Not supported as written.** AWS docs describe VPC-attached Lambda networking through Hyperplane ENIs, but I did **not** find an official AWS source for a general **50–200 ms** latency penalty here. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html?utm_source=chatgpt.com))  
24. Claim: **"Use DynamoDB \+ minimal API \+ provisioned concurrency"** for **"\> 30 %"** latency drop.  
    Assessment: **Reasonable architecture advice, not an AWS-documented latency guarantee.** AWS docs support each building block individually, but not the promised percentage outcome. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))  
25. Claim: **"Stay with containers; Lambda will add overhead in the warm case."**  
    Assessment: **Not supported as a universal AWS fact.** AWS docs do not state a general rule that warm Lambda necessarily adds more end-to-end latency than containers for all low-volume workloads. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html?utm_source=chatgpt.com))  
26. Claim: **"the default container environment will often out-perform a vanilla serverless stack"**  
    Assessment: **Not supported by primary AWS docs as written.** I did not find an official AWS source making that blanket comparative claim.  
27. Claim: **"budget a *2-week migration window*"**  
    Assessment: **Not a factual AWS claim.** This is project advice/opinion, not something you can verify from AWS documentation.

## **What I would flag as the most likely inaccuracies**

1. **"VPC endpoint that uses a PrivateLink with no ENI creation"** — current AWS docs disagree with this wording because DynamoDB gateway endpoints do **not** use PrivateLink, and interface endpoints are represented by **ENIs**. ([AWS Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html?utm_source=chatgpt.com))  
2. **"\< 50 k concurrent invocations per account"** — AWS’s documented default account concurrency is **1,000**, not 50,000. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html?utm_source=chatgpt.com))  
3. **"SnapStart ... Java \+ .NET (if available)"** — current AWS docs say SnapStart is already available for **.NET 8+** managed runtimes. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/snapstart.html?utm_source=chatgpt.com))  
4. The exact latency numbers like **5–20 ms**, **\~1 ms**, **10–20 ms**, **20–50 ms**, **0–5 ms**, **5–15 s**, **0.1–0.9 ms**, **12–15 ms**, and **50–200 ms** are mostly **not backed by official AWS docs** in the generic way they’re presented. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))

## **Manual testing plan**

There is no runnable code in the response, so test the **claims** instead.

### **Best environment**

* **Best overall:** a temporary **EC2 instance in the same Region** as your services  
* **If choosing only between Mac and Codespaces:** use **Codespaces**  
* **Do not use your home network as the final source of truth** for latency claims

AWS’s own .NET Lambda testing guide says **cloud-based tests provide the most accurate measure**. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/dotnet-csharp-testing.html?utm_source=chatgpt.com))

### **Dependencies**

Install:

aws \--version

jq \--version

curl \--version

k6 version

If `k6` is missing in Codespaces:

sudo gpg \-k

sudo apt-get update

sudo apt-get install \-y gnupg ca-certificates

curl \-fsSL https://dl.k6.io/key.gpg | sudo gpg \--dearmor \-o /usr/share/keyrings/k6-archive-keyring.gpg

echo "deb \[signed-by=/usr/share/keyrings/k6-archive-keyring.gpg\] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list

sudo apt-get update

sudo apt-get install \-y k6

### **Test 1: verify the payload-limit claim**

This tests:

* **"Low payload, \<= 6 MB"**  
* **"Lambda sync payload restriction"**

Expected result if the response is right on this part: Lambda synchronous requests should respect the **6 MB** limit, and asynchronous ones should respect the **1 MB** limit. AWS documents those limits directly. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html?utm_source=chatgpt.com))

### **Test 2: verify the Function URL / API Gateway routing claim**

Create three front doors for the same Lambda:

* Lambda Function URL  
* API Gateway HTTP API  
* API Gateway REST API  
* optionally ALB target group with Lambda

Expected result if the response is right in direction: the routing layers should show measurable overhead differences, but the response’s exact **0–5 ms** and **10–30 ms** numbers are not doc-backed and must be measured. Use API Gateway’s `Latency` and `IntegrationLatency` metrics; AWS defines `Latency` as full gateway time and `IntegrationLatency` as backend-only time. ([AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-metrics-and-dimensions.html?utm_source=chatgpt.com))

### **Test 3: verify the cold-start / provisioned concurrency / SnapStart claims**

Run the same Lambda in four modes:

* on-demand, no VPC  
* on-demand, VPC-attached  
* provisioned concurrency  
* SnapStart, if using a supported runtime

Expected result if the response is directionally right:

* provisioned concurrency should remove cold-start behavior for requests that use it  
* SnapStart should reduce startup latency for supported runtimes  
* current docs do **not** promise the response’s exact **1–3 s** or **5–15 s** figures, so compare your own measurements against the claim text, not against assumptions. AWS says a provisioned-concurrency function does not exhibit cold-start behavior, and current SnapStart docs say startup can be reduced from several seconds to sub-second in optimal cases. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/provisioned-concurrency.html?utm_source=chatgpt.com))

To inspect init behavior:

aws logs tail /aws/lambda/YOUR\_FUNCTION \--follow

Look for `INIT_REPORT` and `Init Duration`; AWS documents those logs. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtime-environment.html?utm_source=chatgpt.com))

### **Test 4: verify the DynamoDB latency claim**

Keep the business logic as thin as possible and switch only the read path to DynamoDB.

Expected result if the response is directionally right: DynamoDB service-side latency should usually be in the **single-digit millisecond** range, but the exact **\~5 ms** number is not guaranteed. AWS recommends looking at the CloudWatch `SuccessfulRequestLatency` metric, which measures time inside DynamoDB only, excluding network and client overhead. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html?utm_source=chatgpt.com))

### **Test 5: verify the DAX claim**

Run the same hot-key read path:

* direct DynamoDB  
* DynamoDB \+ DAX

Expected result if the response is directionally right: DAX should materially reduce read latency for cache-friendly eventually consistent workloads. AWS docs say DAX can reduce read latency by about an order of magnitude from single-digit milliseconds to microseconds. The exact **0.1–0.9 ms** claim still needs your own benchmark. ([AWS Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html?utm_source=chatgpt.com))

### **Test 6: verify the VPC-endpoint / ENI wording**

Run three variants:

* Lambda outside VPC, hitting public DynamoDB endpoint  
* Lambda in VPC, using a DynamoDB **gateway endpoint**  
* Lambda in VPC, using a DynamoDB **interface endpoint** if you specifically need PrivateLink behavior

Expected result:

* gateway endpoint should avoid internet gateway / NAT for DynamoDB access  
* interface endpoint is the PrivateLink option and is represented by ENIs  
* Lambda in a VPC still uses Hyperplane ENIs

This directly tests the most questionable wording in the response. ([AWS Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html?utm_source=chatgpt.com))

### **Test 7: verify the concurrency claim**

Load-test the Lambda until you approach your current concurrency limits.

Expected result:

* default account concurrency is **1,000**, unless you have a quota increase  
* per-function scaling rate is documented as **1,000 additional concurrent executions every 10 seconds** for synchronous invocations

This is where the response’s **"\< 50k concurrent invocations per account"** claim is easiest to challenge. ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html?utm_source=chatgpt.com))

### **Minimal load script**

Use the same request against each architecture.

`script.js`

import http from 'k6/http';

import { sleep } from 'k6';

export const options \= {

  vus: 50,

  duration: '2m',

};

export default function () {

  http.get(\_\_ENV.TARGET\_URL);

  sleep(1);

}

Run:

TARGET\_URL="https://your-endpoint" k6 run script.js

Capture:

* p50  
* p95  
* p99  
* error rate

### **What to collect and send back**

Send:

* the exact endpoint type you tested  
* whether Lambda was in a VPC  
* whether provisioned concurrency or SnapStart was on  
* the `k6` summary  
* CloudWatch screenshots or copied values for:  
  * API Gateway `Latency`  
  * API Gateway `IntegrationLatency`  
  * DynamoDB `SuccessfulRequestLatency`  
  * Lambda logs with any `INIT_REPORT`

That will let me map your results back to each quoted claim one by one.

