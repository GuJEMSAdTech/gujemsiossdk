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

#ifndef PubMaticConstants_h
#define PubMaticConstants_h

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


const static NSString * version = @"1.2.0";

typedef NS_ENUM(NSInteger, PMLocSource)  {
    
    PMLocSourceUnknown,
    PMLocSourceGPS,
    PMLocSourceIPAddress,
    PMLocSourceUserProvided
    
} ;

// Genders to help deliver more relevant ads.
typedef NS_ENUM(NSInteger, PMGender)  {
    PMGenderUnknown = -1,
    PMGenderOther = 0,
    PMGenderMale,
    PMGenderFemale,
};

typedef NS_ENUM(NSInteger, PMBOOL) {
    PMBOOLNone = -1,
    PMBOOLNo = 0,
    PMBOOLYES
};

typedef NS_ENUM(NSInteger, PMUdidhashType) {
    PMUdidhashTypeUnknown=0,
    PMUdidhashTypeRaw,
    PMUdidhashTypeSHA1,
    PMUdidhashTypeMD5
};

/*!
 Indicates whether the tracking URL has been wrapped or not in the creative tag.
 Possible options are:
 0 - Indicates that the tracking URL is sent separately in the response JSON as tracking_url. In this case, the tracking_url field is absent in the JSON response.
 1 - Indicates that the tracking_url value is wrapped in an Iframe and appended to the creative_tag.
 2 - Indicates that the tracking_url value is wrapped in a JS tag and appended to the creative_tag.
 Note:
 If the awt parameter is absent in the bid request URL, then it is same as awt=0 mentioned above.
 Its default value is 0.
 */
typedef NS_ENUM(NSInteger, PMAWT) {
    PMAWTSeparateTracker,
    PMAWTiframeEmbeddedTracker,
    PMAWTJSEmbeddedTracker
};

/*!
 Fold placement of the ad to be served. Possible values are:
 0 – Visibility cannot be determined
 1 – Above the fold
 2 - Below the fold.
 3 – Partially above the fold
 Note: If you are unable to determine it, you can set the default value as 0 in this parameter.
 */
typedef NS_ENUM(NSInteger, PMAdVisibility) {
    PMAdVisibilityUnKnown,
    PMAdVisibilityAboveFold,
    PMAdVisibilityBelowFold,
    PMAdVisibilityPartiallyAboveFold
};

/*!
 Numeric code of ethnicity. Possible options are:
 0 - Hispanic
 1 - African-American
 2 - Caucasian
 3 - Asian-American
 4 – Other
 For example, ethn=1. 
 */
typedef NS_ENUM(NSInteger, PMEthnicity) {
    PMEthnicityNone=-1,
    PMEthnicityHispanic=0,
    PMEthnicityAfricanAmerican,
    PMEthnicityCaucasian,
    PMEthnicityAsianAmerican,
    PMEthnicityOther
};

#define NETWORK_TIMEOUT_SECONDS 3
#endif /* PubMaticConstants_h */
