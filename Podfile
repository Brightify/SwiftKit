source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def shared
    pod 'SwiftyJSON', '~> 3.1'
    pod 'Alamofire', '~> 4.0'
    pod 'HTTPStatusCodes', '~> 3.1'
    pod 'SwiftKitStaging'
end

target 'SwiftKit' do
    shared
end

target 'Showcase' do
    shared
end

target 'SwiftKitTests' do
    pod 'Nimble', '~> 5.0'
    pod 'Quick',  :git => 'https://github.com/Quick/Quick.git', :commit => '5e38179a69efd3601dea91c8825b9c35c28f9357'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
