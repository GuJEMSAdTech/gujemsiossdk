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

#import <Foundation/Foundation.h>


@class GUJNativeAd;

@protocol GUJNativeAdDelegate <NSObject>

@optional

/**
 Sent when an NativeAd has been successfully loaded.
 */
- (void)nativeAdDidLoad:(GUJNativeAd *)nativeAd;

/**
 Sent when an NativeAd is failed to load.
 */
- (void)nativeAd:(GUJNativeAd *)nativeAd didFailWithError:(NSError *)error;

/**
 Sent after an ad has been clicked by the person.
 */
- (void)nativeAdDidClick:(GUJNativeAd *)nativeAd;

@end



@interface GUJNativeAd : NSObject

@property (nonatomic, strong) NSString *adUnitId;
@property (nonatomic, weak) id<GUJNativeAdDelegate> delegate;

//click url, what will be used if ad not return click url
@property (nonatomic, strong) NSString *defaultClickURL;

//text for Presentership
@property (nonatomic, strong) NSString *presenterText;

//Source for optional image in aspect ratio 1:1
@property (nonatomic, strong) NSString *teaserImage1;
//Source for optional image in aspect ratio 2:1
@property (nonatomic, strong) NSString *teaserImage2;
//Source for optional image in aspect ratio 3:2
@property (nonatomic, strong) NSString *teaserImage3;

//for a Headline-field in the view
@property (nonatomic, strong) NSString *headline;
//for a SubHeadline-field in the view
@property (nonatomic, strong) NSString *subHeadline;
//for a TeaserText-field in the view
@property (nonatomic, strong) NSString *teaserText;


+(GUJNativeAd *) nativeAdWithUnitId:(NSString *) unitId;

-(void) setTileIndex:(NSInteger) index;
-(void) setPositionIndex:(NSInteger) index;
-(void) setRandom:(NSString *) random;
-(void) setAdSize:(CGSize) size;

-(void) loadAd;

-(void) registerViewForInteraction:(UIView *) view;
-(void) unregisterViewForInteraction:(UIView *) view;

-(void) clickAction;
-(void) sendTrackers;

@end

