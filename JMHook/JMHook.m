//
//  JMHook.m
//  JMHook
//
//  Created by jimmy on 2019/12/16.
//  Copyright © 2019 com.jimmy. All rights reserved.
//

#import "JMHook.h"
#include <objc/objc.h>
#include <objc/runtime.h>
#include <objc/message.h>

@implementation JMHook

@end


@implementation _MMTLIOAccelResource

+ (_MMTLIOAccelResource *)shareInstance{
    
    static _MMTLIOAccelResource *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        
        _sharedInstance = [[_MMTLIOAccelResource alloc] init];
        
    });
    return _sharedInstance;
    
}

+(void)load{
    Method originMethod = class_getInstanceMethod(NSClassFromString(@"MTLIOAccelResource"), NSSelectorFromString(@"initWithDevice:options:args:argsSize:"));
    
    Method swizzlingMethod = class_getInstanceMethod([self class], @selector(exchangeInitWithDevice:options:args:argsSize:));
    
     class_addMethod(NSClassFromString(@"MTLIOAccelResource"), @selector(exchangeInitWithDevice:options:args:argsSize:), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));

    class_addMethod(NSClassFromString(@"MTLIOAccelResource"), NSSelectorFromString(@"initWithDevice:options:args:argsSize:"), method_getImplementation(originMethod), method_getTypeEncoding(swizzlingMethod));

    method_exchangeImplementations(originMethod, swizzlingMethod);
   
}

-(id)exchangeInitWithDevice:(id)arg1 options:(unsigned long long)arg2 args:(void *)arg3 argsSize:(unsigned)arg4
{
    id tmp=  [self exchangeInitWithDevice:arg1 options:arg2 args:arg3 argsSize:arg4];
    
    printf(" %p\n",objc_msgSend(self,  NSSelectorFromString(@"virtualAddress")));
    return tmp;
    
}

@end
