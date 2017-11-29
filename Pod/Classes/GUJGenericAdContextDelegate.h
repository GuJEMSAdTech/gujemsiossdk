//
//  GUJGenericAdContextDelegate.h
//  Pods
//
//

@class GUJGenericAdContext;

@protocol GUJGenericAdContextDelegate <NSObject>

@optional

- (void)genericAdContext:(GUJGenericAdContext *)adContext didLoadData:(GUJAdViewContext *)adViewContext;
- (void)genericAdContext:(GUJGenericAdContext *)adContext didFailWithError:(NSError *)error;

- (void)genericAdContext:(GUJGenericAdContext *)adContext didLoadFacebookNativeAd:(FBNativeAd *)fbNativeAd;

- (void)genericAdContext:(GUJGenericAdContext *)adContext didChangeBannerSize:(CGSize)size duration:(CGFloat) duration;
- (void)genericAdContext:(GUJGenericAdContext *)adContext didReceiveLog:(NSString *) log;
- (void)genericAdContextDidRemoveBannerFromView:(GUJGenericAdContext *)adContext;

@end
