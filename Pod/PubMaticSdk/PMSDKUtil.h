/*
 
 * PubMatic Inc. ("PubMatic") CONFIDENTIAL
 
 * Unpublished Copyright (c) 2006-2017 PubMatic, All Rights Reserved.
 
 *
 
 * NOTICE:  All information contained herein is, and remains the property of PubMatic. The intellectual and technical concepts contained
 
 * herein are proprietary to PubMatic and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret or copyright law.
 
 * Dissemination of this information or reproduction of this material is strictly forbidden unless prior written permission is obtained
 
 * from PubMatic.  Access to the source code contained herein is hereby forbidden to anyone except current PubMatic employees, managers or contractors who have executed
 
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 
 *
 
 * The copyright notice above does not evidence any actual or intended publication or disclosure  of  this source code, which includes
 
 * information that is confidential and/or proprietary, and is a trade secret, of  PubMatic.   ANY REPRODUCTION, MODIFICATION, DISTRIBUTION, PUBLIC  PERFORMANCE,
 
 * OR PUBLIC DISPLAY OF OR THROUGH USE  OF THIS  SOURCE CODE  WITHOUT  THE EXPRESS WRITTEN CONSENT OF PubMatic IS STRICTLY PROHIBITED, AND IN VIOLATION OF APPLICABLE
 
 * LAWS AND INTERNATIONAL TREATIES.  THE RECEIPT OR POSSESSION OF  THIS SOURCE CODE AND/OR RELATED INFORMATION DOES NOT CONVEY OR IMPLY ANY RIGHTS
 
 * TO REPRODUCE, DISCLOSE OR DISTRIBUTE ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT IT  MAY DESCRIBE, IN WHOLE OR IN PART.
 
 */

//
//  PUBDeviceUtil.h
//


// SYSTEM IMPORTS
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PubDeviceIDType) {
    // Any unique type of udid other than mentioned below
    kOther,
    
    // Identifier For Advertiser for iOS Devices (IDFA)
    kIDFA,
    
    // Identifier For Vendor for iOS Devices (IDFV)
    kIDFV,
    
    // Unique identifier for android Devices
    kAndroid_ID,
    
    // Unique device identifier for iOS Devices (Now depricated by apple)
    kUDID,
    
    // Open UDID is opensource library for generating unique device id
    kOpenUDID,
    
    // SecureUDID is an open-source sandboxed UDID solution ( Now depricated since release of iOS6)
    kSecureUDID,
    
    // Unique identifier of the network card been used for net connection
    kMAC_Address,
    
    // ODIN-1 is opensource library for generating unique device id
    kODIN_1
} ;


#pragma once

@interface PMSDKUtil : NSObject 
  
// Retrivies useragent of device
@property(nonatomic,strong,readonly) NSString *userAgent;

//// Retrieves latitude and longitude of auto-retieved location
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSNumber *longitude;

// Gives singleton instance of this class
+ (PMSDKUtil *)sharedInstance;

+ (NSString*) getCurrentDate;
+(NSString *) contentMd5String:( NSString *)str;

-(PubDeviceIDType) pubDeviceIDTypeForIDFAFlag:(BOOL)isIDFAEnabled;


//Device specific parameters

// Holds the unique identity of device
@property (nonatomic,retain,readonly)  NSString *deviceID;

// Holds the unique identity of device id type
@property (nonatomic,assign,readonly)  PubDeviceIDType pubDeviceIDType;

// Holds the ISO code of the Country
@property (nonatomic,retain,readonly)  NSString *countryCode;

// Holds the Name of Carrier
@property (nonatomic,retain,readonly)  NSString *carrierName;

// Used for Accept Language
@property (nonatomic,retain,readonly)  NSString *deviceAcceptLanguage;

// Holds the  device model
@property (nonatomic,retain,readonly)  NSString *deviceModel;

// Holds the OS system used
@property (nonatomic,retain,readonly)  NSString *deviceOSName;

// Holds the OS system version
@property (nonatomic,retain,readonly)  NSString *deviceOSversion;

//Origin specific parameters

// Holds the Application's Bundle Identity
@property (nonatomic,retain,readonly)  NSString *applicationId;

// Holds the Application's Name
@property (nonatomic,retain,readonly)  NSString *applicationName;

// Holds the current working Application version
@property (nonatomic,retain,readonly)  NSString *appVersion;

// Holds the Application's Bundle Identity
@property (nonatomic,retain,readonly)  NSString *appBundleIdentifier;

//Holds height of device
@property (nonatomic,assign,readonly)  CGFloat deviceHeight;

//Holds width of device
@property (nonatomic,assign,readonly)  CGFloat deviceWidth;

//Holds Screen Resolution of device
@property (nonatomic,retain,readonly)  NSString *deviceScreenResolution;

// Holds manufacturer of device
@property (nonatomic,retain,readonly)  NSString *deviceMake;

// Getter parameters

// Holds page url
@property (nonatomic,retain,readonly)  NSString *pageURL;

// Holds Ad Position
@property (nonatomic,retain,readonly)  NSString *adPosition;

// Holds kind of network connection viz. wifi,carrier etc.
@property (nonatomic,retain,readonly)  NSString *currentNetworkStatus;


//PubMatic’s parameters

//Holds Current orientation of device
@property (nonatomic,assign,readonly)  int    deviceOrientation;

// Used to verify whether JavaScript is supported or not
@property (nonatomic,assign,readonly)  int    javaScriptSupport;

//Holds Current Time
@property (nonatomic,retain,readonly)  NSString *currentTime;

//Holds Current TimeZone
@property (nonatomic,assign,readonly)  double currentTimeZone;

// Holds random number for different request
@property (nonatomic,assign,readonly)  float  ranreq;

// Holds whether dnt is set by user or not
@property(nonatomic,assign) int dnt;

// Holds supported APIs
@property (nonatomic, assign,readonly) int api;



@property (nonatomic, retain,readonly) NSString *mnc;
@property (nonatomic, retain,readonly) NSString *mcc;

-(NSNumber *)rtbConnectionType;
-(NSString *)netType;

-(NSString *) vendorID;
-(NSString *) advertisingID;
+ (NSString* )stringFromGender:(int)gender;
@end


@interface NSMutableDictionary (SafeMutableDictionary)
-(void)setObjectSafely:(id)anObject forKey:(id<NSCopying>)aKey;
-(void)replaceKey:(NSString *)oldKey withKey:(NSString *)newKey;
-(id)popObjetForKey:(NSString *)key;
@end

