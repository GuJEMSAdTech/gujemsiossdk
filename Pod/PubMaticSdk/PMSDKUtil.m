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
//  PUBDeviceUtil.m


#import "PMSDKUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import<AdSupport/ASIdentifierManager.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>

#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "PubMaticConstants.h"

#define kDNT_Enabled 1
#define kDNT_Disabled 0

NSString * const kPubDeviceOSName  = @"iOS";
NSString * const kNotReachable      =   @"Network Not Available";
NSString * const kReachableViaWWAN  =   @"carrier";
NSString * const kReachableViaWiFi  =   @"wifi";

@interface PMSDKUtil ()
@property(nonatomic,strong) NSMutableSet * locationObserverObjIds;
@property(nonatomic,strong) NSDictionary * countryCodeDictionary;
@end


@implementation PMSDKUtil
@dynamic userAgent;
@synthesize deviceOrientation = _deviceOrientation;

typedef enum {
    ConnectionTypeUnknown,
    ConnectionTypeNone,
    ConnectionType3G,
    ConnectionTypeWiFi
} ConnectionType;

+ (SCNetworkReachabilityRef ) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    return reachability;
}

+ (SCNetworkReachabilityRef ) reachabilityForInternetConnection;
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    return [self reachabilityWithAddress: &zeroAddress];
}

+ (ConnectionType)connectionType
{
    SCNetworkReachabilityRef reachability = [[self class] reachabilityForInternetConnection];
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    if (!success) {
        return ConnectionTypeUnknown;
    }
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL isNetworkReachable = (isReachable && !needsConnection);
    
    if (!isNetworkReachable) {
        return ConnectionTypeNone;
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        return ConnectionType3G;
    } else {
        return ConnectionTypeWiFi;
    }
}

-(NSNumber *)rtbConnectionType{
    /*
     0     Unknown
     1     Ethernet
     2     WIFI
     3     Cellular Network – Unknown Generation
     4     Cellular Network – 2G
     5     Cellular Network – 3G
     ￼6     Cellular Network – 4G
     */
    
    ConnectionType conectionType = [[self class] connectionType];
    switch (conectionType) {
        case ConnectionTypeNone:
        case ConnectionTypeUnknown:
            return [NSNumber numberWithInt:0];
            break;
            
        case ConnectionType3G:
            return [NSNumber numberWithInt:3];
            break;
            
        case ConnectionTypeWiFi:
            return [NSNumber numberWithInt:2];
            break;
            
        default:
            return [NSNumber numberWithInt:0];;
            break;
    }
}

-(NSString *)netType{
    
    ConnectionType conectionType = [[self class] connectionType];
    switch (conectionType) {
        case ConnectionTypeNone:
        case ConnectionTypeUnknown:
            return nil;
            break;
            
        case ConnectionType3G:
            return @"cellular";
            break;
            
        case ConnectionTypeWiFi:
            return @"wifi";
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark -  Initialization
- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.latitude = nil;
        self.longitude = nil;
        
    }
    return self;
}

#pragma mark -  Overridden methods to make class singleton

static id sharedInstance = nil;

//
// Static functions return the singleton object of Derived class
//
+ (PMSDKUtil *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == sharedInstance || (![sharedInstance isKindOfClass:self]))
            sharedInstance = [[super allocWithZone:NULL] init];
        return sharedInstance;
    }
}

// We don't allocate a new instance, so return the current one.

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance] ;
}

//  we don't generate multiple copies.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Get the current date in format: Tue,15 Nov 1994 08:12:31 GMT
+ (NSString*) getCurrentDate
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:today];
    
    NSInteger day = [components day];
    NSInteger month = [components month] -1;
    NSInteger year = [components year];
    NSInteger weekday = [components weekday] -1;
    
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"HH:mm:ss"];
    
    NSString *monthString = [self getMonthString:month];
    NSString *weekDayString = [self getWeekDayString:weekday];
    
    NSString *formattedDateString = [NSString stringWithFormat:@"%@, %ld %@ %ld %@ GMT",
                                     weekDayString,(long)day,monthString,(long)year,[dt stringFromDate:today]];
    
    return formattedDateString;
}

