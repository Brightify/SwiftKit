#
# Be sure to run `pod lib lint SwiftKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
    spec.name             = "SwiftKit"
    spec.version          = "1.0.0"
    spec.summary          = "SwiftKit is a collection of simple libraries that make your life easier."
    spec.description      = <<-DESC
                       SwiftKit's main purpose is to jumpstart iOS app development. We strive to deliver multiple small libraries that will solve the most basic things so you will not have to do it yourself.
                       DESC
    spec.homepage         = "https://github.com/SwiftKit/SwiftKit"
    spec.license          = 'MIT'
    spec.author           = { "Tadeas Kriz" => "tadeas@brightify.org", "Filip Dolnik" => "filip@brightify.org" }
    spec.source           = {
        :git => "https://github.com/SwiftKit/SwiftKit.git",
        :tag => spec.version.to_s
    }
    spec.social_media_url = 'https://twitter.com/BrightifyOrg'
    spec.platform     = :ios, '8.0'
    spec.requires_arc = true

    spec.default_subspec = 'Events', 'Preferences', 'Injection', 'Router', 'ViewComposer'

    spec.subspec 'Events' do |events|
        events.source_files = 'SwiftKit/Events/**/*.swift'
        events.frameworks = 'UIKit'
        events.dependency 'SwiftKit/Internal'
    end

    spec.subspec 'Preferences' do |preferences|
        preferences.source_files = 'SwiftKit/Preferences/**/*.swift'
        preferences.frameworks = 'Foundation'
        preferences.dependency 'SwiftKitStaging'
        preferences.dependency 'SwiftKit/Events'
    end

    spec.subspec 'Injection' do |injection|
        injection.source_files = 'SwiftKit/Injection/**/*.swift'
        injection.frameworks = 'Foundation'
        injection.dependency 'SwiftKitStaging'
    end

    spec.subspec 'Router' do |router|
        router.source_files = 'SwiftKit/Router/**/*.swift'
        router.frameworks = 'Foundation'
        router.dependency 'SwiftKitStaging'
        router.dependency 'SwiftKit/ObjectMapper'
        router.dependency 'Alamofire', '~> 2.0'
        router.dependency 'HTTPStatusCodes'
        router.dependency 'SwiftyJSON'
    end

    spec.subspec 'ObjectMapper' do |objectMapper|
        objectMapper.source_files = 'SwiftKit/ObjectMapper/**/*.swift'
        objectMapper.dependency 'SwiftKitStaging'
        objectMapper.dependency 'SwiftyJSON'
    end

    spec.subspec 'ViewComposer' do |composer|
        composer.source_files = 'SwiftKit/ViewComposer/**/*.swift'
        composer.frameworks = 'UIKit'
        composer.dependency 'SwiftKitStaging'
        composer.dependency 'SwiftKit/Events'
    end
end
