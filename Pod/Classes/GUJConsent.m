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

@implementation GUJConsentHelper
+ (void)init:(UIView *)view {
    GUJConsent* consent = [[GUJConsent alloc] init];
    [consent load];
    [consent appendSubview:view];
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
    
    /*ConsentViewController.onReceiveMessageData = { (cbw: ConsentViewController) in
        print("msgJSON from backend", cbw.msgJSON as Any)
    }
    
    ConsentViewController.onMessageChoiceSelect = { cbw in
        print("Choice type selected by user", cbw.choiceType as Any)
    }
    
    ConsentViewController.onInteractionComplete = { (cbw: ConsentViewController) in
        print(
              "\n eu consent prop",
              cbw.euconsent as Any,
              "\n consent uuid prop",
              cbw.consentUUID as Any,
              "\n eu consent in storage",
              UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY) as Any,
              "\n consent uuid in storage",
              UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY) as Any,
              
              // Standard IAB values in UserDefaults
              "\n IABConsent_ConsentString in storage",
              UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING) as Any,
              "\n IABConsent_ParsedPurposeConsents in storage",
              UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS) as Any,
              "\n IABConsent_ParsedVendorConsents in storage",
              UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS) as Any,
              
              // API for getting IAB Vendor Consents
              "\n IAB vendor consent for Smaato Inc",
              cbw.getIABVendorConsents([82]),
              
              // API for getting IAB Purpose Consents
              "\n IAB purpose consent for \"Ad selection, delivery, reporting\"",
              cbw.getIABPurposeConsents([3]),
              
              // Get custom vendor results:
              "\n custom vendor consents",
              cbw.getCustomVendorConsents(forIds: ["5bc76807196d3c5730cbab05", "5bc768d8196d3c5730cbab06"]),
              
              // Get purpose results:
              "\n all purpose consents ",
              cbw.getPurposeConsents(),
              "\n filtered purpose consents ",
              cbw.getPurposeConsents(forIds: ["5bc4ac5c6fdabb0010940ab1", "5bc4ac5c6fdabb0010940aae", "invalid_id_returns_nil" ]),
              "\n consented to measurement purpose ",
              cbw.getPurposeConsent(forId: "5bc4ac5c6fdabb0010940ab1")
              )
    }*/
}
- (void)appendSubview: (UIView*)view {
    [view addSubview:self->webView.view];
}
@end
