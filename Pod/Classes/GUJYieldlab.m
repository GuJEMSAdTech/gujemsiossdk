//
//  GUJYieldlab.m
//  gujemsiossdk
//
//  Created by Gohl, Michael on 23.01.19.
//

#import "GUJYieldlab.h"
#import <Foundation/Foundation.h>
#import "GUJAdUtils.h"
#import "GUJAdViewContext.h"

@implementation GUJYieldlabElement {
    NSString* pvid;
    NSString* price;
    NSString* partner;
    NSString* ylid;
    NSString* yid;
    NSString* map;
}

+ (GUJYieldlabElement *)init:(NSString *)pvid price:(NSString *)price partner:(NSString *)partner ylid:(NSString *)ylid yid:(NSString *)yid map:(NSString *)map {
    GUJYieldlabElement* instance = [GUJYieldlabElement alloc];
    instance->map = [instance getString:map];
    instance->pvid = [instance getString:pvid];
    instance->partner = [instance getString:partner];
    instance->price = [instance getString:price];
    instance->yid = [instance getString:yid];
    instance->ylid = [instance getString:ylid];
    return instance;
}

- (NSString *)getString:(NSString *)str {
    return str == nil ? @"" : str;
}

- (NSArray<GUJYieldlabMapElement*> *)getDataForAdCall {

    NSMutableArray<GUJYieldlabMapElement*>* array = [[NSMutableArray alloc] init];
    if (![self->ylid isEqual: @"0"]) {
        [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@%@", @"ylid", self->map, @"c"] value:self->ylid]];
        [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@", @"ylp", self->map] value:self->price]];
    } else {
        [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@", @"ylid", self->map] value:self->yid]];
    }
    [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@", @"yl", self->map] value:self->yid]];
    [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@%@", @"ylid", self->map, @"pa"] value:self->partner]];
    [array addObject:[GUJYieldlabMapElement init:[NSString stringWithFormat: @"%@%@", @"ylpvid", self->map] value:self->pvid]];

    return array;
}

@end

@implementation GUJYieldlabMapElement {
    NSString* key;
    NSString* value;
}

+ (GUJYieldlabMapElement*) init:(NSString *)key value:(NSString *)value {
    GUJYieldlabMapElement* instance = [[GUJYieldlabMapElement alloc] init];
    instance->key = key;
    instance->value = value;
    return instance;
}

- (NSString *)getKey {
    return self->key;
}

- (NSString *)getValue {
    return self->value;
}

@end

@implementation GUJYieldlab {
    NSString* idfa;
    int deviceType;
    NSArray<GUJYieldlabMapElement *> *list;
    NSMutableArray<GUJYieldlabElement *> *elements;
}

+ (instancetype) sharedManager {
    static GUJYieldlab *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GUJYieldlab alloc] init];
        instance->idfa = [GUJAdUtils identifierForAdvertising];
        instance->elements = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void) appendToAdCall:(GUJAdViewContext*)context {
    for (int i = 0; i < [self->elements count]; i++) {
        NSArray<GUJYieldlabMapElement*>* content = [[self->elements objectAtIndex:i] getDataForAdCall];
        for (int j = 0; j < [content count]; j++) {
            GUJYieldlabMapElement* element = [content objectAtIndex:j];
            [context addCustomTargetingKey:[element getKey] Value:[element getValue]];
        }
    }
}

- (void) configure:(NSArray<GUJYieldlabMapElement *>*) list deviceType:(int)deviceType {
    self->list = list;
    self->deviceType = deviceType;
}

- (void) request {
    if ([self->list count] > 0) {
        [self submitToServer];
    }
}

- (NSString* ) findMapKeyById:(NSString*)yid {
    for (int i = 0; i < [self->list count]; i++) {
        GUJYieldlabMapElement *currentElement = [self->list objectAtIndex:i];
        if ([[currentElement getValue] isEqual:yid]) {
            return [currentElement getKey];
        }
    }
    return nil;
}

- (void)submitToServer {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[self generateUrl]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    // Success
                    if(NSClassFromString(@"NSJSONSerialization"))
                    {
                        id object = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:0
                                     error:&error];
                        
                        if(!error) {
                            if([object isKindOfClass:[NSArray class]]) {
                                [self->elements removeAllObjects];
                                NSArray *results = object;
                                for (int i = 0; i < [results count]; i++) {
                                    NSDictionary *element = [results objectAtIndex:i];
                                    
                                    NSString * price = @"";
                                    @try {
                                        price = [element valueForKey:@"price"];
                                    }
                                    @catch(NSException * e) {
                                        NSLog(@"Exception: Yieldlab %@", e);
                                    }
                                    NSString* yid = [NSString stringWithFormat:@"%@", [element valueForKey:@"id"]];
                                    
                                    [self->elements addObject:[GUJYieldlabElement init:[element valueForKey:@"pvid"] price:price partner:[element valueForKey:@"c.partner"] ylid:[element valueForKey:@"c.ylid"] yid:yid map:[self findMapKeyById:yid]]];
                                }
                            } else {
                                NSLog(@"Exception: Yieldlab not an array");
                            }
                        }
                    } else {
                        NSLog(@"Exception: Yieldlab Response not correct");
                    }
                }
            }] resume];
    
}

- (NSURL*) generateUrl {
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://ad.yieldlab.net"];
    NSString* list = @"";
    for (int i = 0; i < [self->list count]; i++) {
        GUJYieldlabMapElement *currentElement = [self->list objectAtIndex:i];
        list = [NSString stringWithFormat: @"%@,%@", list, [currentElement getValue]];
    }
    [components setPath:[NSString stringWithFormat:@"/yp/%@", list]];
    NSMutableArray *queryItems = [NSMutableArray array];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"json" value:@"true"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pvid" value:@"true"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"yl_rtb_ifa" value:self->idfa]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"yl_rtb_devicetype" value:[NSString stringWithFormat:@"%d", self->deviceType]]];
    
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
