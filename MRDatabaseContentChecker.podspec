#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "MRDatabaseContentChecker"
  s.version          = "0.1.0"
  s.summary          = "Check what's in your database during testing"
  s.description      = <<-DESC
                       MRDatabaseContentChecker will check the content of
                       database tables and queries against arrays containing
                       the expected rows. It'll intelligently figure out the
                       types of the expected values and use appropriate checks
                       for equality (e.g., regex matching).
                       DESC
  s.homepage         = "https://github.com/mikerhodes/MRDatabaseContentChecker"
  s.license          = {:type => 'Apache', :text => license}
  s.author           = { "Michael Rhodes" => "mike.rhodes@gmail.com" }
  s.source           = { :git => "https://github.com/mikerhodes/MRDatabaseContentChecker/MRDatabaseContentChecker.git", :tag => s.version.to_s }

  # s.platform     = :ios, '6.0'
  # s.ios.deployment_target = '6.0'
  # s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets/*.png'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'

  s.dependency 'FMDB', '~> 2.0'
end
