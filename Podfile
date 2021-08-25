platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

def app_pods
	pod 'Alamofire', '5.4.0'
	pod 'Kingfisher', '5.15.7'
	pod 'MBProgressHUD', '1.2.0'
	pod 'R.swift', '5.3.0'
	pod 'SwiftLint', '0.41.0'
	pod 'KeychainAccess', '4.2.1'
 	pod 'FBSDKLoginKit/Swift', '6.5.2'
 	pod 'GoogleSignIn', '5.0.2'
 	pod 'GoogleMaps', '4.0.0'
 	#pod 'Google-Maps-iOS-Utils'
  pod 'SwiftMessages'
	pod 'ActionSheetPicker-3.0', '2.7.1'
  pod 'ERJustifiedFlowLayout', '1.1'
  pod 'loady', '1.0.7'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'

  pod 'IQKeyboardManagerSwift', '6.5.6'
  pod 'KafkaRefresh', '1.5.0'
  pod 'OpalImagePicker', '3.0.0'

end

target 'DostupnoUA' do
  app_pods
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
