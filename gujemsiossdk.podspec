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
  s.version          = "3.1.10"
  s.summary          = "G+J EMS iOS SDK"
  s.description      = <<-DESC
                       G+J EMS iOS SDK

                       * Includes the Google-Mobile-Ads-SDK
                       * Easily integrate Banner Ads, Interstitials and Native Ads into your App by creating an
                        AdViewContext summarizing all meta information needed to load the ads from the Google DFP Server
                       * Includes the GoogleAds-IMA-iOS-SDK-For-AdMob
                       * Integrate preroll videos by loading VAST files from the Google DFP Server
                       * Version 3.x.x replaces the G+J EMS iOS SDK 2.1.x based on Amobee ad server, while keeping the same interfaces
                       * Internal mapping of previously used AdSpace IDs to new AdUnit IDs
                       * Inflow Ads
                       DESC
  s.homepage         = "https://github.com/GuJEMSAdTech/gujemsiossdk"
  s.license          = 'BSD'
  s.authors          = { "Daniel Gerold" => "gerold.daniel@ems.guj.de", "Sebastian Otte" => "otte.sebastian@ems.guj.de", "Michael Brügmann" => "mail@michael-bruegmann.de" }
  s.source           = { :git => "https://github.com/GuJEMSAdTech/gujemsiossdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'gujemsiossdk' => ['Pod/Assets/*.xml', 'Pod/Assets/*.png']
  }

  s.vendored_frameworks = 'Pod/Assets/TeadsSDK.framework'
  s.resource = "Pod/Assets/TeadsSDKResources.bundle"

  s.public_header_files = 'Pod/Classes/*.h'
  s.frameworks = 'CoreMedia', 'UIKit', 'AVFoundation', 'AdSupport', 'StoreKit', 'CoreMotion', 'CoreLocation', 'CoreTelephony', 'MediaPlayer', 'SystemConfiguration'
  s.libraries = 'xml2'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 7.0'
  s.dependency 'GoogleAds-IMA-iOS-SDK-For-AdMob'

end
