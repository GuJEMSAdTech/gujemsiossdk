//
//  GUJNativeAdManager.h
//  Pods
//
//  
//
//

#import <Foundation/Foundation.h>
#import "GUJNativeAd.h"


@interface GUJNativeAdManager : NSObject

-(GUJNativeAd *) nativeAdWithUnitID:(NSString *) unitId;

@end
