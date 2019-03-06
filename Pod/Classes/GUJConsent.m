//
//  GUJConsent.m
//  Pods
//
//  Created by Gohl, Michael on 28.02.19.
//

#import "GUJConsent.h"
#import <Foundation/Foundation.h>
#import "GUJAdUtils.h"
@import ConsentViewController;

@implementation GUJConsentHelper {
    
}
static UIView* currentView = nil;

+ (void)init:(UIView *)view {
    currentView = view;
}
+ (void)request {
    if (currentView != nil) {
        GUJConsent* consent = [[GUJConsent alloc] init];
        [consent load];
        [consent appendSubview:currentView];
    }
}
@end

@implementation GUJConsent {
    ConsentViewController* webView;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self->webView = [[ConsentViewController alloc] initWithAccountId:212 siteName: [GUJAdUtils identifierForAdvertising]];
    }
    return self;
}

- (void)setStageCampaigns:(Boolean)stage {
    self->webView.isStage = stage;
}

- (void)setInternalStage:(Boolean)stage {
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
    };
    
    self->webView.onMessageChoiceSelect = ^(ConsentViewController * cb) {
        // message
    };
    
    self->webView.onInteractionComplete = ^(ConsentViewController *cb) {
        // interaction completed
    };
}
- (void)appendSubview: (UIView*)view {
    [view addSubview:self->webView.view];
}
@end
