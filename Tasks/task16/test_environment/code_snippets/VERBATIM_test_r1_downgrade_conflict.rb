# Simulated Podfile testing Response 1's downgrade advice
# This demonstrates the conflict scenario Response 1 doesn't warn about

platform :ios, '11.0'

target 'TestApp' do
  # Response 1's verbatim downgrade suggestion:
  pod 'Firebase/Auth', '~> 10.25.0'
  pod 'Firebase/Firestore', '~> 10.25.0'
  pod 'Firebase/Storage', '~> 10.25.0'

  # But what if you also have a dependency that requires Firebase 11+?
  # Example: A third-party analytics library
  # pod 'SomeAnalyticsSDK', '~> 5.0'
  # which internally depends on: Firebase/Core >= 11.0

  # CocoaPods will fail with:
  # [!] CocoaPods could not find compatible versions for pod "Firebase/Core":
  #   In Podfile:
  #     Firebase/Auth (~> 10.25.0) was resolved to 10.25.0, which depends on
  #       Firebase/Core (= 10.25.0)
  #
  #     SomeAnalyticsSDK (~> 5.0) was resolved to 5.0.0, which depends on
  #       Firebase/Core (>= 11.0)
end
