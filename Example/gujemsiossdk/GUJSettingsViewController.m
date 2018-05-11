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
    
    __weak IBOutlet UITextField *facebookAdUnitTextField;
    __weak IBOutlet UITextField *nativeBaseUrlTextField;
    
    __weak IBOutlet UITextField *iqAppEventsAdUnitField;
    
    __weak IBOutlet UITextField *keywordsField;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self saveSettingsToUserDefaults];
    [self resetAdspaceIdConverter];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)resetAdspaceIdConverter {
    positionLabel.text = @"";
    adSpaceIdTextField.text = @"";
}


- (IBAction)mapAdSpaceIdToAdUnitId:(id)sender {

    NSString *adSpaceId = adSpaceIdTextField.text;
    NSString *adUnitId = [[GUJAdSpaceIdToAdUnitIdMapper instance] getAdUnitIdForAdSpaceId:adSpaceId];
    NSInteger position = [[GUJAdSpaceIdToAdUnitIdMapper instance] getPositionForAdSpaceId:adSpaceId];
    BOOL isIndex = [[GUJAdSpaceIdToAdUnitIdMapper instance] getIsIndexForAdSpaceId:adSpaceId].boolValue;

    if (adUnitId == nil) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Ad Space ID not found in mapping file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        adUnitIdTextField.text = adUnitId;
        positionLabel.text = [NSString stringWithFormat:@"Position: %ld %@", (long)position, isIndex ? @"(index)" : @""];
    }
   
    [self dismissKeyboard];
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


-(void)saveSettingsToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:adUnitIdTextField.text forKey:AD_UNIT_USER_DEFAULTS_KEY];
    [userDefaults setObject:facebookAdUnitTextField.text forKey:FACEBOOK_AD_UNIT_USER_DEFAULTS_KEY];
    [userDefaults setObject:nativeBaseUrlTextField.text forKey:NATIVE_BASE_URI_USER_DEFAULTS_KEY];
    [userDefaults setObject:iqAppEventsAdUnitField.text forKey:IQ_APP_EVENTS_AD_UNIT_USER_DEFAULTS_KEY];
  
    [userDefaults setObject:keywordsField.text forKey:KEYWORD_DEFAULTS_KEY];
    
    [userDefaults synchronize];
}


-(void)initSettingsFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    adUnitIdTextField.text = [userDefaults objectForKey:AD_UNIT_USER_DEFAULTS_KEY];
    facebookAdUnitTextField.text = [userDefaults objectForKey:FACEBOOK_AD_UNIT_USER_DEFAULTS_KEY];
    nativeBaseUrlTextField.text = [userDefaults objectForKey:NATIVE_BASE_URI_USER_DEFAULTS_KEY];
    iqAppEventsAdUnitField.text = [userDefaults objectForKey:IQ_APP_EVENTS_AD_UNIT_USER_DEFAULTS_KEY];

    keywordsField.text = [userDefaults objectForKey:KEYWORD_DEFAULTS_KEY];

}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self resetAdspaceIdConverter];
}


#pragma mark Keyboard

-(UIView *) findFirstResponderInView:(UIView *) view {
    for (UIView *v in view.subviews) {
        if (v.isFirstResponder) {
            return v;
        }
        
        UIView *recurciveView = [self findFirstResponderInView:v];
        if (recurciveView) {
            return recurciveView;
        }
    }
    
    return nil;
}

-(CGPoint) textfieldOrigin:(UIView *) view {
    return [self.view convertPoint:view.frame.origin fromView:view.superview];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    UIView *text = [self findFirstResponderInView:self.view];
    if (text) {
        CGPoint textOrigin = [self textfieldOrigin:text];
        
        CGFloat endTextPoint = self.view.frame.size.height - (self.view.frame.size.height - textOrigin.y - text.frame.size.height);
        CGFloat keyboardPoint = self.view.frame.size.height - keyboardSize.height;
        
        if (endTextPoint > keyboardPoint) {
            [UIView animateWithDuration:durationValue.doubleValue animations:^{
                CGRect frame = self.view.frame;
                frame.origin.y = 0 - (endTextPoint - keyboardPoint) - 10;
                self.view.frame = frame;
            }];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:durationValue.doubleValue animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}


@end
