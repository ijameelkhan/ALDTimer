#
# Be sure to run `pod lib lint ALDTimer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ALDTimer"
  s.version          = "0.1.0"
  s.summary          = "A short description of ALDTimer."
  s.description      = <<-DESC
                        The UYLPasswordManager class provides a simple wrapper around Apple Keychain
                        Services on iOS devices. The class is designed to make it quick and easy to
                        create, read, update and delete keychain items. Keychain groups are also
                        supported as is the ability to set the data migration and protection attributes
                        of keychain items.
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/ALDTimer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jameel" => "i.jameelkhan@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/ALDTimer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'ALDTimer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
