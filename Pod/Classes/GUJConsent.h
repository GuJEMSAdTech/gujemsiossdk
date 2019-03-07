//
//  GUJConsent.h
//  gujemsiossdk
//
//  Created by Gohl, Michael on 28.02.19.
//

#import <Foundation/Foundation.h>

@interface GUJConsentHelper: NSObject
+ (void)init:(UIView*) view;
+ (void)request;
+ (BOOL)consentForAdvertising;
@end

@interface GUJConsent : NSObject
- (void)setStageCampaigns:(BOOL)stage;
- (instancetype)init;
- (void)setInternalStage:(BOOL)stage;
- (void)setTargetingStringValue:(NSString*)key value:(NSString*)value;
- (void)setTargetingIntValue:(NSString*)key value:(NSInteger)value;
- (void)load;
- (void)appendSubview: (UIView*)view;
- (BOOL)getAdvertingStatus;
@end
