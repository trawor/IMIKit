//
//  IMIKitAppDelegate.m
//  IMIKit
//
//  Created by Travis on 11-4-13.
//  Copyright imi.im 2009-2011. All rights reserved.
//	More Information: http://imi.im


#import "IMIKitAppDelegate.h"
#import "TestC.h"
@implementation IMIKitAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSLog(@"Start!");
    TestC *tc= [TestC new];
    
    UINavigationController *nvc=[[UINavigationController alloc] initWithRootViewController:[tc autorelease]];
    
    [window addSubview:nvc.view];
    
    window.backgroundColor=[UIColor grayColor];
    [window makeKeyAndVisible];
    
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [self applicationWillTerminate:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
-(void)applicationDidEnterBackground:(UIApplication *)application{
	[self applicationWillTerminate:application];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
