//
// Created by Michael Brügmann on 03.08.15.
// Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

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
- (NSString *)getAdUnitIdForAdspaceId:(NSString *)adSpaceId;


/**
* Get a Google Ad custom criteria position (pos) for the given Amobee AdSpace ID.
* @return a position or NSNotFound if no mapping found
*/
- (NSInteger)getPositionForAdspaceId:(NSString *)adSpaceId;


- (NSString *)getAdspaceIdForAdUnitId:(NSString *)adUnitId position:(NSInteger)position;

/**
* Check if the given identifier string is an Amobee AdSpace ID (i.e. exists of digits only)
* @return YES if identifier is an Amobee AdSpace ID, NO otherwise
*/
- (BOOL)isAdSpaceId:(NSString *)identifier;

@end