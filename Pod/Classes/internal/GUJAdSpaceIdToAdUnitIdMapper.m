//
// Created by Michael Brügmann on 03.08.15.
// Copyright (c) 2015 Michael Brügmann. All rights reserved.
//

#import "GUJAdSpaceIdToAdUnitIdMapper.h"
#import "XMLDictionary.h"


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
        if (xmlDictionary != nil){
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
    return NSNotFound;
}


-(BOOL)isAdSpaceId:(NSString *)identifier {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [identifier rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

@end