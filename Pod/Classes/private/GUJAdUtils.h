//
// Created by Michael Brügmann on 07.08.15.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GUJAdUtils : NSObject

+ (BOOL)isOtherAudioPlaying;

+ (BOOL)isHeadsetPluggedIn;

+ (NSNumber *)getBatteryLevel;

+ (NSString *)getIPAddress;

+ (CLLocationDistance)getAltitude;

@end