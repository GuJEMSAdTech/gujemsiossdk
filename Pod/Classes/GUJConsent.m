//
//  GUJConsent.m
//  Pods
//
//  Created by Gohl, Michael on 28.02.19.
//

#import "GUJConsent.h"
#import <Foundation/Foundation.h>
@import ConsentViewController;

@implementation GUJConsentHelper {
    
}
static GUJConsent* consent = nil;
static UIView* currentView = nil;

+ (void)init:(UIView *)view {
    currentView = view;
}
+ (void)request {
    if (currentView != nil) {
        consent = [[GUJConsent alloc] init];
        [consent load];
        [consent appendSubview:currentView];
    }
}
+ (BOOL)consentForAdvertising {
    if (consent != nil) {
        return [consent getAdvertingStatus];
    } else {
        return true;
    }
}
@end

@implementation GUJConsent {
    ConsentViewController* webView;
    BOOL advertisingStatus;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self->webView = [[ConsentViewController alloc] initWithAccountId:212 siteName: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];        
        self->advertisingStatus = [userDefaults boolForKey:@"CONSENT_ADVERTISING"];
    }
    return self;
}

- (void)setStageCampaigns:(BOOL)stage {
    self->webView.isStage = stage;
}

- (void)setInternalStage:(BOOL)stage {
    self->webView.isInternalStage = stage;
}

- (void)setTargetingStringValue:(NSString*)key value:(NSString*)value {
    [self->webView setTargetingParamString:key value:value];
}

- (void)setTargetingIntValue:(NSString*)key value:(NSInteger)value {
    [self->webView setTargetingParamInt:key value:value];
}

- (void)load {
    self->webView.page = @"main";
    self->webView.mmsDomain = @"mms.adalliance.io";
    
    self->webView.onReceiveMessageData = ^(ConsentViewController *cb) {
        // receive message
        BOOL result = [[[cb getIABPurposeConsents:@[@3]] objectAtIndex:0] boolValue];
        [self setAdvertisingStatus:result];
    };
    
    self->webView.onMessageChoiceSelect = ^(ConsentViewController *cb) {
        // message
        BOOL result = [[[cb getIABPurposeConsents:@[@3]] objectAtIndex:0] boolValue];
        [self setAdvertisingStatus:result];
    };
    
    self->webView.onInteractionComplete = ^(ConsentViewController *cb) {
        // interaction completed
        BOOL result = [[[cb getIABPurposeConsents:@[@3]] objectAtIndex:0] boolValue];
        [self setAdvertisingStatus:result];
    };
}

- (void)setAdvertisingStatus:(BOOL)status {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:status forKey:@"CONSENT_ADVERTISING"];
    self->advertisingStatus = status;
}

- (BOOL)getAdvertingStatus {
    return self->advertisingStatus != false;
}

- (void)appendSubview: (UIView*)view {
    [view addSubview:self->webView.view];
}
@end
