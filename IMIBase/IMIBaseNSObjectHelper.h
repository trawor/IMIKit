//
//  IMIBaseNSObjectHelper.h
//  IMIBase
//
//  Created by Travis on 09-7-13.
//	Copyright 2009 imi.im All rights reserved.
//

#import <Foundation/Foundation.h>

//there is no className method on iPhone Device so I do it
@interface NSObject(IMIBase)

+ (NSString *)className;
- (NSString *)className;

@end

#pragma mark UIColor

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define NSRangeMake(s,l) NSMakeRange(s,l)

@interface NSArray(IMIBase)
@property (nonatomic,readonly) NSUInteger count;
@end
