//
//  GUJPubMaticAdContext.h
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GUJAdViewContext.h"


@protocol GUJPubMaticAdContextDelegate <NSObject>

@optional

- (void)bannerViewDidLoad:(GUJAdViewContext *)adViewContext;

- (void)bannerView:(GUJAdViewContext *)adViewContext didFailWithError:(NSError *)error;


@end



@interface GUJPubMaticAdContext : NSObject

@property (nonatomic, weak) id<GUJPubMaticAdContextDelegate> delegate;

+(GUJPubMaticAdContext *) adWithAdUnitId:(NSString *) adUnitId publisherId:(NSString *) pubId;

-(void) setAdSize:(CGSize) size;
-(void) setPosition:(NSInteger) position;


-(void) loadBannerViewForViewController:(UIViewController *) controller;

@end