+ (NSString*) getMonthString:(NSInteger) month
{
    switch(month)
    {
        case 0: return @"Jan";
            
        case 1: return @"Feb";
            
        case 2: return @"Mar";
            
        case 3: return @"Apr";
            
        case 4: return @"May";
            
        case 5: return @"Jun";
            
        case 6: return @"Jul";
            
        case 7: return @"Aug";
            
        case 8: return @"Sep";
            
        case 9: return @"Oct";
            
        case 10: return @"Nov";
            
        case 11: return @"Dec";
            
        default: return nil;
    }
}

+ (NSString*) getWeekDayString:(NSInteger) weekday
{
    switch(weekday)
    {
        case 0: return @"Sun";
            
        case 1: return @"Mon";
            
        case 2: return @"Tue";
            
        case 3: return @"Wed";
            
        case 4: return @"Thu";
            
        case 5: return @"Fri";
            
        case 6: return @"Sat";
            
        default: return nil;
    }
}

+(NSString *) contentMd5String:( NSString *)str
{
    const char *cStr = [str UTF8String];
    // md5 string is of 16 bytes hence 16
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    NSString *md5t = [[NSString alloc] initWithBytes:result length:sizeof(16) encoding:NSASCIIStringEncoding];
    NSString *base64_encoded_nsstring = [self base64EncodeStringFromData:[md5t dataUsingEncoding:NSUTF8StringEncoding]];
    return base64_encoded_nsstring;
}

+(NSString *)base64EncodeStringFromData:(NSData *)data{
    //Point to start of the data and set buffer sizes
    unsigned long inLength = [data length];
    unsigned long outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
    const char *inputBuffer = [data bytes];
    char *outputBuffer = malloc(outLength);
    outputBuffer[outLength] = 0;
    
    //64 digit code
    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //start the count
    int cycle = 0;
    int inpos = 0;
    int outpos = 0;
    char temp = '\0';
    
    //Pad the last to bytes, the outbuffer must always be a multiple of 4
    outputBuffer[outLength-1] = '=';
    outputBuffer[outLength-2] = '=';
    
    /* http://en.wikipedia.org/wiki/Base64
     Text content   M           a           n
     ASCII          77          97          110
     8 Bit pattern  01001101    01100001    01101110
     
     6 Bit pattern  010011  010110  000101  101110
     Index          19      22      5       46
     Base64-encoded T       W       F       u
     */
    
    
    while (inpos < inLength){
        switch (cycle) {
            case 0:
                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
                cycle = 1;
                break;
            case 1:
                temp = (inputBuffer[inpos++]&0x03)<<4;
                outputBuffer[outpos] = Encode[temp];
                cycle = 2;
                break;
            case 2:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
                temp = (inputBuffer[inpos++]&0x0F)<<2;
                outputBuffer[outpos] = Encode[temp];
                cycle = 3;
                break;
            case 3:
                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
                cycle = 4;
                break;
            case 4:
                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
                cycle = 0;
                break;
            default:
                cycle = 0;
                break;
        }
    }
    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
    free(outputBuffer);
    return pictemp;
}


#pragma mark -  Accessor Functions

-(NSString *) deviceID
{
    // We are actually supporting idfa from ios6 onwards for ios
    // version before ios6 we support odin-1
    
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
}

-(NSString *) vendorID
{
    // We are actually supporting idfa from ios6 onwards for ios
    // version before ios6 we support odin-1
    
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
}

-(NSString *) advertisingID
{
    // We are actually supporting idfa from ios6 onwards for ios
    // version before ios6 we support odin-1
    
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
}

-(PubDeviceIDType) pubDeviceIDTypeForIDFAFlag:(BOOL)isIDFAEnabled
{
    return isIDFAEnabled ? kIDFA : kIDFV;
}

-(PubDeviceIDType) pubDeviceIDType
{
    return kIDFA;
}

