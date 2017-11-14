//
//  GUJGenericAdContext.h
//  gujemsiossdk-gujemsiossdk
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GUJAdViewContext.h"

#import "GUJGenericAdContextDelegate.h"

typedef NS_OPTIONS(NSUInteger, GUJGenericAdContextOption) {
    GUJGenericAdContextOptionDefault   = 0,
    GUJGenericAdContextOptionUsePubMatic   = 1 << 0,
    GUJGenericAdContextOptionUseFacebook   = 1 << 1,
    GUJGenericAdContextOptionUseIQEvents   = 1 << 2
};

@interface GUJGenericAdContext : NSObject

@property (nonatomic, strong, readonly) NSString *adUnitId;
@property (nonatomic, strong) GUJAdViewContext *adViewContext;
@property (nonatomic, weak) id <GUJGenericAdContextDelegate> delegate;

+(GUJGenericAdContext *) contextForAdUnitId:(NSString *) adUnitId withOptions:(GUJGenericAdContextOption) options delegate:(id <GUJGenericAdContextDelegate>) delegate;

-(void) loadInViewController:(UIViewController *) vc;
-(void) addKeyword:(NSString *)keyword;

-(GADBannerView *) bannerView;

-(void)setPubmaticPublisherId:(NSString *)publisherId size:(CGSize) size;


@end
