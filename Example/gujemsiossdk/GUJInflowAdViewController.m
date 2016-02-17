/*
 * BSD LICENSE
 * Copyright (c) 2016, Mobile Unit of G+J Electronic Media Sales GmbH, Hamburg All rights reserved.
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

#import "GUJInflowAdViewController.h"
#import "GUJInflowAdViewContext.h"
#import "GUJSettingsViewController.h"


@implementation GUJInflowAdViewController {
    GUJInflowAdViewContext *inflowAdViewContext;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *dfpAdunitId = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];
    NSString *teadsPlacementId = [userDefaults objectForKey:TEADS_PLACEMENT_ID_USER_DEFAULTS_KEY];

    if (dfpAdunitId == nil) {
        dfpAdunitId = @"/6032/sdktest/preroll";
        [userDefaults setObject:dfpAdunitId forKey:AD_UNIT_USER_DEFAULTS_KEY];
        [userDefaults synchronize];
    }

    if (teadsPlacementId == nil) {
        teadsPlacementId = @"47140";
        [userDefaults setObject:teadsPlacementId forKey:TEADS_PLACEMENT_ID_USER_DEFAULTS_KEY];
        [userDefaults synchronize];
    }

    inflowAdViewContext = [[GUJInflowAdViewContext alloc] initWithScrollView:self.scrollView
                                                     inFlowAdPlaceholderView:self.teadsVideoView
                                     inFlowAdPlaceholderViewHeightConstraint:self.teadsVideoViewHeightConstraint
                                                                 dfpAdunitId:dfpAdunitId
                                                            teadsPlacementId:teadsPlacementId
    ];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [inflowAdViewContext containerViewDidAppear];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [inflowAdViewContext containerViewWillDisappear];
}

@end