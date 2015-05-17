Pod::Spec.new do |spec|
    spec.name             = "SwiftKit"
    spec.version          = "0.12.0"
    spec.summary          = "SwiftKit is library for testing new ideas. Do not use unless you know what you are doing!"
    spec.description      = <<-DESC
                       SwiftKit is a template repository for new libraries from Brightify. It also serve as testing library for our new ideas. Everything here is highly experimental and every new commit can (and usually will) break a lot of things! If you are not interested in pre-pre-pre alpha testing then you should probably stay away from this.
                       DESC
    spec.homepage         = "https://github.com/Brightify/SwiftKit"
    spec.license          = 'MIT'
    spec.author           = { "Tadeas Kriz" => "tadeas@brightify.org", "Filip Dolnik" => "filip@brightify.org" }
    spec.source           = {
        :git => "https://github.com/Brightify/SwiftKit.git",
        :tag => spec.version.to_s
    }
    spec.social_media_url = 'https://twitter.com/BrightifyOrg'
    spec.requires_arc = true

    spec.platform = :ios, '8.0'

    spec.frameworks = 'Foundation'

    spec.source_files = ['Source/**/*.swift']
end
