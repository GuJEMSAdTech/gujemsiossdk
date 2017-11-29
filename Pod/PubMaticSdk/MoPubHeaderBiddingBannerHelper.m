/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2017 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */


#define kWDealId        @"wdeal"
#define kBidId          @"bidid"
#define kBidStatus      @"bidstatus"

#import "MoPubHeaderBiddingBannerHelper.h"
#import "PMPrefetchManager.h"
#import <MPAdView.h>

@interface MoPubHeaderBiddingBannerHelper()<MPAdViewDelegate, PMPrefetchDelegate>
@property (nonatomic)  PMPrefetchManager     * prefetchManager;
@property (nonatomic ) NSMutableDictionary   * impressionIdViewMap;
@property (nonatomic ) NSArray               * adSlotInfoArray;
@property (nonatomic,weak ) UIViewController * controller;
@property (nonatomic ) NSString              * publisherId;
@end

@implementation MoPubHeaderBiddingBannerHelper

-(id)initWithAdSlotInfo:(NSArray *)adSlotInfoArray{
    
    NSAssert(([adSlotInfoArray count] != 0), @"adSlotInfoArray should not be empty");
    self = [super init];
    if (self) {
        
        _adSlotInfoArray = adSlotInfoArray;
        _impressionIdViewMap = [NSMutableDictionary new];
        _prefetchManager = [PMPrefetchManager sharedInstance];
        _prefetchManager.delegate = self;
        
    }
    return self;
}

-(id)initWithAdSlotInfo:(NSArray *)adSlotInfoArray
            publisherId:(NSString *)pubId
             controller:(UIViewController *)controller{
    
    NSAssert(([adSlotInfoArray count] != 0), @"adSlotInfoArray should not be empty");
    self = [super init];
    if (self) {
        
        _adSlotInfoArray = adSlotInfoArray;
        _impressionIdViewMap = [NSMutableDictionary new];
        _prefetchManager = [PMPrefetchManager sharedInstance];
        _prefetchManager.delegate = self;
        _controller = controller;
        _publisherId = pubId;
        
    }
    return self;
}

-(void)execute{
    
    [self registerEventListener ];
    [self requestPubMaticHeaderBidding];
    
}

-(void)registerEventListener{
    
    [_impressionIdViewMap removeAllObjects];
    [_adSlotInfoArray enumerateObjectsUsingBlock:^(AdSlotInfo * adSlotInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MPAdView * mpAdView  = (MPAdView *)adSlotInfo.adView;
        mpAdView.delegate = self;
        
    }];
}

-(void)requestPubMaticHeaderBidding{
    
    [_impressionIdViewMap removeAllObjects];
    NSMutableArray * impressionArray = [NSMutableArray new];
    [_adSlotInfoArray enumerateObjectsUsingBlock:^(AdSlotInfo * adSlotInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MPAdView * mpAdView  = (MPAdView *)adSlotInfo.adView;
        NSString * slotName  = adSlotInfo.slotName;
        NSString * impressionId = mpAdView.adUnitId;
        PMBannerImpression *impression = [[PMBannerImpression alloc] initWithImpressionId:impressionId slotName:slotName slotIndex:1 sizes:adSlotInfo.sizes];
        [impressionArray addObject:impression];
        [_impressionIdViewMap setObject:mpAdView forKey:impressionId];
        
    }];
    
    PMBannerPrefetchRequest * prefetchAdRequest = [[PMBannerPrefetchRequest alloc] initForPrefetchWithPublisherId:_publisherId impressionArray:impressionArray];
    self.prefetchManager.refreshInterval = self.refreshInterval;;
    [self.prefetchManager prefetchCreativesForRequest:prefetchAdRequest];
}

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didReceiveBids:(NSDictionary *)bids
{
    [self requestToMopub:bids];
}

- (void)prefetchManager:(PMPrefetchManager *)prefetchManager didFailWithError:(NSError *)error
{
    [self requestToMopub:nil];
    NSLog(@"PrefetchManager failed with error: %@", error.debugDescription);
}

-(void)requestToMopub:(NSDictionary *)bids{
 
    __weak typeof(self) weakSelf = self;
    NSArray *impressions = [self.impressionIdViewMap allKeys];
    for (NSString *impressionId in impressions)
    {
        PMBid *bid = bids[impressionId];
        
        NSMutableString * keywords = [NSMutableString new];

        if (bid)
        {
            
            [keywords appendFormat:@"%@:%d,",kBidStatus,bid.status.intValue];
            [keywords appendFormat:@"%@:%0.1f,",@"m_bid",bid.price];
            [keywords appendFormat:@"%@:%@,",kBidId,bid.impId];
            if (bid.dealId) {
                [keywords appendFormat:@"%@:%@",kWDealId,bid.dealId];
            }

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MPAdView * banner = [weakSelf.impressionIdViewMap objectForKey:impressionId];
            banner.keywords = [NSString stringWithString:keywords];
            [banner loadAd];
        });
    }
    
    NSLog(@"Creatives: %@", bids.description);
}

#pragma mark - MPAdViewDelegate

-(void)adViewDidLoadAd:(MPAdView *)view{
    
    [view stopAutomaticallyRefreshingContents];
    NSLog(@"MoPub banner ad loaded");

}

-(void)adViewDidFailToLoadAd:(MPAdView *)view{
    
    [view stopAutomaticallyRefreshingContents];
    NSLog(@"MoPub banner ad failed");

}

-(UIViewController *)viewControllerForPresentingModalView{
    
    return self.controller;
}

-(void)dealloc{
    
    [self.prefetchManager reset];
    _prefetchManager.delegate = nil;
    _impressionIdViewMap = nil;
    _prefetchManager = nil;
    _controller = nil;
}
@end
