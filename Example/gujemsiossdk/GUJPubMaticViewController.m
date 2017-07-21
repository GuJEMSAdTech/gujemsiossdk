//
//  GUJPubMaticViewController.m
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import "GUJPubMaticViewController.h"
#import "GUJSettingsViewController.h"

#import "GUJPubMaticAdContext.h"



@interface GUJPubMaticViewController () <GUJPubMaticAdContextDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adAreaHeight;
@property (weak, nonatomic) IBOutlet UIView *adArea;
@property (weak, nonatomic) IBOutlet UILabel *adErrorLabel;

@property(nonatomic, strong) GUJPubMaticAdContext *bannerContext;
@property(nonatomic, strong) GUJPubMaticAdContext *interstitialContext;

@end








@implementation GUJPubMaticViewController

-(NSString *) adUnitId {
    //return @"/6032/stern_ip/auto";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:PUBMATIC_AD_UNIT_USER_DEFAULTS_KEY];
    
    return adUnitId;
}

-(NSString *) publisherId {

    //return @"51013";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:PUBMATIC_PUBLISHER_USER_DEFAULTS_KEY];
    
    return adUnitId;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *unitId = [self adUnitId];
    NSString *publisherId = [self publisherId];
    
    if (unitId == nil || publisherId == nil) {
        self.adErrorLabel.text = @"Enter adUnitId and publisherId";
        return;
    }
    
    [self loadAd];
}

-(IBAction) loadAd {
    
    NSString *unitId = [self adUnitId];
    NSString *publisherId = [self publisherId];
    
    self.bannerContext = [GUJPubMaticAdContext adWithAdUnitId:unitId publisherId:publisherId];
    [self.bannerContext setPosition:3];
    [self.bannerContext setAdSize:CGSizeMake(300, 250)];
    self.bannerContext.delegate = self;
    [self.bannerContext loadBannerViewForViewController:self];
    
}


#pragma mark - GUJPubMaticAdContextDelegate

- (void)bannerViewDidLoad:(GUJAdViewContext *)adViewContext {
    UIView *bannerView = (UIView *)adViewContext.bannerView;
    [self.adArea addSubview:bannerView];
    self.adAreaHeight.constant = bannerView.frame.size.height;
    
    self.adErrorLabel.text = nil;
}

- (void)bannerView:(GUJAdViewContext *)adViewContext didFailWithError:(NSError *)error {

    self.adErrorLabel.text = error.localizedDescription;
}




@end
