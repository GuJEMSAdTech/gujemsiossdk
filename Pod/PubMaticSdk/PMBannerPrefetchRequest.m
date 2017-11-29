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

#define kAdPositionParamValue    @"-1x-1"
#define kAdOrientationParam      @"adOrientation"
#define kAdPositionParam         @"adPosition"
#define kAdTypeParam             @"adtype"
#define kAdTypeParamValue        @"5"
#define kDeviceOrientationParam  @"deviceOrientation"
#define kOperIdParam             @"operId"
#define kPubIdParam              @"pubId"
#define kltstampParam            @"kltstamp"
#define kRanReqParam             @"ranreq"
#define kJsParam                 @"js"
#define kTimezoneParam           @"timezone"
#define kScreenResolutionParam   @"screenResolution"
#define kAdVisibilityParam       @"adVisibility"
#define kUdidParam               @"udid"
#define kUdidTypeParam           @"udidtype"
#define kUdidHashParam           @"udidhash"
#define kMakeParam               @"make"
#define kModelParam              @"model"
#define kOsParam                 @"os"
#define kOsvParam                @"osv"
#define kLocParam                @"loc"
#define kNetworkType             @"nettype"
#define kCarrierParam            @"carrier"
#define kAppName                 @"name"
#define kAppPaid                 @"paid"
#define kAppStoreUrl             @"storeurl"
#define kAppID                   @"aid"
#define kVerParam                @"ver"
#define kAPIParam                @"api"
#define kDNT                     @"dnt"
#define kCoppaParam              @"coppa"
#define kAwt                     @"awt"
#define kAdRefreshRateParam      @"adRefreshRate"
#define kLanguage                @"lang"
#define kAppIabCat               @"iabcat"
#define kBundleParam             @"bundle"
#define kAPIParamValue           @"3::4::5"
#define kAppDomain               @"domain"
#define kAppCat                  @"cat"
#define kPageURLParam            @"pageURL"
#define kInIframeParam           @"inIframe"
#define kInIframeParamValue      @"1"

#define kYobParam                @"yob"
#define kGenderParam             @"gender"
#define kLocSourceParam          @"loc_source"
#define kZipParam                @"zip"
#define kStateParam              @"state"
#define kCityParam               @"city"
#define kDMAParam                @"dma"
#define kKeywordsParam           @"keywords"
#define kAreaCodeParam           @"area"
#define kUserIncome              @"inc"
#define kUserEthnicity           @"ethn"
#define kCustomParameter         @"pmcust"
#define kCountryParam            @"country"

#define kContentType            @"Content-Type"
#define kContentTypeValue       @"application/json"
#define kUserAgent              @"User-Agent"
#define kRLNClientIpAddr        @"RLNClientIpAddr"
#define kContentLength          @"Content-Length"

//RTB keys
#define kSAVersionParam                @"SAVersion"
#define kSAVersionValue                @"1000"
#define kRTBRequestIDParam             @"id"
#define kRTBRequestIDValue             @"1471504048821"
#define kAuctionTypeParam              @"at"
#define kAuctionTypeValue              2
#define kCurrencyParam                 @"cur"
#define kImpressionIDParam             @"id"
#define kPositionParam                 @"pos"
#define kRTBFormatParam                @"format"
#define kRTBAPIParam                   @"api"
#define kRTBBannerParam                @"banner"
#define kRTBAdUnitParam                @"adunit"
#define kRTBImpressionKeyValueParam    @"key-value"
#define kRTBExtensionParam             @"extension"
#define kRTBExtParam                   @"ext"
#define kRTBInstlParam                 @"instl"
#define kRTBImpParam                   @"imp"
#define kRTBPubIdParam                 @"id"
#define kRTBAppIdParam                 @"id"
#define kRTBpublisherObjParam          @"publisher"
#define kRTBAppObjParam                @"app"
#define kRTBLatitudeParam              @"lat"
#define kRTBLongitudeParam             @"lon"
#define kRTBRegionParam                @"region"
#define kRTBMetroParam                 @"metro"
#define kRTBGeoParam                   @"geo"
#define kRTBIfaParam                   @"ifa"
#define kRTBdpidsha1Param              @"dpidsha1"
#define kRTBdpidmd5Param               @"dpidmd5"
#define kRTBConnectionTypeParam        @"connectiontype"
#define kRTBDeviceObjParam             @"device"
#define kRTBUserObjParam               @"user"
#define kRTBRegsObjParam               @"regs"
#define kRTBDMResponseParam            @"rs"
#define kRTBDMPubIdParam               @"pubId"
#define kRTBDMExtensionParam           @"dm"
#define kRTBAdServerParam              @"as"
#define kRTBAppExtensionParam          @"extension"
#define kRTBAppExtParam                @"ext"
#define kRTBDeviceUserAgent            @"ua"

