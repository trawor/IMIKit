//
//  IMIBaseEvent.m
//  IMIKit
//
//  Created by Travis on 09-7-28.
//  Copyright 2009 imi.im All rights reserved.
//

#import "IMIBase/IMIBaseEvent.h"

@implementation IMIEvent
@synthesize sender;
@synthesize name,data;

NSString* const  IMIEventStart=@"IMIEventStart";
NSString* const  IMIEventProgress=@"IMIEventProgress";
NSString* const  IMIEventComplete=@"IMIEventComplete";

NSString* const IMIEventError=@"IMIEventError"; 

- (void) dealloc
{
	self.name=nil;
	self.data=nil;

	[super dealloc];
}

-(id)create{
	return self;
}

+(id)event{
	id event=[self alloc];
	return [event autorelease];
}
+(id)eventWithName:(NSString*)iname{
	IMIEvent *event=[self alloc];
	event.name=iname;
	return [event autorelease];
}
-(NSString*)name{
	return name;
}
-(id)object{
	return data;
}
-(id)userInfo{
	return nil;
}

-(NSString*)description{
	NSString *des=[NSString stringWithFormat:@"Event: %@,Sender: %@",
				   self.name,
				   [self.sender description]];
	if (self.data) {
		des=[des stringByAppendingFormat:@",Data: %@",[self.data description]];
	}
	
	return des;
}
@end

@implementation NSObject(EventDispatcher)

-(void)dispatchEvent:(IMIEvent*)event{
	event.sender=self;
	
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc postNotification:event];
}
-(void)listenToEventWithName:(NSString*)ename withFunction:(SEL)func{
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:func name:ename object:nil];
}
-(void)stopListenToEventWithName:(NSString*)ename{
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:ename object:nil];
}

@end