//
//  GUJFacebookNativeAdManager.h
//  Pods
//
//  
//
//

#import <Foundation/Foundation.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GUJAdViewContext.h"

@class GUJFacebookNativeAdManager;

@protocol GUJFacebookNativeAdManagerDelegate <NSObject>

@optional

-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didLoadAdDataForContext:(GUJAdViewContext *)context;

-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didLoadNativeAd:(FBNativeAd *)nativeAd;

-(void) facebookNativeAdManager:(GUJFacebookNativeAdManager *) manager didFailWithError:(NSError *)error;

@end



@interface GUJFacebookNativeAdManager : NSObject

@property (nonatomic, weak) id<GUJFacebookNativeAdManagerDelegate> delegate;

-(void) loadWithAdUnitId:(NSString *) adUnitId inController:(UIViewController *) vc;

@end