// Determines whether user has set dnt or not
-(int) dnt
{
    if(! [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
    {
        return kDNT_Enabled;
    }
    
    return kDNT_Disabled;
    
}

// Get the application name
-(NSString *) applicationName
{
    if ([[[NSBundle mainBundle] infoDictionary]
         objectForKey:@"CFBundleName"]) {
        return [[[NSBundle mainBundle] infoDictionary]
                objectForKey:@"CFBundleName"];
    }
    
    return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleDisplayName"];
}

// Get the Application version
-(NSString *) appVersion
{
    return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleVersion"];
}


-(NSString *) appBundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

// Get the Page url
-(NSString *) pageURL
{
    return @"" ;
}


// Retrieve the device locale
-(NSString *) deviceAcceptLanguage
{
    return [[NSLocale currentLocale] localeIdentifier];;
}


// Get the carrier information, contry code
-(NSString*) carrierName
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    if(carrier){
        
        return [carrier carrierName];
    }
    return nil;
}

// Get the carrier country code in isoAlpha3
- (NSString*) countryCode
{
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init] ;
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    
    // Get the ISO Country Code of carrier
    NSString *countryCodeInAlpha2 = [carrier isoCountryCode];
    
    if (countryCodeInAlpha2 != nil)
    {
        // Fetch the corresponding value in ISO-3166-1 Alpha 3
        NSString *countryCodeInAlpha3 = [[self countryCodeDictionary] valueForKey:[countryCodeInAlpha2 uppercaseString]];
        
        if (countryCodeInAlpha3 != nil)
        {
            return countryCodeInAlpha3;
        }
    }
    return nil;
}

// Get the device OS Name
-(NSString*) deviceOSName
{
    return kPubDeviceOSName;
}


// Get the device OS version
-(NSString*) deviceOSversion
{
    return [[UIDevice currentDevice] systemVersion];
}

// Get the current device make
-(NSString*) deviceMake
{
    return @"Apple";
}

// Get the current device model
-(NSString*) deviceModel
{
    return [[UIDevice currentDevice] model];
}

// Get the device height
-(CGFloat)deviceHeight
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.height;
}

// Get the device width
-(CGFloat)deviceWidth
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.width;
}

// Get the screen resolution
-(NSString*) deviceScreenResolution
{
    return [NSString stringWithFormat:@"%dx%d",(int)self.deviceWidth,(int)self.deviceHeight];
}


// Get the current time
- (NSString*) currentTime
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"HH:mm:ss"];
    NSString *str = [NSString stringWithFormat:@"%ld-%ld-%ld %@", (long)year, (long)month,(long)day, [dt stringFromDate:today]];
    
    return str;
}

// Method for getting current TimeZone
-(double) currentTimeZone
{
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    return (double) [localTime secondsFromGMT]/3600;
}

//Method for getting Current Device Orientation
-(int) deviceOrientation
{
    _deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch(_deviceOrientation)
    {
        case UIDeviceOrientationPortrait: return 0;
        case UIDeviceOrientationLandscapeRight: return 1;
        case UIDeviceOrientationPortraitUpsideDown:return 0;
        case UIDeviceOrientationLandscapeLeft:return 1;
        default : return -1;
    }
    return -1;
}

// Generate the randome number in between 0 to 1
-(float) ranreq
{
    float randomNumber=(float)random();
    while(randomNumber>=1)
        randomNumber=randomNumber/10;
    return randomNumber;
}

