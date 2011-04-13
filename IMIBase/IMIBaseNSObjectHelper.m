//
//  IMIBaseNSObjectHelper.m
//  IMIBase
//
//  Created by Travis on 09-7-13.
//	Copyright 2009 imi.im All rights reserved.
//

#import "IMIBase/IMIBaseNSObjectHelper.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject(IMIBase)

#if (TARGET_OS_IPHONE)
- (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}
+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}
#endif

@end


