#
# Be sure to run `pod lib lint gujemsiossdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "gujemsiossdk"
  s.version          = "0.1.2"
  s.summary          = "G+J EMS mobile iOS SDK"
  s.description      = <<-DESC
                       G+J EMS mobile iOS SDK

                       * Helps integrating G+J EMS Google Ads
                       * Replaces G+J EMS SDK based on Amobee, while keeping the same interfaces
                       DESC
  s.homepage         = "https://github.com/GuJEMSAdTech/gujemsiossdk"
  s.license          = 'MIT'
  s.author           = { "Michael Brügmann" => "mail@michael-bruegmann.de" }
  s.source           = { :git => "https://github.com/GuJEMSAdTech/gujemsiossdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'gujemsiossdk' => ['Pod/Assets/*.xml']
  }

  s.public_header_files = 'Pod/Classes/*.h'
  s.frameworks = 'UIKit', 'AVFoundation'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 7.0'
  s.dependency 'FBSDKCoreKit', '~> 4.4.0'
  s.dependency 'FBSDKLoginKit', '~> 4.4.0'
  s.dependency 'FBSDKShareKit', '~> 4.4.0'
  s.dependency 'FBAudienceNetwork', '~> 4.1.0'
  s.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.0.beta.14'
end
