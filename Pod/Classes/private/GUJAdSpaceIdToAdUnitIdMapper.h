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

#import <Foundation/Foundation.h>


static NSString *const DFP_PUBLISHER_ID = @"6032";

@interface GUJAdSpaceIdToAdUnitIdMapper : NSObject

@property(nonatomic, strong) NSArray *mappingData;


/**
* Get a singleton instance of this GUJAdSpaceIdToAdUnitIdMapper class.
*/
+ (GUJAdSpaceIdToAdUnitIdMapper *)instance;


/**
* Get a Google AdUnit ID for the given Amobee AdSpace ID.
* @return a Google AdUnit ID or nil if no mapping found
*/
- (NSString *)getAdUnitIdForAdSpaceId:(NSString *)adSpaceId;


/**
* Get a Google Ad custom criteria position (pos) for the given Amobee AdSpace ID.
* @return a position or NSNotFound if no mapping found
*/
- (NSInteger)getPositionForAdSpaceId:(NSString *)adSpaceId;


/**
* Get a Google Ad custom criteria index page (ind) for the given Amobee AdSpace ID.
* @return YES if the AdSpace ID is used for an index, NO otherwise
*/
- (BOOL)getIsIndexForAdSpaceId:(NSString *)adSpaceId;


/**
* Reverse map an Ad Unit ID and its pos/ ind attribute to an AdSpace ID.
*/
- (NSString *)getAdSpaceIdForAdUnitId:(NSString *)adUnitId position:(NSInteger)position index:(BOOL)isIndex;


/**
* Check if the given identifier string is an Amobee AdSpace ID (i.e. exists of digits only)
* @return YES if identifier is an Amobee AdSpace ID, NO otherwise
*/
- (BOOL)isAdSpaceId:(NSString *)identifier;

@end