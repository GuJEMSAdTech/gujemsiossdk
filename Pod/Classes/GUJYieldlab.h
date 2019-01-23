//
//  GUJYieldlab.h
//  gujemsiossdk
//
//  Created by Gohl, Michael on 23.01.19.
//

#import <Foundation/Foundation.h>
#import "GUJAdViewContext.h"


@interface GUJYieldlabMapElement : NSObject

+ (GUJYieldlabMapElement*) init:(NSString*)key value:(NSString*)value;
- (NSString*) getKey;
- (NSString*) getValue;

@end

@interface GUJYieldlabElement : NSObject

+(GUJYieldlabElement*) init:(NSString*)pvid price:(NSString*)price partner:(NSString*)partner ylid: (NSString*)ylid yid:(NSString*)yid map:(NSString*)map;
-(NSArray<GUJYieldlabMapElement*>*) getDataForAdCall;

@end

@interface GUJYieldlab : NSObject

+ (instancetype) sharedManager;
- (NSURL*) generateUrl;
- (void) configure:(NSArray<GUJYieldlabMapElement*>*) list deviceType:(int)deviceType;
- (void) request;
- (void) submitToServer;
- (NSString* ) findMapKeyById:(NSString*)yid;
- (void) appendToAdCall:(GUJAdViewContext*)context;

@end

