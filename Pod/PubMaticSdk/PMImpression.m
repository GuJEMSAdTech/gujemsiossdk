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
#import "PMImpression.h"
#import "PMSDKUtil.h"

@implementation PMImpression

-(id)initWithImpId:(NSString*)impId slotName:(NSString*)slotName slotIndex:(NSInteger)slotIndex
{
    self = [super init];
    if (self) {
        _impId = impId;
        _adSlotId = slotName;
        _adSlotIndex = slotIndex;
    }
    
    return self;
}

- (BOOL)isValid
{
    return ([_impId length] && [_adSlotId length]);
}

@end

@implementation PMSize

+(id)sizeWithWidth:(float)width height:(float)height
{
    return [[PMSize alloc] initWithWidth:width height:height];
}

-(id)initWithWidth:(float)width height:(float)height
{
    self = [super init];
    
    if (self) {
        _width = width;
        _height = height;
    }
    
    return self;
}

@end
