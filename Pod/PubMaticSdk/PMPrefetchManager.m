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

#define WEBVIEW_TAG 1025
#define HTML_WRAP @"<html><head><meta name=\"viewport\" content=\"user-scalable=0;\"/><style>*:not(input){-webkit-touch-callout:none;-webkit-user-select:none;-webkit-text-size-adjust:none;}body{margin:0;padding:0;}</style></head><body><div align=\"center\">%@</div></body></html>"

#import "PMPrefetchManager.h"
#import "PMBid.h"
#import "NSTimerProxy.h"

@interface PMPrefetchManager ()<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *prefetchedCreatives;
@property (nonatomic, strong) NSMutableDictionary *impressionIdWebViewMap;
@property (nonatomic ) NSURLRequest * request;
@property (nonatomic ) NSTimerProxy * timer;
@property (nonatomic, assign) BOOL refreshEnabled;
@end

@implementation PMPrefetchManager
-(void)dealloc{

    [self.timer invalidate];
    self.timer = nil;
    self.prefetchedCreatives = nil;
    self.request = nil;
    self.impressionIdWebViewMap = nil;
}

+(PMPrefetchManager *)sharedInstance{
    
    static PMPrefetchManager * instance = nil;
    if (instance ==nil) {
        instance = [PMPrefetchManager new];
    }
    return instance;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _refreshInterval = 30;
        _maxNetworkTimeout = NETWORK_TIMEOUT_SECONDS;;
        _impressionIdWebViewMap = [NSMutableDictionary new];

    }
    return self;
}

-(void)setRefreshInterval:(NSTimeInterval)refreshInterval{

    _refreshEnabled = YES;
    if (refreshInterval>=120) {
        _refreshInterval = 120;
    }else if (refreshInterval>=12) {
        _refreshInterval = refreshInterval;
    }else if (refreshInterval>=1) {
        _refreshInterval = 12;
    }else{
        _refreshEnabled = NO;
    }
}

-(void)setMaxNetworkTimeout:(NSTimeInterval)maxNetworkTimeout{
    
    if (maxNetworkTimeout>=10) {
        _maxNetworkTimeout = 10;
    }else if (maxNetworkTimeout>3) {
        _maxNetworkTimeout = maxNetworkTimeout;
    }else{
        _maxNetworkTimeout = 3;
    }
}

-(void)removeOldWebViews{
    
    NSArray *impressions = [self.impressionIdWebViewMap allKeys];
    for (NSString *impressionId in impressions)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        
            UIWebView * oldWebView = [self.impressionIdWebViewMap objectForKey:impressionId];
            [oldWebView removeFromSuperview];
        });
    }
}

-(void)renderPubMaticAdWithImpressionId:(NSString *)impressionId forAdView:(UIView *)adView{

    __weak typeof(self) weakSelf = self;
    PMBid * bid = [self.prefetchedCreatives objectForKey:impressionId];
    if (!bid.impTrackerExecuted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIView * container = adView.superview;
            UIWebView * oldWebView = [self.impressionIdWebViewMap objectForKey:impressionId];
            [oldWebView removeFromSuperview];
            
            UIWebView * webView = [[UIWebView alloc] initWithFrame:adView.frame];
            webView.delegate = weakSelf;
            [self.impressionIdWebViewMap setObject:webView forKey:impressionId];
            [container addSubview:webView];
            NSString * creative = [NSString stringWithFormat:HTML_WRAP,bid.creativeTag];
            [webView loadHTMLString:creative baseURL:nil];
            [self track:bid.impTracker];
            bid.impTrackerExecuted = YES;
            
        });
    }else{
        DLog(@"Already Ad rendered for bid - %@",bid.impId);
    }
}

-(UIWebView * )renderedViewForImpressionId:(NSString *)impressionId adsize:(CGSize)size{
    
    __weak typeof(self) weakSelf = self;
    
    PMBid * bid = [self.prefetchedCreatives objectForKey:impressionId];
    if (bid && !bid.impTrackerExecuted) {
        
        UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        webView.delegate = weakSelf;
        [self.impressionIdWebViewMap setObject:webView forKey:impressionId];
        NSString * creative = [NSString stringWithFormat:HTML_WRAP,bid.creativeTag];
        [webView loadHTMLString:creative baseURL:nil];
        [self track:bid.impTracker];
        bid.impTrackerExecuted = YES;
        return webView;
    }else{
        return nil;
    }
}

