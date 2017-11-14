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


#import "PMImpression.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PubMaticConstants.h"

@class PMBannerImpression;


@interface PMBannerPrefetchRequest : NSObject

//
// The user's location may be useful in delivering geographically relevant ads
// Latitude value of users location
//
@property (nonatomic, strong) NSString* latitude;

//
// Longitude value of users location
//
@property (nonatomic, strong) NSString* longitude;

//
// City of user
//
@property (nonatomic, strong) NSString* city ;

//
// You can set Designated market area (DMA) code of the user in this field.
// This field is applicable for US users only
//
@property (nonatomic, strong) NSString* dma;
//
// The user's zipcode may be useful in delivering geographically relevant ads
//
@property (nonatomic, strong) NSString* zip;
/*
 A comma-separated list of keywords indicating the consumer's interests or intent.
 */
@property (nonatomic, strong) NSString* keywords;

/*!
 ID of the publisher. This value can be obtained from the pubId parameter in the PubMatic ad tag.
 */
@property (strong,nonatomic)  NSString  *publisherId;

/*!
 User Income if available for more relevant Ads
 */
@property (nonatomic, strong) NSString* userIncome;

/*!
 The user's state may be useful in delivering geographically relevant ads
 */
@property (nonatomic, strong) NSString* state;

/*
 Indicates whether Advertisment ID should be sent in the request. Possible values are:
 YES - IDFA will be sent in the request.
 NO - Vendor ID will be sent in the request instead of the IDFA.
 Default value - YES
 */
@property (nonatomic, assign) BOOL isIDFAEnabled;

/*
 Apply following hashing on udid before sending to server
 PMUdidhashTypeUnknown=0,
 PMUdidhashTypeRaw,
 PMUdidhashTypeSHA1,
 PMUdidhashTypeMD5
Default is PMUdidhashTypeRaw
 */
@property (nonatomic, assign) PMUdidhashType udidHashType;

/*!
 Indicates whether the user has opted out of the publisher or not, or whether HTTP_DNT is set or not. Possible values are:
 0 - Either the user has not opted out of the publisher or HTTP_DNT is not set.
 1 - Either the user has opted out of the publisher or HTTP_DNT is set; in this case, PubMatic will not target such users.
 Note: The default value for this parameter is 0.
 */
@property (nonatomic, assign) BOOL dnt;

/*!
 Indicates whether the visitor is COPPA-specific or not. For COPPA (Children's Online Privacy Protection Act) compliance, if the visitor's age is below 13, then such visitors should not be served targeted ads.
 Possible options are:
 0 - Indicates that the visitor is not COPPA-specific and can be served targeted ads.
 1 - Indicates that the visitor is COPPA-specific and should be served only COPPA-compliant ads.
 */
@property (nonatomic, assign) PMBOOL coppa;

/*!
 Indicates whether the mobile application is a paid version or not. Possible values are:
 0 - Free version
 1 - Paid version
 */
@property (nonatomic, assign) PMBOOL paid;

/*!
 This parameter is used to pass a zone ID for reporting.
 */
@property (nonatomic, strong) NSString * pmZoneId;

/*!
 Application primary category as displayed on storeurl page for the respective platform.
 */
@property (nonatomic, strong) NSString * appCategory;

/*!
 List of IAB content categories for the overall site/application
 */
@property (nonatomic, strong) NSString * IABCategory;

/*!
 Indicates the domain of the mobile application
 */
@property (nonatomic, strong) NSString * appDomain;

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
@property (nonatomic, assign) PMAWT awt;

/*!
 The user's ethnicity may be used to deliver more relevant ads.
 Numeric code of ethnicity. Possible options are:
 0 - Hispanic
 1 - African-American
 2 - Caucasian
 3 - Asian-American
 4 – Other
 For example, ethn=1.
 */
@property (nonatomic, assign) PMEthnicity ethnicity;

/*!
 Fold placement of the ad to be served. Possible values are:
 0 – Visibility cannot be determined
 1 – Above the fold
 2 - Below the fold.
 3 – Partially above the fold
 Note: If you are unable to determine it, you can set the default value as 0 in this parameter.
 */
@property (nonatomic, assign) PMAdVisibility adVisibility;


/*!
 The user's location source may be useful in delivering geographically relevant ads
 */
@property (nonatomic, assign) PMLocSource locationSource;

/*!
 Set the user gender
 */
@property (nonatomic, assign) PMGender gender;

/*!
 iOS application's ID
 */
@property (nonatomic, strong) NSString* aid;

/*!
 The year of Year of birth as a 4-digit integer
 */
@property (nonatomic, strong) NSString* birthYear;

/*!
 URL of application on App store URL
 */
@property (nonatomic, strong) NSString* storeURL;

@property (nonatomic, readonly) NSArray *impressions;

/*!
 setCustomParamValue:forParam
 @param value
 Value of custom parameter
 @param param
 Name of custom parameter
 
 */
-(void)setCustomParamValue:(NSString *)value forParam:(NSString *)param;


/*!
 ID of the ad orientation. Possible values are:
 0 - Portrait orientation
 1 - Landscape orientation
 */
@property (nonatomic,assign)  NSInteger  adOrientation;


/*!
 Header bidding API URL / mainly used for testing
 */
@property (nonatomic,strong) NSString * adServerURL;

-(instancetype)init __attribute__((unavailable("Use -(id)initForPrefetchWithPublisherId:impressionArray: instead")));

- (id)initForPrefetchWithPublisherId:(NSString*)pubId impressionArray:(NSArray<PMBannerImpression *>*)impressions;

- (NSURLRequest*)prefetchUrlRequestWithError:(NSError *__autoreleasing *)error;
@end


@interface PMBannerImpression : PMImpression

@property (nonatomic, readonly) NSArray *sizes;

- (id)initWithImpressionId:(NSString*)impId
                  slotName:(NSString*)slotName
                 slotIndex:(NSInteger)slotIndex
                     sizes:(NSArray*)sizes;

@end

