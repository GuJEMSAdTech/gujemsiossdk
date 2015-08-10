/*
 * BSD LICENSE
 * Copyright (c) 2012, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
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
 * The source code is just allowed for private use, not for commercial use.
 *
 */

#import <UIKit/UIKit.h>
#import <GoogleMobileAds.h>


@protocol GUJAdViewContextDelegate;
@class DFPBannerView;
@class DFPInterstitial;
@class GUJAdViewContext;

static const int GUJ_AD_VIEW_POSITION_UNDEFINED = 0;
static const int GUJ_AD_VIEW_POSITION_TOP = 1;
static const int GUJ_AD_VIEW_POSITION_MID_1 = 2;
static const int GUJ_AD_VIEW_POSITION_MID_2 = 3;
static const int GUJ_AD_VIEW_POSITION_BOTTOM = 10;


__attribute__((deprecated("Dont' use methods returning GUJAdView anymore. Use their replacements instead.")))
@interface GUJAdView : GADBannerView

/*!
 * shows the view if hidden.
 * Important: Do not user show for presenting interstitial ad views
 *
 @since 2.0.1
 */
- (void)show;

- (id)initWithContext:(GUJAdViewContext *)context;

/*
 * shows the Interstitial Modal View if available.
 *
 @since 2.0.1
 */
- (void)showInterstitialView;

/*!
 * Hides the view without removing it.
 *
 @since 2.0.1
 */
- (void)hide;

/*!
 * Returns the AdSpaceId for this AdView
 *
 @since 2.0.1
 */
- (NSString*)adSpaceId;

@end


@interface GUJAdViewContext : NSObject <GADNativeCustomTemplateAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADNativeAppInstallAdLoaderDelegate, GADBannerViewDelegate, GADInterstitialDelegate>

@property(nonatomic, strong) NSString *adUnitId;
@property(nonatomic, assign) NSInteger position;
@property(nonatomic, strong) UIViewController *rootViewController;
@property(nonatomic, weak) id <GUJAdViewContextDelegate> delegate;

/*
 * Initialization Completion Handler.
 * This Handler is called when the ad creation process is completed.
 *
 @since 2.0.1
 */
typedef BOOL (^adViewCompletion)(DFPBannerView *_adView, NSError *_error);

/*
 * Interstitial Initialization Completion Handler.
 * This Handler is called when the ad creation process for an interstitial is completed.
 *
 @since 3.0.0
 */
typedef BOOL (^interstitialAdViewCompletion)(GADInterstitial *_interstitial, NSError *_error);


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param Ad-Space-Id
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId DEPRECATED_MSG_ATTRIBUTE("Use instanceForAdUnitId: position: rootViewController: method instead.");


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param Ad-Space-Id
 @param delegate A class that implements the GUJAdViewContextDelegate Protocol
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId delegate:(id <GUJAdViewContextDelegate>)delegate DEPRECATED_MSG_ATTRIBUTE("Use instanceForAdUnitId: position: rootViewController: delegate: method instead.");


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param Ad-Space-Id
 @param adUnitId - adExchange adUnitId
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId DEPRECATED_MSG_ATTRIBUTE("Use instanceForAdUnitId: position: rootViewController: method instead.");


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param Ad-Space-Id
 @param adUnitId - adExchange adUnitId
 @param delegate A class that implements the GUJAdViewContextDelegate Protocol
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId delegate:(id <GUJAdViewContextDelegate>)delegate DEPRECATED_MSG_ATTRIBUTE("Use instanceForAdUnitId: position: rootViewController: delegate: method instead.");


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param adUnitId The DFP adUnitId
 @param position The position (one of GUJ_AD_VIEW_POSITION_UNDEFINED, GUJ_AD_VIEW_POSITION_TOP, GUJ_AD_VIEW_POSITION_CENTER, GUJ_AD_VIEW_POSITION_BOTTOM)
 @param rootViewController Required reference to the current root view controller.
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId position:(NSInteger)position rootViewController:(UIViewController *)rootViewController;


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param adUnitId The DFP adUnitId
 @param position The position (one of GUJ_AD_VIEW_POSITION_UNDEFINED, GUJ_AD_VIEW_POSITION_TOP, GUJ_AD_VIEW_POSITION_CENTER, GUJ_AD_VIEW_POSITION_BOTTOM)
 @param rootViewController Required reference to the current root view controller.
 @param delegate A class that implements the GUJAdViewContextDelegate Protocol
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId position:(NSInteger)position rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewContextDelegate>)delegate;


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param adUnitId The DFP adUnitId
 @param rootViewController Required reference to the current root view controller.
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController;


/*!
 * Returns a GUJAdViewContext instance.
 *
 @param adUnitId The DFP adUnitId
 @param rootViewController Required reference to the current root view controller.
 @param delegate A class that implements the GUJAdViewContextDelegate Protocol
 @result A newly created GUJAdViewContext instance
 */
+ (GUJAdViewContext *)instanceForAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id <GUJAdViewContextDelegate>)delegate;


