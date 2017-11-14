/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2017 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

#import "NSTimerProxy.h"

@interface NSTimerProxy()
@property (nonatomic) NSTimer * timer;
@property (nonatomic,weak) id target;
@property (nonatomic, assign) NSTimeInterval ti;
@property (nonatomic, assign) SEL selector;
@end

@implementation NSTimerProxy

+ (NSTimerProxy *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    NSTimerProxy * timer = [[self alloc] initScheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:userInfo];
    [timer start];
    return timer;
    
}

- (NSTimerProxy *)initScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    self = [super init];
    if (self) {
        
        self.ti = ti;
        self.target = aTarget;
        self.selector = aSelector;
    }
    return self;
}

-(void)start{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.ti target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)tick{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector];
#pragma clang diagnostic pop
    
}

-(void)invalidate{
    
    [self.timer invalidate];
    self.target = nil;
    self.selector = nil;
}

-(void)dealloc{
    
    [self invalidate];
}
@end
