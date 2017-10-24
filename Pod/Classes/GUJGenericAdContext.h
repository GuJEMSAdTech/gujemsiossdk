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
@property(nonatomic, weak) id <GUJGenericAdContextDelegate> delegate;

+(GUJGenericAdContext *) contextWithOptions:(GUJGenericAdContextOption) options delegate:(id <GUJGenericAdContextDelegate>) delegate;
-(void) loadWithAdUnitId:(NSString *) adUnitId inController:(UIViewController *) vc;

-(GADBannerView *) bannerView;

-(void) setPubmaticPublisherId:(NSString *) publisherId;
-(void) setAdSize:(CGSize) size;
-(void) setPosition:(NSInteger) position;
-(void) setIsIndex:(BOOL) isIndex;


@end
