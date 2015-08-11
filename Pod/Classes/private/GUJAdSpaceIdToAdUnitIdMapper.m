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


- (NSString *)getAdUnitIdForAdspaceId:(NSString *)adSpaceId {
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"_name"] isEqual:adSpaceId]) {
            return [NSString stringWithFormat:@"/%@/%@", DFP_PUBLISHER_ID, dict[@"_adunit"]];
        }
    }
    return nil;
}


- (NSInteger)getPositionForAdspaceId:(NSString *)adSpaceId {
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"_name"] isEqual:adSpaceId]) {
            return [dict[@"_position"] intValue];
        }
    }
    return GUJ_AD_VIEW_POSITION_UNDEFINED;
}


- (NSString *)getAdspaceIdForAdUnitId:(NSString *)adUnitId position:(NSInteger)position {
    for (NSDictionary *dict in self.mappingData) {
        if ([dict[@"adunit"] isEqual:adUnitId] && [dict[@"position"] isEqual:@(position)]) {
            return dict[@"_name"];
        }
    }
    return nil;
}


- (BOOL)isAdSpaceId:(NSString *)identifier {
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [identifier rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

@end