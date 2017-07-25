//
//  GUJPubMaticAdContext.m
//  gujemsiossdk
//
//  
//  Copyright © 2017 Michael Brügmann. All rights reserved.
//

#import "GUJPubMaticAdContext.h"

#import <PubMaticSDK-HB/PMPrefetchManager.h>
#import <PubMaticSDK-HB/PMBannerPrefetchRequest.h>
#import <PubMaticSDK-HB/PMBid.h>


#import "GUJAdViewContextDelegate.h"

@interface GUJPubMaticAdContext () <PMPrefetchDelegate, GUJAdViewContextDelegate>

@property (nonatomic, strong) NSString *adUnitId;
@property (nonatomic, strong) NSString *publisherId;

@property (nonatomic) CGSize adSize;
@property (nonatomic) NSInteger position;


@property(nonatomic, strong) GUJAdViewContext *adViewContext;


@end




@implementation GUJPubMaticAdContext

+(GUJPubMaticAdContext *) adWithAdUnitId:(NSString *) adUnitId publisherId:(NSString *) pubId {
    
    GUJPubMaticAdContext *ad = [[GUJPubMaticAdContext alloc] init];
    ad.adUnitId = adUnitId;
    ad.publisherId = pubId;
    
    ad.position = GUJ_AD_VIEW_POSITION_TOP;
    ad.adSize = CGSizeMake(300, 50);
    
    return ad;
}


-(void) loadBannerViewForViewController:(UIViewController *) controller {
    
    PMSize *impSize = [PMSize sizeWithWidth:self.adSize.width height:self.adSize.height];
    NSString *impressionId = self.adUnitId;
    if (self.position > 0) {
        impressionId = [impressionId stringByAppendingFormat:@"-%ld", (long)self.position];
    }
    
    PMBannerImpression *impression = [[PMBannerImpression alloc] initWithImpressionId:impressionId slotName:self.adUnitId slotIndex:self.position sizes:impSize, nil];
    
    
    PMPrefetchManager *prefetchManager = [PMPrefetchManager new];
    prefetchManager.delegate = self;
    
    PMBannerPrefetchRequest * prefetchAdRequest = [[PMBannerPrefetchRequest alloc] initForPrefetchWithPublisherId:[self publisherId] impressions:impression, nil];
    [prefetchManager prefetchCreativesForRequest:prefetchAdRequest];
    
    
    self.adViewContext = [GUJAdViewContext instanceForAdUnitId:self.adUnitId rootViewController:controller];
    self.adViewContext.position = self.position;
    self.adViewContext.delegate = self;
}


- (void)loadBannerViewWithBids:(NSDictionary*)bids {
    
    PMBid *bid = [bids valueForKey:[self adUnitId]];
    //NSLog(@"Creatives: %@", bids.description);
    
    NSMutableDictionary *targeting = [NSMutableDictionary dictionaryWithDictionary:self.adViewContext.customTargetingDict];
    if (bid) {
        [targeting setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:bid.impId, @"bidid",[NSString stringWithFormat:@"%ld", (long)bid.status.integerValue], @"bidstatus", [NSString stringWithFormat:@"%f", bid.price], @"bid", bid.dealId, @"wdeal", nil]];
    }
    
    [self.adViewContext setCustomTargetingDict:targeting];
    
    [self.adViewContext adView];
}


#pragma mark GUJAdViewContextDelegate

- (void)bannerViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    if ([self.delegate respondsToSelector:@selector(bannerView:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate bannerView:self.adViewContext didFailWithError:error];
        });
    }
}

- (void)bannerViewDidLoadAdDataForContext:(GUJAdViewContext *)context {
    if ([self.delegate respondsToSelector:@selector(bannerViewDidLoad:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate bannerViewDidLoad:self.adViewContext];
        });
    }
}


#pragma mark - PMPrefetchDelegate

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didReceiveBids:(NSDictionary *)bids
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBannerViewWithBids:bids];
    });
}

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didFailWithError:(NSError *)error
{
    NSLog(@"PrefetchManager failed with error: %@", error.debugDescription);
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate bannerView:self.adViewContext didFailWithError:error];
        });
    }
}

@end