#define PUBMATIC_PREFETCH_URL          @"http://hb.pubmatic.com/openrtb/24"

#import "PMBannerPrefetchRequest.h"
#import "PMSDKUtil.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString(PMAddition)
- (NSString*)hashUsingSHA1;
- (NSString *)hashUsingMD5;
@end

@interface PMBannerPrefetchRequest()
@property (nonatomic,strong) NSURLRequest * request;
@property (readonly,nonatomic)  NSDictionary  *custParamdict;
-(NSDictionary *)paramsDictionary;
-(NSDictionary *)defaultParams;
@end

@implementation PMBannerPrefetchRequest

@synthesize custParamdict = _custParamdict;

-(NSDictionary *)custParamdict{
    
    if(!_custParamdict){
        _custParamdict = [NSDictionary new];
    }
    return _custParamdict;
}

-(NSError *)validate{
    
    NSError * error = nil;
    if(!(self.publisherId && (error==nil))){
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Can not update without a proper publisherId, siteId & adTagId", nil),};
        NSError *error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                             code:1
                                         userInfo:userInfo];
        return error;
    }
    
    if(!self.adServerURL){
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Can not set Adserver URL to nil", nil),};
        NSError *error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                             code:1
                                         userInfo:userInfo];
        return error;
    }
    return error;
}

-(void)setCustomParamValue:(NSString *)value forParam:(NSString *)param{
    
    NSMutableDictionary * mDict = [[self custParamdict] mutableCopy];
    if([mDict objectForKey:param]){
        
        NSSet * set = [mDict objectForKey:param];
        NSMutableSet * mSet = [set mutableCopy];
        [mSet addObject:value];
        [mDict setObject:[NSSet setWithSet:mSet]forKey:param];
        
    }else{
        
        NSSet * set = [NSSet setWithObject:value];
        [mDict setObject:[NSSet setWithSet:set]forKey:param];
        
    }
    _custParamdict = [NSDictionary dictionaryWithDictionary:mDict];
    
}

-(NSDictionary *)defaultParams{
    
    PMSDKUtil *util = [PMSDKUtil sharedInstance];
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObjectSafely:util.currentTime forKey:kltstampParam];
    [params setObjectSafely:util.netType forKey:kNetworkType];
    [params setObjectSafely:[NSString stringWithFormat:@"%f",util.ranreq] forKey:kRanReqParam];
    [params setObjectSafely:[NSString stringWithFormat:@"%f",util.currentTimeZone] forKey:kTimezoneParam];
    [params setObjectSafely:util.deviceScreenResolution forKey:kScreenResolutionParam];
    [params setObjectSafely:util.deviceAcceptLanguage forKey:kLanguage];
    
    [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[util deviceOrientation]]  forKey:kDeviceOrientationParam];
    
    
    BOOL dnt = self.dnt || util.dnt;
    
    if (!dnt){
        
        NSString * udidValue = self.isIDFAEnabled?[util advertisingID]:[util vendorID];
        
        if (self.udidHashType == PMUdidhashTypeSHA1) {
            udidValue = [udidValue hashUsingSHA1];
        }else if(self.udidHashType == PMUdidhashTypeMD5) {
            udidValue = [udidValue hashUsingMD5];
        }
        
        [params setObjectSafely:udidValue  forKey:kUdidParam];

        [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[util pubDeviceIDTypeForIDFAFlag:self.isIDFAEnabled]]  forKey:kUdidTypeParam];
        [params setObjectSafely:[NSString stringWithFormat:@"%ld", (long)self.udidHashType] forKey:kUdidHashParam];
    }
    
    [params setObjectSafely:kAPIParamValue  forKey:kAPIParam];
    
    [params setObjectSafely:util.pageURL forKey:kPageURLParam];
    
    return [NSDictionary dictionaryWithDictionary:params];
}

