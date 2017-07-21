//
//  GUJIQAdViewContext.m
//  Pods
//
//  
//
//

#import "GUJIQAdViewContext.h"



static NSString *SetSizeEventName = @"setsize";
static NSString *LogEventName = @"log";
static NSString *NoadEventName = @"noad";


@interface GUJIQAdViewContext () <GADAppEventDelegate>

@end


@implementation GUJIQAdViewContext


- (void) loadBannerWithAdUnitId:(NSString *)adUnitId rootViewController:(UIViewController *)rootViewController delegate:(id<GUJAdViewContextDelegate, GUJIQAdViewContextDelegate>) delegate {
    
    self.delegate = delegate;
    
    self.adViewContext = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:rootViewController];
    self.adViewContext.position = GUJ_AD_VIEW_POSITION_TOP;
    self.adViewContext.delegate = delegate;
    
    DFPBannerView *v = [self.adViewContext adView];
    v.appEventDelegate = self;
}

-(GADBannerView *) bannerView {
    return self.adViewContext.bannerView;
}

- (void)adView:(GADBannerView *)banner
didReceiveAppEvent:(NSString *)name
      withInfo:(NSString *GAD_NULLABLE_TYPE)info {
    
    if ([name.lowercaseString isEqualToString:SetSizeEventName]) {
        [self didRecieveSetSizeEvent:info];
    }
    
    if ([name.lowercaseString isEqualToString:LogEventName]) {
        [self didRecieveLogEvent:info];
    }
    
    if ([name.lowercaseString isEqualToString:NoadEventName]) {
        [self didRecieveNoadEvent];
    }
}


-(void) didRecieveSetSizeEvent:(NSString *) info {
    
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
        
        if ([self.delegate respondsToSelector:@selector(iqAdView:changeSize:duration:)]) {
            [self.delegate iqAdView:self changeSize:size duration:timeValue];
        }
    });
}

-(void) didRecieveLogEvent:(NSString *) info {
    if ([self.delegate respondsToSelector:@selector(iqAdView:didReceivedLog:)]) {
        [self.delegate iqAdView:self didReceivedLog:info];
    }
}

-(void) didRecieveNoadEvent {
    [[self bannerView] removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(iqAdViewDidRemoveFromView:)]) {
        [self.delegate iqAdViewDidRemoveFromView:self];
    }
}


@end
