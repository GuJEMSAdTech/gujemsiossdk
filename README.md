# gujemsiossdk

[![Version](https://img.shields.io/cocoapods/v/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![License](https://img.shields.io/cocoapods/l/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![Platform](https://img.shields.io/cocoapods/p/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

The SDK supports **iOS 7.0 and higher**.  
Language Support: **Objective-C**  
Use **xCode 5.0 or higher**.


## Installation

gujemsiossdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile and run `pod install` from the command line.

```ruby
pod "gujemsiossdk"
```

If you don't have CocoaPods installed so far, check the [Cocoa Pods documentation](https://guides.cocoapods.org/using/using-cocoapods.html).  
If you don't want to use CocoaPods you should be able to copy the classes from this workspace and manually add 
the dependencies like we did in `gujemsiossdk.podspec`. Anyway we do not recommend to do the installation without CocoaPods.


## Upgrading from v2.1.x to v3.0.0

If you are not upgrading just [skip this chapter](#usage).

If you previously used version 2.1.x of this SDK there are several important changes you need to pay attention to.

Under the hood we exchanged the Amobee Ad Server with Googles DoubleClick for Publishers (DFP).

Also we did some cleanup to make the SDK better understandable.


#### GUJAdViewControllerDelegate renamed to GUJAdViewContextDelegate

First we renamed `GUJAdViewControllerDelegate` to `GUJAdViewContextDelegate`, because it is the delegate of the `GUJAdViewContext`
 and has noting to do with a `GUJAdViewController`.
`GUJAdViewControllerDelegate` can still be used, but is deprecated. Simply change `GUJAdViewControllerDelegate` to `GUJAdViewContextDelegate` via search and replace in your project.


#### Reference to rootViewController

Loading ads with the `GUJAdViewContext` requires a reference to the current root viewController now.
This can be added either by using the new initialization methods (below) or simply by setting it via `adViewContext.rootViewController = <YOUR_ROOT_VIEW_CONTROLLER>;`


#### Deprecated GUJAdView Object 

All banner initialization methods that returned a `GUJAdView` in former versions 
now return a `DFPBannerView` from the Google SDK directly.
Like `GUJAdView` `DFPBannerView` also extends `UIView`.

The old delegate callbacks in the `GUJAdViewContextDelegate` protocol still return a `GUJAdView` for compatibility reasons.
It is actually only a dummy object extending UIView now. It is deprecated. You should use the new delegate methods
returning a reference to the actual `GUJAdViewContext`. The `GUJAdViewContext` then has references 
to the `bannerView`, `interstitial` or `nativeContentAd` created by it.


#### Ad Unit IDs replacing Ad Space IDs

Previously used Ad Space IDs (e.g. "12345") were replaced by Ad Unit IDs (e.g. "/stern/sport/").
For now you can continue to use the Ad Space IDs as we integrated a mapping file with does some magic for all 
previously existing Ad Space IDs.
Anyway you might want to completely switch to the new Ad Unit IDs by time.

Following methods were used to configure Google Ad Exchange backfill. The second parameter was also called Ad Unit ID,
but was an ID of format "ca-app-pub-xxxxxxxxxxxxxxxx/nnnnnnnnnn". It is ignored now, because Google 
Ad Exchange backfill is configured on server side from now on. The methods also were deprecated and should not be used anymore.

```objective-c
+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId;

+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId delegate:(id<GUJAdViewControllerDelegate>)delegate;
```

We recommend to use the new initialization methods:

```objective-c
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController;

+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewControllerDelegate>)delegate;
```

... if you also want to set the custom criteria position (pos) and index (idx):

```objective-c
adViewContext.position = <POSITION>;
adViewContext.index = <YES|NO>;
```


#### No setting of HTTP request parameters or headers

It is not possible to add HTTP request parameters or headers to an ad request
to the Google Doubleclick DFP server. That is why we removed the methods 
~~- (void)addAdServerRequestHeaderField:(NSString *)name value:(NSString *)value;~~,
~~- (void)addAdServerRequestHeaderFields:(NSDictionary *)headerFields;~~,
~~- (void)addAdServerRequestParameter:(NSString *)name value:(NSString *)value;~~ and 
~~- (void)addAdServerRequestParameters:(NSDictionary *)requestParameters;~~


Instead you can add keywords or key/ value pairs for custom targeting via the following new methods:

```objective-c
- (void)addCustomTargetingKeyword:(NSString *)keyword;

- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value;
```


#### No more mOceon backfill

We removed support for the mOceon backfill service.
That is why we skipped the property ~~@property (assign, nonatomic) BOOL mOceanBackFill;~~ and the methods
 ~~+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId site:(NSInteger)siteId zone:(NSInteger)zoneId;~~ and 
 ~~+ (GUJAdViewContext*)instanceForAdspaceId:(NSString*)adSpaceId adUnit:(NSString*)adUnitId site:(NSInteger)siteId zone:(NSInteger)zoneId delegate:(id<GUJAdViewControllerDelegate>)delegate;~~ 
 of the GUJAdViewContext.


#### Removed references to GUJAdViewController

There is no such thing as a `GUJAdViewController` in the SDK. You simply use your own UIViewControllers.
That's why we removed methods from the `GUJAdViewContextDelegate` protocol which returned a `GUJAdViewController`, which were 
~~- (void)adViewController:(GUJAdViewController*)adViewController didConfigurationFailure:(NSError*)error;~~
and
~~- (BOOL)adViewController:(GUJAdViewController*)adViewController canDisplayAdView:(GUJAdView*)adView;~~.


#### Removed references to GUJAdEvent

Also we removed methods returning references to `GUJAdEvent`, something that was removed in former versions already.
The methods ~~- (void)bannerView:(GUJAdView*)bannerView receivedEvent:(GUJAdViewEvent*)event;~~ and 
~~- (void)interstitialViewReceivedEvent:(GUJAdViewEvent*)event;~~ were removed from the `GUJAdViewContextDelegate` protocol. 


#### Removed initalizationAttempts handling

In former versions of the SDK it was possible to set a number of possible initialization attempts for checking for
availability of a view controller while loading interstitials.
We removed this mechanism and `GUJAdViewContext`s method ~~- (void)initalizationAttempts:(NSUInteger)attempts;~~ because it is the
responsibility of the developer to set a rootViewController during initialization of the `GUJAdViewContext`.


#### Removed Banner reloading

We removed the method ~~- (void)setReloadInterval:(NSTimeInterval)reloadInterval;~~ of `GUJAdViewContext` as automatic ad reloading is not wanted.
In case there should be an ad reload based on user interaction (e.g. while swiping through a gallery) it is the
developers responsibility to refresh the ad.


#### Cleanup of GUJAdViewContextDelegate

We refactored the `GUJAdViewContextDelegate` protocol, which was called `GUJAdViewControllerDelegate` before (see above).
All old methods became deprecated. Most of the methods got a replacement returning a reference to their `GUJAdViewContext`
so you can distinguish between multiple contexts. The `GUJAdViewContext` then has references to the `bannerView`,
`interstitial` or `nativeContentAd` created by it.  

The callbacks ~~-(void)bannerViewDidShow:(GUJAdView *)bannerView;~~ and
~~- (void)bannerViewDidHide:(GUJAdView *)bannerView;~~ were removed completely. Banners will always 
automatically show and showing/ hiding can be done via the `hidden` property of UIView directly when needed.


<a name="usage"></a>
## Usage 

If you are not migrating from a 2.1.x version this is your starting point!

Loading and displaying Banner Ads, Interstitial Ads or Native Ads is straight forward. :)

You always start by creating a `GUJAdViewContext`. Define a class variable to keep the reference.  
Then set the delegate and specify the position and whether it is an ad on an index page (vs. article).  
Create multiple `GUJAdViewContext` instances for every ad you want to show.

You receive your Ad Unit ID from the [G+J EMS Team](#contact), an example could be "/6032/sdktest"


```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
    adViewContext = [GUJAdViewContext instanceForAdUnitId:<YOUR ADUNIT ID> rootViewController:self];
    
    // set the delegate
    adViewContext.delegate = self;
    
    // set the position (not needed for interstitials)
    adViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    
    // set if we use the context for an index page (defaults to NO)
    adViewContext.isIndex = YES;
    ...
}
```

#### load a banner view

Load a banner view to a given origin:

```objective-c
- (void)viewDidAppear:(BOOL)animated {
    
    ...
    [adViewContext adViewWithOrigin:CGPointMake(0, 20)];

}
```

Alternatively you can simply call the `- (DFPBannerView *)adView;` method and position the returned view via
autolayout constraints or your preferred view layouting method.

The returned ad view object is of type `DFPBannerView` known from the Google SDK for DFP Users on iOS.

There are some other Ad View initialization methods that allow you to add keywords or a completion handler.
The completion handler will return immediately.

A couple of additional delegate callbacks can be implemented to interact with the banner view while loading/ showing/ hiding:

```objective-c
- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;
- (void)bannerViewInitializedForContext:(GUJAdViewContext *)context;
- (void)bannerViewWillLoadAdDataForContext:(GUJAdViewContext *)context;
- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context;
```

See the documentation in the header file for further information.


#### load an interstitial

Load an interstitial view with completion handler:

```objective-c
- (void)viewDidAppear:(BOOL)animated {
    
    ...
    [adViewContext interstitialAdViewWithCompletionHandler:^BOOL(GADInterstitial *_interstitial, NSError *_error) {
            
            if (_error == nil) {
                // interstitial ready, show it when needed
            } else {
                // handle the error
            }
            
            return NO; // whether or not the interstitial should show automatically
        }];

}
```

The returned interstitial view object is of type `GADInterstitial` known from the Google SDK for DFP Users on iOS.

A couple of additional delegate callbacks can be implemented to interact with the interstitial view while loading/ showing/ hiding:

```objective-c
- (void)interstitialViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;
- (void)interstitialViewInitializedForContext:(GUJAdViewContext *)context;
- (void)interstitialViewWillLoadAdDataForContext:(GUJAdViewContext *)context;
- (void)interstitialViewDidLoadAdDataForContext:(GUJAdViewContext *)context;
- (void)interstitialViewWillAppearForContext:(GUJAdViewContext *)context;
- (void)interstitialViewDidAppearForContext:(GUJAdViewContext *)context;
- (void)interstitialViewWillDisappearForContext:(GUJAdViewContext *)context;
- (void)interstitialViewDidDisappearForContext:(GUJAdViewContext *)context;
```

See the documentation in the header file for further information.


#### load a native ad

Load a native add and handle the result via delegate callbacks:

```objective-c
- (void)viewDidAppear:(BOOL)animated {

    ...
    [adViewContext loadNativeAd];

}


- (void)nativeAdLoaderDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    // handle the error
}


- (void)nativeAdLoaderDidLoadData:(GADNativeContentAd *)nativeContentAd ForContext:(GUJAdViewContext *)context {
    headlineLabel.text = nativeContentAd.headline;
    bodyLabel.text = nativeContentAd.body;
    
    ...

}
```

The returned native ad object is of type `GADNativeContentAd` known from the Google SDK for DFP Users on iOS.
To display the native ad make your view extend `GADNativeContentAdView` as described in the [Google SDK for DFP documentation](https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/native).
`GADNativeContentAdView` will automatically take care for tracking views and clicks and it will make 
the whole ad clickable to allow the user to be redirected to the specified click-through-URL.


#### loading video ads with the IMA iOS SDK


For integration of preroll videos we included the IMA iOS SDK Version 3 (Beta).  
You can find an example in our Example App which is based on the Google example in the official documentation 
of the IMA iOS SDK.

See the [IMA iOS SDK documentation](https://developers.google.com/interactive-media-ads/docs/sdks/ios/) for any details.

To load video ads you need an Ad Tag URL.  
You receive your Ad Tag URL from the [G+J EMS Team](#contact).  
It should look similar to this:

```
https://pubads.g.doubleclick.net/gampad/ads?sz=480x360&iu=/6032/sdktest/preroll&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=[timestamp]
```


<a name="contact"></a>
## Contact

In case of any questions send us an email or give us a call!


**Jens Jensen**  
Product Manager Mobile  
\+ 49 (0) 40 / 3703 7475  
jensen.jens@ems.guj.de

**Daniel Gerold**  
Head of Technical Projects  
\+ 49 (0) 40 / 3703 7415  
gerold.daniel@ems.guj.de

**Arne Steinmetz**  
Director Digital Ad Technology  
\+ 49 (0) 40 / 3703 7384  
steinmetz.arne@ems.guj.de


## License

gujemsiossdk is available under the BSD license. See the LICENSE file for more info.
