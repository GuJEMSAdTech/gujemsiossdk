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

#import "GUJVideoAdViewController.h"
#import "GoogleInteractiveMediaAds.h"


@interface GUJVideoAdViewController () <IMAAdsLoaderDelegate, IMAAdsManagerDelegate>

/// Content video player.
@property(nonatomic, strong) AVPlayer *contentPlayer;

// SDK
/// Entry point for the SDK. Used to make ad requests.
@property(nonatomic, strong) IMAAdsLoader *adsLoader;
// Playhead used by the SDK to track content video progress and insert mid-rolls.
@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
/// Main point of interaction with the SDK. Created by the SDK as the result of an ad request.
@property(nonatomic, strong) IMAAdsManager *adsManager;
/// Player layer for the player
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UITextView *adTagUrlTextView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation GUJVideoAdViewController {
}

// The content URL to play.
NSString *const kTestAppContentUrl_MP4 = @"http://rmcdn.2mdn.net/Demo/html5/output.mp4";

// Ad tag
NSString *const kTestAppAdTagUrl =
        @"https://pubads.g.doubleclick.net/gampad/ads?sz=480x360&iu=/6032/sdktest/preroll&impl=s&gdfp_req=1&env=vp&output=xml_vast2&unviewed_position_start=1&url=[referrer_url]&description_url=[description_url]&correlator=[timestamp]";


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initAdTagUrlFromUserDefaults];

    // close keyboard on tap outside
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

    self.adTagUrlTextView.delegate = self;

    [self setupAdsLoader];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpContentPlayer];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.adsLoader contentComplete];
    self.playButton.enabled = YES;
    [self.playerLayer removeFromSuperlayer];
    self.errorLabel.text = @"";
}


- (IBAction)onPlayButtonTouch:(id)sender {
    [self requestAds];
    self.playButton.enabled = NO;
}


- (void)dismissKeyboard {
    [self.adTagUrlTextView resignFirstResponder];
}


-(void)initAdTagUrlFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:AD_TAG_DEFAULTS_KEY] == nil) {
        [userDefaults setObject:kTestAppAdTagUrl forKey:AD_TAG_DEFAULTS_KEY];
    }
    self.adTagUrlTextView.text = [userDefaults objectForKey:AD_TAG_DEFAULTS_KEY];
}


#pragma mark Content Player Setup

- (void)setUpContentPlayer {
    // Load AVPlayer with path to our content.
    NSURL *contentURL = [NSURL URLWithString:kTestAppContentUrl_MP4];
    self.contentPlayer = [AVPlayer playerWithURL:contentURL];

    // Create a player layer for the player.
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];

    // Display, size and position the AVPlayer.

    [self.videoView.layer addSublayer:self.playerLayer];

    self.playerLayer.frame = self.videoView.layer.bounds;
}


#pragma mark SDK Setup

- (void)setupAdsLoader {
    self.adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    self.adsLoader.delegate = self;
}


- (void)requestAds {
    // Create an ad display container for ad rendering.
    IMAAdDisplayContainer *adDisplayContainer =
            [[IMAAdDisplayContainer alloc] initWithAdContainer:self.videoView companionSlots:nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *adTagUrl = [userDefaults objectForKey:AD_TAG_DEFAULTS_KEY];

    NSLog(@"requesting Ad with Ad Tag URL: '%@'", adTagUrl);

    // Create an ad request with our ad tag, display container, and optional user context.
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:kTestAppAdTagUrl
                                                  adDisplayContainer:adDisplayContainer
                                                         userContext:nil];
    [self.adsLoader requestAdsWithRequest:request];
}


- (void)createContentPlayhead {
    self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.contentPlayer currentItem]];
}


- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // Make sure we don't call contentComplete as a result of an ad completing.
    if (notification.object == self.contentPlayer.currentItem) {
        [self.adsLoader contentComplete];
    }
}


#pragma mark AdsLoader Delegates

- (void)adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
    self.adsManager = adsLoadedData.adsManager;
    self.adsManager.delegate = self;
    // Create ads rendering settings to tell the SDK to use the in-app browser.
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.webOpenerPresentingController = self;
    // Create a content playhead so the SDK can track our content for VMAP and ad rules.
    [self createContentPlayhead];
    // Initialize the ads manager.
    [self.adsManager initializeWithContentPlayhead:self.contentPlayhead
                              adsRenderingSettings:adsRenderingSettings];
}


- (void)adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    // Something went wrong loading ads. Log the error and play the content.
    NSLog(@"Error loading ads: %@", adErrorData.adError.message);
    self.errorLabel.text = adErrorData.adError.message;
    [self.contentPlayer play];
}


#pragma mark AdsManager Delegates

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    if (event.type == kIMAAdEvent_LOADED) {
        [adsManager start];
    }
}


- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    // Something went wrong with the ads manager after ads were loaded. Log the error and play the
    // content.
    NSLog(@"AdsManager error: %@", error.message);
    self.errorLabel.text = error.message;
    [self.contentPlayer play];
}


- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    // The SDK is going to play ads, so pause the content.
    [_contentPlayer pause];
}


- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    // The SDK is done playing ads (at least for now), so resume the content.
    [_contentPlayer play];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.adTagUrlTextView.text forKey:AD_TAG_DEFAULTS_KEY];
    [userDefaults synchronize];
}


@end