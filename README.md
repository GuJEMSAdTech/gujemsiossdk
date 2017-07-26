# gujemsiossdk
 
[![Version](https://img.shields.io/cocoapods/v/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![License](https://img.shields.io/cocoapods/l/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
[![Platform](https://img.shields.io/cocoapods/p/gujemsiossdk.svg?style=flat)](http://cocoapods.org/pods/gujemsiossdk)
 
## Example Project
 
To run the example project, clone the repo, and run `pod install` from the Example directory first.
 
 
## Requirements
 
The SDK supports **iOS 8.0 and higher**.  
Language Support: **Objective-C**  
Use **Xcode 8.1 or higher**.
 
 
## Installation
 
gujemsiossdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile and run `pod install` from the command line.
 
```ruby
pod "gujemsiossdk"
```
 
Make sure you have a recent version of CocoaPods installed. We used version 1.0.0 and saw problems with older version of CocoaPods.
 
If you don't have CocoaPods installed so far, check the [CocoaPods documentation](https://guides.cocoapods.org/using/using-cocoapods.html).  
If you don't want to use CocoaPods you should be able to copy the classes from this workspace and manually add 
the dependencies like we did in `gujemsiossdk.podspec`. Anyway we do not recommend to do the installation without CocoaPods.
 
## Changelog
 
#### v3.2.0-beta-1 |  12/July/2017
- Updated Google Mobile Ads SDK to version 7.20.0
- Teads removed / Smartclip added in preliminary version
- Pubmatic SDK for Header Bidding added (preliminary)
- Facebook Audience Network SDK added
- Native Ad Functionality over XML added
- iq digital app events Functionality added
 
#### v3.1.10 | 19/Dec/2016
Moved deployment target from iOS7 to iOS8. Make sure your project has a minimum deployment target of 8.0.
 
#### v3.1.11 | 27/Jan/2017
Updated mapping of Ad Space IDs to Ad Unit IDs.
 
#### v3.1.12 | 20/Mar/2017
Updated mapping of Ad Space IDs to Ad Unit IDs.
 
#### v3.1.13 | 20/Mar/2017
Fixed version numbers for Google-Mobile-Ads-SDK and GoogleAds-IMA-iOS-SDK-For-AdMob.
 
## New in 3.2.0
Version 3.2.0 includes the following updates:
- In this version Teads has been removed
- The current version includes updates for Facebook Audience Network SDK. The app can retrieve a facebook placement ID from the Google SDK, which is then handled by our SDK automatically.
- We have added Pubmatic Header Bidding. With Pubmatic TKP it becomes possible to compare the DFP-Ad-Server with other campaigns over DFP mediation or a key-value-solution. 
- Native Ad Functionality over XML has been implemented as an interface between the iOS SDK and a publisher server to request a XML-file. The XML-content can be used in a native ad view, which app developers can style individually (look & feel) in their apps.
- iq digital app events Functionality added. The app events consist of a name and a "data" string. The events "setsize", "noad" and "log" are available. Please see the example app source code or the iq digital documentation for details. "setsize" can be problematic when used inside a scrollable container and should not be used for ads at the bottom of a container.
 
 
## Handling App Transport Security in iOS 9
 
Important note on App Transport Security (ATS) in iOS 9: A lot of content delivered by the DFP Server is using URLs not
yet switched to secure HTTPS. To avoid trouble loading ads with this SDK we recommend to switch of ATS for now.
 
Adding the following to your Info.plist will disable ATS:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
<true/>
```
 
See this [Google Developers Blog Post](http://googleadsdeveloper.blogspot.no/2015/08/handling-app-transport-security-in-ios-9.html)
for details.
 
## New in 3.1.x: Inflow Video Ads
 
In version 3.1.x we added a new feature: Inflow Video Ads.
We are using the IMA iOS SDK to load the video ads, then start the video and expand a placeholder once the user scrolls this into view.
If no video ad is available from the DFP server, there is a fallback to use 
[Teads iOS SDK](http://mobile.teads.tv/sdk/documentation/) without the need for you to add this fallback on your own.
Read more in the [Usage](#inflow) chapter.
 
 
## Upgrading from v2.1.x to v3.x.x
 
If you are not upgrading just [skip this chapter](#usage).
 
If you previously used version 2.1.x of this SDK there are several important changes you need to pay attention to.
 
Under the hood we exchanged the Amobee Ad Server with Googles DoubleClick for Publishers (DFP).
 
Also we did some cleanup to make the SDK better understandable.
 
 
#### Remove old SDK installation
 
First step during upgrade from 2.1.x is to remove all libraries and files belonging to the old SDK installation.
This includes libGUJAdViewContext.a, libGUJAdViewContextSimulator.a, GUJAdViewContext.h, GUJAdViewControllerDelegate.h,
ORMMAResourceBundle.bundle, VideoAdLib.bundle and may be others depending on your installation.
 
Then add the new SDK as CocoaPod to your pod file and run `pod install` as described above.
 
 
 
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
 
... if you also want to set the custom criteria position (pos) and index (ind):
 
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
 
Instead we added the following delegate methods to the `GUJAdViewContextDelegate` protocol:
 
```objective-c
/*!
 * Tells the delegate that a full screen view will be presented in response to the user clicking on
 * an ad. The delegate may want to pause animations and time sensitive interactions.
 */
- (void)bannerViewWillPresentScreenForContext:(GUJAdViewContext *)context;
 
/*!
 *  Tells the delegate that the full screen view will be dismissed.
 */
- (void)bannerViewWillDismissScreenForContext:(GUJAdViewContext *)context;
 
/*!
 *  Tells the delegate that the full screen view has been dismissed. The delegate should restart
 *  anything paused while handling adViewWillPresentScreen:.
 */
- (void)bannerViewDidDismissScreenForContext:(GUJAdViewContext *)context;
 
/*!
 *  Tells the delegate that the user click will open another app, backgrounding the current
 *  application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
 *  are called immediately before this method is called.
 */
- (void)bannerViewWillLeaveApplicationForContext:(GUJAdViewContext *)context;
```
 
 
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
 
 
#### Adjusted completion handlers for banners and interstitials
 
The initialization completion handler for banners will now return a `DFPBanner` view, instead of `GUJAdView` before.
 
```objective-c
typedef BOOL (^adViewCompletion)(DFPBannerView *_adView, NSError *_error);
```
 
For interstitials there is a separate completion handler now, which directly returns a `GADInterstitial`:
 
```objective-c
typedef BOOL (^interstitialAdViewCompletion)(GADInterstitial *_interstitial, NSError *_error);
```
 
 
 
<a name="usage"></a>
## Usage 
 
If you are not migrating from a 2.1.x version this is your starting point!
 
Loading and displaying Banner Ads, Interstitial Ads or Native Ads is straight forward. :)
 
You always start by creating a `GUJAdViewContext`. Define a class variable to keep the reference.  
Then set the delegate and specify the position and whether it is an ad on an index page (vs. article). 
The position can be any value between 1 and 10. You can use the predefined constants `GUJ_AD_VIEW_POSITION_TOP` (1),
`GUJ_AD_VIEW_POSITION_MID_1` (2), `GUJ_AD_VIEW_POSITION_MID_1` (3) or `GUJ_AD_VIEW_POSITION_BOTTOM` (10) to set the position.
 
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
 
e.g. to load a banner view with a completion handler:
 
```objective-c
- (void)viewDidAppear:(BOOL)animated {
    
    ...
    [adViewContext adView:^BOOL(DFPBannerView *_adView, NSError *_error) {
           
            if (_error == nil) {
                // banner ready, do some layout setup
            } else {
                // handle the error
            }
            return YES; // whether or not the banner should show 
        }];
        
}
```
 
 
A couple of additional delegate callbacks can be implemented to interact with the banner view while loading/ showing/ hiding:
 
```objective-c
- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;
- (void)bannerViewInitializedForContext:(GUJAdViewContext *)context;
- (void)bannerViewWillLoadAdDataForContext:(GUJAdViewContext *)context;
- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context;
```
 
See the documentation in the header file for further information.
 
 
#### banner view sizes
 
By default the GUJAdViewContext will allow all possible ad view sizes in a request to the DFP server.
You can limit the possible sizes, by disabling some of them via the following methods:
 
```objective-c
- (void)disableMediumRectangleAds;
- (void)disableTwoToOneAds;
- (void)disableBillboardAds;
- (void)disableDesktopBillboardAds;
- (void)disableLeaderboardAds;
```
 
Alternatively if the only ad size you want to show from the current `GUJAdViewContext` is a smart banner, you can
limit the possible ad sizes to this by calling the `- (void)allowSmartBannersOnly` method.
The above listed disabling methods will then have no additional effect. A smart banner typically is 
50 pixels in height on iPhone/iPod and 90 pixels on iPad.
 
 
#### add an optional content URL for further targeting
 
You can add an optional content URL on the `GUJAdViewContext` to be used in the the DFP request.
This is a URL of a website displaying equivalent content like your current view.
The DFP server will parse the content of the URL for additional targeting.
 
```objective-c
- (void)setContentURL:(NSString *)contentURL;
```
 
#### Set the publisher provided identifier (PPID)
 
You can set a publisher provided identifier (PPID) on the `GUJAdViewContext` for use in frequency capping, 
audience segmentation and targeting, sequential ad rotation, and other audience-based ad delivery controls across devices.
Please do not set the PPID unless otherwise agreed.
```objective-c
- (void)setPublisherProvidedID:(NSString *)publisherProvidedID;
```
 
 
 
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
 
Load a native ad and handle the result via delegate callbacks:
 
```objective-c
- (void)viewDidAppear:(BOOL)animated {
 
    ...
    [adViewContext loadNativeAd];
 
}
 
 
- (void)nativeContentAdLoaderDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    // handle the error
}
 
 
- (void)nativeContentAdLoaderDidLoadDataForContext:(GUJAdViewContext *)context {
    headlineLabel.text = context.nativeContentAd.headline;
    bodyLabel.text = context.nativeContentAd.body;
    
    ...
 
}
```
 
The created native ad object is of type `GADNativeContentAd` known from the Google SDK for DFP users on iOS.
To display the native ad make your view extend `GADNativeContentAdView` as described in the [Google SDK for DFP documentation](https://developers.google.com/mobile-ads-sdk/docs/dfp/ios/native).
`GADNativeContentAdView` will automatically track views and clicks and it will make 
the whole ad clickable to allow the user to be redirected to the specified click-through-URL.
 
 
#### Load native ad from XML
 
For loading a native ad from XML, use `GUJNativeAdManager` to create one or several native ads for the same view.
Load a native ad with method `loadAd` of `GUJNativeAd` and handle the result via delegate callbacks:
 
```objective-c
self.adManager = [GUJNativeAdManager new];
 
GUJNativeAd *ad = [self.adManager nativeAdWithUnitID:<YOUR ADUNIT ID>];
ad.baseClickUrl = <BASE CLICK URL>;
ad.delegate = self;
[ad loadAd];
```
 
```objective-c
- (void)nativeAdDidLoad:(GUJNativeAd *)nativeAd {
 
    //you need associate GUJNativeAd with UIView where display ad 
    [nativeAd registerViewForInteraction:<vUIView where display ad>];
}
 
- (void)nativeAd:(GUJNativeAd *)nativeAd didFailWithError:(NSError *)error {
 
}
 
- (void)nativeAdDidClick:(GUJNativeAd *)nativeAd {
    
}
```
 
For tracking views and clicks call `registerViewForInteraction` after loading ad
 
 
#### load PubMatic ad
 
Load a native ad and handle the result via delegate callbacks:
 
```objective-c
self.bannerContext = [GUJPubMaticAdContext adWithAdUnitId:<YOUR ADUNIT ID> publisherId:<YOUR PUBLISHER ID>];
    self.bannerContext.delegate = self;
    [self.bannerContext loadBannerViewForViewController:self];
```
 
    
    
```objective-c
- (void)bannerViewDidLoad:(GUJAdViewContext *)adViewContext {
 
}
 
- (void)bannerView:(GUJAdViewContext *)adViewContext didFailWithError:(NSError *)error {
 
}
```



#### Load native Facebook ad

For loading a native Facebook ad use `GUJFacebookNativeAdManager`

```objective-c
self.adManager = [[GUJFacebookNativeAdManager alloc] init];
self.adManager.delegate = self;
[self.adManager loadWithAdUnitId:<YOUR ADUNIT ID> inController:self];
```

`GUJFacebookNativeAdManager` with delegate callbacks will return `FBNativeAd` object, or `GUJAdViewContext` if ad doesn't contain facebook placement id, or error

```objective-c
-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didLoadAdDataForContext:(GUJAdViewContext *)context {
}

-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didLoadNativeAd:(FBNativeAd *)nativeAd {
}

-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didFailWithError:(NSError *)error {
} 
```

#### Iq Digital app events

`GUJIQAdViewContext` can handle events in ad with callbacks:

```objective-c
-(void) iqAdView:(GUJIQAdViewContext *) viewContext didReceivedLog:(NSString *) log {
}

-(void) iqAdView:(GUJIQAdViewContext *) viewContext changeSize:(CGSize) size duration:(CGFloat) duration {
}

-(void) iqAdViewDidRemoveFromView:(GUJIQAdViewContext *) viewContext {
}
```

#### loading video ads with the IMA iOS SDK
 
 
For the integration of preroll videos we included the IMA iOS SDK Version 3 (Beta).  
You can find an example in our example app which is based on the Google example in the official documentation 
of the IMA iOS SDK.
 
See the [IMA iOS SDK documentation](https://developers.google.com/interactive-media-ads/docs/sdks/ios/) for any details.
 
To load video ads you need an ad tag URL.  
You receive your ad tag URL from the [G+J EMS Team](#contact).  
It should look similar to this:
 
```
https://pubads.g.doubleclick.net/gampad/ads?sz=480x360&iu=/6032/sdktest/preroll&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=[timestamp]
```
 
<a name="inflow"></a>
#### integrate inflow video ads (new in 3.1.x)
 
Inflow video ads are thought to be presented/ expanded on a scroll view once the user scrolled to a given position.
 
To add an inflow ad in your xib file of storyboard add a placeholder view somewhere between other views on your scrollview.
Give it the width of the scroll view and add an autolayout constraint for the height with an initial value of 0.
Keep in mind to also set the autolayout constraints top, left, right, bottom to link the placeholder view to the superview and/ or its other subviews. 
Connect the views and the autolayout constraint as outlets to your view controller:
 
```objective-c
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *inFlowAdPlaceholderView;
    __weak IBOutlet NSLayoutConstraint *inFlowAdPlaceholderViewHeightConstraint;
```
 
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    ...
    
    inflowAdViewContext = [[GUJInflowAdViewContext alloc] initWithScrollView:scrollView
                                                     inFlowAdPlaceholderView:inFlowAdPlaceholderView
                                     inFlowAdPlaceholderViewHeightConstraint:inFlowAdPlaceholderViewHeightConstraint
                                                                 dfpAdunitId:<YOUR ADUNIT ID>
    ];
}
```

 
Then in the `viewDidAppear` method call:
 
```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ...
    
    [inflowAdViewContext containerViewDidAppear];
}
```
 
In the `viewWillDisappear` method call `containerViewWillDisappear`, so the video can be paused and resumed once the user comes back.
 
 
```objective-c
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ...
    
    [inflowAdViewContext containerViewWillDisappear];
}
```
 
 
## Submitting your App to App Review
 
During submission of your App for App Review you will be asked whether your app uses the Advertising Identifier (IDFA).
This question needs to be answered with Yes.
 
Then select that your app uses the Advertising Identifier to "Serve advertisements within the app".
 
If you submit the app again for another review in the future, you will need to fill out the questions again.
 
 
 
<a name="contact"></a>
## Contact
 
In case of any questions send us an email or give us a call!
 
 
**Sebastian Otte**  
Technical Projects Manager  
\+ 49 (0) 40 / 3703 2991  
otte.sebastian@ems.guj.de
 
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
 
 
