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

#import "GUJAdUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GUJAdUtils {
}

static BOOL npaStatus = false;
static BOOL isChildStatus = false;

+ (void)setNonPersonalizedAds:(BOOL)status:(BOOL)isChild {
    npaStatus = status;
    isChildStatus = isChild;
}

+ (BOOL)getIsChild {
    return isChildStatus;
}

+ (BOOL)getNonPersonalizedAds {
    return npaStatus;
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


+ (BOOL)isLoadingCablePluggedIn {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

    UIDeviceBatteryState currentState = [[UIDevice currentDevice] batteryState];
    return currentState == UIDeviceBatteryStateCharging || currentState == UIDeviceBatteryStateFull;
}


+ (NSString *)identifierForAdvertising {
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        NSUUID *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        return [idfa UUIDString];
    }

    return nil;
}


+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}


+ (NSString *)normalizeAdUnitId:(NSString *)adUnitId {

    if (adUnitId == nil) {
        NSLog(@"ERROR: AdUnitId is may not be nil.");
        return nil;
    }

    if (![adUnitId hasPrefix:@"/"]) {
        adUnitId = [@"/" stringByAppendingString:adUnitId];
    }
    if (![adUnitId hasPrefix:@"/6032"]) {
        adUnitId = [@"/6032" stringByAppendingString:adUnitId];
    }

    return adUnitId;
}


+ (NSString *)urlencode:(NSString*)unencodedString {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[unencodedString UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                (thisChar >= 'a' && thisChar <= 'z') ||
                (thisChar >= 'A' && thisChar <= 'Z') ||
                (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
