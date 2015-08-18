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

#import "GUJAdSpaceIdToAdUnitIdMapper.h"
#import "XMLDictionary.h"
#import "GUJAdViewContext.h"


@implementation GUJAdSpaceIdToAdUnitIdMapper {
}

+ (GUJAdSpaceIdToAdUnitIdMapper *)instance {
    static GUJAdSpaceIdToAdUnitIdMapper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];

        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle]
                pathForResource:@"gujemsiossdk"
                         ofType:@"bundle"]];

        NSString *filePath = [bundle pathForResource:@"dfpmapping" ofType:@"xml"];
        NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLFile:filePath];
        instance.mappingData = xmlDictionary[@"zone"];
        if (xmlDictionary != nil) {
            NSLog(@"successfully loaded dfpmapping.xml");
        } else {
            NSLog(@"ERROR loading dfpmapping.xml");
        }
    });
    return instance;
}


- (NSString *)getAdUnitIdForAdSpaceId:(NSString *)adSpaceId {
    NSLog(@"getAdUnitIdForAdSpaceId: %@ ...", adSpaceId);
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"_name"] isEqual:adSpaceId]) {
            NSString *adUnitId = [NSString stringWithFormat:@"/%@/%@", DFP_PUBLISHER_ID, dict[@"_adunit"]];
            NSLog(@"adUnitId: %@", adUnitId);
            return adUnitId;
        }
    }
    NSLog(@"adSpaceId not found in mapping file!");
    return nil;
}


- (NSInteger)getPositionForAdSpaceId:(NSString *)adSpaceId {
    NSLog(@"getPositionForAdSpaceId: %@ ...", adSpaceId);
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"_name"] isEqual:adSpaceId]) {
            NSInteger position = [dict[@"_position"] intValue];
            NSLog(@"position: %ld", (long)position);
            return position;
        }
    }
    NSLog(@"adSpaceId not found in mapping file!");
    return GUJ_AD_VIEW_POSITION_UNDEFINED;
}


- (BOOL)getIsIndexForAdSpaceId:(NSString *)adSpaceId {
    NSLog(@"getIsIndexForAdSpaceId: %@ ...", adSpaceId);
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"_name"] isEqual:adSpaceId]) {
            BOOL isIndex = [dict[@"_index"] isEqualToString:@"true"];
            NSLog(@"isIndex: %@", isIndex ? @"YES" : @"NO");
            return isIndex;
        }
    }
    NSLog(@"adSpaceId not found in mapping file!");
    return NO;  // default
}


- (NSString *)getAdSpaceIdForAdUnitId:(NSString *)adUnitId position:(NSInteger)position index:(BOOL)isIndex {

    for (NSDictionary *dict in self.mappingData) {
        if (isIndex) {
            if ([dict[@"_adunit"] isEqual:adUnitId]
                    && [dict[@"_position"] isEqual:@(position)]
                    && [dict[@"_index"] isEqualToString:@"true"]) {
                return dict[@"_name"];
            }
        } else {  // index is optional attribute in dfpmapping.xml, default is false
            if ([dict[@"_adunit"] isEqual:adUnitId]
                    && [dict[@"_position"] isEqual:@(position)]
                    && ([dict[@"_index"] isEqualToString:@"false"] || dict[@"_index"] == nil)) {
                return dict[@"_name"];
            }
        }
    }
    return nil;
}


- (BOOL)isAdSpaceId:(NSString *)identifier {
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [identifier rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

@end