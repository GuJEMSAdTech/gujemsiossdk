//
//  GUJGenericAdContextDelegate.h
//  Pods
//
//

@class GUJAdViewContext;

@protocol GUJGenericAdContextDelegate <NSObject>

@optional

- (void)genericAdContext:(GUJAdViewContext *)adViewContext didFailWithError:(NSError *)error;
- (void)genericAdContextDidLoadData:(GUJAdViewContext *)adViewContext;

- (void)genericAdContextDidLoadFacebookNativeAd:(FBNativeAd *)fbNativeAd;

- (void)genericAdContextDidChangeBannerSize:(CGSize)size duration:(CGFloat) duration;
- (void)genericAdContextDidReceiveLog:(NSString *) log;
- (void)genericAdContextDidRemoveBannerFromView;

@end
