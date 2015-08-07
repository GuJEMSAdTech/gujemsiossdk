# gujemsiossdk

[![CI Status](http://img.shields.io/travis/Michael Brügmann/gujemsiossdk.svg?style=flat)](https://travis-ci.org/Michael Brügmann/gujemsiossdk)
[![Version](https://img.shields.io/cocoapods/v/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![License](https://img.shields.io/cocoapods/l/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![Platform](https://img.shields.io/cocoapods/p/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

gujemsiossdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "gujemsiossdk"
```

## Upgrading from v2.1.1 to 3.0.0

If you previously used version 2.1.1 of this SDK there are several important changes you need to pay attention to.

Under the hood we exchanged the Amobee Ad Server with Googles DoubleClick for Publishers (DFP).


We performed some clean up, to make the SDK better understandable.

First we renamed `GUJAdViewControllerDelegate` to `GUJAdViewContextDelegate`, because it is the delegate of the `GUJAdViewContext`
 and has noting to do with a `GUJAdViewController`.
`GUJAdViewControllerDelegate` can still be used, but is deprecated. Simply change `GUJAdViewControllerDelegate` to `GUJAdViewContextDelegate` via search and replace in your project.


Loading adds with the `GUJAdViewContext` requires a reference to the current root viewController now.
This can be added either by using the new initialization methods (below) or simply by setting it via `adViewContext.rootViewController = <YOUR_ROOT_VIEW_CONTROLLER>;`

All methods that returned an `GUJAdView` in former versions now return a `DFPBannerView` from the Google SDK directly.
As `GUJAdView` did `DFPBannerView` also extends `UIView`.
The methods `show:` and `hide:` of `GUJAdView` are obsolete as you can do this by calling `setHidden = YES|NO` on `UIView` classes directly
Instead of `showInterstitialView:` on `GUJAdView` you can now call `showInterstitial:` on the corresponding `GUJAdViewContext`


We removed support for the mOceon backfill service.
That is why we skipped the following properies and methods of the GUJAdViewContext:

```
@property (assign, nonatomic) BOOL mOceanBackFill;
```

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId site:(NSInteger)siteId zone:(NSInteger)zoneId;
```

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId site:(NSInteger)siteId zone:(NSInteger)zoneId delegate:(id<GUJAdViewControllerDelegate>)delegate;
```

Previously used adSpaceIds (e.g. "12345") were replaced by adUnitIds (e.g. "/stern/sport/"). For now you can continue to use the adSpaceIds as we integrated a mapping file with does some magic.
Anyway we recommend to switch to the new adUnitIds by time.
The following methods have been deprecated for this reason:

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId;
```

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId delegate:(id<GUJAdViewControllerDelegate>)delegate;
```

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId;
```

```
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId delegate:(id<GUJAdViewControllerDelegate>)delegate;
```


We recommend to use the new initialization methods:

```
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController;
```

```
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewControllerDelegate>)delegate;
```



The following methods have been removed, as it is not possible to add HTTP request parameters or headers to an request to the Google Doubleclick DFP server.

```
- (void)addAdServerRequestHeaderField:(NSString *)name value:(NSString *)value;
```

```
- (void)addAdServerRequestHeaderFields:(NSDictionary *)headerFields;
```

```
- (void)addAdServerRequestParameter:(NSString *)name value:(NSString *)value;
```

```
- (void)addAdServerRequestParameters:(NSDictionary *)requestParameters;
```

Instead you can add parameters for custom targeting via the following new methods:

```
- (void)addCustomTargetingKeyword:(NSString *)keyword;
```

```
- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value;
```


There is no such thing as a GUJAdViewController in the SDK anymore. You simply use you custom UIViewControllers.
That's why we removed methods returning GUJAdViewController:

```
- (void)adViewController:(GUJAdViewController*)adViewController didConfigurationFailure:(NSError*)error;
```

```
- (BOOL)adViewController:(GUJAdViewController*)adViewController canDisplayAdView:(GUJAdView*)adView;
```


Also we removed methods returning references to GUJAdEvent. Something that was removed in former versions already.

```
- (void)bannerView:(GUJAdView*)bannerView receivedEvent:(GUJAdViewEvent*)event;
```

```
- (void)interstitialViewReceivedEvent:(GUJAdViewEvent*)event;
```

## Author

Michael Brügmann, mail@michael-bruegmann.de

## License

gujemsiossdk is available under the MIT license. See the LICENSE file for more info.
