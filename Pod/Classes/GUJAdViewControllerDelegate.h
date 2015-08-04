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

/*!
 * The GUJAdViewControllerDelegate Protocol defines the messages sent to the AdView and its Controller.
 *
 */

#import <UIKit/UIKit.h>

@class GUJAdViewController;
@class GUJAdView;
@class GUJAdViewEvent;

@protocol GUJAdViewControllerDelegate<NSObject, UIApplicationDelegate>

/*!
 * Will be called if the current instance is not well configured
 *
 @param error the configuration error
 @since 1.2.1
 */
- (void)adViewController:(GUJAdViewController*)adViewController didConfigurationFailure:(NSError*)error;

/*!
 * Will be called if the current instance:
 * + Performed an erroneous AdView-request.
 * + The Ad-Content is invalid or does not match the ad-type
 * + No Ad-Content is loaded.
 * + The AdView did an loading or configuration failure
 *
 @param bannerView The adView object
 @param error The adView error object
 */
- (void)bannerView:(GUJAdView*)bannerView didFailLoadingAdWithError:(NSError*)error;

- (void)interstitialView:(GUJAdView*)interstitialView didFailLoadingAdWithError:(NSError*)error;

@optional

/*!
 * Will be called if the current adViewController can present the AdView.
 * Return 0 to supress the SDK to show the AdView directly.
 *
 @param error the configuration error
 @since 2.0.1
 */
- (BOOL)adViewController:(GUJAdViewController*)adViewController canDisplayAdView:(GUJAdView*)adView;

/*!
 * - (void)didConfigurationFailure:(NSError*)error __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_5_0);
 * deprecated since 1.2.1
 *
 * use: adViewController:didConfigurationFailure
 */

/*!
 * Will be called if the current instance has allocated and created the AdView.
 * No Ad-Content is loaded at this time.
 *
 @deprecated since 2.0.1
 *
 * use: bannerViewInitialized
 *
 @param bannerView The adView object
 */
- (void)bannerViewDidLoad:(GUJAdView*)bannerView __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_5_0);

/*!
 * Will be called if the current instance has allocated and created the AdView.
 */
- (void)bannerViewInitialized:(GUJAdView*)bannerView;

/*!
 * Will notify the delegate when the Ad-View changes from hidden to visible
 */
- (void)bannerViewDidShow:(GUJAdView*)bannerView;

/*!
 * Will notify the delegate when the Ad-View changes from visible to hidden
 */
- (void)bannerViewDidHide:(GUJAdView*)bannerView;

/*!
 * Will be called if the current AdView will perform the ad-server request.
 *
 @param bannerView The adView object
 */
- (void)bannerViewWillLoadAdData:(GUJAdView*)bannerView;

/*!
 * Will be called if the current AdView did successfully performed the ad-server request
 *
 @param bannerView The adView object
 */
- (void)bannerViewDidLoadAdData:(GUJAdView*)bannerView;

/*!
 * Will called if the current ad receives an event.
 * An event can be a third party delegate notification or internal call.
 @since 1.2.1
 */
- (void)bannerView:(GUJAdView*)bannerView receivedEvent:(GUJAdViewEvent*)event;

#pragma mark Interstitial banner
/*!
 * Will be called if the current instance has allocated and created the interstitial AdView.
 */
- (void)interstitialViewInitialized:(GUJAdView*)interstitialView;

/*!
 * Will be called if the current AdView is an interstitial and will perform the ad-server request.
 *
 @param bannerView The adView object
 */
- (void)interstitialViewWillLoadAdData:(GUJAdView*)interstitialView;

/*!
 * Will be called if the current AdView is an interstitial and did successfully performed the ad-server request
 *
 @param bannerView The adView object
 */
- (void)interstitialViewDidLoadAdData:(GUJAdView*)interstitialView;

/*!
 * Will be called if the current AdView did failed to load.
 *
 @deprecated since 2.0.1
 *
 * use: interstitialView:didFailLoadingAdWithError:
 *
 */
- (void)interstitialViewDidFailLoadingWithError:(NSError*)error __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_5_0);

/*!
 * Will be called if the current AdView will appear as interstitial view.
 */
- (void)interstitialViewWillAppear;

/*!
 * Will be called if the current AdView did appear as interstitial view.
 *  As usual, the view will be modal.
 */
- (void)interstitialViewDidAppear;

/*!
 * Will be called if the current AdView will disapper the interstitial view.
 */
- (void)interstitialViewWillDisappear;

/*!
 * Will be called if the current AdView did disappear.
 *  As usual, the modal view is hidden.
 */
- (void)interstitialViewDidDisappear;

/*!
 * Will called if the current ad receives an event.
 * An event can be a third party delegate notification or internal call.
 @since 1.2.1
 */
- (void)interstitialViewReceivedEvent:(GUJAdViewEvent*)event;

@end
