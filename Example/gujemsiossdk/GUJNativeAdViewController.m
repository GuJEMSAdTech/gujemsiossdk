//
//  GUJNativeAdViewController.m
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import "GUJNativeAdViewController.h"
#import "GUJNativeAdManager.h"

#import "GUJSettingsViewController.h"

@interface GUJNativeAdViewController () <GUJNativeAdDelegate>

@property (nonatomic, strong) GUJNativeAdManager *adManager;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadlineLabel;
@property (weak, nonatomic) IBOutlet UITextView *teaserTextView;
@property (weak, nonatomic) IBOutlet UILabel *presenterLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation GUJNativeAdViewController

-(NSString *) adUnitId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];
    
    return adUnitId;
}

-(NSString *) baseUrl {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:NATIVE_BASE_URI_USER_DEFAULTS_KEY];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //use GUJNativeAdManager for loading ad or few ad's in same view
    self.adManager = [GUJNativeAdManager new];
    
    GUJNativeAd *ad = [self.adManager nativeAdWithUnitID:[self adUnitId]];
    ad.defaultClickURL = [self baseUrl];
    ad.delegate = self;
    [ad loadAd];
    
    [self.activityView startAnimating];
}


- (IBAction)reloadAction:(id)sender {
    self.adView.hidden = YES;
    
    GUJNativeAd *ad = [self.adManager nativeAdWithUnitID:[self adUnitId]];
    ad.defaultClickURL = [self baseUrl];
    ad.delegate = self;
    [ad loadAd];
    
    [self.activityView startAnimating];
}

#pragma mark - GUJNativeAdDelegate

- (void)nativeAdDidLoad:(GUJNativeAd *)nativeAd {
    [self.activityView stopAnimating];
    self.adView.hidden = NO;

    NSURL *url = [NSURL URLWithString:nativeAd.teaserImage3];
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

    self.headlineLabel.text = nativeAd.headline;
    self.subheadlineLabel.text = nativeAd.subHeadline;
    self.teaserTextView.text = nativeAd.teaserText;
    self.presenterLabel.text = nativeAd.presenterText;

    [nativeAd registerViewForInteraction:self.adView];
}

- (void)nativeAd:(GUJNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self.activityView stopAnimating];

    UIAlertController *alertController = [UIAlertController
                                       alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                       message:error.localizedDescription
                                       preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                    style:UIAlertActionStyleDefault
                                                  handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)nativeAdDidClick:(GUJNativeAd *)nativeAd {
    
}

@end
