/*
 * BSD LICENSE
 * Copyright (c) 2015, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer .
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import <GoogleMobileAds.h>
#import "GUJAdViewContext.h"
#import "GUJAdSpaceIdToAdUnitIdMapper.h"
#import "GUJAdViewContextDelegate.h"
#import "GUJAdUtils.h"
#import <gujemsiossdk/GUJAdViewContext.h>


static NSString *const KEYWORDS_DICT_KEY = @"kw";
static NSString *const CUSTOM_TARGETING_KEY_POSITION = @"pos";
static NSString *const CUSTOM_TARGETING_KEY_INDEX = @"idx";
static NSString *const CUSTOM_TARGETING_KEY_ALTITUDE = @"psa";
static NSString *const CUSTOM_TARGETING_KEY_SPEED = @"pgv";
static NSString *const CUSTOM_TARGETING_KEY_DEVICE_STATUS = @"psx";
static NSString *const CUSTOM_TARGETING_KEY_BATTERY_LEVEL = @"pbl";

@implementation GUJAdView {
    GUJAdViewContext *context;
}

- (void)show {
    super.hidden = NO;
}


- (id)initWithContext:(GUJAdViewContext *)context1 {
    self = [super init];
    context = context1;
    return self;
}


- (void)showInterstitialView {
    [context showInterstitial];
}


- (void)hide {
    super.hidden = YES;
}


- (NSString *)adSpaceId {
    return [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdSpaceIdForAdUnitId:context.adUnitId position:context.position index:context.isIndex];
}

@end


@interface GUJAdViewContext () <GADNativeContentAdLoaderDelegate, GADBannerViewDelegate, GADInterstitialDelegate, CLLocationManagerDelegate>

@end

@implementation GUJAdViewContext {
    GADAdLoader *adLoader;
    NSMutableDictionary *customTargetingDict;
    BOOL locationServiceDisabled;
    BOOL autoShowInterstitialView;

    interstitialAdViewCompletion interstitialAdViewCompletionHandler;

    CLLocationManager *locationManager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        customTargetingDict = [NSMutableDictionary new];
        locationServiceDisabled = false;

        customTargetingDict[CUSTOM_TARGETING_KEY_BATTERY_LEVEL] = [GUJAdUtils getBatteryLevel];

        BOOL isHeadsetPluggedIn = [GUJAdUtils isHeadsetPluggedIn];
        BOOL isLoadingCablePluggedIn = [GUJAdUtils isLoadingCablePluggedIn];

        if (isHeadsetPluggedIn && isLoadingCablePluggedIn) {
            customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"c,h";

        } else if (isLoadingCablePluggedIn) {
            customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"c";

        } else if (isHeadsetPluggedIn) {
            customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"h";

        }

    }
    return self;
}


+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId {
    GUJAdViewContext *adViewContext = [[self alloc] init];
    adViewContext.adUnitId = [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdSpaceId:adSpaceId];
    adViewContext.position = [[GUJAdSpaceIdToAdUnitIdMapper instance] getPositionForAdSpaceId:adSpaceId];
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId delegate:(id <GUJAdViewContextDelegate>)delegate {
    GUJAdViewContext *adViewContext = [self instanceForAdspaceId:adSpaceId];
    adViewContext.delegate = delegate;
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId {
    // ignore adUnitId ... was ad exchange id of format "ca-app-pub-xxxxxxxxxxxxxxxx/nnnnnnnnnn"

    GUJAdViewContext *adViewContext = [self instanceForAdspaceId:adSpaceId];
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId delegate:(id <GUJAdViewContextDelegate>)delegate {
    // ignore adUnitId ... was ad exchange id of format "ca-app-pub-xxxxxxxxxxxxxxxx/nnnnnnnnnn" in v2.1.1

    GUJAdViewContext *adViewContext = [self instanceForAdspaceId:adSpaceId delegate:delegate];
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId position:(NSInteger)position rootViewController:(UIViewController *)rootViewController {
    GUJAdViewContext *adViewContext = [[self alloc] init];
    adViewContext.adUnitId = adUnitId;
    adViewContext.position = position;
    adViewContext.rootViewController = rootViewController;
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId position:(NSInteger)position rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewContextDelegate>)delegate {
    GUJAdViewContext *adViewContext = [self instanceForAdUnitId:adUnitId position:position rootViewController:rootViewController];
    adViewContext.delegate = delegate;
    return adViewContext;
}


+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController {
    return [self instanceForAdUnitId:adUnitId position:GUJ_AD_VIEW_POSITION_UNDEFINED rootViewController:rootViewController];
}


+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewContextDelegate>)delegate {
    return [self instanceForAdUnitId:adUnitId position:GUJ_AD_VIEW_POSITION_UNDEFINED rootViewController:rootViewController delegate:delegate];
}


- (void)setPosition:(NSInteger)position {
    _position = position;
    if (position != 0) {
        customTargetingDict[CUSTOM_TARGETING_KEY_POSITION] = @(position);
    } else {
        [customTargetingDict removeObjectForKey:CUSTOM_TARGETING_KEY_POSITION];
    }
}


- (void)setIsIndex:(BOOL)isIndex {
    _isIndex = isIndex;
    if (isIndex) {
        customTargetingDict[CUSTOM_TARGETING_KEY_INDEX] = @(YES);
    } else {
        [customTargetingDict removeObjectForKey:CUSTOM_TARGETING_KEY_INDEX];
    }
}


- (BOOL)disableLocationService {
    locationServiceDisabled = YES;
    return YES;
}


- (void)shouldAutoShowIntestitialView:(BOOL)show {
    [self shouldAutoShowInterstitialView:show];
}


- (void)shouldAutoShowInterstitialView:(BOOL)show {
    autoShowInterstitialView = show;
}


- (DFPRequest *)createRequest {
    DFPRequest *request = [DFPRequest request];

    if ([CLLocationManager locationServicesEnabled] && !locationServiceDisabled) {

        locationManager = [[CLLocationManager alloc] init];

        BOOL locationAllowed_iOS7 = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
        BOOL locationAllowed_iOS8 = ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]
                && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways));

        if (locationAllowed_iOS7 || locationAllowed_iOS8) {

            // we don't require a delegate and location updates
            // we simply take the last available location, if existing

            CLLocation *location = locationManager.location;

            if (location != nil) {   // might be nil on first start of app, we skip sending location data in this case
                [request setLocationWithLatitude:locationManager.location.coordinate.latitude
                                       longitude:locationManager.location.coordinate.longitude
                                        accuracy:locationManager.location.horizontalAccuracy];

                customTargetingDict[CUSTOM_TARGETING_KEY_ALTITUDE] = @((int) locationManager.location.altitude);
                customTargetingDict[CUSTOM_TARGETING_KEY_SPEED] = @((int) locationManager.location.speed);

                NSLog(@"Added location data.");
            } else {
                NSLog(@"No location data available.");
            }
        } else {
            NSLog(@"Location Services not authorized.");
        }
    }

    request.customTargeting = customTargetingDict;
    return request;
}


- (DFPBannerView *)adView {
    return [self adViewWithOrigin:CGPointZero];
}


- (void)adView:(adViewCompletion)completion {
    completion([self adView], nil);
}


- (DFPBannerView *)adViewWithOrigin:(CGPoint)origin {

    self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];

    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {  // iPad

        self.bannerView.validAdSizes = @[
                NSValueFromGADAdSize(kGADAdSizeBanner),
                NSValueFromGADAdSize(kGADAdSizeMediumRectangle),
                NSValueFromGADAdSize(kGADAdSizeFullBanner),
                NSValueFromGADAdSize(kGADAdSizeLargeBanner),
                NSValueFromGADAdSize(kGADAdSizeLeaderboard),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 50))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 75))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 150))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(320, 75))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(728, 90))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(180, 150))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 600))),
                NSValueFromGADAdSize(isLandscape ? GADAdSizeFromCGSize(CGSizeMake(1024, 220)) : GADAdSizeFromCGSize(CGSizeMake(768, 300))),
                NSValueFromGADAdSize(isLandscape ? kGADAdSizeSmartBannerLandscape : kGADAdSizeSmartBannerPortrait)
        ];

    } else {  //iPhone, iPod

        self.bannerView.validAdSizes = @[
                NSValueFromGADAdSize(kGADAdSizeBanner),
                NSValueFromGADAdSize(kGADAdSizeMediumRectangle),
                NSValueFromGADAdSize(kGADAdSizeLargeBanner),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 50))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(300, 75))),
                NSValueFromGADAdSize(GADAdSizeFromCGSize(CGSizeMake(320, 75))),
                NSValueFromGADAdSize(isLandscape ? kGADAdSizeSmartBannerLandscape : kGADAdSizeSmartBannerPortrait)
        ];


    }


    self.bannerView.adUnitID = self.adUnitId;
    self.bannerView.rootViewController = self.rootViewController;
    self.bannerView.delegate = self;

    DFPRequest *request = [self createRequest];

    if ([self.delegate respondsToSelector:@selector(bannerViewInitialized:)]) {
        [self.delegate bannerViewInitialized:(id) self.bannerView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewInitializedForContext:)]) {
        [self.delegate bannerViewInitializedForContext:self];
    }

    if ([self.delegate respondsToSelector:@selector(bannerViewWillLoadAdData:)]) {
        [self.delegate bannerViewWillLoadAdData:(id) self.bannerView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewWillLoadAdDataForContext:)]) {
        [self.delegate bannerViewWillLoadAdDataForContext:self];
    }
    [self.bannerView loadRequest:request];

    return self.bannerView;
}


- (void)adViewWithOrigin:(CGPoint)origin completion:(adViewCompletion)completion {
    completion([self adViewWithOrigin:origin], nil);
}


- (DFPBannerView *)adViewForKeywords:(NSArray *)keywords {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    return [self adView];
}


- (void)adViewForKeywords:(NSArray *)keywords completion:(adViewCompletion)completion {
    completion([self adViewForKeywords:keywords], nil);
}


- (DFPBannerView *)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    return [self adViewWithOrigin:origin];
}


- (void)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin completion:(adViewCompletion)completion {
    completion([self adViewForKeywords:keywords origin:origin], nil);
}


- (DFPInterstitial *)interstitialAdView {
    self.interstitial = [[DFPInterstitial alloc] initWithAdUnitID:self.adUnitId];
    self.interstitial.delegate = self;
    DFPRequest *request = [self createRequest];

    if ([self.delegate respondsToSelector:@selector(interstitialViewInitialized:)]) {
        [self.delegate interstitialViewInitialized:[[GUJAdView alloc] initWithContext:self]];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewInitializedForContext:)]) {
        [self.delegate interstitialViewInitializedForContext:self];
    }

    if ([self.delegate respondsToSelector:@selector(interstitialViewWillLoadAdData:)]) {
        [self.delegate interstitialViewWillLoadAdData:[[GUJAdView alloc] initWithContext:self]];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewWillLoadAdDataForContext:)]) {
        [self.delegate interstitialViewWillLoadAdDataForContext:self];
    }

    [self.interstitial loadRequest:request];

    return self.interstitial;
}


- (void)interstitialAdViewWithCompletionHandler:(interstitialAdViewCompletion)completion {
    interstitialAdViewCompletionHandler = completion;
    [self interstitialAdView];
}


- (DFPInterstitial *)interstitialAdViewForKeywords:(NSArray *)keywords {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    return [self interstitialAdView];
}


- (void)interstitialAdViewForKeywords:(NSArray *)keywords completion:(interstitialAdViewCompletion)completion {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    [self interstitialAdViewWithCompletionHandler:interstitialAdViewCompletionHandler];
}


- (void)showInterstitial {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self.rootViewController];
        if ([self.delegate respondsToSelector:@selector(interstitialViewDidAppear)]) {
            [self.delegate interstitialViewDidAppear];
        }
        if ([self.delegate respondsToSelector:@selector(interstitialViewDidAppearForContext:)]) {
            [self.delegate interstitialViewDidAppearForContext:self];
        }
    }
}


- (void)addCustomTargetingKeyword:(NSString *)keyword {
    if (customTargetingDict[KEYWORDS_DICT_KEY] != nil) {
        customTargetingDict[KEYWORDS_DICT_KEY] = [NSMutableArray new];
    }
    NSMutableArray *keywordArray = customTargetingDict[KEYWORDS_DICT_KEY];
    [keywordArray addObject:keyword];
}


- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value {
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_POSITION], @"Set the position (pos) via position property.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_INDEX], @"Set the isIndex (idx) via isIndex property.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_ALTITUDE], @"psa automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_SPEED], @"pgv automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_DEVICE_STATUS], @"psx automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_BATTERY_LEVEL], @"pbl automatically set by SDK.");
    NSAssert(![key isEqualToString:KEYWORDS_DICT_KEY], @"Set single keyword via the addKeywordForCustomTargeting: method.");
    customTargetingDict[key] = value;
}


- (void)freeInstance {
    self.bannerView.delegate = nil;
    self.interstitial.delegate = nil;
    adLoader.delegate = nil;
}


- (void)loadNativeContentAd {
    adLoader = [[GADAdLoader alloc]
            initWithAdUnitID:self.adUnitId
          rootViewController:self.rootViewController
                     adTypes:@[kGADAdLoaderAdTypeNativeContent]
                     options:@[]];
    adLoader.delegate = self;

    DFPRequest *request = [self createRequest];
    [adLoader loadRequest:request];

}


- (void)loadNativeContentAdForKeywords:(NSArray *)keywords {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    [self loadNativeContentAd];
}


# pragma mark - GADAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader1 didFailToReceiveAdWithError:(GADRequestError *)error {
    if ([self.delegate respondsToSelector:@selector(nativeContentAdLoaderDidFailLoadingAdWithError:ForContext:)]) {
        [self.delegate nativeContentAdLoaderDidFailLoadingAdWithError:error ForContext:self];
    }
}


#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader1 didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    self.nativeContentAd = nativeContentAd;
    if ([self.delegate respondsToSelector:@selector(nativeContentAdLoaderDidLoadDataForContext:)]) {
        [self.delegate nativeContentAdLoaderDidLoadDataForContext:self];
    }
}


#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if ([self.delegate respondsToSelector:@selector(bannerViewDidLoadAdData:)]) {
        [self.delegate bannerViewDidLoadAdData:(GUJAdView *) bannerView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewDidLoadAdDataForContext:)]) {
        [self.delegate bannerViewDidLoadAdDataForContext:self];
    }
}


- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    if ([self.delegate respondsToSelector:@selector(bannerView:didFailLoadingAdWithError:)]) {
        [self.delegate bannerView:(GUJAdView *) bannerView didFailLoadingAdWithError:error];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewDidFailLoadingAdWithError:ForContext:)]) {
        [self.delegate bannerViewDidFailLoadingAdWithError:error ForContext:self];
    }
}


#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    BOOL completionHandlerAllowsToShowInterstitial = NO;
    if (interstitialAdViewCompletionHandler != nil) {
        completionHandlerAllowsToShowInterstitial = interstitialAdViewCompletionHandler(ad, nil);
    }

    if (autoShowInterstitialView || completionHandlerAllowsToShowInterstitial) {
        [self showInterstitial];
    }

    if ([self.delegate respondsToSelector:@selector(interstitialViewDidLoadAdData:)]) {
        [self.delegate interstitialViewDidLoadAdData:[[GUJAdView alloc] initWithContext:self]];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewDidLoadAdDataForContext:)]) {
        [self.delegate interstitialViewDidLoadAdDataForContext:self];
    }
}


- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    if (interstitialAdViewCompletionHandler != nil) {
        interstitialAdViewCompletionHandler(ad, error);
    }
    if ([self.delegate respondsToSelector:@selector(interstitialView:didFailLoadingAdWithError:)]) {
        [self.delegate interstitialView:[[GUJAdView alloc] initWithContext:self] didFailLoadingAdWithError:error];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewDidFailLoadingAdWithError:ForContext:)]) {
        [self.delegate interstitialViewDidFailLoadingAdWithError:error ForContext:self];
    }
}


- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    if ([self.delegate respondsToSelector:@selector(interstitialViewWillAppear)]) {
        [self.delegate interstitialViewWillAppear];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewWillAppearForContext:)]) {
        [self.delegate interstitialViewWillAppearForContext:self];
    }
}


- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    if ([self.delegate respondsToSelector:@selector(interstitialViewWillDisappear)]) {
        [self.delegate interstitialViewWillDisappear];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewWillDisappearForContext:)]) {
        [self.delegate interstitialViewWillDisappearForContext:self];
    }
}


- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    if ([self.delegate respondsToSelector:@selector(interstitialViewDidDisappear)]) {
        [self.delegate interstitialViewDidDisappear];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewDidDisappearForContext:)]) {
        [self.delegate interstitialViewDidDisappearForContext:self];
    }
}

@end
