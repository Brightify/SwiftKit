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
  spec.version          = "0.3.0"
  spec.summary          = "SwiftKit is a collection of simple libraries that make your life easier."
  spec.description      = <<-DESC
                       SwiftKit's main purpose is to jumpstart iOS app development. We strive to deliver multiple small libraries that will solve the most basic things so you will not have to do it yourself.
                       DESC
  spec.homepage         = "https://github.com/brightify/SwiftKit"
  spec.license          = 'MIT'
  spec.author           = { "Tadeas Kriz" => "tadeas@brightify.org", "Filip Dolnik" => "filip@brightify.org" }
  spec.source           = { 
    :git => "https://github.com/brightify/SwiftKit.git", 
    :tag => spec.version.to_s
  }
  spec.social_media_url = 'https://twitter.com/BrightifyOrg'

  spec.platform     = :ios, '8.0'
  spec.requires_arc = true

  spec.subspec 'Events' do |events|
    events.source_files = 'Events/**/*.swift'
    events.frameworks = 'UIKit'
  end

  spec.subspec 'Preferences' do |preferences|
    preferences.source_files = 'Preferences/**/*.swift'
    preferences.frameworks = 'Foundation'
    preferences.dependency 'SwiftKit/Events'
  end

  spec.subspec 'Injection' do |injection|
    injection.source_files = 'Injection/**/*.swift'
    injection.frameworks = 'Foundation'
  end

  spec.subspec 'Router' do |router|
    router.source_files = 'Router/**/*.swift'
    router.frameworks = 'Foundation'
    router.dependency 'Alamofire'
    router.dependency 'ObjectMapper'
  end

end