-(NSDictionary *)paramsDictionary{
    
    PMSDKUtil *util = [PMSDKUtil sharedInstance];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    NSDictionary * defaultParams = [self defaultParams];
    [params addEntriesFromDictionary:defaultParams];
    [params setObjectSafely:self.publisherId forKey:kPubIdParam];
    
    if ( self.latitude.length && self.longitude.length)
    {
        NSString * latLong = [NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude];
        [params setObjectSafely:latLong forKey:kLocParam];
        [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)PMLocSourceUserProvided] forKey:kLocSourceParam];
        
    }
    
    [params setObjectSafely:self.keywords forKey:kKeywordsParam];
    
    BOOL dnt = self.dnt || util.dnt;
    
    if (!dnt)
    {
        [params setObjectSafely:[self userIncome] forKey:kUserIncome];
        
        if (self.ethnicity != PMEthnicityNone) {
            [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)self.ethnicity] forKey:kUserEthnicity];
        }
    }
    
    [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)self.awt] forKey:kAwt];
    [params setObjectSafely:[NSString stringWithFormat:@"%ld",(long)self.adVisibility] forKey:kAdVisibilityParam];
    [params setObjectSafely:self.appCategory forKey:kAppCat];
    [params setObject:kInIframeParamValue forKey:kInIframeParam];
    [params setObject:kAdPositionParamValue forKey:kAdPositionParam];
    
    // Setting adOrientation
    if(self.adOrientation!=-1){
        
        [params setObjectSafely:[NSString stringWithFormat:@"%d",(int)self.adOrientation] forKey:kAdOrientationParam];
    }
    
    [params setObject:kAdTypeParamValue forKey:kAdTypeParam];
    return [NSDictionary dictionaryWithDictionary:params];
    
}

- (id)initForPrefetchWithPublisherId:(NSString*)pubId impressionArray:(NSArray<PMBannerImpression *>*)impressions
{
    self = [super init];
    if (self) {
        
        self.adServerURL =  PUBMATIC_PREFETCH_URL;
        self.publisherId = pubId;
        _publisherId = pubId;
        _dnt = NO;
        _awt = PMAWTSeparateTracker;
        _adVisibility = PMAdVisibilityUnKnown;
        _adOrientation = -1;
        _gender = PMGenderUnknown;
        _impressions = impressions;
        _paid = PMBOOLNo;
        _isIDFAEnabled = YES;
        _ethnicity = PMEthnicityNone;
        _udidHashType = PMUdidhashTypeRaw;
    }
    return self;
}

