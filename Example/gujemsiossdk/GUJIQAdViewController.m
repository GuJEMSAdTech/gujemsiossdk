//
//  GUJIQAdViewController.m
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import "GUJIQAdViewController.h"
#import "GUJSettingsViewController.h"

#import "GUJGenericAdContext.h"

@interface GUJIQAdViewController () <GUJGenericAdContextDelegate>

@property (nonatomic, strong) GUJGenericAdContext *adContext;

@property (weak, nonatomic) IBOutlet UIView *bannerAreaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAreaViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAreaViewWidth;

@end

@implementation GUJIQAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loadAction:(id)sender {
    [self loadAd];
}

- (void)loadAd {
    
    //reset banner area view
    for (UIView *subview in self.bannerAreaView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.bannerAreaViewHeight.constant = 120;
    self.bannerAreaViewWidth.constant = 320;
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:IQ_APP_EVENTS_AD_UNIT_USER_DEFAULTS_KEY];
    
    self.adContext = [GUJGenericAdContext contextWithOptions:GUJGenericAdContextOptionUseIQEvents delegate:self];
    [self.adContext loadWithAdUnitId:adUnitId inController:self];

    [self.bannerAreaView addSubview:[self.adContext bannerView]];
}

#pragma mark GUJIQAdViewContextDelegate

- (void)genericAdContextDidReceiveLog:(NSString *) log {
    NSLog(@"iq ad logging: %@", log);
}
- (void)genericAdContextDidChangeBannerSize:(CGSize)size duration:(CGFloat) duration {
    
    self.bannerAreaViewHeight.constant = size.height;
    self.bannerAreaViewWidth.constant = size.width;
    
    [UIView animateWithDuration:duration animations:^{
        [self.bannerAreaView layoutIfNeeded];
    }];
}

- (void)genericAdContextDidRemoveBannerFromView {
    self.bannerAreaViewHeight.constant = 0;
}


@end
