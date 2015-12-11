//
// Created by Michael Brügmann on 11.12.15.
// Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

#import "GUJFacebookNativeAdViewController.h"


@implementation GUJFacebookNativeAdViewController {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.activityIndicator.hidesWhenStopped = YES;
    self.placementIdTextField.text = @"1573876952861381_1640386426210433";
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    [self.activityIndicator stopAnimating];

    [self.adTitleLabel setText:nativeAd.title];
    [self.adBodyLabel setText:nativeAd.body];
    [self.adSocialContextLabel setText:nativeAd.socialContext];
    [self.sponsoredLabel setText:@"Sponsored"];
    [self.adCallToActionButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];

    [nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
        [self.adIconImageView setImage:image];
    }];

    // Allocate a FBMediaView to contain the cover image or native video asset
    self.adCoverMediaView = [[FBMediaView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [self.adCoverMediaView setNativeAd:nativeAd];

    // Add adChoicesView
    FBAdChoicesView *adChoicesView = [[FBAdChoicesView alloc] initWithNativeAd:nativeAd];
    [self.adView addSubview:adChoicesView];
    [adChoicesView updateFrameFromSuperview];

    // Register the native ad view and its view controller with the native ad instance
    [nativeAd registerViewForInteraction:self.adView withViewController:self];
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    self.errorLabel.text = error.localizedDescription;
}

- (IBAction)loadFacebookNativeAd:(id)sender {
    [self.activityIndicator startAnimating];
    self.errorLabel.text = @"";

    FBNativeAd *nativeAd =
    [[FBNativeAd alloc] initWithPlacementID:self.placementIdTextField.text];
    nativeAd.delegate = self;
    [nativeAd loadAd];
}

@end