#import "GUJAdViewContext.h"
#import <CoreLocation/CoreLocation.h>


@interface GUJAdView ()
@end

@implementation GUJAdView
- (void)show {

}

- (void)showInterstitialView {

}

- (void)hide {

}

- (NSString *)adSpaceId {
    return nil;
}

@end


@interface GUJAdViewContext ()

@end

@implementation GUJAdViewContext{
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId {
    GUJAdViewContext *adViewContext = [[self alloc] init];
    adViewContext._adSpaceId = adSpaceId;
    return adViewContext;
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId delegate:(id <GUJAdViewControllerDelegate>)delegate {
    GUJAdViewContext *adViewContext = [self instanceForAdspaceId:adSpaceId];
    adViewContext.delegate = delegate;
    return adViewContext;
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId {
    return nil;
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId delegate:(id <GUJAdViewControllerDelegate>)delegate {
    return nil;
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId site:(NSInteger)siteId zone:(NSInteger)zoneId {
    return nil;
}

+ (GUJAdViewContext *)instanceForAdspaceId:(NSString *)adSpaceId adUnit:(NSString *)adUnitId site:(NSInteger)siteId zone:(NSInteger)zoneId delegate:(id <GUJAdViewControllerDelegate>)delegate {
    return nil;
}

- (void)setReloadInterval:(NSTimeInterval)reloadInterval {

}

- (BOOL)disableLocationService {
    return NO;
}

- (void)shouldAutoShowIntestitialView:(BOOL)show {

}

- (GUJAdView *)adView {


    return nil;
}

- (void)adView:(adViewCompletion)completion {

}

- (GUJAdView *)adViewWithOrigin:(CGPoint)origin {

    GUJAdView *bannerView = [[GUJAdView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 320, 50)];

    bannerView.adUnitID = @"/6032/sdktest";
    bannerView.rootViewController = self.rootViewController;
    bannerView.backgroundColor = [UIColor yellowColor];

    DFPRequest *request = [DFPRequest request];
    request.customTargeting = @{@"pos" : @1 };

    if ([CLLocationManager locationServicesEnabled]) {

        CLLocationManager * locationManager_ = [[CLLocationManager alloc] init];
        [request setLocationWithLatitude:locationManager_.location.coordinate.latitude
                               longitude:locationManager_.location.coordinate.longitude
                                accuracy:locationManager_.location.horizontalAccuracy];
    }



    [bannerView loadRequest:request];
    return bannerView;
}

- (void)adViewWithOrigin:(CGPoint)origin completion:(adViewCompletion)completion {
    NSLog(@"Google Mobile Ads SDK version: %@", [DFPRequest sdkVersion]);






}

- (GUJAdView *)adViewForKeywords:(NSArray *)keywords {
    return nil;
}

- (void)adViewForKeywords:(NSArray *)keywords completion:(adViewCompletion)completion {

}

- (GUJAdView *)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin {
    return nil;
}

- (void)adViewForKeywords:(NSArray *)keywords origin:(CGPoint)origin completion:(adViewCompletion)completion {

}

- (void)interstitialAdView {

}

- (void)interstitialAdViewWithCompletionHandler:(adViewCompletion)completion {

}

- (void)interstitialAdViewForKeywords:(NSArray *)keywords {

}

- (void)interstitialAdViewForKeywords:(NSArray *)keywords completion:(adViewCompletion)completion {

}

- (void)addAdServerRequestHeaderField:(NSString *)name value:(NSString *)value {

}

- (void)addAdServerRequestHeaderFields:(NSDictionary *)headerFields {

}

- (void)addAdServerRequestParameter:(NSString *)name value:(NSString *)value {

}

- (void)addAdServerRequestParameters:(NSDictionary *)requestParameters {

}

- (void)initalizationAttempts:(NSUInteger)attempts {

}

- (void)freeInstance {

}

@end
