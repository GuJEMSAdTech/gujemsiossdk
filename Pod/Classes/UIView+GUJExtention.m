//
//  UIView+GUJExtention.m
//  Pods
//
//  
//
//

#import <objc/runtime.h>
#import "UIView+GUJExtention.h"

@implementation UIView (GUJExtention)

- (id)nativeAd {
    return objc_getAssociatedObject(self, @selector(nativeAd));
}

- (void)setNativeAd:(id)nativeAd {
    objc_setAssociatedObject(self, @selector(nativeAd), nativeAd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
