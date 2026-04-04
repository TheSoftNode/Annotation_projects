platform :ios, '12.0'  # ✅ Updated to 12.0

use_frameworks! :linkage => :static

use_modular_headers!

target 'YourApp' do

  # React Native

  pod 'React', :path => '../node_modules/react-native/'

  pod 'React-Core', :path => '../node_modules/react-native/'

  pod 'React-DevSupport', :path => '../node_modules/react-native/'

  pod 'React-RCTActionSheet', :path => '../node_modules/react-native/'

  pod 'React-RCTAnimation', :path => '../node_modules/react-native/'

  pod 'React-RCTBlob', :path => '../node_modules/react-native/'

  pod 'React-RCTImage', :path => '../node_modules/react-native/'

  pod 'React-RCTLinking', :path => '../node_modules/react-native/'

  pod 'React-RCTNetwork', :path => '../node_modules/react-native/'

  pod 'React-RCTSettings', :path => '../node_modules/react-native/'

  pod 'React-RCTText', :path => '../node_modules/react-native/'

  pod 'React-RCTVibration', :path => '../node_modules/react-native/'

  pod 'React-cxxreact', :path => '../node_modules/react-native/ReactCommon/cxxreact'

  pod 'React-jsi', :path => '../node_modules/react-native/ReactCommon/jsi'

  pod 'React-jsiexecutor', :path => '../node_modules/react-native/ReactCommon/jsiexecutor'

  pod 'React-jsinspector', :path => '../node_modules/react-native/ReactCommon/jsinspector'

  pod 'ReactCommon/jscallinvoker', :path => '../node_modules/react-native/ReactCommon'

  pod 'ReactCommon/turbomodule/core', :path => '../node_modules/react-native/ReactCommon'

  pod 'Yoga', :path => '../node_modules/react-native/ReactCommon/yoga'

  # Firebase (via @react-native-firebase)

  pod 'RNFirebase', :path => '../node_modules/@react-native-firebase/app'

  pod 'RNFirebaseAuth', :path => '../node_modules/@react-native-firebase/auth'

  pod 'RNFirebaseFirestore', :path => '../node_modules/@react-native-firebase/firestore'

  pod 'RNFirebaseStorage', :path => '../node_modules/@react-native-firebase/storage'

  # If using Firebase directly (not via wrapper):

  # pod 'Firebase/Auth'

  # pod 'Firebase/Firestore'

  # pod 'Firebase/Storage'

  # Other pods...

end
