//
//  GUJIQAdViewContext.h
//  Pods
//
//  
//
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GUJAdViewContext.h"
#import "GUJAdViewContextDelegate.h"



@class GUJIQAdViewContext;

@protocol GUJIQAdViewContextDelegate <NSObject>

@optional

-(void) iqAdView:(GUJIQAdViewContext *) viewContext didReceivedLog:(NSString *) log;
-(void) iqAdView:(GUJIQAdViewContext *) viewContext changeSize:(CGSize) size duration:(CGFloat) duration;
-(void) iqAdViewDidRemoveFromView:(GUJIQAdViewContext *) viewContext;

@end



@interface GUJIQAdViewContext : NSObject

@property (nonatomic, weak) id <GUJIQAdViewContextDelegate> delegate;

@property (nonatomic, strong) GUJAdViewContext *adViewContext;

- (void) loadBannerWithAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id<GUJAdViewContextDelegate, GUJIQAdViewContextDelegate>) delegate;

-(GADBannerView *) bannerView;

@end
