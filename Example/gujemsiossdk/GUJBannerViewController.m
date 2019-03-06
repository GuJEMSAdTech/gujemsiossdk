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
#import "GUJSettingsViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "GUJYieldlab.h"
#import "GUJGenericAdContext.h"
#import "GUJConsent.h"

@interface GUJBannerViewController () <GUJGenericAdContextDelegate>
@end

@implementation GUJBannerViewController {

    GUJGenericAdContext *topAdContext;
    GUJGenericAdContext *mid1AdContext;
    GUJGenericAdContext *mid2AdContext;
    GUJGenericAdContext *bottomAdContext;

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

    // prompt for location permission
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    } else {  // iOS7
        [locationManager startUpdatingLocation];
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];

    if (adUnitId == nil) {
        adUnitId = @"/6032/sdktest";
        [userDefaults setObject:adUnitId forKey:AD_UNIT_USER_DEFAULTS_KEY];
        [userDefaults synchronize];
    }
    
    // Consent
    [GUJConsentHelper init:self.view];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /**** yieldlab ****/
    
    NSArray<GUJYieldlabMapElement*>* list = [NSArray arrayWithObjects:
            [GUJYieldlabMapElement init:@"mpa" value:@"7509781"],
            [GUJYieldlabMapElement init:@"msa" value:@"7509784"],
            [GUJYieldlabMapElement init:@"mca" value:@"7509790"],
            [GUJYieldlabMapElement init:@"mda" value:@"7509787"], nil];
   
    GUJYieldlab* yieldService = [GUJYieldlab sharedManager];
    [yieldService configure:list deviceType:4];
    [yieldService request];
    
    /**** yieldlab ****/
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];
    NSString *keyword = [userDefaults objectForKey:KEYWORD_DEFAULTS_KEY];
    if (keyword == nil) {
        keyword = @"";
    }

    // TOP
    topAdContext = [GUJGenericAdContext contextForAdUnitId:adUnitId
                                                   withOptions:GUJGenericAdContextOptionDefault
                                                    delegate:self];
    topAdContext.adViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    [topAdContext addKeyword:keyword];
    [topAdContext loadInViewController:self];
    [topPlaceholderView addSubview:[topAdContext bannerView]];
    
    
    
    // MID 1
    mid1AdContext = [GUJGenericAdContext contextForAdUnitId:adUnitId
                                                   withOptions:GUJGenericAdContextOptionDefault
                                                      delegate:self];
    mid1AdContext.adViewContext.position = GUJ_AD_VIEW_POSITION_MID_1;
    [mid1AdContext addKeyword:keyword];
    [mid1AdContext loadInViewController:self];
    [mid1PlaceholderView addSubview:[mid1AdContext bannerView]];

    // MID 2
    mid2AdContext = [GUJGenericAdContext contextForAdUnitId:adUnitId
                                                    withOptions:GUJGenericAdContextOptionDefault
                                                       delegate:self];
    mid2AdContext.adViewContext.position = GUJ_AD_VIEW_POSITION_MID_2;
    [mid2AdContext addKeyword:keyword];
    [mid2AdContext loadInViewController:self];
    [mid2PlaceholderView addSubview:[mid2AdContext bannerView]];


    // BOTTOM
    bottomAdContext = [GUJGenericAdContext contextForAdUnitId:adUnitId
                                                    withOptions:GUJGenericAdContextOptionDefault
                                                       delegate:self];
    bottomAdContext.adViewContext.position = GUJ_AD_VIEW_POSITION_BOTTOM;
    [bottomAdContext addKeyword:keyword];
    [bottomAdContext loadInViewController:self];
    [bottomPlaceholderView addSubview:[bottomAdContext bannerView]];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

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


- (void)genericAdContext:(GUJGenericAdContext *)context didLoadData:(GUJAdViewContext *)adViewContext {
    if (context == topAdContext) {
        topPlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;
        
    } else if (context == mid1AdContext) {
        mid1PlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;
        
    } else if (context == mid2AdContext) {
        mid2PlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;
        
    } else if (context == bottomAdContext) {
        bottomPlaceholderHeightConstraint.constant = context.bannerView.frame.size.height;
    }
}

- (void)genericAdContext:(GUJGenericAdContext *)context didFailWithError:(NSError *)error {
    if (context == topAdContext) {
        topErrorLabel.text = error.localizedDescription;
    } else if (context == mid1AdContext) {
        mid1ErrorLabel.text = error.localizedDescription;
    } else if (context == mid2AdContext) {
        mid2ErrorLabel.text = error.localizedDescription;
    } else if (context == bottomAdContext) {
        bottomErrorLabel.text = error.localizedDescription;
    }
}



@end
