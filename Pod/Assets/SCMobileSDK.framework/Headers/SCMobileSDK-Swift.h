// Generated by Apple Swift version 4.0 effective-3.2 (swiftlang-900.0.65 clang-900.0.37)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_attribute(external_source_symbol)
# define SWIFT_STRINGIFY(str) #str
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name) _Pragma(SWIFT_STRINGIFY(clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in=module_name, generated_declaration))), apply_to=any(function, enum, objc_interface, objc_category, objc_protocol))))
# define SWIFT_MODULE_NAMESPACE_POP _Pragma("clang attribute pop")
#else
# define SWIFT_MODULE_NAMESPACE_PUSH(module_name)
# define SWIFT_MODULE_NAMESPACE_POP
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR __attribute__((enum_extensibility(open)))
# else
#  define SWIFT_ENUM_ATTR
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import Foundation;
@import ObjectiveC;
@import UIKit;
@import WebKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

SWIFT_MODULE_NAMESPACE_PUSH("SCMobileSDK")
@class SCAdViewController;

/// Listener protocol which is informed about state changes from SCAdSDKController
SWIFT_PROTOCOL("_TtP11SCMobileSDK12SCAdListener_")
@protocol SCAdListener
@optional
/// Called when advertisement playback has ended
/// \param controller The parent controller
///
- (void)onEndCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// Called when advertisement playback has started
/// \param controller The parent controller
///
- (void)onStartCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// Called when an emmpty video ad was delivered
/// \param controller The parent controller
///
- (void)onCappedCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// Called when prefetching of data for advertisement has finished
/// \param controller The parent controller
///
- (void)onPrefetchCompleteCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// Called when the advertisement is clicked. You can prevent linking to the
/// advertisers WebSite by catching click events.
/// \param controller The parent controller
///
/// \param targetURL the advertisement url to be opened
///
///
/// returns:
/// true if the given url could be successfully opened
- (BOOL)onClickthruWithController:(SCAdViewController * _Nonnull)controller targetURL:(NSURL * _Nonnull)targetURL SWIFT_WARN_UNUSED_RESULT;
@end


/// Use this class to enable loggings helping you with troubleshooting
/// any kind of errornous behavior of SCMobileSDK
SWIFT_CLASS("_TtC11SCMobileSDK7SCAdLog")
@interface SCAdLog : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@protocol SCAdSequencingDelegate;
@class UIViewController;
@class UIView;

/// Controls the sequence and starting points of multiple videos played
/// by SCAdController. This controller is not automatically started
/// after initialization.
SWIFT_CLASS("_TtC11SCMobileSDK24SCAdSequencingController")
@interface SCAdSequencingController : NSObject <SCAdListener>
/// Set this if you want to get informed about the state of internal SCAdController that
/// this sequencer uses. Usually not needed.
@property (nonatomic, weak) id <SCAdListener> _Nullable sdkDelegate;
/// This delegate needs to be implemented to synchronize your content player
/// with this sequencer. Provides the sequencer with information about the content
/// player state and controls.
@property (nonatomic, weak) id <SCAdSequencingDelegate> _Nullable sequencingDelegate;
/// Default initialization that sets the anchor view and creates an empty sequence map.
/// \param anchor The view the ads will be played in. Use this view for your
/// content video too to create seamless transitions.
///
- (nonnull instancetype)initWithParentViewController:(UIViewController * _Nonnull)parentViewController anchor:(UIView * _Nonnull)anchor OBJC_DESIGNATED_INITIALIZER;
/// Initializes SCAdSequencer with a given sequence map and the anchor
/// view to display the adverts sequence in.
/// \param sequenceMap key value map where the key is position of ad and the value is
/// the url of the ad clip to play
///
/// \param anchor the container view to display the videos in
///
- (nonnull instancetype)initWithParentViewController:(UIViewController * _Nonnull)parentViewController sequenceMap:(NSDictionary<NSNumber *, NSString *> * _Nonnull)sequenceMap anchor:(UIView * _Nonnull)anchor OBJC_DESIGNATED_INITIALIZER;
/// Starts this sequencers udpdate method. From this moment on ad urls from the
/// sequence map will be processed and shown if content player has reached a position
/// of an ad from sequence map.
- (void)start;
/// Pause the sequencer manually. Usually you don’t need to call this as sequencer
/// cares about stopping itself.
- (void)pause;
/// :nodoc:
- (void)onEndCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// :nodoc:
- (void)onStartCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// :nodoc:
- (BOOL)onClickthruWithController:(SCAdViewController * _Nonnull)controller targetURL:(NSURL * _Nonnull)targetURL SWIFT_WARN_UNUSED_RESULT;
/// :nodoc:
- (void)onPrefetchCompleteCallbackWithController:(SCAdViewController * _Nonnull)controller;
/// :nodoc:
- (void)onCappedCallbackWithController:(SCAdViewController * _Nonnull)controller;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end

@class SCAdVariants;

