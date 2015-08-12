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

#import "GUJAdViewContext.h"
#import "GUJAdSpaceIdToAdUnitIdMapper.h"
#import "GUJAdViewContextDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <gujemsiossdk/GUJAdViewContext.h>


static NSString *const KEYWORDS_DICT_KEY = @"kw";

@implementation GUJAdView : DFPBannerView {
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


@interface GUJAdViewContext ()
@end

@implementation GUJAdViewContext {
    GADAdLoader *adLoader;
    NSMutableDictionary *customTargetingDict;
    BOOL locationServiceDisabled;
    BOOL autoShowInterstitialView;
    NSTimeInterval reloadInterval;

    adViewCompletion adViewCompletionHandler;
    interstitialAdViewCompletion interstitialAdViewCompletionHandler;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        customTargetingDict = [NSMutableDictionary new];
        locationServiceDisabled = false;
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
        customTargetingDict[@"pos"] = @(position);
    } else {
        [customTargetingDict removeObjectForKey:@"pos"];
    }
}


- (void)setIsIndex:(BOOL)isIndex {
    _isIndex = isIndex;
    if (isIndex) {
        customTargetingDict[@"idx"] = @(YES);
    } else {
        [customTargetingDict removeObjectForKey:@"idx"];
    }
}


- (void)setReloadInterval:(NSTimeInterval)_reloadInterval {
    reloadInterval = _reloadInterval;
    // todo: implement ad reload
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


- (DFPBannerView *)adView {
    return [self adViewWithOrigin:CGPointZero];
}


- (void)adView:(adViewCompletion)completion {
    completion([self adView], nil);
}


- (DFPBannerView *)adViewWithOrigin:(CGPoint)origin {

    self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    /*self.bannerView.validAdSizes = @[
            NSValueFromGADAdSize(kGADAdSizeBanner),
            NSValueFromGADAdSize(kGADAdSizeMediumRectangle),
            NSValueFromGADAdSize(kGADAdSizeLargeBanner),
            NSValueFromGADAdSize(kGADAdSizeSmartBannerPortrait)
    ];/*/

    self.bannerView.adUnitID = self.adUnitId;
    self.bannerView.rootViewController = self.rootViewController;
    self.bannerView.delegate = self;

    DFPRequest *request = [DFPRequest request];
    request.customTargeting = customTargetingDict;

    if ([CLLocationManager locationServicesEnabled] && !locationServiceDisabled) {
        CLLocationManager *locationManager_ = [[CLLocationManager alloc] init];
        [request setLocationWithLatitude:locationManager_.location.coordinate.latitude
                               longitude:locationManager_.location.coordinate.longitude
                                accuracy:locationManager_.location.horizontalAccuracy];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewInitialized:)]) {
        [self.delegate bannerViewInitialized:(id) self.bannerView];
    }

    if ([self.delegate respondsToSelector:@selector(bannerViewWillLoadAdData:)]) {
        [self.delegate bannerViewWillLoadAdData:(id) self.bannerView];
    }
    [self.bannerView loadRequest:request];

    return self.bannerView;
}


- (void)adViewWithOrigin:(CGPoint)origin completion:(adViewCompletion)completion {
    adViewCompletionHandler = completion;

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
    DFPRequest *request = [DFPRequest request];
    request.customTargeting = customTargetingDict;

    if ([self.delegate respondsToSelector:@selector(interstitialViewInitialized:)]) {
        [self.delegate interstitialViewInitialized:nil];
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
    }
}


- (void)initalizationAttempts:(NSUInteger)attempts {
    //todo: implement
}


- (void)addCustomTargetingKeyword:(NSString *)keyword {
    if (customTargetingDict[KEYWORDS_DICT_KEY] != nil) {
        customTargetingDict[KEYWORDS_DICT_KEY] = [NSMutableArray new];
    }
    NSMutableArray *keywordArray = customTargetingDict[KEYWORDS_DICT_KEY];
    [keywordArray addObject:keyword];
}


- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value {
    NSAssert(![key isEqualToString:@"pos"], @"Set the position (pos) via position property.");
    NSAssert(![key isEqualToString:@"idx"], @"Set the isIndex (idx) via isIndex property.");
    NSAssert(![key isEqualToString:KEYWORDS_DICT_KEY], @"Set single keyword via the addKeywordForCustomTargeting: method.");
    customTargetingDict[key] = value;
}


- (void)freeInstance {
    //todo: implement
}


- (void)loadNativeAd {
    adLoader = [[GADAdLoader alloc]
            initWithAdUnitID:self.adUnitId
          rootViewController:self.rootViewController
                     adTypes:@[kGADAdLoaderAdTypeNativeContent]
                     options:@[]];
    adLoader.delegate = self;

    DFPRequest *request = [DFPRequest request];
    request.customTargeting = customTargetingDict;
    [adLoader loadRequest:request];

}


- (void)loadNativeAdForKeywords:(NSArray *)keywords {
    customTargetingDict[KEYWORDS_DICT_KEY] = keywords;
    [self loadNativeAd];
}


# pragma mark - GADAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader1 didFailToReceiveAdWithError:(GADRequestError *)error {
    if ([self.delegate respondsToSelector:@selector(nativeAdLoaderDidFailLoadingAdWithError:ForContext:)]) {
        [self.delegate nativeAdLoaderDidFailLoadingAdWithError:error ForContext:self];
    }
}


#pragma mark - GADNativeContentAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader1 didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    self.nativeContentAd = nativeContentAd;
    if ([self.delegate respondsToSelector:@selector(nativeAdLoaderDidLoadData:ForContext:)]) {
        [self.delegate nativeAdLoaderDidLoadData:nativeContentAd ForContext:self];
    }
}


#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if ([self.delegate respondsToSelector:@selector(bannerViewDidLoadAdData:)]) {
        [self.delegate bannerViewDidLoadAdData:(GUJAdView *) bannerView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewWillLoadAdDataForContext:)]) {
        [self.delegate bannerViewWillLoadAdDataForContext:self];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewDidShow:)]) {
        [self.delegate bannerViewDidShow:(GUJAdView *) bannerView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerViewDidShowForContext:)]) {
        [self.delegate bannerViewDidShowForContext:self];
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

    if ([self.delegate respondsToSelector:@selector(interstitialViewInitialized:)]) {
        [self.delegate interstitialViewInitialized:[[GUJAdView alloc] initWithContext:self]];
    }
    if ([self.delegate respondsToSelector:@selector(interstitialViewInitializedForContext:)]) {
        [self.delegate interstitialViewInitializedForContext:self];
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
