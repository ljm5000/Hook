//
//  JMHook.h
//  JMHook
//
//  Created by jimmy on 2019/12/16.
//  Copyright © 2019 com.jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 通过 +(load) 来对 MTLIOAccelResource 的 initWithDevice:options:args:argsSize: 方法交换
 */
@interface JMHook : NSObject

@end

@interface _MMTLIOAccelResource : NSObject

-(id)exchangeInitWithDevice:(id)arg1 options:(unsigned long long)arg2 args:(void *)arg3 argsSize:(unsigned)arg4;
@end