-(PMBid *)bidForWebView:(UIWebView *)webView{
    
    __block PMBid * bid = nil;
    [self.impressionIdWebViewMap enumerateKeysAndObjectsUsingBlock:^(NSString * imprId, UIWebView * obj, BOOL *stop){
        
        if ([obj isEqual:webView]) {
            
            bid = [self.prefetchedCreatives objectForKey:imprId];
        }
    }];
    return bid;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        PMBid * bid = [self bidForWebView:webView];
        if (bid) {
         
            if (!bid.clkTrackerExecuted) {
                
                [self track:bid.clkTracker];
                [bid setClkTrackerExecuted:YES];

            }
        }
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:^(BOOL success) {
                
            }];
        }else{
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        
        return NO;
    }
    return YES;
}

-(void)track:(NSString *)url{
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        DLog(@"Tracked - %@",response.URL);

    }] resume];
}

- (NSMutableDictionary*)prefetchedCreatives
{
    if (_prefetchedCreatives == nil)
    {
        _prefetchedCreatives = [[NSMutableDictionary alloc] init];
    }
    return _prefetchedCreatives;
}

- (void)prefetchCreativesForRequest:(PMBannerPrefetchRequest *)prefetchRequest{

    NSError * error = nil;

    NSURLRequest *request = [prefetchRequest prefetchUrlRequestWithError:&error];
    if (error) {
        
        [self.delegate prefetchManager:self didFailWithError:error];
        return;
    }
    self.request = request;
    [self.timer invalidate];
    self.timer = nil;
    
    [self loadRequest];

    if (self.refreshEnabled) {
     
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimerProxy scheduledTimerWithTimeInterval:(self.refreshInterval-self.maxNetworkTimeout) target:weakSelf selector:@selector(loadRequest) userInfo:nil repeats:YES];

    }
}

-(void)loadRequest{
    
    [self removeOldWebViews];
    NSMutableURLRequest * mRequest = [self.request mutableCopy];
    [mRequest setTimeoutInterval:self.maxNetworkTimeout];
    
    __weak typeof(self) weakSelf = self;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable anError) {
        
        if (anError) {
            
            [weakSelf.delegate prefetchManager:weakSelf didFailWithError:anError];
            return ;
        }
        
        NSString *respString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"Prefetch Response:- \n%@", respString);
        
        NSError * error = nil;
        
        //Received response. Parse & save pre-fetched creative details.
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:&error];
        
        if (!error && jsonResponse != nil && jsonResponse.count > 0)
        {
            NSArray *seatBids = [jsonResponse objectForKey:@"seatbid"];
            
            if (seatBids && seatBids.count) {
                
                NSArray *bids = [seatBids[0] valueForKey:@"bid"];
                
                if (bids && bids.count) {
                    //Bid details to return to publisher in delegate call.
                    
                    for (NSDictionary *creativeDict in bids)
                    {
                        PMBid *bid = [[PMBid alloc] initWithBidDetails:creativeDict];
                        [weakSelf.prefetchedCreatives setValue:bid forKey:bid.impId];
                        if (bid.error) {
                            DLog(@"Invalid Bid for Impression Id - %@, Error - %@ ",bid.impId,bid.error);
                        }
                    }
                    
                    if ([weakSelf.prefetchedCreatives count]) {
                        [weakSelf.delegate prefetchManager:weakSelf didReceiveBids:weakSelf.prefetchedCreatives];
                    }else{
                        
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No bids available", nil),};
                        error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                                    code:1
                                                userInfo:userInfo];
                    }
                }
                else {
                    
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No bids available", nil),};
                    error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                                code:1
                                            userInfo:userInfo];
                    
                }
            }
            else {
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No bids available", nil),};
                error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                            code:1
                                        userInfo:userInfo];
                
            }
        }
        else {
            
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No bids available", nil),};
            error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                        code:1
                                    userInfo:userInfo];
            
        }
        
        if (error)
        {
            [weakSelf.delegate prefetchManager:weakSelf didFailWithError:error];
        }
        
    }] resume];
}

-(void)stopRefresh{
    
    [self reset];
}

-(void)reset{
    
    [self.timer invalidate];
    self.timer = nil;
}
@end
