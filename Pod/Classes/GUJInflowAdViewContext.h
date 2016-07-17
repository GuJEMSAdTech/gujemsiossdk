/*
 * BSD LICENSE
 * Copyright (c) 2016, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
#import <TeadsSDK/TeadsSDK.h>
#import "GUJBaseAdViewContext.h"


@interface GUJInflowAdViewContext : GUJBaseAdViewContext <UIGestureRecognizerDelegate, UIScrollViewDelegate, IMAAdsLoaderDelegate, IMAAdsManagerDelegate>

@property(nonatomic, strong) NSString *dfpAdunitId;
@property(nonatomic, strong) NSString *teadsPlacementId;
@property(nonatomic, weak) id<TeadsVideoDelegate> teadsVideoDelegate;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *inFlowAdPlaceholderView;
@property(nonatomic, strong) NSLayoutConstraint *inFlowAdPlaceholderViewHeightConstraint;

/*!
 * Returns a GUJInflowAdViewContext instance.
 *
 @param scrollView - the main scroll view containing the inFlowAdPlaceholderView as a subview
 @param inFlowAdPlaceholderView - a placeholder view for the inflow add, give it the width of the scrollview
 @param inFlowAdPlaceholderViewHeightConstraint an autolayout constraint for the placeholder view with an initial value of 0.
 @param dfpAdunitId - DFP adUnit ID
 @param teadsPlacementId - Teads Placement ID
 @result A newly created GUJAdViewContext instance
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView inFlowAdPlaceholderView:(UIView *)inFlowAdPlaceholderView inFlowAdPlaceholderViewHeightConstraint:(NSLayoutConstraint *)inFlowAdPlaceholderViewHeightConstraint dfpAdunitId:(NSString *)dfpAdunitId teadsPlacementId:(NSString *)teadsPlacementId;

/*!
 * Starts loading/ resuming of the inflow ad, add will be preloaded and started once scrolled into view.
 * Should be called in your viewDidAppear method.
 */
- (void)containerViewDidAppear;

/*!
 * Stops/ pauses the inflow ad once the user navigates to the next view controller.
 * Should be called in your viewWillDisappear method.
*/
- (void)containerViewWillDisappear;

/*!
 * Disables the location service
 @result YES if the location service was disabled
 */
- (BOOL)disableLocationService;

@end