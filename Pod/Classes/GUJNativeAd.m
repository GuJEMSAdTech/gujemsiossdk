/*
 * BSD LICENSE
 * Copyright (c) 2015, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer .
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "GUJNativeAd.h"
#import "XMLDictionary.h"
#import "UIView+GUJExtention.h"




/*
 used for sending impressionTrackers requests
 */

@interface GUJNativeAdTracker : NSObject <UIWebViewDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong) UIWebView *invisibleWebView;
@property (nonatomic, strong) NSMutableArray *trackers;

@property (nonatomic, strong) NSString *activeTracker;
-(void) addTracker:(NSString *) tracker;
-(void) sendTrackers;

@end


@implementation GUJNativeAdTracker

+ (instancetype)sharedManager
{
    static GUJNativeAdTracker *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GUJNativeAdTracker alloc] init];
        instance.trackers = [NSMutableArray array];
    });
    
    return instance;
}

-(void) addTracker:(NSString *) tracker {
    if (tracker != nil) {
        [self.trackers addObject:tracker];
    }
}

-(BOOL) trackerIsLink:(NSString *) tracker {
    return [tracker hasPrefix:@"http"];
}

-(NSString *) htmlForTracker:(NSString *) tracker {
    return [NSString stringWithFormat:@"<html><body>%@</body></html>", tracker];
}

-(void) sendTrackers {
    
    if (self.invisibleWebView.isLoading) {
        return;
    }
    
    if (self.invisibleWebView == nil) {
        self.invisibleWebView = [[UIWebView alloc] init];
        self.invisibleWebView.delegate = self;
    }
    
    if (self.trackers.count) {
        [self sendTrackerItem:self.trackers.firstObject];
    } else {
        [self clearTracker];
    }
}

-(void) sendTrackerItem:(NSString *) tracker {
    self.activeTracker = tracker;
    
    if ([self trackerIsLink:tracker]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tracker]];
        [self.invisibleWebView loadRequest:request];
    } else {
        [self.invisibleWebView loadHTMLString:[self htmlForTracker:tracker] baseURL:nil];
    }
}

-(void) didFinishSendTrackerItem {
    [self.trackers removeObject:self.activeTracker];
    self.activeTracker = nil;
    
    //check if need send next tracker
    [self sendTrackers];
}

-(void) clearTracker {
    self.activeTracker = nil;
    
    [self.invisibleWebView stopLoading];
    self.invisibleWebView.delegate = nil;
    self.invisibleWebView = nil;
}

#pragma mark UIWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self didFinishSendTrackerItem];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self didFinishSendTrackerItem];
}

@end










static NSString *const NATIVE_AD_SERVER_ADDRESS = @"https://pubads.g.doubleclick.net/gampad/adx";


@interface GUJNativeAd ()

@property (nonatomic, strong) NSMutableDictionary *requestParameters;

/* Ad content */

//a HTML Tag, <img> or <script>,to load in an invisible Webview
@property (nonatomic, strong) NSArray *impressionTrackers;

//a Native Ad View can have a  "Anzeige"-Label  false deactivates this (hides it), true shows it
@property (nonatomic) BOOL isAdLabelShow;

//a Native Ad View can have a „Presenter“ Label false deactivates this (hides it), true shows it Presenterlabel would be PresenterText + " " + PresenterName (trimmed, if PresenterText is empty)
@property (nonatomic) BOOL isPresenterLabelShow;

//Presentername, e.g. the clients name, like „BMW“
@property (nonatomic, strong) NSString *presenterName;

//value for Presentership text
@property (nonatomic, strong) NSString *presenterTextValue;

//used for generating click url
@property (nonatomic, strong) NSString *specialAdUnit;

//used for generating click url
@property (nonatomic, strong) NSString *articleId;

//used for generating click url
@property (nonatomic, strong) NSString *clickUrlServer;

//a URL, which will be called invisible on click, to enable the advertiser to count the click
@property (nonatomic, strong) NSString *clickTracker;

//a HTML Tag, <img> or <script>,to load in an invisible Webview
@property (nonatomic, strong) NSString *impressionPixel;


@end





@implementation GUJNativeAd

+(GUJNativeAd *) nativeAdWithUnitId:(NSString *) unitId {
    
    GUJNativeAd *adContext = [[GUJNativeAd alloc] init];
    adContext.adUnitId = unitId;

    return adContext;
}

-(NSString *) presenterText {
    if (self.isPresenterLabelShow) {
        if (self.presenterTextValue && self.presenterName) {
            return [NSString stringWithFormat:@"%@ %@", self.presenterTextValue, self.presenterName];
        } else {
            return self.presenterTextValue;
        }
    }
    
    return nil;
}

-(void) registerViewForInteraction:(UIView *) view {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [view addGestureRecognizer:tapRecognizer];
    view.guj_nativeAd = self;
    
    [self sendTrackers];
}

-(void) unregisterViewForInteraction:(UIView *) view {
    
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        if (recognizer.numberOfTouches == 1) {
            [view removeGestureRecognizer:recognizer];
        }
    }
}


#pragma mark Trackers

-(void) sendTrackers {

    [[GUJNativeAdTracker sharedManager] addTracker:self.impressionPixel];

    for (NSString *tracker in self.impressionTrackers) {
        [[GUJNativeAdTracker sharedManager] addTracker:tracker];
    }

    [[GUJNativeAdTracker sharedManager] sendTrackers];
}

#pragma mark Click Action

