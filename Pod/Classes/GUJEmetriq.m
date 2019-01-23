//
//  GUJEmetriq.m
//  gujemsiossdk
//
//  Created by Gohl, Michael on 23.01.19.
//

#import "GUJEmetriq.h"
#import <Foundation/Foundation.h>
#import "GUJAdUtils.h"

@implementation GUJEmetriq {
    NSString* idfa;
    NSString* appId;
    NSString* contentUrl;
    BOOL submitted;
}

+ (instancetype)sharedManager {
    static GUJEmetriq *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GUJEmetriq alloc] init];
        instance->submitted = false;
        instance->contentUrl = @"";
    });
    
    return instance;
}

- (void)submit:(NSString *)contentUrl {
    if (self->contentUrl != contentUrl) {
        self->contentUrl = contentUrl;
        // hole idfa
        self->idfa = [GUJAdUtils identifierForAdvertising];
        // hole app id
        self->appId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        // call url
        [self sendToServer];
    }
}

- (NSURL*) generateUrl {
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://aps.xplosion.de/data"];
    
    NSMutableArray *queryItems = [NSMutableArray array];
    
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"sid" value:@"13262"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"device_id" value:self->idfa]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"app_id" value:self->appId]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"link" value:self->contentUrl]];
    
    components.queryItems = queryItems;
    
    return components.URL;
}

- (void) sendToServer {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[self generateUrl]] resume];
}

@end

