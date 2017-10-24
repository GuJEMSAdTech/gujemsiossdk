//
//  GUJGenericAdContext.m
//  gujemsiossdk-gujemsiossdk
//
//

#import "GUJGenericAdContext.h"

#import "GUJAdViewContextDelegate.h"

#import "PMPrefetchManager.h"
#import "PMBannerPrefetchRequest.h"
#import "PMBid.h"




static NSString *const EVENT_HANDLER_NAME_FACEBOOK = @"handOverAdViewToFacebook";

static NSString *const EVENT_HANDLER_NAME_SET_SIZE = @"setsize";
static NSString *const EVENT_HANDLER_NAME_LOG = @"log";
static NSString *const EVENT_HANDLER_NAME_NOAD = @"noad";


@interface GUJGenericAdContext () <GUJAdViewContextDelegate, PMPrefetchDelegate, FBNativeAdDelegate, GADAppEventDelegate>

@property (nonatomic, strong) GUJAdViewContext *adViewContext;
@property GUJGenericAdContextOption options;

@property (nonatomic) CGSize adSize;
@property (nonatomic) NSInteger position;
@property (nonatomic) BOOL isIndex;

@property (nonatomic, strong) NSString *pubmaticPublisherId;
@property (nonatomic, strong) NSString *facebookPlacementId;
@property (nonatomic, strong) NSString *igChangedSizeString;


@end

@implementation GUJGenericAdContext

+(GUJGenericAdContext *) contextWithOptions:(GUJGenericAdContextOption) options delegate:(id <GUJGenericAdContextDelegate>) delegate {
    
    GUJGenericAdContext *context = [[GUJGenericAdContext alloc] init];
    context.options = options;
    context.delegate = delegate;
    
    //default values
    [context setPosition:GUJ_AD_VIEW_POSITION_TOP];
    if (options & GUJGenericAdContextOptionUsePubMatic) {
        [context setAdSize:CGSizeMake(320, 50)];
    }
    
    return context;
}

-(void) loadWithAdUnitId:(NSString *) adUnitId inController:(UIViewController *) vc {
    
    _adUnitId = adUnitId;
    
    self.facebookPlacementId = nil;
    
    self.adViewContext = [GUJAdViewContext instanceForAdUnitId:self.adUnitId rootViewController:vc];
    self.adViewContext.position = self.position;
    self.adViewContext.delegate = self;
    self.adViewContext.isIndex = self.isIndex;
    
    if (self.options & GUJGenericAdContextOptionUsePubMatic) {
        if (self.pubmaticPublisherId == nil) {
            [self failLoadingWithErrorText:@"Can't use Pubmatic. Pubmatic publisherId = nil"];
            return;
        }
        
        [self loadPubmaticTargetInfo:self.pubmaticPublisherId];
        return;
    }
    
    [self loadAd];
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
        [self.delegate genericAdContext:nil didFailWithError:error];
    }
}

#pragma mark - GUJAdViewContextDelegate

- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        [self.delegate genericAdContext:context didFailWithError:error];
    }
}

- (void)bannerViewDidRecieveEventForContext:(GUJAdViewContext *)context eventName:(NSString *)name
                                   withInfo:(NSString *)info {
    
    if (self.options & GUJGenericAdContextOptionUseFacebook) {
        if ([name isEqualToString:EVENT_HANDLER_NAME_FACEBOOK]) {
            self.facebookPlacementId = info;
        }
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

    if ([self.delegate respondsToSelector:@selector(genericAdContextDidLoadData:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContextDidLoadData:context];
        });
    }
}



#pragma mark - Pubmatic

-(void) loadPubmaticTargetInfo:(NSString *) publisherId {
    
    PMSize *impSize = [PMSize sizeWithWidth:self.adSize.width height:self.adSize.height];
    NSString *impressionId = self.adUnitId;
    if (self.position > 0) {
        impressionId = [impressionId stringByAppendingFormat:@"-%ld", (long)self.position];
    }
    
    PMBannerImpression *impression = [[PMBannerImpression alloc] initWithImpressionId:impressionId slotName:self.adUnitId slotIndex:self.position sizes:@[impSize]];
    
    
    PMPrefetchManager *prefetchManager = [PMPrefetchManager sharedInstance];
    prefetchManager.delegate = self;
    
    PMBannerPrefetchRequest * prefetchAdRequest = [[PMBannerPrefetchRequest alloc] initForPrefetchWithPublisherId:publisherId impressionArray:@[impression]];
    [prefetchManager prefetchCreativesForRequest:prefetchAdRequest];
}

- (void)loadBannerViewWithTargetInfo:(NSDictionary*)bids {
    
    PMBid *bid = [bids valueForKey:[self adUnitId]];
    
    NSMutableDictionary *targeting = [NSMutableDictionary dictionaryWithDictionary:self.adViewContext.customTargetingDict];
    if (bid) {
        [targeting setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:bid.impId, @"bidid",[NSString stringWithFormat:@"%ld", (long)bid.status.integerValue], @"bidstatus", [NSString stringWithFormat:@"%f", bid.price], @"bid", bid.dealId, @"wdeal", nil]];
    }
    
    [self.adViewContext setCustomTargetingDict:targeting];
    
    [self loadAd];
}

#pragma mark PMPrefetchDelegate

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didReceiveBids:(NSDictionary *)bids
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBannerViewWithTargetInfo:bids];
    });
}

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContext:nil didFailWithError:error];
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
    
    if ([self.delegate respondsToSelector:@selector(genericAdContextDidLoadFacebookNativeAd:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContextDidLoadFacebookNativeAd:nativeAd];
        });
    }
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(genericAdContext:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate genericAdContext:nil didFailWithError:error];
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
        
        if ([self.delegate respondsToSelector:@selector(genericAdContextDidChangeBannerSize:duration:)]) {
            [self.delegate genericAdContextDidChangeBannerSize:size duration:timeValue];
        }
    });
}

-(void) didRecieveLogEvent:(NSString *) info {
    if ([self.delegate respondsToSelector:@selector(genericAdContextDidReceiveLog:)]) {
        [self.delegate genericAdContextDidReceiveLog:info];
    }
}

-(void) didRecieveNoadEvent {
    [[self bannerView] removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(genericAdContextDidRemoveBannerFromView)]) {
        [self.delegate genericAdContextDidRemoveBannerFromView];
    }
}

@end
