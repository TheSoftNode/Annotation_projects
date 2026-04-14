I’m treating only **concrete technical/product statements** in RESPONSE 2 as factual claims. I’m **not** treating the hour/week estimates, study advice, “what you’ll be able to build,” or motivational lines as factual claims, because those are judgments or projections rather than product facts. All quoted claims below are kept verbatim. ([Expo Documentation](https://docs.expo.dev/get-started/create-a-project/))

## **1\) Factual-claim breakdown from RESPONSE 2**

1. Claim: **"RN is still JavaScript – you’ll be writing the same code you already know, just with a different runtime."**

Status: **Partly supported.** React Native docs do support the idea that RN uses JavaScript and React concepts, and React docs support the JavaScript/Hook side. The softer wording about “the same code you already know” is more of an explanatory simplification than a strict product fact. ([React Native](https://reactnative.dev/docs/intro-react-native-components?utm_source=chatgpt.com))

2. Claim: **"RN uses the same hook API, but some patterns differ slightly (e.g., `useLayoutEffect`)."**

Status: **Partly supported.** The “same hook API” part is supported by React and React Native docs. The example mentioning `useLayoutEffect` is also grounded: React documents `useLayoutEffect`, and React Native documents using it for layout measurement. The phrase “patterns differ slightly” is real-world interpretation, not a directly sourceable official sentence. ([React](https://react.dev/reference/react/useState))

3. Claim: **"Same syntax, but you’ll use native UI primitives (`<View>`, `<Text>`, `<Image>`, etc.)."**

Status: **Supported.** React Native docs explicitly describe `View`, `Text`, and `Image` as core/native building blocks, and the React Native tutorial says RN uses native components instead of web components. ([React Native](https://reactnative.dev/docs/0.84/intro-react))

4. Claim: **"In RN you often add Redux, MobX, Recoil, or React Query for more complex apps; the concepts are identical."**

Status: **Partly supported.** The libraries named are real ecosystems commonly used with React apps, but the official React Native docs do not make a blanket claim that “the concepts are identical.” That last phrase is stronger than the primary docs establish. ([React Native](https://reactnative.dev/docs/navigation))

5. Claim: **"RN uses `StyleSheet` or `@types/style-modules`, not web CSS."**

Status: **Partly supported, partly disputed.** React Native docs clearly support the `StyleSheet` / JavaScript styling part. I could not find official/current evidence supporting `@types/style-modules` as an RN styling mechanism. The searchable package result points instead to `@types/css-modules`, which is a web/CSS-Modules typings package, not a React Native styling primitive. ([React Native](https://reactnative.dev/docs/style))

6. Claim: **"Different build pipelines (Metro vs. Webpack)."**

Status: **Broadly supported.** Metro’s official site describes Metro as “The JavaScript bundler for React Native.” Next.js historically uses webpack in some modes and other bundlers in newer setups, but the core point that RN’s standard bundler is Metro is supported. ([metrobundler.dev](https://metrobundler.dev/))

7. Claim: **"Navigation | React Router / Next.js `pages` | `React Navigation` (stack, tab, drawer) \+ optional `React Native Directory Navigator`."**

Status: **Partly supported, partly disputed.** React Native and Expo docs support React Navigation and Expo Router as mainstream choices, and React Navigation docs support stack/tab/drawer navigators. I found no official/current navigator called **“React Native Directory Navigator.”** React Native Directory is a package directory, not a documented navigation library. ([Expo Documentation](https://docs.expo.dev/develop/app-navigation/))

8. Claim: **"RN uses `fetch` just like the web, but network calls often hit a mobile backend (GraphQL, REST)."**

Status: **Partly supported.** React Native docs explicitly say RN provides the Fetch API and that it will feel familiar if you’ve used other web networking APIs. The “mobile backend” phrasing is reasonable but not a distinct official rule. ([React Native](https://reactnative.dev/docs/network?utm_source=chatgpt.com))

9. Claim: **"Understanding the bridge to native code and how to profile with Flipper/React DevTools."**

Status: **Partly supported, partly outdated.** React Native does support native modules/native integration. The profiling/debugging part is outdated in its Flipper emphasis: current docs say **React Native DevTools** is the built-in debugger and that it **replaces** the previous Flipper / Hermes Chrome debugging frontends. ([React Native](https://reactnative.dev/docs/turbo-native-modules-introduction?utm_source=chatgpt.com))

10. Claim: **"RN apps need e2e testing (Detox) in addition to unit tests."**

Status: **Partly supported.** Detox is real and official Detox docs describe it as an end-to-end testing framework for React Native apps. But the wording “need” is stronger than the docs prove; that part is advice, not a universal fact. ([Wix](https://wix.github.io/Detox/docs/introduction/getting-started/))

11. Claim: **"No equivalent on the web – you’ll learn how to ship binaries."**

Status: **Broadly supported in spirit.** Fastlane docs and Expo build docs support the existence of binary/app-store distribution workflows for mobile apps. The phrase “no equivalent on the web” is explanatory rather than an official product claim. ([React Native](https://reactnative.dev/docs/typescript))

12. Claim: **"Styles that look fine on iOS can break on Android (different default paddings, fonts)."**

Status: **Not directly verifiable from the primary docs I checked.** It is plausible and common in practice, but I did not find a primary source that states this exact claim as written.

13. Claim: **"Test on both simulators/emulators early; use `Platform` API."**

Status: **Supported for the technical part.** React Native does have a `Platform` API and platform-specific coding patterns; the “test early” part is advice. ([React Native](https://reactnative.dev/docs/permissionsandroid?utm_source=chatgpt.com))

14. Claim: **"RN’s Flexbox is mostly the same as web, but some properties (e.g., `alignContent`) behave differently."**

Status: **Supported in general, but not fully on the example.** React Native docs explicitly say Flexbox works like CSS on the web with a few exceptions. I did not verify the specific `alignContent` example from the current docs I checked, so that sub-example remains unverified. ([React Native](https://reactnative.dev/docs/style))

15. Claim: **"`ScrollView` renders lazily; mis-ordered state updates can cause “blank screen”."**

Status: **Disputed by current docs.** React Native docs say **`ScrollView` renders all its child components at once**, while **`FlatList` renders lazily**. So the “ScrollView renders lazily” part is contradicted by primary docs. ([React Native](https://reactnative.dev/docs/scrollview))

16. Claim: **"Use `keyExtractor`, `initialNumToRender`, or switch to `FlatList` for long lists."**

Status: **Partly supported.** `FlatList` is the right component for long lists, and `keyExtractor` / `initialNumToRender` are real `FlatList`/virtualized-list concepts. But in the original response they were presented immediately after a `ScrollView` claim, and those props are not `ScrollView` props. ([React Native](https://reactnative.dev/docs/flatlist))

17. Claim: **"`AsyncStorage` are promise-based but have different naming."**

Status: **Partly supported.** AsyncStorage is real and official docs describe it as an asynchronous key-value storage API. I did not find a primary source for the vague “different naming” part. ([Expo Documentation](https://docs.expo.dev/versions/latest/sdk/async-storage/))

18. Claim: **"Mobile apps stay alive longer, can be backgrounded, have push notifications, and need `App State` listeners."**

Status: **Partly supported.** React Native docs clearly support the `AppState` / background-foreground part and `addEventListener`. The broader statement about app lifecycle and push-notification needs is partly explanatory. ([React Native](https://reactnative.dev/docs/appstate))

19. Claim: **"Learn `AppState` and `AppState.addEventListener`."**

Status: **Supported.** `AppState` and `addEventListener()` are current React Native APIs documented in the official docs. ([React Native](https://reactnative.dev/docs/appstate))

20. Claim: **"Chrome DevTools won’t work directly; you rely on Flipper, React Native Debugger, or `node --inspect`."**

Status: **Outdated / partly disputed.** Current React Native docs say the built-in debugger is **React Native DevTools**, that it replaces the previous Flipper/Hermes-Chrome frontends, and that connecting via `chrome://inspect` is no longer supported. RN 0.79 also says React Native is no longer compatible with the `react-native-debugger` community project. ([React Native](https://reactnative.dev/docs/react-native-devtools))

21. Claim: **"Use the `Performance Monitor` in Flipper; memoize with `React.memo`, `useCallback`, `useMemo`."**

Status: **Partly supported, partly outdated.** React’s memoization APIs are real. The Flipper-specific monitoring recommendation is outdated or at least not the current default recommendation in official RN docs, which point new apps to React Native DevTools. ([React Native](https://reactnative.dev/docs/debugging?utm_source=chatgpt.com))

22. Claim: **"`reactnative.dev` is the single source of truth; includes a Getting Started guide."**

Status: **Mostly supported.** It is absolutely an official primary source and it does include getting-started/tutorial material. “Single source of truth” is a rhetorical phrase, not an official designation. ([React Native](https://reactnative.dev/docs/next/tutorial?utm_source=chatgpt.com))

23. Claim: **"Expo strips away the native-project setup for the first 2–3 weeks..."**

Status: **Partly supported as a learning recommendation.** Expo docs support the idea that Expo Go is a quick learner playground and that Expo helps you get started fast. The exact “first 2–3 weeks” part is not a factual statement from the docs. ([Expo Documentation](https://docs.expo.dev/get-started/set-up-your-environment/))

24. Claim: **"`expo init myApp` gives you a managed workflow; you can skip Xcode/Android Studio entirely while you learn UI basics."**

Status: **Partly supported, partly outdated.** Expo docs currently recommend **`create-expo-app`** to create new projects, not `expo init`. Expo Go does support a quick learning flow, but current docs also say Expo Go is limited and not useful for production-grade projects. ([Expo Documentation](https://docs.expo.dev/get-started/create-a-project/))

25. Claim: **"`<Image source={{uri: '...'}} />` (remote) or require local assets."**

Status: **Supported.** React Native `Image` docs explicitly cover remote images and local/static resources. ([React Native](https://reactnative.dev/docs/image))

26. Claim: **"`PermissionsAndroid`, `SecureStore`, `AsyncStorage`"**

Status: **Supported as named APIs/libraries.** `PermissionsAndroid` is an official RN API; `expo-secure-store` and `@react-native-async-storage/async-storage` are documented packages. ([React Native](https://reactnative.dev/docs/permissionsandroid))

27. Claim: **"`KeyboardAvoidingView`, `TextInput`, animations (`Animated`)"**

Status: **Supported as real RN APIs/components.** React Native docs document `KeyboardAvoidingView`, `TextInput`, and `Animated`. ([React Native](https://reactnative.dev/docs/keyboardavoidingview))

28. Claim: **"`expo-secure-store`"**

Status: **Supported.** Expo docs document `expo-secure-store` as encrypted key-value storage on device. ([Expo Documentation](https://docs.expo.dev/versions/latest/sdk/securestore/))

29. Claim: **"`react-native-background-fetch`"**

Status: **Supported as a real library, but not an official RN core API.** The package exists and is documented in its repository; it is not a built-in React Native API. ([GitHub](https://github.com/transistorsoft/react-native-background-fetch))

30. Claim: **"Detox"**

Status: **Supported.** Detox is an official E2E framework with public docs. ([Wix](https://wix.github.io/Detox/docs/introduction/getting-started/))

31. Claim: **"Fastlane, GitHub Actions, code signing (iOS/Android), app store submission"**

Status: **Supported in broad terms.** Fastlane is real and its docs cover iOS/Android release automation; Expo docs cover build/signing realities too. GitHub Actions exists as a CI option, though the original response did not provide a primary source for it. ([Fastlane Docs](https://docs.fastlane.tools/))

---

## **2\) Parts of RESPONSE 2 that are not clean factual claims**

These are better treated as advice, estimates, or opinion rather than fact-check targets:

* all the hour/week timelines  
* “You already know 80-90% of the JavaScript/React side”  
* “what you’ll be able to build” after each phase  
* “usually add the most extra time”  
* “must-have resources” quality judgments like “industry-standard,” “single source of truth,” “good,” “well-structured”  
* “Completing these projects in order will give you…”  
* all the schedule/productivity guidance in section 6  
* the TL;DR time estimates and “graduate to plain React Native” coaching language

Those can be evaluated for reasonableness, but not verified like API/tooling claims. ([Expo Documentation](https://docs.expo.dev/get-started/set-up-your-environment/))

## **3\) Code / manual testing plan**

There is **not much executable code** in RESPONSE 2\. What it mostly contains is:

* API/component names  
* library names  
* one concrete command: **`expo init myApp`**  
* a few JSX examples like **`<View>`**, **`<Text>`**, **`<Image source={{uri: '...'}} />`**

For fair testing, **use your Mac, not GitHub Codespaces**. React Native / Expo claims are about local mobile tooling, device testing, simulators, and native build flow. Expo’s own setup docs recommend a real device for development, and Codespaces is not a good environment for testing local device/simulator behavior. ([Expo Documentation](https://docs.expo.dev/get-started/set-up-your-environment/))

### **Dependencies to install first**

Install these before testing:

1. **Node.js (LTS)**. Expo docs list Node.js LTS as a system requirement. ([Expo Documentation](https://docs.expo.dev/get-started/create-a-project/))  
2. **Expo Go on a physical device** for the quickest learner workflow. Expo docs call Expo Go a learner playground and recommend a real device. ([Expo Documentation](https://docs.expo.dev/get-started/set-up-your-environment/))  
3. **Xcode** only if you want iOS Simulator / deeper native testing. ([Expo Documentation](https://docs.expo.dev/develop/development-builds/create-a-build/))  
4. **Android Studio** only if you want Android emulator / deeper native testing. ([Expo Documentation](https://docs.expo.dev/develop/development-builds/create-a-build/))

---

## **4\) Step-by-step manual tests**

### **Test A — exact command from the response**

Use this to test the command claim in section 6:

1. Open **Terminal** on your Mac.

Run exactly:  
expo init myApp

2.   
3. Record the full terminal output.

Expected result:

* this is the **literal** test of the response as written.  
* current Expo docs do **not** use this as the documented project-creation command; current docs point to `create-expo-app` instead. So one fair possible result today is that this exact command is unavailable, deprecated, or not the current recommended path. ([Expo Documentation](https://docs.expo.dev/get-started/create-a-project/))

What to send me:

* whether the command worked  
* whether it failed with “command not found”  
* whether it printed a deprecation or migration hint

---

### **Test B — verify the “same hook API / native primitives” claims**

Use this to test:

* **"RN uses the same hook API..."**  
* **"Same syntax, but you’ll use native UI primitives (`<View>`, `<Text>`, `<Image>`, etc.)."**

Steps:

1. Create a **current** Expo app using the official documented flow so you have a working RN project.  
2. In the starter app, import `useState`.  
3. Render a `View`, `Text`, and `Image`.  
4. Use a button or press handler to update a counter with `useState`.  
5. Run the app on your phone via Expo Go.

Expected result:

* the app renders with RN primitives like `View`, `Text`, and `Image`  
* `useState` behaves like a React Hook in the component  
* remote `Image` requires explicit dimensions according to docs. ([Expo Documentation](https://docs.expo.dev/tutorial/create-your-first-app/))

What to send me:

* whether the `useState` update worked  
* whether the `Image` rendered  
* whether it required width/height to display properly

---

### **Test C — verify the `StyleSheet` claim**

Use this to test:

* **"RN uses `StyleSheet`..."**

Steps:

1. In the same app, create a `StyleSheet.create({...})`.  
2. Apply styles to a `View` and `Text`.  
3. Change `backgroundColor`, `padding`, and `fontSize`.  
4. Save the file and watch the app reload.

Expected result:

* styles are applied via JavaScript objects / `StyleSheet`  
* this matches current RN docs. ([React Native](https://reactnative.dev/docs/style))

What to send me:

* whether the styles updated live  
* whether you had to write JS object keys like `backgroundColor`

---

### **Test D — verify the navigation claim**

Use this to test:

* **"`React Navigation` (stack, tab, drawer)..."**

Steps:

1. Create a small test project using the React Navigation starter template documented by React Native.  
2. Start the app.  
3. Inspect whether the template includes navigation setup.  
4. Add one extra screen and navigate to it.

Expected result:

* React Navigation is a current supported navigation solution  
* stack/tab/drawer navigators are real documented navigators. ([React Native](https://reactnative.dev/docs/navigation))

What to send me:

* whether the template worked  
* what navigators were included by default

---

### **Test E — verify the `fetch` claim**

Use this to test:

* **"RN uses `fetch` just like the web..."**

Steps:

1. In your Expo app, add a simple `fetch()` call inside `useEffect`.  
2. Call any public JSON endpoint.  
3. Log the response and render one field on screen.

Expected result:

* the network call works through RN’s Fetch API  
* this matches the official networking docs. ([React Native](https://reactnative.dev/docs/network?utm_source=chatgpt.com))

What to send me:

* whether the data appeared  
* whether `fetch` behaved the way you expect from web React

---

### **Test F — verify the `ScrollView` / `FlatList` claim**

Use this to test the questionable gotcha:

* **"`ScrollView` renders lazily..."**  
* **"Use `keyExtractor`, `initialNumToRender`, or switch to `FlatList` for long lists."**

Steps:

1. Create a screen with a **very long** `ScrollView` containing many children.  
2. Then create a second screen with `FlatList` using the same data.  
3. Compare the two implementations.  
4. Look at the official docs for both components while doing this.

Expected result:

* docs say **`ScrollView` renders all child components at once**  
* docs say **`FlatList` renders lazily / windowed**  
* `keyExtractor` and `initialNumToRender` belong to `FlatList` / virtualized-list behavior, not `ScrollView`. ([React Native](https://reactnative.dev/docs/scrollview))

What to send me:

* whether you saw any prop errors on `ScrollView`  
* whether `FlatList` felt more appropriate for the long list

---

### **Test G — verify `AppState` and `AppState.addEventListener`**

Use this to test:

* **"Learn `AppState` and `AppState.addEventListener`."**

Steps:

1. Import `AppState`.  
2. Add an `AppState.addEventListener('change', ...)` listener.  
3. Log state changes.  
4. Run on a real device.  
5. Background the app, then reopen it.

Expected result:

* the listener should fire with app-state changes  
* this is an officially documented RN API. ([React Native](https://reactnative.dev/docs/appstate))

What to send me:

* what states you saw  
* whether the listener fired on background/foreground

---

### **Test H — verify the debugging claim against current docs**

Use this to test:

* **"Chrome DevTools won’t work directly; you rely on Flipper, React Native Debugger, or `node --inspect`."**

Steps:

1. Open current React Native debugging docs.  
2. Look for the recommended debugger.  
3. Check whether docs still recommend Flipper / Chrome frontends for new apps.  
4. Check whether `chrome://inspect` is supported.  
5. Check whether React Native Debugger is still compatible in current releases.

Expected result:

* current docs say the built-in debugger is **React Native DevTools**  
* `chrome://inspect` is no longer supported  
* current RN docs describe Flipper/Chrome debugging as replaced  
* RN 0.79 says React Native is no longer compatible with `react-native-debugger`. ([React Native](https://reactnative.dev/docs/react-native-devtools))

What to send me:

* the exact lines you found  
* whether you think the original response is outdated on debugging

---

## **5\) What looks most inaccurate before you even start testing**

These are the lines I would scrutinize first:

1. Claim: **"RN uses `StyleSheet` or `@types/style-modules`, not web CSS."**  
   Reason: `StyleSheet` is supported, but `@types/style-modules` did not check out as an RN styling primitive. ([React Native](https://reactnative.dev/docs/style))  
2. Claim: **"`React Navigation` ... \+ optional `React Native Directory Navigator`."**  
   Reason: I found support for React Navigation and Expo Router, but not for a navigator by that exact name. ([Expo Documentation](https://docs.expo.dev/develop/app-navigation/))  
3. Claim: **"`ScrollView` renders lazily..."**  
   Reason: current RN docs say the opposite. ([React Native](https://reactnative.dev/docs/scrollview))  
4. Claim: **"Use `keyExtractor`, `initialNumToRender`..."** right after the `ScrollView` statement.  
   Reason: those are `FlatList` / virtualized-list concepts, not `ScrollView` props. ([React Native](https://reactnative.dev/docs/flatlist?utm_source=chatgpt.com))  
5. Claim: **"Chrome DevTools won’t work directly; you rely on Flipper, React Native Debugger, or `node --inspect`."**  
   Reason: current docs point new apps to React Native DevTools and explicitly say older Chrome frontend support is gone. ([React Native](https://reactnative.dev/docs/react-native-devtools))  
6. Claim: **"`expo init myApp` gives you a managed workflow..."**  
   Reason: current Expo docs use `create-expo-app` for new projects, so this exact command looks dated. ([Expo Documentation](https://docs.expo.dev/get-started/create-a-project/))

Send your reports back in the same numbered format and I’ll map each result to the exact claim.

