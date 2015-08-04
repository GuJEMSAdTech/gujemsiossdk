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

@implementation GUJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdspaceId:@"24757"]);
    NSLog(@"%@", [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdspaceId:@"24757"]);
    
    
    
    GUJAdViewContext *context = [GUJAdViewContext instanceForAdspaceId:@"16144"];
    context.rootViewController = self;
    
    [context adViewWithOrigin:CGPointMake(0.0f, 20.0f) completion:^BOOL(GUJAdView *_adView, NSError *_error) {
        if( !_error ) {
            
            [self.view addSubview:_adView];
            return YES;
            
        } else {
            NSLog(@"AdView:didFailLoadingAdWithError %@",_error);
            return NO;
        }
        
    }];
    
    GUJAdView *adView = [context adViewWithOrigin:CGPointMake(0.0f, 100.0f)];
    [self.view addSubview:adView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
