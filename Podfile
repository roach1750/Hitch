# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Hitch' do
pod 'KinveyKit'
pod 'Cosmos', '~> 7.0'

 pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'
pod 'RealmSwift'
pod 'FBSDKCoreKit'

pod 'FBSDKLoginKit'

pod 'FBSDKShareKit'
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = ‘3.0’ # or '3.0'
        end
    end
end

pod 'SwiftyJSON'


end

