/*
 *  IMIBaseAppHelper.h
 *  IMIBase
 *
 *  Created by Travis on 09-7-12.
 *  Copyright 2009 imi.im All rights reserved.
 *
 */
#import "IMIBasePrefix.h"

#import <UIKit/UIKit.h>

IMIExtend IMIEventSystemError;
IMIExtend IMIEventNewVersion;

@interface UIApplication (IMIBase)<UIAlertViewDelegate>


/** return the main UIWindow of the application */
@property(nonatomic,readonly) UIWindow *mainWindow;
@property(nonatomic,readonly) NSString *storeURL;
@property(nonatomic,readonly) NSInteger runCount;
@property(nonatomic,readonly) NSInteger quitCount;
@property(nonatomic,readonly) BOOL hasCrashOfLastRunning;
@property(nonatomic,readonly) BOOL isCracked;

void IMIAlert(NSString *title, NSString *msg, NSString *buttonText);

NSInteger IMIRandom(int n);

/** return the full path of file in app install folder
 *	arguments:
 *		name: file name
 *		folder: the folder of file
 */
NSString* ResourceFilePath(NSString* name, NSString* folder);

/** return the full path of file in app bundle folder
 *	arguments:
 *		name: file name
 *		folder: the folder of file
 */
NSString* BundledFilePath(NSString* name, NSString* bundleName);

/** return the full path of file in app documents folder
 *	arguments:
 *		name: file name 
 *		folder: the folder of file
 */
NSString* DataFilePath(NSString* name, NSString* folder);

/** return the full path of file in app cache folder
 *	arguments:
 *		name: file name 
 *		folder: the folder of file
 */
NSString* CachedFilePath(NSString* name, NSString* folder);

/** return the full path of file in app tmp folder
 *	arguments:
 *		name: file name 
 *		folder: the folder of file
 */
NSString* TempFilePath(NSString* name, NSString* folder);

/** return the full path of file is exist
 *	arguments:
 *		name: file full path
 */
BOOL FileExistAt(NSString *filepath);

/** return app distribute Type,eg:AdHoc,Debug,'App Store'...,default is 'App Store'*/
+ (NSString *)distributeType;

/** return app version as nsstring */
+ (NSString*) versionString;
+ (float) versionNumber;

/** show current project version number on screen */
+ (void) showVersion;

/** return app main bundle path as nsstring */
+ (NSString*) appDir;

/** return app documents folder path as nsstring */
+ (NSString*) docDir;

/** return app cache folder path as nsstring */
+ (NSString*) cacheDir;

/** alert the string in debug mode or send the string with Device information to server */
+(void)throwError:(NSString*)errorString;

-(void)checkUpdate;
-(NSString*)storeURL;
@end

#define AppSetting [NSUserDefaults standardUserDefaults]
#define AppDir [UIApplication appDir]
#define DocDir [UIApplication docDir]

IMIDefine void IMIAssert(BOOL flag, NSString *errorString){
	if (flag){
#ifdef DEBUG
		[UIApplication throwError:errorString];
#else
		//TODO: save error to server [UIApplication sumbitError:errorSting];
#endif	
	}
}

#ifdef DEBUG
	#define IMIVersion [UIApplication showVersion]
#else
	#define IMIVersion
#endif	
