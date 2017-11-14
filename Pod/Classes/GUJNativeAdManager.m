//
//  GUJNativeAdManager.m
//  Pods
//
// 
//
//

#import "GUJNativeAdManager.h"

@interface GUJNativeAdManager ()

@property (nonatomic, strong) NSString *randomValue;
@property (nonatomic) NSInteger tileIndex;

@end



@implementation GUJNativeAdManager

-(NSString *) randomValue {
    if (_randomValue == nil) {
        NSInteger timestemp = (NSInteger)[[NSDate date] timeIntervalSince1970];
        _randomValue = [NSString stringWithFormat:@"%ld", (long) timestemp];
    }
    return _randomValue;
}




-(GUJNativeAd *) nativeAdWithUnitID:(NSString *) unitId {
    self.tileIndex++;
    
    GUJNativeAd *ad = [GUJNativeAd nativeAdWithUnitId:unitId];
    [ad setTileIndex:self.tileIndex];
    [ad setRandom:[self randomValue]];
    
    return ad;
}

@end
