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


#import <Foundation/Foundation.h>
#import "PMBid.h"
#import "PMBannerPrefetchRequest.h"
#import "PMImpression.h"

@class PMPrefetchManager;

@protocol PMPrefetchDelegate <NSObject>

/**
 PrefetchManager bid received delegate. Called when prefetch manager receives bids from PubMatic.
 @param prefetchManager A prefetchManager instance that served the bids.
 @param bids Available bids.
 */
- (void)prefetchManager:(PMPrefetchManager*)prefetchManager didReceiveBids:(NSDictionary *)bids;

/**
 PrefetchManager bid request failed delegate. Called when the bid request fails to receive bids.
 @param prefetchManager A prefetchManager instance that failed to serve the bids.
 @param error NSError object containing the error description.
 */
- (void)prefetchManager:(PMPrefetchManager*)prefetchManager didFailWithError:(NSError *)error;

@end

@interface PMPrefetchManager : NSObject

+(PMPrefetchManager *)sharedInstance;

/**
 Interval in seconds for ad refresh, valid values are within range 12-120, if set outside of this range it is set to default value i.e. 30 seconds
 */
@property (nonatomic, assign) NSTimeInterval refreshInterval;

/**
 Interval in seconds for PubMatic prefetch ad request in seconds, valid values are within range 3-10, if set outside of this range it is set to default value i.e. 3 seconds
 */
@property (nonatomic, assign) NSTimeInterval maxNetworkTimeout;

/**
Delegate on which PMPrefetchDelegate methods are called
 */
@property (assign, nonatomic) id<PMPrefetchDelegate>delegate;

/**
Renders prefetched PubMatic Ad already cached against impressionId
@param impressionId Id received with prefetched creatives from PubMatic
@param adView Banner view reference of Master SDK
 */
-(void)renderPubMaticAdWithImpressionId:(NSString *)impressionId forAdView:(UIView *)adView;

/**
 Renders prefetched PubMatic Ad already cached against impressionId & returns instance of UIWebview if successful else nil
 @param impressionId Id received with prefetched creatives from PubMatic
 @param size Banner view reference of Master SDK
 */
-(UIWebView * )renderedViewForImpressionId:(NSString *)impressionId adsize:(CGSize)size;

/**
 Sends RTB request to fetch available bids.
 @param prefetchRequest A PrefetchRequest instance containing the impression details.
 */
- (void)prefetchCreativesForRequest:(PMBannerPrefetchRequest *)prefetchRequest;

/**
Removed old webview from cotainer for respective impressionId
 */
//-(void)removeOldWebViewFomImpressionId:(NSString *)impressionId;

/**
 Stops Ad refresh
 */
-(void)stopRefresh;

/**
 Resets NSTimer used for refresh, this method should be called before assigning nil to PMPrefetchManager instance
 */
-(void)reset;

@end
