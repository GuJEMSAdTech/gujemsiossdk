/*
 * BSD LICENSE
 * Copyright (c) 2015, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer .
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "GUJInterstitialViewController.h"
#import "GUJAdViewContext.h"
#import "GUJSettingsViewController.h"


@implementation GUJInterstitialViewController {
    GUJAdViewContext *_context;

    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
    __weak IBOutlet UIButton *showInterstitialButton;
    __weak IBOutlet UILabel *errorLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adUnitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];

    _context = [GUJAdViewContext instanceForAdUnitId:adUnitId rootViewController:self];
    _context.delegate = self;

    [activityIndicatorView startAnimating];
    activityIndicatorView.hidden = NO;
    showInterstitialButton.enabled = NO;
    
    [_context interstitialAdViewWithCompletionHandler:^BOOL(GADInterstitial *_interstitial, NSError *_error) {
        
        [activityIndicatorView stopAnimating];
        activityIndicatorView.hidden = YES;
        
        if (_error == nil) {
           showInterstitialButton.enabled = YES;
        }
        
        return NO;
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _context.delegate = nil;
    errorLabel.text = @"";
}


- (void)interstitialViewDidFailLoadingAdWithError:(NSError *)error ForContext:(GUJAdViewContext *)context {
    errorLabel.text = error.localizedDescription;
}


- (IBAction)showInterstitial:(id)sender {
    [_context showInterstitial];
}

@end