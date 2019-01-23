//
//  GUJEmetriq.h
//  gujemsiossdk
//
//  Created by Gohl, Michael on 23.01.19.
//

#import <Foundation/Foundation.h>

@interface GUJEmetriq : NSObject

+ (instancetype) sharedManager;
- (void) sendToServer;
- (NSURL*) generateUrl;
- (void) submit:(NSString *)contentUrl;

@end
