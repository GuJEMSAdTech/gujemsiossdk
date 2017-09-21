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

- (id)guj_nativeAd {
    return objc_getAssociatedObject(self, @selector(guj_nativeAd));
}

- (void)setGuj_nativeAd:(id)guj_nativeAd {
    objc_setAssociatedObject(self, @selector(guj_nativeAd), guj_nativeAd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