/*!
 * Set the global reload interval for this instance.
 *
 @param reloadInterval Reload interval as NSTimeInterval
 */
- (void)setReloadInterval:(NSTimeInterval)reloadInterval;


/*!
 * Disables the location service
 @result YES if the location service was disabled
 */
- (BOOL)disableLocationService;


/*!
 * If you do not wish to present the Interstital View directly (automaticly), set this value to NO.
 * If AutoShow is disabled, you have to present the interstitial AdView manually.
 *
 @since 2.0.1
 */
- (void)shouldAutoShowIntestitialView:(BOOL)show DEPRECATED_MSG_ATTRIBUTE("Use shouldAutoShowInterstitialView: method instead, we don't like typos in method names ;)");

- (void)shouldAutoShowInterstitialView:(BOOL)show;


/*!
 * Creates a mobile banner view.
 *
 @result A newly created static DFPBannerView instance
 */
- (DFPBannerView *)adView;


/*!
 * Creates a mobile banner view.
 * The DFPBannerView is returned within the block.
 *
 @since 2.0.1
 */
- (void)adView:(adViewCompletion)completion;


/*!
 * Creates a mobile banner view.
 *
 @param origin The origin of this ad view.
 @result A newly created static DFPBannerView instance
 */
- (DFPBannerView *)adViewWithOrigin:(CGPoint)origin;


/*!
 * Creates a mobile banner view.
 * The DFPBannerView is returned within the block.
 *
 @param origin The origin of this ad view.
 @since 2.0.1
 */
- (void)adViewWithOrigin:(CGPoint)origin completion:(adViewCompletion)completion;


/*!
 * Creates a mobile banner view.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad will be shown.
 *
 @param keywords keywords that will be used for the ad request
 @result A newly creates DFPBannerView instance
 */
- (DFPBannerView *)adViewForKeywords:(NSArray *)keywords;


/*!
 * Creates a mobile banner view.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad will be shown.
 * The DFPBannerView is returned within the block.
 *
 @param keywords keywords that will be used for the ad request
 @since 2.0.1
 */
- (void)adViewForKeywords:(NSArray *)keywords completion:(adViewCompletion)completion;


/*!
 * Creates a mobile banner view with the given origin.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad will be shown.
 *
 @param keywords keywords that will be used for the ad request
 @param origin The origin of this AdView.
 @result A newly created  GUJAdView instance
 */
- (DFPBannerView *)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin;


/*!
 * Creates a mobile banner view with the given origin.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad will be shown.
 * The DFPBannerView is returned within the block.
 *
 @param keywords keywords that will be used for the ad request
 @param origin The origin of this AdView.
 @since 2.0.1
 */
- (void)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin completion:(adViewCompletion)completion;


/*!
 * Initializes an interstitial view.
 * The GUJAdViewContextDelegate SHOULD be implemented in the caller class.
 *
 */
- (DFPInterstitial *)interstitialAdView;


/*!
 * Initializes an interstitial view.
 * The DFPInterstitial for this interstitial is returned within the block.
 *
 @since 2.0.1
 */
- (void)interstitialAdViewWithCompletionHandler:(interstitialAdViewCompletion)completion;


/*!
 * Initializes an interstitial view.
 * The GUJAdViewContextDelegate SHOULD be implemented in the caller class.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad can be shown.
 *
 @param keywords keywords that will be used for the ad request
 */
- (DFPInterstitial *)interstitialAdViewForKeywords:(NSArray *)keywords;


/*!
 * Initializes an interstitial view.
 * The DFPInterstitial for this interstitial is returned within the block.
 * If no suitable ad matches the keyword(s) the instance stays inactive and no ad can be shown.
 *
 @param keywords keywords that will be used for the ad request
 @since 2.0.1
 */
- (void)interstitialAdViewForKeywords:(NSArray *)keywords completion:(interstitialAdViewCompletion)completion;


/*!
 * Immediately shows the previously initialized interstitial, in case it is ready to show.
 */
- (void)showInterstitial;


/*!
 * Set the maximum of initialization attempts.
 * Has no functionality since 3.0.0
 */
- (void)initalizationAttempts:(NSUInteger)attempts DEPRECATED_MSG_ATTRIBUTE("has no functionality.");


/*!
 * Add a keyword that will be used for the ad request.
 * Can be called multiple times to add multiple keywords.
 * If no suitable ad of a following ad view or interstitial request matches the keyword(s)
 * the instance will stay inactive and no ad can be shown.
 */
- (void)addCustomTargetingKeyword:(NSString *)keyword;


/*!
 * Add a key value pair for custom targetting.
 * Can be called multiple times to add values for multiple keys.
 * If no suitable ad of a following ad view or interstitial request matches the key/ value combinations
 * the instance will stay inactive and no ad can be shown.
 */
- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value;


/*!
 * Frees the current Instance.
 */
- (void)freeInstance;


// todo: complete native ad support
- (void)loadNativeAd;


@end


