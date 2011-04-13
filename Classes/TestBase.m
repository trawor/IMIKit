//
//  TestBase.m
//  IMIKit
//
//  Created by Travis Worm on 10-6-7.
//  Copyright 2009-2010 imi.im. All rights reserved.
//

#import "TestBase.h"

@implementation TestBase
- (id) init
{
	self = [super init];
	if (self != nil) {
		
	}
	return self;
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	UIApplication *application=[UIApplication sharedApplication];
	
	//[application checkUpdate];
	if (application.hasCrashOfLastRunning) {
		//--get the Localized string from IMIResources bundle
		//NSString *atitle=IMILocalizedString(@"Warning");
		//NSString *abtn=IMILocalizedString(@"OK");
		
		//--Shortcut to creat an Alert View
		//IMIAlert(atitle, @"The app might crash at last running", abtn);
	}
	
	//--same as NSLog, but this only works fo "Debug" mode
	IMILog(@"%@ is something",[self className]);
	
	//--same as IMILog, but with more info like Class Name, line number of this code
	IMIDevLog(@"%@ is something",[self className]);
	
	
	//--show svn build version at the left-botton corner
	IMIVersion;
	
	//--return the rest memory that you can use, the unit is MB
	[UIDevice availableMemory];
	
	//--log the rest memory that you can use
	MEM;
	
	//----IMIBaseNSStringHelper
	//IMILog(@"%@",@"test".MD5);
	//IMILog(@"%@",@"test".base64);
	
	//--print a todo log that remind you do sth.
	//IMIToDo(@"del this line");
	
	//--date to string with format
	IMILog(@"%@",[[NSDate date] stringWithDateFormat:@"yyyy-MM-dd"]);
	
	//--AppStore link
	IMILog(@"%@",[application storeURL]);
	
	//----IMIEvent
	[self listenToEventWithName:IMIEventComplete withFunction:@selector(onFinish:)];
	
	IMIEvent *e=[IMIEvent eventWithName:IMIEventComplete];
	e.data=@"IMIBase Test Finish!";
	[self dispatchEvent:e];
	
	SCREEN_WIDTH;
	
}
-(void)onFinish:(IMIEvent*)e{
	IMILog(@"%@",[e description]);
}
@end
