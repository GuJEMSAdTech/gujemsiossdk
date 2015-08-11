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


@implementation GUJNativeAdViewController {
    GUJAdViewContext *adViewContext;
   
    __weak IBOutlet UILabel *errorLabel;
    
    __weak IBOutlet UILabel *headlineLabel;
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UILabel *bodyLabel;
    __weak IBOutlet UIImageView *secondaryImageView;

    __weak IBOutlet UILabel *calltoactionLabel;
    __weak IBOutlet UILabel *advertiserLabel;

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

    [adViewContext loadNativeAd];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self clearView];
}


- (void)nativeAdLoaderDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    errorLabel.text = error.localizedDescription;
}


- (void)nativeAdLoaderDidLoadData:(GADNativeContentAd *)nativeContentAd ForContext:(GUJAdViewContext *)context {
    headlineLabel.text = nativeContentAd.headline;
    bodyLabel.text = nativeContentAd.body;
    if ([nativeContentAd.images count] >= 1) {
        imageView.image = ((GADNativeAdImage*) nativeContentAd.images[0]).image;
    }
    if ([nativeContentAd.images count] >= 2) {
        secondaryImageView.image = ((GADNativeAdImage*) nativeContentAd.images[1]).image;
    }
    calltoactionLabel.text = nativeContentAd.callToAction;
    advertiserLabel.text = nativeContentAd.advertiser;

}


-(void)clearView {
    errorLabel.text = @"";
    headlineLabel.text = @"";
    imageView.image = nil;
    bodyLabel.text = @"";
    secondaryImageView.image = nil;
    calltoactionLabel.text = @"";
    advertiserLabel.text = @"";
}


@end