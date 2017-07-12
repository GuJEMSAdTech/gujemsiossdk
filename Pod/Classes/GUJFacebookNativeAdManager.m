//
//  GUJFacebookNativeAdManager.m
//  Pods
//
//  
//
//

#import "GUJFacebookNativeAdManager.h"
#import "GUJAdViewContextDelegate.h"


static NSString *const FACEBOOK_EVENT_HANDLER_NAME = @"handOverAdViewToFacebook";

@interface GUJFacebookNativeAdManager () <GUJAdViewContextDelegate, FBNativeAdDelegate>

@property (nonatomic, strong) GUJAdViewContext *adViewContext;
@property (nonatomic, strong) NSString *facebookPlacementId;

@end


@implementation GUJFacebookNativeAdManager


-(void) loadWithAdUnitId:(NSString *) adUnitId inController:(UIViewController *) vc {
    self.facebookPlacementId = nil;
    
    self.adViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:vc];
    self.adViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    self.adViewContext.delegate = self;
    [self.adViewContext adView];
}


- (void)loadFacebookNativeAd:(NSString *)placementId {
    
    FBNativeAd *nativeAd =
    [[FBNativeAd alloc] initWithPlacementID:placementId];
    nativeAd.delegate = self;
    [nativeAd loadAd];
}

-(void) didLoadAdWithError:(NSError *) error {
    if ([self.delegate respondsToSelector:@selector(facebookNativeAdManager:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate facebookNativeAdManager:self didFailWithError:error];
        });
    }
}

#pragma mark GUJAdViewContextDelegate

- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    [self didLoadAdWithError:error];
}

- (void)bannerViewDidRecieveEventForContext:(GUJAdViewContext *)context eventName:(NSString *)name
                                   withInfo:(NSString *)info {
    
    if ([name isEqualToString:FACEBOOK_EVENT_HANDLER_NAME]) {
        self.facebookPlacementId = info;
    }
}

- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context {
    if (self.facebookPlacementId == nil) {
        if ([self.delegate respondsToSelector:@selector(facebookNativeAdManager:didLoadAdDataForContext:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate facebookNativeAdManager:self didLoadAdDataForContext:context];
            });
        }
    } else {
        [self loadFacebookNativeAd:self.facebookPlacementId];
    }
}



#pragma mark FBNativeAdDelegate

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    
    if ([self.delegate respondsToSelector:@selector(facebookNativeAdManager:didLoadNativeAd:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate facebookNativeAdManager:self didLoadNativeAd:nativeAd];
        });
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self didLoadAdWithError:error];
}



@end