- (NSURLRequest*)prefetchUrlRequestWithError:(NSError *__autoreleasing *)error
{
    if (self.impressions.count == 0) {
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No valid impressions for this request", nil),};
        *error = [NSError errorWithDomain:@"PubMaticHeaderBidding"
                                     code:1
                                 userInfo:userInfo];
        return nil;
    }
    
    PMSDKUtil *util = [PMSDKUtil sharedInstance];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.adServerURL]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary * adServerParams = [[self paramsDictionary] mutableCopy];
    [adServerParams setObject:kSAVersionValue forKey:kSAVersionParam];
    [adServerParams setObjectSafely:[NSNumber numberWithFloat:util.ranreq] forKey:kRanReqParam];
    [adServerParams setObjectSafely:[NSNumber numberWithDouble:util.currentTimeZone] forKey:kTimezoneParam];
    
    
    //Prepare header bidding request payload.
    NSMutableDictionary *rtbPayload = [NSMutableDictionary new];
    [rtbPayload setObject:kRTBRequestIDValue forKey:kRTBRequestIDParam];
    [rtbPayload setObject:[NSNumber numberWithInt:kAuctionTypeValue] forKey:kAuctionTypeParam];
    [rtbPayload setObjectSafely:@[@"USD"] forKey:kCurrencyParam];
    
    //Impressions
    NSMutableArray *rtbImpressions = [NSMutableArray new];
    for (PMBannerImpression *impression in self.impressions) {
        
        NSMutableDictionary *rtbImpression = [NSMutableDictionary new];
        [rtbImpression setObject:impression.impId forKey:kImpressionIDParam];
        
        NSMutableDictionary *bannerObj = [NSMutableDictionary new];
        [bannerObj setObject:[NSNumber numberWithInt:0] forKey:kPositionParam];
        [bannerObj setObjectSafely:impression.sizes forKey:kRTBFormatParam];
        [bannerObj setObjectSafely:@[@3, @4, @5] forKey:kRTBAPIParam];
        [rtbImpression setObjectSafely:bannerObj forKey:kRTBBannerParam];
        
        NSMutableDictionary *rtbExt = [NSMutableDictionary new];
        NSMutableDictionary *rtbExtension = [NSMutableDictionary new];
        [rtbExtension setObject:impression.adSlotId forKey:kRTBAdUnitParam];
        [rtbExtension setObject:[NSString stringWithFormat:@"%d",(int)impression.adSlotIndex] forKey:@"slotIndex"];
        [rtbExtension setObjectSafely:impression.keyValues forKey:kRTBImpressionKeyValueParam];
        [rtbExt setObjectSafely:rtbExtension forKey:kRTBExtensionParam];
        
        [rtbImpression setObjectSafely:rtbExt forKey:kRTBExtParam];
        [rtbImpression setObjectSafely:impression.isInterstitial?@1:@0 forKey:kRTBInstlParam];
        
        [rtbImpressions addObject:rtbImpression];
    }
    
    [rtbPayload setObjectSafely:rtbImpressions forKey:kRTBImpParam];
    
    NSMutableDictionary *rtbPublisher = [NSMutableDictionary new];
    [rtbPublisher setObject:self.publisherId forKey:kRTBPubIdParam];
    
    //App object
    NSMutableDictionary *rtbApp = [NSMutableDictionary new];
    [rtbApp setObjectSafely:self.aid forKey:kRTBAppIdParam];
    
    [rtbApp setObjectSafely:[util applicationName] forKey:kAppName];
    [rtbApp setObjectSafely:[util appBundleIdentifier] forKey:kBundleParam];
    [rtbApp setObjectSafely:self.appDomain forKey:kAppDomain];
    [rtbApp setObjectSafely:self.storeURL forKey:kAppStoreUrl];
    
    //Do not remove 'cat' from 'adServerParams' as the format is different.
    NSArray *appCat = [self.IABCategory componentsSeparatedByString:@","];
    [rtbApp setObjectSafely:appCat forKey:kAppCat];
    if (self.paid !=PMBOOLNone) {
        NSNumber *appPaid = [NSNumber numberWithInt:self.paid];
        [rtbApp setObjectSafely:appPaid forKey:kAppPaid];
    }
    [rtbApp setObjectSafely:[util appVersion] forKey:kVerParam];
    [rtbApp setObjectSafely:rtbPublisher forKey:kRTBpublisherObjParam];
    [rtbPayload setObjectSafely:rtbApp forKey:kRTBAppObjParam];
    
    //Device object
    NSMutableDictionary *rtbDeviceObj = [NSMutableDictionary new];
    
    NSMutableDictionary *rtbGeoObj = [NSMutableDictionary new];
    
    NSNumber *lat = self.latitude.length?[NSNumber numberWithFloat:[self.latitude floatValue]]:util.latitude;
    [rtbGeoObj setObjectSafely:lat forKey:kRTBLatitudeParam];
    NSNumber *lon = self.longitude.length?[NSNumber numberWithFloat:[self.longitude floatValue]]:util.longitude;
    [rtbGeoObj setObjectSafely:lon forKey:kRTBLongitudeParam];
    [rtbGeoObj setObjectSafely:util.countryCode forKey:kCountryParam];
    
    if (self.state && self.state.length) {
        [rtbGeoObj setObjectSafely:self.state forKey:kRTBRegionParam];
    }
    
    if (self.dma && self.dma.length) {
        [rtbGeoObj setObjectSafely:self.dma forKey:kRTBMetroParam];
    }
    
    if (self.city && self.city.length) {
        [rtbGeoObj setObjectSafely:self.city forKey:kCityParam];
    }
    
    if (self.zip && self.zip.length) {
        [rtbGeoObj setObjectSafely:self.zip forKey:kZipParam];
    }
    [rtbDeviceObj setObjectSafely:rtbGeoObj forKey:kRTBGeoParam];
    
    BOOL dnt = self.dnt || util.dnt;
    
    [rtbDeviceObj setObjectSafely:dnt?@1:@0 forKey:kDNT];
    if (!dnt) {
        if (self.isIDFAEnabled) {
            
            if (self.udidHashType == PMUdidhashTypeMD5) {
            
                [rtbDeviceObj setObjectSafely:[util.advertisingID hashUsingMD5] forKey:kRTBdpidmd5Param];

            }else if(self.udidHashType == PMUdidhashTypeSHA1){
                
                [rtbDeviceObj setObjectSafely:[util.advertisingID hashUsingSHA1] forKey:kRTBdpidsha1Param];

            }else{

                [rtbDeviceObj setObjectSafely:util.advertisingID forKey:kRTBIfaParam];
            }

        }else{
            
            if (self.udidHashType == PMUdidhashTypeMD5) {
                
                [rtbDeviceObj setObjectSafely:[util.vendorID hashUsingMD5] forKey:kRTBdpidmd5Param];
                
            }else if(self.udidHashType == PMUdidhashTypeSHA1){
                
                [rtbDeviceObj setObjectSafely:[util.vendorID hashUsingSHA1] forKey:kRTBdpidsha1Param];

            }
        }
    }
    [rtbDeviceObj setObjectSafely:util.deviceMake forKey:kMakeParam];
    [rtbDeviceObj setObjectSafely:util.deviceModel forKey:kModelParam];
    [rtbDeviceObj setObjectSafely:util.deviceOSName forKey:kOsParam];
    [rtbDeviceObj setObjectSafely:util.deviceOSversion forKey:kOsvParam];
    [rtbDeviceObj setObjectSafely:[NSNumber numberWithFloat:util.deviceHeight] forKey:@"h"];
    [rtbDeviceObj setObjectSafely:[NSNumber numberWithFloat:util.deviceWidth] forKey:@"w"];
    
    [rtbDeviceObj setObjectSafely:@1 forKey:kJsParam];
    [rtbDeviceObj setObjectSafely:util.carrierName forKey:kCarrierParam];
    [rtbDeviceObj setObjectSafely:util.rtbConnectionType forKey:kRTBConnectionTypeParam];
    [rtbDeviceObj setObjectSafely:util.userAgent forKey:kRTBDeviceUserAgent];
    
    [rtbPayload setObjectSafely:rtbDeviceObj forKey:kRTBDeviceObjParam];
    
    if (!dnt)
    {
        NSMutableDictionary *rtbUserObj = [NSMutableDictionary new];
        if(self.birthYear){
            
            NSNumber * yob = [NSNumber numberWithInteger:[self.birthYear integerValue]];
            [rtbUserObj setObjectSafely:yob forKey:kYobParam];
            
        }
        
        [rtbUserObj setObjectSafely:[PMSDKUtil stringFromGender:self.gender] forKey:kGenderParam];
        [rtbPayload setObjectSafely:rtbUserObj forKey:kRTBUserObjParam];
    }
    
    //Regs object
    NSMutableDictionary *rtbRegsObj = [NSMutableDictionary new];
    [rtbRegsObj setObjectSafely:self.coppa?@1:@0 forKey:kCoppaParam];
    [rtbPayload setObjectSafely:rtbRegsObj forKey:kRTBRegsObjParam];
    
    //App extension object
    NSMutableDictionary *rtbAppExt = [NSMutableDictionary new];
    NSMutableDictionary *rtbAppExtension = [NSMutableDictionary new];
    
    //Decision manager ext obj
    NSMutableDictionary *dmObj = [NSMutableDictionary new];
    [dmObj setObjectSafely:[NSNumber numberWithInt:1] forKey:kRTBDMResponseParam];
    [dmObj setObject:self.publisherId forKey:kRTBDMPubIdParam];
    [rtbAppExtension setObjectSafely:dmObj forKey:kRTBDMExtensionParam];
    
    //Ad server ext obj
    [adServerParams setObjectSafely:self.IABCategory forKey:kAppIabCat];
    [adServerParams setObjectSafely:self.appCategory forKey:kAppCat];
    [rtbAppExtension setObjectSafely:adServerParams forKey:kRTBAdServerParam];
    
    [rtbAppExt setObjectSafely:rtbAppExtension forKey:kRTBAppExtensionParam];
    [rtbPayload setObjectSafely:rtbAppExt forKey:kRTBAppExtParam];
    
    NSError *jsonError = nil;
    NSData * postData = [NSJSONSerialization dataWithJSONObject:rtbPayload options:kNilOptions error:&jsonError];
    if (jsonError) {
        DLog(@"Malformed json");
    }
    
    DLog(@"%@",[rtbPayload description]);
    
    //HTTP Headers
    NSString *userAgent = [util userAgent];
    
    [request setValue:kContentTypeValue forHTTPHeaderField:kContentType];
    [request setValue:userAgent forHTTPHeaderField:kUserAgent];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[request.HTTPBody length]] forHTTPHeaderField: kContentLength];
    
    if(postData != nil ){
        [request setHTTPBody:postData];
    }    
    return request;
}

@end

@implementation PMBannerImpression

- (id)initWithImpressionId:(NSString*)impId slotName:(NSString*)slotName slotIndex:(NSInteger)slotIndex sizes:(NSArray*)sizes{
    
    self = [super initWithImpId:impId slotName:slotName slotIndex:slotIndex];
    
    if (self) {
        
        NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
        
        for(PMSize * size in sizes)
        {
            NSDictionary *sizeDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:size.width], @"w", [NSNumber numberWithFloat:size.height], @"h", nil];
            [sizeArray addObject:sizeDict];
        }
        _sizes = sizeArray;
    }
    return self;
}

-(BOOL)isValid
{
    BOOL isValid = [super isValid] && _sizes && _sizes.count;
    return isValid;
}

@end


@implementation NSString(PMAddition)

- (NSString*)hashUsingSHA1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (uint)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [NSString stringWithString:output];
}

- (NSString *)hashUsingMD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (uint)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [NSString stringWithString:output];
}

@end
