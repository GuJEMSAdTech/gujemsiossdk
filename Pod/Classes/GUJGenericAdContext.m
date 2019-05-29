//
//  GUJGenericAdContext.m
//  gujemsiossdk-gujemsiossdk
//
//  Created by triare-imac on 18.10.17.
//

#import "GUJGenericAdContext.h"

#import "GUJAdViewContextDelegate.h"





static NSString *const EVENT_HANDLER_NAME_FACEBOOK = @"handOverAdViewToFacebook";

static NSString *const EVENT_HANDLER_NAME_SET_SIZE = @"setsize";
static NSString *const EVENT_HANDLER_NAME_LOG = @"log";
static NSString *const EVENT_HANDLER_NAME_NOAD = @"noad";
static NSString *const EVENT_HANDLER_NAME_SHOWHEROES_NOAD = @"showHeroesNoAd";


@interface GUJGenericAdContext () <GUJAdViewContextDelegate, FBNativeAdDelegate, GADAppEventDelegate>

@property GUJGenericAdContextOption options;

@property (nonatomic, strong) NSString *pubmaticPublisherId;
@property (nonatomic) CGSize pubmaticSize;

@property (nonatomic, strong) NSString *facebookPlacementId;
@property (nonatomic, strong) NSString *igChangedSizeString;


@end

@implementation GUJGenericAdContext

+(GUJGenericAdContext *) contextForAdUnitId:(NSString *) adUnitId withOptions:(GUJGenericAdContextOption) options delegate:(id <GUJGenericAdContextDelegate>) delegate {
    
    GUJGenericAdContext *context = [[GUJGenericAdContext alloc] initWithAdUnitId:adUnitId];
    context.options = options;
    context.delegate = delegate;
    
    return context;
}

-(instancetype) initWithAdUnitId:(NSString *) adUnitId {
    if (self = [super init]) {
        _adUnitId = adUnitId;
        _adViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:nil];
        _adViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    }
    
    return self;
}

-(void) loadInViewController:(UIViewController *) vc {
    
    self.facebookPlacementId = nil;
    
    self.adViewContext.delegate = self;
    self.adViewContext.rootViewController = vc;
    
    [self loadAd];
}

-(void) addKeyword:(NSString *)keyword {
    [self.adViewContext addCustomTargetingKeyword:keyword];
}

-(void) loadAd {    
    [self.adViewContext adView];
}

-(GADBannerView *) bannerView {
    return self.adViewContext.bannerView;
}

-(void) failLoadingWithErrorText:(NSString *) text {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(text, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(text, nil)
                               };
    NSError *error = [NSError errorWithDomain:@"GUJGenericAdContext"
                                         code:-57
                                     userInfo:userInfo];
    
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        [self.delegate genericAdContext:self didFailWithError:error];
    }
}

#pragma mark - GUJAdViewContextDelegate

- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        [self.delegate genericAdContext:self didFailWithError:error];
    }
}

- (void)bannerViewDidRecieveEventForContext:(GUJAdViewContext *)context eventName:(NSString *)name
                                   withInfo:(NSString *)info {
    
    if (self.options & GUJGenericAdContextOptionUseFacebook) {
        if ([name isEqualToString:EVENT_HANDLER_NAME_FACEBOOK]) {
            self.facebookPlacementId = info;
        }
    }
    
    if ([name isEqualToString:EVENT_HANDLER_NAME_SHOWHEROES_NOAD]) {
        [self didRecieveNoadEvent];
    }
    
    if (self.options & GUJGenericAdContextOptionUseIQEvents) {
        if ([name.lowercaseString isEqualToString:EVENT_HANDLER_NAME_SET_SIZE]) {
            [self didRecieveSetSizeEvent:info];
        }
        
        if ([name.lowercaseString isEqualToString:EVENT_HANDLER_NAME_LOG]) {
            [self didRecieveLogEvent:info];
        }
        
        if ([name.lowercaseString isEqualToString:EVENT_HANDLER_NAME_NOAD]) {
            [self didRecieveNoadEvent];
        }
    }
    
    
}

- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context {
    
    if (self.facebookPlacementId != nil) {
        [self loadFacebookNativeAd:self.facebookPlacementId];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(genericAdContext:didLoadData:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContext:self didLoadData:context];
        });
    }
}

#pragma mark - Facebook

- (void)loadFacebookNativeAd:(NSString *)placementId {
    
    FBNativeAd *nativeAd =
    [[FBNativeAd alloc] initWithPlacementID:placementId];
    nativeAd.delegate = self;
    [nativeAd loadAd];
}

#pragma mark FBNativeAdDelegate

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd {
    
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didLoadFacebookNativeAd:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContext:self didLoadFacebookNativeAd:nativeAd];
        });
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContext:self didFailWithError:error];
        });
    }
}

#pragma mark - IQ Ad

-(void) didRecieveSetSizeEvent:(NSString *) info {
    
    //when you change frame of banner view, Google SDK call adView:didReceiveAppEvent:withInfo: again
    //don't change frame if sizeInfo same
    
    if ([self.igChangedSizeString isEqualToString:info]) {
        return;
    }
    
    self.igChangedSizeString = info;
    
    NSArray *values = [info componentsSeparatedByString:@":"];
    
    NSString *width;
    if (values.count > 0) width = values[0];
    
    CGFloat widthValue = 0;
    if ([width isEqualToString:@"max"]) {
        widthValue = [UIScreen mainScreen].bounds.size.width;
    } else {
        widthValue = width.floatValue;
    }
    
    
    NSString *height;
    if (values.count > 1) height = values[1];
    
    CGFloat heightValue = 0;
    if ([height isEqualToString:@"max"]) {
        heightValue = [UIScreen mainScreen].bounds.size.height;
    } else {
        heightValue = width.floatValue;
    }
    
    
    NSString *time;
    if (values.count > 3) time = values[3];
    CGFloat timeValue = time.floatValue / 1000;
    
    CGSize size = CGSizeMake(widthValue, heightValue);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:timeValue animations:^{
            CGRect frame = [self bannerView].frame;
            frame.size = size;
            [self bannerView].frame = frame;
        }];
        
        if ([self.delegate respondsToSelector:@selector(genericAdContext:didChangeBannerSize:duration:)]) {
            [self.delegate genericAdContext:self didChangeBannerSize:size duration:timeValue];
        }
    });
}

-(void) didRecieveLogEvent:(NSString *) info {
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didReceiveLog:)]) {
        [self.delegate genericAdContext:self didReceiveLog:info];
    }
}

-(void) didRecieveNoadEvent {
    [[self bannerView] removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(genericAdContextDidRemoveBannerFromView:)]) {
        [self.delegate genericAdContextDidRemoveBannerFromView:self];
    }
}

@end