-(NSString *) clickLink {
    if (self.clickUrl) {
        NSString *encodedClickUrl = [self.clickUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self.clickUrlServer stringByAppendingString:encodedClickUrl];
    } else {
        if (self.defaultClickURL) {
            NSString *clickUrl = [NSString stringWithFormat:@"%@?an=s:%@-a:%@-t:n", self.defaultClickURL, self.specialAdUnit, self.articleId];
            NSString *encodedClickUrl = [clickUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return [self.clickUrlServer stringByAppendingString:encodedClickUrl];
        }
    }
    
    return nil;
}

-(void) clickAction {
    NSString *link = [self clickLink];

    if ([self.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.delegate nativeAdDidClick:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(nativeAdCustomBrowser:)]) {
        [self.delegate nativeAdCustomBrowser:link];
    } else if (link) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
}

#pragma mark Request ad

-(NSMutableDictionary *) requestParameters {
    if (_requestParameters == nil) {
        _requestParameters = [NSMutableDictionary dictionary];
        [_requestParameters setObject:@"text/xml" forKey:@"m"];

        [self setAdSize:CGSizeMake(200, 200)];
        [self setPositionIndex:1];
        [self setTileIndex:1];
        
    }
    
    return _requestParameters;
}

-(void) setTileIndex:(NSInteger) index {
    [self.requestParameters setObject:[NSString stringWithFormat:@"%ld", (long) index] forKey:@"tile"];
}

-(void) setPositionIndex:(NSInteger) index {
    [self.requestParameters setObject:[NSString stringWithFormat:@"pos=%ld", (long)index] forKey:@"t"];
}

-(void) setRandom:(NSString *) random {
    if (random == nil) return;
    
    [self.requestParameters setObject:random forKey:@"c"];
}

-(void) setAdSize:(CGSize) size {
    [self.requestParameters setObject:[NSString stringWithFormat:@"%.fx%.f", size.width, size.height] forKey:@"sz"];
}


-(NSURL *) requestUrl {
    
    NSURLComponents *components = [NSURLComponents componentsWithString:NATIVE_AD_SERVER_ADDRESS];

    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in self.requestParameters) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:self.requestParameters[key]];
        [queryItems addObject:item];
    }
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"iu" value:self.adUnitId]];
    components.queryItems = queryItems;

    return components.URL;
}


-(void) loadAd {
    
    NSURL *url = [self requestUrl];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
                if (!error) {
                    // Success
                    
                    if ([self parseXMLData:data]) {
                        [self didCompleateLoadData];
                    } else {
                        NSDictionary *info = [NSDictionary dictionaryWithObject:@"XML data is not correct" forKey:NSLocalizedDescriptionKey];
                        NSError *error = [NSError errorWithDomain:@"app" code:0 userInfo:info];
                        [self didFailLoadData:error];
                    }
                } else {
                    // Fail
                    [self didFailLoadData:error];
                }
            }] resume];
}

-(void) didCompleateLoadData {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad:)]) {
            [self.delegate nativeAdDidLoad:self];
        }
    });
}

-(void) didFailLoadData:(NSError *) error {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(nativeAd:didFailWithError:)]) {
            [self.delegate nativeAd:self didFailWithError:error];
        }
    });
}

#pragma mark XML parsing

//return YES if success
-(BOOL) parseXMLData:(NSData *) data {
    
    if (data != nil) {
        NSDictionary *info = [NSDictionary dictionaryWithXMLData:data];
        
        if (info.allKeys.count == 0) {
            return NO;
        }
        
        NSMutableArray *trakers = [NSMutableArray array];
        NSString *tracker1 = [info valueForKey:@"ImpressionTracker1"];
        if (tracker1) [trakers addObject:tracker1];
        NSString *tracker2 = [info valueForKey:@"ImpressionTracker2"];
        if (tracker2) [trakers addObject:tracker2];
        NSString *tracker3 = [info valueForKey:@"ImpressionTracker3"];
        if (tracker3) [trakers addObject:tracker3];
        NSString *tracker4 = [info valueForKey:@"ImpressionTracker4"];
        if (tracker4) [trakers addObject:tracker4];
        self.impressionTrackers = trakers;
        
        NSString *adLabel = [info valueForKey:@"AdLabel"];
        self.isAdLabelShow = adLabel.boolValue;
        
        NSString *presenterLabel = [info valueForKey:@"PresenterLabel"];
        self.isPresenterLabelShow = presenterLabel.boolValue;
        self.presenterTextValue = [info valueForKey:@"PresenterText"];
        self.presenterName = [info valueForKey:@"PresenterName"];
        
        self.teaserImage1 = [info valueForKey:@"TeaserImage12"];
        self.teaserImage2 = [info valueForKey:@"TeaserImage11"];
        self.teaserImage3 = [info valueForKey:@"TeaserImage13"];
        
        self.headline = [info valueForKey:@"Headline"];
        self.subHeadline = [info valueForKey:@"SubHeadline"];
        self.teaserText = [info valueForKey:@"TeaserText"];
        
        self.impressionPixel = [info valueForKey:@"ViewBasedImpressionPixel"];
        self.specialAdUnit = [info valueForKey:@"SpecialAdUnit"];
        self.articleId = [info valueForKey:@"ArticleId"];
        self.clickUrlServer = [info valueForKey:@"ClickURLServer"];
        self.clickTracker = [info valueForKey:@"ClickTracker"];
        
        return YES;
    }
    
    return NO;
}

@end
