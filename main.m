//
//  main.m
//  IMIKit
//
//  Created by Travis on 11-4-13.
//  Copyright imi.im 2009-2011. All rights reserved.
//	More Information: http://imi.im


#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"IMIKitAppDelegate");
    [pool release];
    return retVal;
}
