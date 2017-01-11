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
    spec.version          = "0.11.1"
    spec.summary          = "SwiftKit is a collection of simple libraries that make your life easier."
    spec.description      = <<-DESC
                       SwiftKit's main purpose is to jumpstart iOS app development. We strive to deliver multiple small libraries that will solve the most basic things so you will not have to do it yourself.
                       DESC
    spec.homepage         = "https://github.com/Brightify/SwiftKit"
    spec.license          = 'MIT'
    spec.author           = {
        "Tadeas Kriz" => "tadeas@brightify.org",
        "Filip Dolnik" => "filip@brightify.org",
        "Maros Seleng" => "maros@brightify.org"
    }
    spec.source           = {
        :git => "https://github.com/Brightify/SwiftKit.git",
        :tag => spec.version.to_s
    }
    spec.social_media_url = 'https://twitter.com/BrightifyOrg'
    spec.platform     = :ios, '9.0'
    spec.requires_arc = true

    spec.source_files = ['AlamofireRequestPerformer/**/*.swift', 'JsonSerializer/**/*.swift', 'ObjectMapper/**/*.swift', 'Router/**/*.swift', 'RxRouter/**/*.swift']
    spec.frameworks = 'Foundation'
    spec.dependency 'Alamofire', '~> 4.0'
    spec.dependency 'HTTPStatusCodes', '~> 3.1'
    spec.dependency 'SwiftyJSON', '~> 3.1'
    spec.dependency 'RxSwift', '~> 3.0'
    spec.dependency 'Result'
end
