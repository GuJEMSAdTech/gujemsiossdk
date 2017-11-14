//
// Created by Michael Brügmann on 11.12.15.
// Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBNativeAd.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface GUJFacebookNativeAdViewController : UIViewController <FBNativeAdDelegate>
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *adBodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *adCallToActionButton;
@property (weak, nonatomic) IBOutlet UILabel *adSocialContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *sponsoredLabel;

@property (strong , nonatomic) FBMediaView *adCoverMediaView;

@property (weak, nonatomic) IBOutlet UIView *adView;

@end