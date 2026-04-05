# R2 Step 7: Compare the printed line to the InfluxDB structure

## InfluxDB Line Protocol Structure

According to https://docs.influxdata.com/influxdb/v2/reference/syntax/line-protocol/

### Syntax
```
measurement,tag1=val1,tag2=val2 field1=value1,field2=value2 timestamp
```

### Rules to check:
1. Everything before the first unescaped space = measurement + tags
2. Everything after the first unescaped space = field set
3. Field pairs are comma-delimited **with no spaces**
4. Tag pairs are comma-delimited **with no spaces**
5. If keys/values include spaces, commas, or equals signs, they must be escaped

## R2's Claims to Verify

### Claim: "cpu_count, cpu_min, etc., should just be field keys like count, min, 10p, etc."
**Status: DISPUTED**
- InfluxDB docs do NOT say field keys must be named only `count`, `min`, `10p`
- Prefixing them with `cpu_` is valid
- Field keys are strings subject to naming restrictions and escaping rules

### Claim: "the space after \" in += \" \" $1 ... introduces a leading space in the field list, which breaks the InfluxDB format"
**Status: DISPUTED**
- InfluxDB requires ONE space delimiter between measurement/tag set and field set
- R2 has not shown that the code creates an EXTRA invalid space beyond this required delimiter

### Claim: "the field section should start immediately after the space following the tags — no leading space"
**Status: PARTLY SUPPORTED**
- The field set does begin after the first unescaped space (correct)
- But this doesn't prove the original code's delimiter placement is the bug

## Manual verification
Compare your actual output against the documented format:
- measurement,tags SPACE fields
- No spaces within comma-separated tag pairs
- No spaces within comma-separated field pairs
