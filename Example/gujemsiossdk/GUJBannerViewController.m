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

#import "GUJBannerViewController.h"
#import "GUJAdViewContext.h"
#import "GUJSettingsViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface GUJBannerViewController ()
@end

@implementation GUJBannerViewController {

    GUJAdViewContext *topAdViewContext;
    GUJAdViewContext *mid1AdViewContext;
    GUJAdViewContext *mid2AdViewContext;
    GUJAdViewContext *bottomAdViewContext;

    __weak IBOutlet UIView *topPlaceholderView;
    __weak IBOutlet UIView *mid1PlaceholderView;
    __weak IBOutlet UIView *mid2PlaceholderView;
    __weak IBOutlet UIView *bottomPlaceholderView;

    __weak IBOutlet UILabel *topErrorLabel;
    __weak IBOutlet UILabel *mid1ErrorLabel;
    __weak IBOutlet UILabel *mid2ErrorLabel;
    __weak IBOutlet UILabel *bottomErrorLabel;

    __weak IBOutlet NSLayoutConstraint *topPlaceholderHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *mid1PlaceholderHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *mid2PlaceholderHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *bottomPlaceholderHeightConstraint;

    CLLocationManager *locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];

    // TOP
    topAdViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    topAdViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    topAdViewContext.delegate = self;
    [topPlaceholderView addSubview:[topAdViewContext adView]];


    // MID 1
    mid1AdViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    mid1AdViewContext.position = GUJ_AD_VIEW_POSITION_MID_1;
    mid1AdViewContext.delegate = self;
    [mid1PlaceholderView addSubview:[mid1AdViewContext adView]];


    // MID 2
    mid2AdViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    mid2AdViewContext.position = GUJ_AD_VIEW_POSITION_MID_2;
    mid2AdViewContext.delegate = self;
    [mid2PlaceholderView addSubview:[mid2AdViewContext adView]];


    // BOTTOM
    bottomAdViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    bottomAdViewContext.position = GUJ_AD_VIEW_POSITION_BOTTOM;
    bottomAdViewContext.delegate = self;
    [bottomPlaceholderView addSubview:[bottomAdViewContext adView]];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    topAdViewContext.delegate = nil;
    mid1AdViewContext.delegate = nil;
    mid2AdViewContext.delegate = nil;
    bottomAdViewContext.delegate = nil;

    [self removeAllSubviewsFromView:topPlaceholderView];
    [self removeAllSubviewsFromView:mid1PlaceholderView];
    [self removeAllSubviewsFromView:mid2PlaceholderView];
    [self removeAllSubviewsFromView:bottomPlaceholderView];

    topErrorLabel.text = @"";
    mid1ErrorLabel.text = @"";
    mid2ErrorLabel.text = @"";
    bottomErrorLabel.text = @"";
}


- (void)removeAllSubviewsFromView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}


- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    if (context == topAdViewContext) {
        topErrorLabel.text = error.localizedDescription;
    } else if (context == mid1AdViewContext) {
        mid1ErrorLabel.text = error.localizedDescription;
    } else if (context == mid2AdViewContext) {
        mid2ErrorLabel.text = error.localizedDescription;
    } else if (context == bottomAdViewContext) {
        bottomErrorLabel.text = error.localizedDescription;
    }
}


- (void)bannerViewDidShowForContext:(GUJAdViewContext *)context {

    if (context == topAdViewContext) {
        topPlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;

    } else if (context == mid1AdViewContext) {
        mid1PlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;

    } else if (context == mid2AdViewContext) {
        mid2PlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;

    } else if (context == bottomAdViewContext) {
        bottomPlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;

    }
}


@end
