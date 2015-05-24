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
  spec.version          = "0.1.0"
  spec.summary          = "SwiftKit is a great way to start your project."
  spec.description      = <<-DESC
                       SwiftKit's main purpose is to jumpstart iOS app development.
                       Soon it will contain a lot of sub specs that will take care of most of the boilerplate.
                       DESC
  spec.homepage         = "https://github.com/brightify/SwiftKit"
  spec.license          = 'MIT'
  spec.author           = { "Tadeas Kriz" => "tadeas@brightify.org" }
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

  spec.subspec 'Injection' do |injection|
    injection.source_files = 'Injection/**/*.swift'
    injection.frameworks = 'Foundation'
  end


end
