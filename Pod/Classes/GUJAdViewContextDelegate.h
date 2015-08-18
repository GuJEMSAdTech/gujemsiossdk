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

/*!
 * The GUJAdViewContextDelegate protocol defines the messages sent by the corresponding GUJAdViewContext
 * on a variety of status changes during initialization/ loading/ showing/ hiding of
 * adViews, interstitials and native ads.
 */

#import <UIKit/UIKit.h>
#import <GoogleMobileAds.h>

@class GUJAdView;
@class GUJAdViewContext;

@protocol GUJAdViewContextDelegate <NSObject>

@optional

#pragma mark - Banner Views

/*!
 * Tells the delegate that an ad request failed. The failure is normally due to network
 * connectivity or ad availablility (i.e., no fill).
 */
- (void)bannerView:(GUJAdView *)bannerView didFailLoadingAdWithError:(NSError *)error DEPRECATED_MSG_ATTRIBUTE("Use bannerViewDidFailLoadingAdWithError: ForContext: method instead.");

/*!
 * Tells the delegate that an ad request failed. The failure is normally due to network
 * connectivity or ad availablility (i.e., no fill).
 */
- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current instance has allocated and created the AdView.
 */
- (void)bannerViewInitialized:(GUJAdView *)bannerView DEPRECATED_MSG_ATTRIBUTE("Use bannerViewInitializedForContext: method instead.");

/*!
 * Will be called if the current instance has allocated and created the AdView.
 */
- (void)bannerViewInitializedForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView will perform the ad server request.
 *
 @param bannerView The adView object
 */
- (void)bannerViewWillLoadAdData:(GUJAdView *)bannerView DEPRECATED_MSG_ATTRIBUTE("Use bannerViewWillLoadAdDataForContext: method instead.");

/*!
 * Will be called if the current AdView will perform the ad server request.
 *
 @param bannerView The adView object
 */
- (void)bannerViewWillLoadAdDataForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView did successfully perform the ad server request
 *
 @param bannerView The adView object
 */
- (void)bannerViewDidLoadAdData:(GUJAdView *)bannerView DEPRECATED_MSG_ATTRIBUTE("Use bannerViewDidLoadAdDataForContext: method instead.");

/*!
 * Will be called if the current AdView did successfully perform the ad server request
 *
 @param bannerView The adView object
 */
- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context;


#pragma mark - Interstitial Views

/*!
 * Called when an interstitial ad request completed without an interstitial to
 * show. This is common since interstitials are shown sparingly to users.
 */
- (void)interstitialView:(GUJAdView *)interstitialView didFailLoadingAdWithError:(NSError *)error DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewDidFailLoadingAdWithError: ForContext: method instead.");

/*!
 * Called when an interstitial ad request completed without an interstitial to
 * show. This is common since interstitials are shown sparingly to users.
 */
- (void)interstitialViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current instance has allocated and created the interstitial AdView.
 */
- (void)interstitialViewInitialized:(GUJAdView *)interstitialView DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewInitializedForContext: method instead.");

/*!
 * Will be called if the current instance has allocated and created the interstitial AdView.
 */
- (void)interstitialViewInitializedForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView is an interstitial and will perform the ad server request.
 *
 @param bannerView The adView object
 */
- (void)interstitialViewWillLoadAdData:(GUJAdView *)interstitialView DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewWillLoadAdDataForContext: method instead.");

/*!
 * Will be called if the current AdView is an interstitial and will perform the ad server request.
 *
 @param bannerView The adView object
 */
- (void)interstitialViewWillLoadAdDataForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView is an interstitial and did successfully perform the ad server request
 *
 @param bannerView The adView object
 */
- (void)interstitialViewDidLoadAdData:(GUJAdView *)interstitialView DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewDidLoadAdDataForContext: method instead.");

/*!
 * Will be called if the current AdView is an interstitial and did successfully perform the ad server request
 *
 @param bannerView The adView object
 */
- (void)interstitialViewDidLoadAdDataForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView will appear as interstitial view.
 */
- (void)interstitialViewWillAppear DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewWillAppearForContext: method instead.");

/*!
 * Will be called if the current AdView will appear as interstitial view.
 */
- (void)interstitialViewWillAppearForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView did appear as interstitial view.
 *  As usual, the view will be modal.
 */
- (void)interstitialViewDidAppear DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewDidAppearForContext: method instead.");

/*!
 * Will be called if the current AdView did appear as interstitial view.
 *  As usual, the view will be modal.
 */
- (void)interstitialViewDidAppearForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView will disapper the interstitial view.
 */
- (void)interstitialViewWillDisappear DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewWillDisappearForContext: method instead.");

/*!
 * Will be called if the current AdView will disapper the interstitial view.
 */
- (void)interstitialViewWillDisappearForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if the current AdView did disappear.
 *  As usual, the modal view is hidden.
 */
- (void)interstitialViewDidDisappear DEPRECATED_MSG_ATTRIBUTE("Use interstitialViewDidDisappearForContext: method instead.");

/*!
 * Will be called if the current AdView did disappear.
 *  As usual, the modal view is hidden.
 */
- (void)interstitialViewDidDisappearForContext:(GUJAdViewContext *)context;


/*!
 * Tells the delegate that an ad request failed. The failure is normally due to network
 * connectivity or ad availablility (i.e., no fill).
 */
-(void)nativeContentAdLoaderDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context;


/*!
 * Will be called if an native ad load was trigggered and did successfully perform the ad server request
 *
 @param bannerView The adView object
 */
-(void)nativeContentAdLoaderDidLoadData:(GADNativeContentAd *)nativeContentAd ForContext:(GUJAdViewContext *)context;


@end
