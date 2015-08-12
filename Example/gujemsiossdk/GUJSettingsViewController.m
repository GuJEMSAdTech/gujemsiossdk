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

#import "GUJSettingsViewController.h"
#import "GUJAdSpaceIdToAdUnitIdMapper.h"


@implementation GUJSettingsViewController {
    __weak IBOutlet UITextField *adUnitIdTextField;
    __weak IBOutlet UITextField *adSpaceIdTextField;
    __weak IBOutlet UIButton *convertButton;
    __weak IBOutlet UILabel *positionLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // close keyboard on tap outside
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    [self initSettingsFromUserDefaults];

    adUnitIdTextField.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self saveSettingsToUserDefaults];
    [self resetAdspaceIdConverter];
}

- (void)resetAdspaceIdConverter {
    positionLabel.text = @"";
    adSpaceIdTextField.text = @"";
}


- (IBAction)mapAdspaceIdToAdUnitId:(id)sender {

    NSString *adSpaceId = adSpaceIdTextField.text;
    NSString *adUnitId = [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdSpaceId:adSpaceId];
    NSInteger position = [[GUJAdSpaceIdToAdUnitIdMapper instance] getPositionForAdSpaceId:adSpaceId];

    if (adUnitId == nil) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Ad Space ID not found in mapping file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        adUnitIdTextField.text = adUnitId;
        positionLabel.text = [NSString stringWithFormat:@"Position: %d", position];
    }
   
    [self dismissKeyboard];
}


- (void)dismissKeyboard {
    [adUnitIdTextField resignFirstResponder];
    [adSpaceIdTextField resignFirstResponder];
}


-(void)saveSettingsToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:adUnitIdTextField.text forKey:AD_UNIT_USER_DEFAULTS_KEY];
    [userDefaults synchronize];
}


-(void)initSettingsFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    adUnitIdTextField.text = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self resetAdspaceIdConverter];
}


@end