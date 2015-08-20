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

#import <gujemsiossdk/GUJAdViewContext.h>
#import "GUJNativeAdViewController.h"
#import "GUJSettingsViewController.h"
#import <GoogleMobileAds.h>


@implementation GUJNativeAdViewController {
    GUJAdViewContext *adViewContext;

    __weak IBOutlet UILabel *errorLabel;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *nativeAdPlaceholder;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];

    adViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    adViewContext.delegate = self;

    [adViewContext loadNativeContentAd];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self clearView];
}


- (void)nativeContentAdLoaderDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    errorLabel.text = error.localizedDescription;
}


- (void)nativeContentAdLoaderDidLoadDataForContext:(GUJAdViewContext *)context {
    // Create a new AdView instance from the xib file
    GADNativeContentAdView *contentAdView =
    [[[NSBundle mainBundle] loadNibNamed:@"GUJNativeContentAdView"
                                   owner:nil
                                 options:nil] firstObject];
    
    // Associate the app install ad view with the app install ad object.
    // This is required to make the ad clickable.
    contentAdView.nativeContentAd = context.nativeContentAd;
   
    // Populate the app install ad view with the app install ad assets.
    ((UILabel *) contentAdView.headlineView).text = context.nativeContentAd.headline;
    ((UIImageView *) contentAdView.imageView).image = ((GADNativeAdImage *)[context.nativeContentAd.images firstObject]).image;
    ((UILabel *) contentAdView.bodyView).text = context.nativeContentAd.body;
    ((UIImageView *) contentAdView.logoView).image = context.nativeContentAd.logo.image;
    ((UILabel *) contentAdView.callToActionView).text = context.nativeContentAd.callToAction;
    ((UILabel *) contentAdView.advertiserView).text = context.nativeContentAd.advertiser;

    // Add appInstallAdView to the view controller's view...
    [nativeAdPlaceholder addSubview:contentAdView];

}


-(void)clearView {
    [self removeAllSubviewsFromView:nativeAdPlaceholder];
    errorLabel.text = @"";
}


- (void)removeAllSubviewsFromView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}


@end