-(NSString *) userAgent
{
    static NSString *userAgent = nil;
    
    if (!userAgent) {
        UIWebView *webview = [[UIWebView alloc] init];
        userAgent = [[webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"] copy];
    }
    return userAgent;
}

#pragma mark -  Private Methods
-(NSString *)mnc{
    
    // Fetch the defaults for the cell info (can be overriden as well).
    CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
    CTCarrier* carrier = [networkInfo subscriberCellularProvider];
    NSString* mnc = [carrier mobileNetworkCode];
    return mnc;
    
}

-(NSString *)mcc{
    
    // Fetch the defaults for the cell info (can be overriden as well).
    CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
    CTCarrier* carrier = [networkInfo subscriberCellularProvider];
    NSString* mcc = [carrier mobileCountryCode];
    return mcc;
}

+ (NSString* )stringFromGender:(int)gender
{
    switch (gender)
    {
        case 0 :
            return @"O";
            
        case 1 :
            return @"M";
            
        case 2:
            return @"F";
            
        default:
            return nil;
            
    }
    return nil;
}

-(NSDictionary * )countryCodeDictionary{
    
    if(!_countryCodeDictionary){
        
        _countryCodeDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"AND",@"AD",@"ARE",@"AE",@"AFG",@"AF",@"ATG",@"AG",@"AIA",@"AI",@"ALB",@"AL",@"ARM",@"AM",@"AGO",@"AO",@"ATA",@"AQ",@"ARG",@"AR",@"ASM",@"AS",@"AUT",@"AT",@"AUS",@"AU",@"ABW",@"AW",@"ALA",@"AX",@"AZE",@"AZ",@"BIH",@"BA",@"BRB",@"BB",@"BGD",@"BD",@"BEL",@"BE",@"BFA",@"BF",@"BGR",@"BG",@"BHR",@"BH",@"BDI",@"BI",@"BEN",@"BJ",@"BLM",@"BL",@"BMU",@"BM",@"BRN",@"BN",@"BOL",@"BO",@"BES",@"BQ",@"BRA",@"BR",@"BHS",@"BS",@"BTN",@"BT",@"BVT",@"BV",@"BWA",@"BW",@"BLR",@"BY",@"BLZ",@"BZ",@"CAN",@"CA",@"CCK",@"CC",@"COD",@"CD",@"CAF",@"CF",@"COG",@"CG",@"CHE",@"CH",@"CIV",@"CI",@"COK",@"CK",@"CHL",@"CL",@"CMR",@"CM",@"CHN",@"CN",@"COL",@"CO",@"CRI",@"CR",@"CUB",@"CU",@"CPV",@"CV",@"CUW",@"CW",@"CXR",@"CX",@"CYP",@"CY",@"CZE",@"CZ",@"DEU",@"DE",@"DJI",@"DJ",@"DNK",@"DK",@"DMA",@"DM",@"DOM",@"DO",@"DZA",@"DZ",@"ECU",@"EC",@"EST",@"EE",@"EGY",@"EG",@"ESH",@"EH",@"ERI",@"ER",@"ESP",@"ES",@"ETH",@"ET",@"FIN",@"FI",@"FJI",@"FJ",@"FLK",@"FK",@"FSM",@"FM",@"FRO",@"FO",@"FRA",@"FR",@"GAB",@"GA",@"GBR",@"GB",@"GRD",@"GD",@"GEO",@"GE",@"GUF",@"GF",@"GGY",@"GG",@"GHA",@"GH",@"GIB",@"GI",@"GRL",@"GL",@"GMB",@"GM",@"GIN",@"GN",@"GLP",@"GP",@"GNQ",@"GQ",@"GRC",@"GR",@"SGS",@"GS",@"GTM",@"GT",@"GUM",@"GU",@"GNB",@"GW",@"GUY",@"GY",@"HKG",@"HK",@"HMD",@"HM",@"HND",@"HN",@"HRV",@"HR",@"HTI",@"HT",@"HUN",@"HU",@"IDN",@"ID",@"IRL",@"IE",@"ISR",@"IL",@"IMN",@"IM",@"IND",@"IN",@"IOT",@"IO",@"IRQ",@"IQ",@"IRN",@"IR",@"ISL",@"IS",@"ITA",@"IT",@"JEY",@"JE",@"JAM",@"JM",@"JOR",@"JO",@"JPN",@"JP",@"KEN",@"KE",@"KGZ",@"KG",@"KHM",@"KH",@"KIR",@"KI",@"COM",@"KM",@"KNA",@"KN",@"PRK",@"KP",@"KOR",@"KR",@"XKX",@"XK",@"KWT",@"KW",@"CYM",@"KY",@"KAZ",@"KZ",@"LAO",@"LA",@"LBN",@"LB",@"LCA",@"LC",@"LIE",@"LI",@"LKA",@"LK",@"LBR",@"LR",@"LSO",@"LS",@"LTU",@"LT",@"LUX",@"LU",@"LVA",@"LV",@"LBY",@"LY",@"MAR",@"MA",@"MCO",@"MC",@"MDA",@"MD",@"MNE",@"ME",@"MAF",@"MF",@"MDG",@"MG",@"MHL",@"MH",@"MKD",@"MK",@"MLI",@"ML",@"MMR",@"MM",@"MNG",@"MN",@"MAC",@"MO",@"MNP",@"MP",@"MTQ",@"MQ",@"MRT",@"MR",@"MSR",@"MS",@"MLT",@"MT",@"MUS",@"MU",@"MDV",@"MV",@"MWI",@"MW",@"MEX",@"MX",@"MYS",@"MY",@"MOZ",@"MZ",@"NAM",@"NA",@"NCL",@"NC",@"NER",@"NE",@"NFK",@"NF",@"NGA",@"NG",@"NIC",@"NI",@"NLD",@"NL",@"NOR",@"NO",@"NPL",@"NP",@"NRU",@"NR",@"NIU",@"NU",@"NZL",@"NZ",@"OMN",@"OM",@"PAN",@"PA",@"PER",@"PE",@"PYF",@"PF",@"PNG",@"PG",@"PHL",@"PH",@"PAK",@"PK",@"POL",@"PL",@"SPM",@"PM",@"PCN",@"PN",@"PRI",@"PR",@"PSE",@"PS",@"PRT",@"PT",@"PLW",@"PW",@"PRY",@"PY",@"QAT",@"QA",@"REU",@"RE",@"ROU",@"RO",@"SRB",@"RS",@"RUS",@"RU",@"RWA",@"RW",@"SAU",@"SA",@"SLB",@"SB",@"SYC",@"SC",@"SDN",@"SD",@"SSD",@"SS",@"SWE",@"SE",@"SGP",@"SG",@"SHN",@"SH",@"SVN",@"SI",@"SJM",@"SJ",@"SVK",@"SK",@"SLE",@"SL",@"SMR",@"SM",@"SEN",@"SN",@"SOM",@"SO",@"SUR",@"SR",@"STP",@"ST",@"SLV",@"SV",@"SXM",@"SX",@"SYR",@"SY",@"SWZ",@"SZ",@"TCA",@"TC",@"TCD",@"TD",@"ATF",@"TF",@"TGO",@"TG",@"THA",@"TH",@"TJK",@"TJ",@"TKL",@"TK",@"TLS",@"TL",@"TKM",@"TM",@"TUN",@"TN",@"TON",@"TO",@"TUR",@"TR",@"TTO",@"TT",@"TUV",@"TV",@"TWN",@"TW",@"TZA",@"TZ",@"UKR",@"UA",@"UGA",@"UG",@"UMI",@"UM",@"USA",@"US",@"URY",@"UY",@"UZB",@"UZ",@"VAT",@"VA",@"VCT",@"VC",@"VEN",@"VE",@"VGB",@"VG",@"VIR",@"VI",@"VNM",@"VN",@"VUT",@"VU",@"WLF",@"WF",@"WSM",@"WS",@"YEM",@"YE",@"MYT",@"YT",@"ZAF",@"ZA",@"ZMB",@"ZM",@"ZWE",@"ZW",@"SCG",@"CS",@"ANT",@"AN",nil ];
    }
    return _countryCodeDictionary;
}

#pragma mark -  Overridden methods to make class singleton

- (void)dealloc
{
    self.latitude = nil;
    self.longitude = nil;
}

@end


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation NSMutableDictionary (SafeMutableDictionary)
-(void)setObjectSafely:(id)anObject forKey:(id<NSCopying>)aKey{
    
    if(anObject){
        
        if(!([anObject isKindOfClass:[NSArray class]] && [anObject count]==0)){
            
            [self setObject:anObject forKey:aKey];
            
        }
    }
}

-(void)replaceKey:(NSString *)oldKey withKey:(NSString *)newKey{
    
    id objectForOldKey = [self objectForKey:oldKey];
    [self setObjectSafely:objectForOldKey forKey:newKey];
    [self removeObjectForKey:oldKey];
    
}

-(id)popObjetForKey:(NSString *)key{
    
    id obj = [self objectForKey:key];
    [self removeObjectForKey:key];
    return obj;
}
@end





