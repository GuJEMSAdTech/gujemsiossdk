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

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GUJBaseAdViewContext.h"


static NSString *const CUSTOM_TARGETING_KEY_ALTITUDE = @"pga";
static NSString *const CUSTOM_TARGETING_KEY_SPEED = @"pgv";
static NSString *const CUSTOM_TARGETING_KEY_DEVICE_STATUS = @"psx";
static NSString *const CUSTOM_TARGETING_KEY_BATTERY_LEVEL = @"pbl";
static NSString *const CUSTOM_TARGETING_KEY_IDFA = @"idfa";


@implementation GUJBaseAdViewContext {
    CLLocationManager *locationManager;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.customTargetingDict = [NSMutableDictionary new];

        self.locationServiceDisabled = false;

        self.customTargetingDict[CUSTOM_TARGETING_KEY_BATTERY_LEVEL] = [[GUJAdUtils getBatteryLevel] stringValue];
        if ([GUJAdUtils identifierForAdvertising]) {
            self.customTargetingDict[CUSTOM_TARGETING_KEY_IDFA] = [GUJAdUtils md5:[GUJAdUtils identifierForAdvertising]];
        }

        BOOL isHeadsetPluggedIn = [GUJAdUtils isHeadsetPluggedIn];
        BOOL isLoadingCablePluggedIn = [GUJAdUtils isLoadingCablePluggedIn];

        if (isHeadsetPluggedIn && isLoadingCablePluggedIn) {
            self.customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"c,h";

        } else if (isLoadingCablePluggedIn) {
            self.customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"c";

        } else if (isHeadsetPluggedIn) {
            self.customTargetingDict[CUSTOM_TARGETING_KEY_DEVICE_STATUS] = @"h";

        }
    }

    return self;
}


- (void)updateLocationDataInCustomTargetingDictAndOptionallySetLocationDataOnDfpRequest:(DFPRequest *)request {
    if ([CLLocationManager locationServicesEnabled] && !self.locationServiceDisabled) {

        locationManager = [[CLLocationManager alloc] init];

        BOOL locationAllowed_iOS7 = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
        BOOL locationAllowed_iOS8 = ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]
                && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways));

        if (locationAllowed_iOS7 || locationAllowed_iOS8) {

            // we don't require a delegate and location updates
            // we simply take the last available location, if existing

            CLLocation *location = locationManager.location;

            if (location != nil) {   // might be nil on first start of app, we skip sending location data in this case
                if (request != nil) {
                    [request setLocationWithLatitude:locationManager.location.coordinate.latitude
                                           longitude:locationManager.location.coordinate.longitude
                                            accuracy:locationManager.location.horizontalAccuracy];
                }

                self.customTargetingDict[CUSTOM_TARGETING_KEY_ALTITUDE] = [@((int) locationManager.location.altitude) stringValue];
                self.customTargetingDict[CUSTOM_TARGETING_KEY_SPEED] = [@((int) locationManager.location.speed) stringValue];

                NSLog(@"Added location data.");
            } else {
                NSLog(@"No location data available.");
            }
        } else {
            NSLog(@"Location Services not authorized.");
        }
    }
}


- (BOOL)disableLocationService {
    self.locationServiceDisabled = YES;
    return YES;
}


- (void)addCustomTargetingKeyword:(NSString *)keyword {
    if (self.customTargetingDict[KEYWORDS_DICT_KEY] != nil) {
        self.customTargetingDict[KEYWORDS_DICT_KEY] = [NSMutableArray new];
    }
    NSMutableArray *keywordArray = self.customTargetingDict[KEYWORDS_DICT_KEY];
    [keywordArray addObject:keyword];
}

- (void)addCustomTargetingKey:(NSString *)key Value:(NSString *)value {
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_ALTITUDE], @"psa automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_SPEED], @"pgv automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_DEVICE_STATUS], @"psx automatically set by SDK.");
    NSAssert(![key isEqualToString:CUSTOM_TARGETING_KEY_BATTERY_LEVEL], @"pbl automatically set by SDK.");
    NSAssert(![key isEqualToString:KEYWORDS_DICT_KEY], @"Set single keyword via the addKeywordForCustomTargeting: method.");
    self.customTargetingDict[key] = value;
}

@end