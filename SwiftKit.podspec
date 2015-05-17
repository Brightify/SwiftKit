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
                       An optional longer description of SwiftKit

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
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

  # spec.source_files = 'Pod/Classes/**/*'
  # spec.resource_bundles = {
  #   'SwiftKit' => ['Pod/Assets/*.png']
  # }

  spec.subspec 'Events' do |events|
    eventu.source_files = 'Events/**/*.swift'
    eventu.frameworks = 'UIKit'
  end

  # spec.public_header_files = 'Pod/Classes/**/*.h'
  # spec.frameworks = 'UIKit', 'MapKit'
  # spec.dependency 'AFNetworking', '~> 2.3'


end
