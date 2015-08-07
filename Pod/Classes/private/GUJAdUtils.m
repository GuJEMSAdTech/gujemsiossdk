//
// Created by Michael Brügmann on 07.08.15.
//

#import <Google-Mobile-Ads-SDK/GoogleMobileAds/DFPRequest.h>
#import "GUJAdUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>

@implementation GUJAdUtils {
}


+ (void)printDeviceInfo {
    NSLog(@"isOtherAudioPlaying: %@", [self isOtherAudioPlaying] ? @"YES" : @"NO");
    NSLog(@"isHeadsetPluggedIn: %@", [self isHeadsetPluggedIn] ? @"YES" : @"NO");
    NSLog(@"getBatteryLevel: %@", [self getBatteryLevel]);
    NSLog(@"getIPAddress: %@", [self getIPAddress]);
    NSLog(@"getAltitude: %f", [self getAltitude]);
}


+ (BOOL)isOtherAudioPlaying {
    BOOL isOtherAudioPlaying = [[AVAudioSession sharedInstance] isOtherAudioPlaying];

    return isOtherAudioPlaying;
}


+ (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}


+ (NSNumber *)getBatteryLevel {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

    //This will give us the battery between 0.0 (empty) and 1.0 (100% charged)
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];

    // convert to percent
    batteryLevel *= 100;

    return @(batteryLevel);
}


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;

}


+ (CLLocationDistance)getAltitude {
    CLLocationManager *locationManager_ = [[CLLocationManager alloc] init];
    return locationManager_.location.altitude;
}

@end