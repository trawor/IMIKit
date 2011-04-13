/*
 *  IMIBaseDeviceHelper.h
 *  IMIBase
 *
 *  Created by Travis on 09-7-12.
 *  Copyright 2009 imi.im All rights reserved.
 *
 */

/** Thanks to shnhrrsn(UIDeviceHelper)*/
//#import <CoreGraphics/CoreGraphics.h>

#import "IMIBasePrefix.h"
#import <UIKit/UIKit.h>
@interface UIDevice(IMIBase)

/** return a double type number in MB size for the device available memory */
+(double)availableMemory;

/** return a current screen shot, and it must be in size of screen */
+(UIImage*)screenShot;

/** return the device information includes:app name,app version,model,os version,device id, */
+(NSString*)trackInformation;

/** return the device current IP address */
+(NSString*)WIFIAddress;

/** return the device has wifi connection */
+(BOOL)isWIFIConnected;

/** return the device supports multi-task */
+(BOOL)isBackgroundSupported;

/** return the device supports multi-task */
+(BOOL)isLandscape;

/** return the device is iPad or not*/
+(BOOL)isIPad;

+(CGSize)screenSize;

+(NSUInteger)installedAppsCount;
@end

#define SCREEN_WIDTH [UIDevice screenSize].width
#define SCREEN_HEIGHT [UIDevice screenSize].height

#define MEM IMILog(@"%f MEM left",[UIDevice availableMemory])