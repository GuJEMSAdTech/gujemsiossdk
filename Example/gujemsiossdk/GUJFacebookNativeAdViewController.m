//
// Created by Michael Brügmann on 11.12.15.
// Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

#import "GUJFacebookNativeAdViewController.h"
#import "GUJSettingsViewController.h"

#import "GUJGenericAdContext.h"




@interface GUJFacebookNativeAdViewController () <GUJGenericAdContextDelegate>

@property (nonatomic, strong) GUJGenericAdContext *adContext;
@property (strong , nonatomic) FBMediaView *adCoverMediaView;

@property (weak, nonatomic) IBOutlet UIView *contextAdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextAdViewHeight;


@property (weak, nonatomic) IBOutlet UISwitch *facebookTestModeSwitch;

@end



@implementation GUJFacebookNativeAdViewController {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.activityIndicator.hidesWhenStopped = YES;
    
    self.nativeAdView.hidden = YES;
    self.contextAdView.hidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FACEBOOK_TEST_MODE]) {
        [self enableTestMode];
        self.facebookTestModeSwitch.on = YES;
    } else {
        [self disableTestMode];
        self.facebookTestModeSwitch.on = NO;
    }
}


-(IBAction) loadAdAction {
    [self startLoadAnimation];

    NSString *adUnitId = [[NSUserDefaults standardUserDefaults] stringForKey:FACEBOOK_AD_UNIT_USER_DEFAULTS_KEY];
    
    if (adUnitId == nil) {
        [self stopLoadAnimation:@"Error: set Facebook Ad Unit ID"];
        return;
    }
    
    if (self.adContext == nil) {
        self.adContext = [GUJGenericAdContext contextForAdUnitId:adUnitId
                                                     withOptions:GUJGenericAdContextOptionUseFacebook
                                                        delegate:self];
    }
    
    [self.adContext loadInViewController:self];
}

-(void) startLoadAnimation {
    self.loadButton.enabled = NO;
    [self.activityIndicator startAnimating];
    
    self.nativeAdView.hidden = YES;
    self.contextAdView.hidden = YES;
    self.errorLabel.text = nil;
}

-(void) stopLoadAnimation:(NSString *) error {
    self.loadButton.enabled = YES;
    [self.activityIndicator stopAnimating];
    if (error) {
        self.errorLabel.text = error;
    } else {
        self.errorLabel.text = nil;
    }
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    [self stopLoadAnimation:nil];
    
    self.nativeAdView.hidden = NO;
    self.contextAdView.hidden = YES;
    
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
    [self.nativeAdView addSubview:adChoicesView];
    [adChoicesView updateFrameFromSuperview];
    
    // Register the native ad view and its view controller with the native ad instance
    [nativeAd registerViewForInteraction:self.nativeAdView withViewController:self];
}

- (void)adWithContextDidLoad:(GUJAdViewContext *)context {

    self.nativeAdView.hidden = YES;
    self.contextAdView.hidden = NO;
    
    self.contextAdViewHeight.constant = context.bannerView.frame.size.height;
    
    [[self.contextAdView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contextAdView addSubview:context.bannerView];
    
}


#pragma mark GUJFacebookNativeAdManagerDelegate

- (void)genericAdContext:(GUJGenericAdContext *)adContext didLoadData:(GUJAdViewContext *)adViewContext {
    [self stopLoadAnimation:nil];
    
    [self adWithContextDidLoad:adViewContext];
}

- (void)genericAdContext:(GUJGenericAdContext *)adContext didLoadFacebookNativeAd:(FBNativeAd *)nativeAd {
    [self stopLoadAnimation:nil];
    
    [self nativeAdDidLoad:nativeAd];
}

- (void)genericAdContext:(GUJGenericAdContext *)adContext didFailWithError:(NSError *)error {
    [self stopLoadAnimation:error.localizedDescription];
}

#pragma mark FB test mode

-(NSArray *) deviceHashes {
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:@"5d0bc104e3966891a46e0a3d0fc434ff2551f61e"];
    [list addObject:@"daa520e304ef10402c2f39f4fe9bd02256ee4cf1"];
    [list addObject:@"d4cdfad42260bf168466838161f68d8288bf1b68"];
    
    [list addObject:@"a5cee39c986adac3dd871b52c1ff05e99ea06303"];
    [list addObject:@"f7efa78e42172b07083c7a49ddf0127ccf184163"];
    
    return list;
}

- (IBAction)testModeSwitchAction:(UISwitch *)sender {
    if (sender.isOn) {
        [self enableTestMode];
    } else {
        [self disableTestMode];
    }
}

-(void) enableTestMode {
    [FBAdSettings setLogLevel:FBAdLogLevelLog];
    
    for (NSString *device in [self deviceHashes]) {
        [FBAdSettings addTestDevice:device];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FACEBOOK_TEST_MODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) disableTestMode {
    
    for (NSString *device in [self deviceHashes]) {
        [FBAdSettings clearTestDevice:device];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACEBOOK_TEST_MODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
