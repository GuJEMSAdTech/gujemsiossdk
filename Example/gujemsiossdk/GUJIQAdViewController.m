//
//  GUJIQAdViewController.m
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import "GUJIQAdViewController.h"
#import "GUJIQAdViewContext.h"
#import "GUJSettingsViewController.h"

@interface GUJIQAdViewController () <GUJAdViewContextDelegate, GUJIQAdViewContextDelegate>

@property (nonatomic, strong) GUJIQAdViewContext *adViewContext;

@property (weak, nonatomic) IBOutlet UIView *bannerAreaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerAreaViewHeight;

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
    
    for (UIView *subview in self.bannerAreaView.subviews) {
        [subview removeFromSuperview];
    }
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:IQ_APP_EVENTS_AD_UNIT_USER_DEFAULTS_KEY];
    
    self.adViewContext = [[GUJIQAdViewContext alloc] init];
    [self.adViewContext loadBannerWithAdUnitId:adUnitId rootViewController:self delegate:self];

    [self.bannerAreaView addSubview:[self.adViewContext bannerView]];
}

#pragma mark GUJIQAdViewContextDelegate

-(void) iqAdView:(GUJIQAdViewContext *) viewContext didReceivedLog:(NSString *) log {
    NSLog(@"iq ad logging: %@", log);
}

-(void) iqAdView:(GUJIQAdViewContext *) viewContext changeSize:(CGSize) size duration:(CGFloat) duration {
    
    self.bannerAreaViewHeight.constant = size.height;
    [UIView animateWithDuration:duration animations:^{
        [self.bannerAreaView layoutIfNeeded];
    }];
}

-(void) iqAdViewDidRemoveFromView:(GUJIQAdViewContext *) viewContext {
    self.bannerAreaViewHeight.constant = 0;
}


@end