/// Delegate methods that are required to synchronise advertising video clips with
/// clients custom content video player. Through this delegate the sequencing
/// controller will provide information when to start and stop the content video player.
SWIFT_PROTOCOL("_TtP11SCMobileSDK22SCAdSequencingDelegate_")
@protocol SCAdSequencingDelegate
@optional
/// <em>Optional</em>
/// This delegate method is called to provide information about VARIANT videos.
/// These are typically short video jingles that are played before, in between or after your
/// advertising blocks.
/// \param position The position of the advertising block in sequence map to provide
/// VARIANT information for.
///
/// \param controller The target sequencing controller.
///
///
/// returns:
/// The VARIANT object taht carries information about opener, prebumper or closer ad
/// urls. Look up SCAdVariants reference about further information.
- (SCAdVariants * _Nonnull)addVariantsAt:(NSInteger)position controller:(SCAdSequencingController * _Nonnull)controller SWIFT_WARN_UNUSED_RESULT;
@required
/// <em>Required</em>
/// Use this delegate method to provide the current playback position of a content
/// video player to the sequencing controller. When there is an advertising clip for the
/// given position in the sequence map the clip gets started and pauseContentVideoPlayer
/// will be called.
/// \param controller The target sequencing controller
///
///
/// returns:
/// The position of your content video player.
- (NSInteger)getContentVideoPlayerPositionWithController:(SCAdSequencingController * _Nonnull)controller SWIFT_WARN_UNUSED_RESULT;
/// <em>Required</em>
/// Called when the sequencing player wants to play an advertising clip
/// Implement code that causes your content video player to stop.
/// \param controller The target sequencing controller
///
- (void)pauseContentVideoPlayerWithController:(SCAdSequencingController * _Nonnull)controller;
/// <em>Required</em>
/// Called when an advertising clip from sequence stopped. Implement code
/// that causes your content video player to continue.
/// \param controller The target sequencing controller
///
- (void)playContentVideoPlayerWithController:(SCAdSequencingController * _Nonnull)controller;
@end


/// This class holds an opener, closer and/or prebumper for any video.
SWIFT_CLASS("_TtC11SCMobileSDK12SCAdVariants")
@interface SCAdVariants : NSObject
/// Initialize a VARIANT object
/// \param opener url of video played before the advertisement
///
/// \param closer url of video played after the advertisement
///
/// \param prebumper url of video played in between advertising clips
///
- (nonnull instancetype)initWithOpener:(NSString * _Nullable)opener closer:(NSString * _Nullable)closer prebumper:(NSString * _Nullable)prebumper OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
/// Used to build a Variant request from your Variant configuration object.
/// pass Url that your Variant info should be combined with
/// \param adUrl The url you want o decorate with opener, closer or prebumber info
///
- (NSString * _Nonnull)getVariantRequestWith:(NSString * _Nonnull)adURL SWIFT_WARN_UNUSED_RESULT;
@end

@class NSCoder;
@class NSBundle;

/// ViewController that is responsible for playing smartclip advertisement videos.
/// The ViewController utilizes a WKWebView which uses smartclip javascript core code
/// to execute the advertisements.
/// You can set SCDisablePlayerScriptUpdate to YES in your projects plist file if you
/// want to use the javascript player that is part of this bundle. Otherwise the player
/// will be updated automatically.
SWIFT_CLASS("_TtC11SCMobileSDK18SCAdViewController")
@interface SCAdViewController : UIViewController
@property (nonatomic, readonly) BOOL isPaused;
@property (nonatomic, readonly) BOOL hasEnded;
@property (nonatomic, readonly) BOOL isAvailable;
/// This text is shown in the upper left corner of the advertisement view.
@property (nonatomic, copy) NSString * _Nullable headerText;
/// The URL you got from us. Required by SDK to choose customized advertising clips.
/// Please contact us if you have not yet received your ad URL or do not know what that means.
@property (nonatomic, readonly, copy) NSString * _Nullable adURL;
/// The target sdk listener. Set this to get informed by state changes from this controller.
@property (nonatomic, weak) id <SCAdListener> _Nullable listener;
/// Recommended method for initializing SCAdController. Submit a view (anchor) of your layout
/// To define the location where the ad is to be played. Also, you need to pass your adURL
/// Specifies the type of ads and other attributes such as execution order or count.
/// \param anchor the view container the ad video will be displayed in
///
/// \param adUrl the url the ad SDK will use to show the video ads.
///
- (nonnull instancetype)initWithAnchor:(UIView * _Nonnull)anchor adURL:(NSString * _Nonnull)adURL;
/// Initializes an instance of SCAdController
/// <ul>
///   <li>
///     Parameter: adUrl: the url the controller will use to show the video ads.
///   </li>
/// </ul>
- (nonnull instancetype)initWithAdURL:(NSString * _Nonnull)adURL OBJC_DESIGNATED_INITIALIZER;
/// Initializes an instance of SCAdController
/// \param anchor the view container the ad video will be displayed in.
///
- (nonnull instancetype)initWithAnchor:(UIView * _Nonnull)anchor OBJC_DESIGNATED_INITIALIZER;
/// Using this method will cause an assertion
/// :nodoc:
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// The view your ads are displayed in
@property (nonatomic, readonly, strong) UIView * _Nullable anchor;
/// :nodoc:
- (void)viewWillDisappear:(BOOL)animated;
/// :nodoc:
- (void)viewWillAppear:(BOOL)animated;
/// Overwrites the UIViewControllers removeFromParentViewController method.
/// This will additionally remove the ad view from view hierarchy.
- (void)removeFromParentViewController;
/// :nodoc:
- (void)viewDidLoad;
/// :nodoc:
- (void)viewWillLayoutSubviews;
/// :nodoc:
- (void)observeValueForKeyPath:(NSString * _Nullable)keyPath ofObject:(id _Nullable)object change:(NSDictionary<NSKeyValueChangeKey, id> * _Nullable)change context:(void * _Nullable)context;
/// :nodoc:
@property (nonatomic, readonly) BOOL prefersStatusBarHidden;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil SWIFT_UNAVAILABLE;
@end


@interface SCAdViewController (SWIFT_EXTENSION(SCMobileSDK))
/// play / continue with currently set smartclip advertising video
- (void)play;
/// pause with currently set smartclip advertising video
- (void)pause;
@end





SWIFT_MODULE_NAMESPACE_POP
#pragma clang diagnostic pop
