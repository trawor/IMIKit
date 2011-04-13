//
//  IMIBaseEvent.h
//  IMIKit
//
//  Created by Travis on 09-7-28.
//  Copyright 2009 imi.im All rights reserved.
//

/*Holp this is useful for Flash AS Developer*/

#import "IMIBasePrefix.h"

@interface IMIEvent : NSNotification{
	NSNotification *notice;
	
	NSObject *sender;
	NSString *name;
	id data;
}

IMIExtend  IMIEventStart;
IMIExtend  IMIEventProgress;
IMIExtend  IMIEventComplete;

IMIExtend  IMIEventError;

@property(nonatomic,copy) NSString *name;
@property(nonatomic,retain) id data;
@property(nonatomic,assign) NSObject *sender;

+(id)event;
+(id)eventWithName:(NSString*)iname;
@end


@interface NSObject(EventDispatcher)

-(void)dispatchEvent:(IMIEvent*)event;
-(void)listenToEventWithName:(NSString*)ename withFunction:(SEL)func;
-(void)stopListenToEventWithName:(NSString*)ename;
@end