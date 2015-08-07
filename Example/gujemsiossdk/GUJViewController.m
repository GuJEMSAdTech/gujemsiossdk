//
//  GUJViewController.m
//  gujemsiossdk
//
//  Created by Michael Brügmann on 08/04/2015.
//  Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

#import "GUJViewController.h"
#import "GUJAdViewContext.h"
#import "GUJAdSpaceIdToAdUnitIdMapper.h"

@interface GUJViewController ()
@end

@implementation GUJViewController {

    DFPInterstitial *interstitial;
    GUJAdViewContext *context;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //NSLog(@"%@", [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdspaceId:@"24757"]);
    //NSLog(@"%@", [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdspaceId:@"24757"]);


    context = [GUJAdViewContext instanceForAdspaceId:@"21772"];
    context.rootViewController = self;

/*
    [context adViewWithOrigin:CGPointMake(0.0f, 20.0f) completion:^BOOL(GUJAdView *_adView, NSError *_error) {
        if( !_error ) {
            
            [self.view addSubview:_adView];
            return YES;
            
        } else {
            NSLog(@"AdView:didFailLoadingAdWithError %@",_error);
            return NO;
        }
        
    }];
    */
    

    UIView *adView = [context adViewWithOrigin:CGPointMake(0.0f, 100.0f)];
    [self.view addSubview:adView];
    [context setReloadInterval:10];
    /*
    NSLog(@"adUnitId: %@", context.adUnitId);
    [context loadNativeAd];*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    interstitial = [[DFPInterstitial alloc] initWithAdUnitID:@"/6032/sdktest"];
    interstitial.delegate = self;
    //[interstitial loadRequest:[DFPRequest request]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  NSLog(@"interstitialDidReceiveAd");
    if (ad.isReady && !ad.hasBeenUsed) {
       [ad presentFromRootViewController:self];
   }

}


@end
