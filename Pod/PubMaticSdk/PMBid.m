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

#import "PMBid.h"

@implementation PMBid
{
}

- (id)initWithBidDetails:(NSDictionary*)bidDetails
{
    self = [super init];
    
    if (self && bidDetails)
    {
        _impId = [bidDetails valueForKey:@"impid"];
        _price = [[bidDetails valueForKey:@"price"] floatValue];
        _status = _price > 0 ? @1 : @0;
        _width = [[bidDetails valueForKey:@"w"] integerValue];
        _height = [[bidDetails valueForKey:@"h"] integerValue];
        
        _creativeTag = [bidDetails valueForKey:@"adm"];
        NSString * dealId = [bidDetails valueForKey:@"dealid"];
        if (dealId && ![dealId isEqual:[NSNull null]]) {
            _dealId = dealId;
        }
        if ([bidDetails valueForKey:@"ext"] && [[bidDetails valueForKey:@"ext"] valueForKey:@"extension"])
        {
            NSDictionary *extension = [[bidDetails valueForKey:@"ext"] valueForKey:@"extension"];
            _impTracker = [extension valueForKey:@"trackingUrl"];
            _clkTracker = [extension valueForKey:@"clicktrackingurl"];
            _slotname = [extension valueForKey:@"slotname"];
            _slotIndex = [[extension valueForKey:@"slotindex"] integerValue];
            
            NSNumber * errroCode = [extension valueForKey:@"errorCode"];
            if (errroCode && ![errroCode isEqual:[NSNull null]]) {
                
                _error = [NSError errorWithDomain:@"PubMaticHeaderBidding" code:[errroCode integerValue] userInfo:@{}] ;
            }
            
            for (NSDictionary * summary in extension[@"summary"]) {
                
                NSNumber * errCode = [summary valueForKey:@"errorCode"];
                NSString * errMsg = [summary valueForKey:@"errorMessage"];
                if (errCode && ![errCode isEqual:[NSNull null]]) {
                    
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:errMsg forKey:NSLocalizedDescriptionKey];
                    _error = [NSError errorWithDomain:@"PubMaticHeaderBidding" code:[errCode integerValue] userInfo:details] ;
                }
            }
        }
    }
    
    return self;
}

@end
