//
//  IMIBaseAppHelper.m
//  IMIKit
//
//  Created by Travis on 09-8-10.
//  Copyright 2009 imi.im  All rights reserved.
//

#import "IMIBase/IMIBase.h"

IMIConst IMIEventSystemError	=@"IMIEventSystemError";
IMIConst IMIEventNewVersion		=@"IMIEventNewVersion";
@protocol UIApplicationDelegate_IMIBase
//return the main window
-(UIWindow*)window;

@end

@implementation UIApplication (IMIBase)
IMIConst kIMIRunCount	=@"IMIRunCount"; 
IMIConst kIMIQuitCount	=@"IMIQuitCount"; 

static UILabel *versionLabel=nil;

void IMIAlert(NSString *title, NSString *msg, NSString *buttonText){
	UIAlertView *av=[[UIAlertView alloc] initWithTitle:title
											   message:msg 
											  delegate:nil 
									 cancelButtonTitle:buttonText 
									 otherButtonTitles:nil];
	[av show];
	[av autorelease];
}

NSInteger IMIRandom(int n){
	return arc4random()%n;
}

BOOL FileExistAt(NSString *filepath)
{
	if(filepath==nil)return NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

NSString* ResourceFilePath(NSString* name, NSString* folder){
	NSString *folderPath=[AppDir stringByAppendingPathComponent:folder];
	return [folderPath stringByAppendingPathComponent:name];
}
NSString* BundledFilePath(NSString* name, NSString* bundleName){
	NSString *bundleFullName=[NSString stringWithFormat:@"%@.bundle",bundleName];
	
	NSString *filePath=ResourceFilePath(name,bundleFullName);
	return filePath;
}
NSString* DataFilePath(NSString* name, NSString* folder){
	NSString *folderPath=[DocDir stringByAppendingPathComponent:folder];
	return [folderPath stringByAppendingPathComponent:name];
}
NSString* CachedFilePath(NSString* name, NSString* folder){
	NSString *folderPath=[[UIApplication cacheDir] stringByAppendingPathComponent:folder];
	return [folderPath stringByAppendingPathComponent:name];
}
NSString* TempFilePath(NSString* name, NSString* folder){
	NSString *folderPath=[NSTemporaryDirectory() stringByAppendingPathComponent:folder];
	return [folderPath stringByAppendingPathComponent:name];
	
}
+ (NSString*) versionString{
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	
	NSString *mainVersion=[info objectForKey:@"CFBundleVersion"];
	
	
	NSString *versionString=[info objectForKey:@"CFBundleShortVersionString"];
	if([versionString intValue]<=0){
		versionString=mainVersion;
	}	
	
	return versionString;
	
}

+ (float) versionNumber{
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	
	NSString *mainVersion=[info objectForKey:@"CFBundleVersion"];
	return [mainVersion floatValue];
}

+ (NSString *)distributeType{
	NSString *appversion=@"App Store";
#ifdef 	DISTRIBUTE
#if	DISTRIBUTE==1
	appversion=@"Debug";
#elif	DISTRIBUTE==2
	appversion=@"AdHoc";	
#endif
	
#else
	NSString *apppath=ResourceFilePath(@"",nil);
	if ([apppath hasPrefix:@"/Applications"] || 
		[[apppath componentsSeparatedByString:@"-"] count]<5) {
		appversion=@"91助手";
	}
#endif
	return appversion;
}

+ (void) showVersion{
	//get current window
	UIWindow *window=[[UIApplication sharedApplication] mainWindow];
	
	if(versionLabel!=nil){
		[window bringSubviewToFront:versionLabel];
		return;
	}
	NSString *versionString=[AppSetting objectForKey:@"IMIAppVersion"];
	CGSize size=window.frame.size;
	UIFont *font=[UIFont systemFontOfSize:12];
	CGSize tsize=[versionString sizeWithFont:font];
	
	versionLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, size.height-15, tsize.width, tsize.height)];
	versionLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
	versionLabel.text=versionString;
	versionLabel.font=font;
	versionLabel.textColor=[UIColor whiteColor];
	versionLabel.shadowColor=[UIColor blackColor];
	versionLabel.backgroundColor=[UIColor clearColor];
	
	[window insertSubview:versionLabel atIndex:UINT16_MAX];
	[versionLabel release];
}

+ (NSString*) appDir{
	return [[NSBundle mainBundle] resourcePath];
}
+ (NSString*) docDir{
	NSArray	*documentPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [documentPaths  objectAtIndex:0];
}
+ (NSString*) cacheDir{
	NSArray	*documentPaths =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [documentPaths  objectAtIndex:0];
}
+(void)throwError:(NSString*)errorString{
	IMIAlert(IMILocalizedString(@"IMIError"), errorString, IMILocalizedString(@"OK"));
}


+ (id)allocWithZone:(NSZone *)zone{
    id app = [super allocWithZone:zone];
	[[NSNotificationCenter defaultCenter] addObserver:app selector:@selector(onStart) 
												 name:UIApplicationDidFinishLaunchingNotification 
											   object:nil];
	
	return app;
}
#pragma mark -----------------------

- (UIWindow*) mainWindow{
	return [(id<UIApplicationDelegate_IMIBase>)[UIApplication sharedApplication].delegate window];
}

-(NSInteger)runCount{
	return [[AppSetting objectForKey:kIMIRunCount] integerValue];
}
-(void)setRunCount:(NSInteger)c{
	[AppSetting setInteger:c forKey:kIMIRunCount];
	[AppSetting synchronize];
}
-(NSInteger)quitCount{
	return [[AppSetting objectForKey:kIMIQuitCount] integerValue];
}
-(void)setQuitCount:(NSInteger)c{
	[AppSetting setInteger:c forKey:kIMIQuitCount];
	[AppSetting synchronize];
}

- (NSString*) systemErrorPath{
	NSString *path=DataFilePath(@"im.imi.crash", nil);
	if (!FileExistAt(path)) {
		[[NSDictionary dictionary] writeToFile:path atomically:YES];
	}
	return path;
}

-(BOOL)hasCrashOfLastRunning{
	NSInteger c=self.runCount;
	if (c>1) {
		if (c-1>self.quitCount) {
			return YES;
		}
	}
	NSDictionary *errs=[NSDictionary dictionaryWithContentsOfFile:[self systemErrorPath]];
	if ([[errs allKeys] count]>0) {
		return YES;
	}
	return NO;
}

- (void) onStart{
	//[IMICrashReporter shared].handler=(NSObject<IMICrashHandler>*)self.delegate;
	
	if ([AppSetting objectForKey:@"IMIAppVersion"]) {
		
	}else {
		//FirstTime run
		if (FileExistAt(ResourceFilePath(@"Config.plist", nil))) {
			NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:ResourceFilePath(@"Config.plist", nil)];
			for (NSString *key in config) {
				[AppSetting setObject:[config objectForKey:key] forKey:key];
			}
		}
	}

	
	
	
	NSString *m=[UIApplication versionString];
	if (m==nil) {
		m=[NSString stringWithFormat:@"%.2f",[UIApplication versionNumber]];
	}else {
		m=[NSString stringWithFormat:@"%@ (v%.0f)",[UIApplication versionString],[UIApplication versionNumber]];
	}

	[AppSetting setObject:m forKey:@"IMIAppVersion"];
	
	
	[self setRunCount:self.runCount+1];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQuit) 
												 name:UIApplicationWillTerminateNotification 
											   object:nil];
	[AppSetting synchronize];
}
- (void) onQuit{
	[self setQuitCount:self.runCount];
}

-(BOOL)isCracked{
#ifdef DEBUG
	//return NO;
#endif
	
#ifdef ADHOC
	return NO;
#endif
	
	NSDictionary *folderA=[[NSFileManager defaultManager] attributesOfItemAtPath:ResourceFilePath(nil, @"Info.plist") error:NULL];
	NSDate *createI=[folderA objectForKey:NSFileCreationDate];
	NSDate *modifI=[folderA objectForKey:NSFileModificationDate];
	
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	NSString *app=[info objectForKey:(NSString*)kCFBundleExecutableKey];
	folderA=[[NSFileManager defaultManager] attributesOfItemAtPath:ResourceFilePath(nil,app) error:NULL];
	
	NSDate *createE=[folderA objectForKey:NSFileCreationDate];
	NSDate *modifE=[folderA objectForKey:NSFileModificationDate];
	
	
	NSTimeInterval ce=[createE timeIntervalSince1970];
	NSTimeInterval me=[modifE timeIntervalSince1970];
	NSTimeInterval ci=[createI timeIntervalSince1970];
	NSTimeInterval mi=[modifI timeIntervalSince1970];
	if (me-ce>100 || mi-ci>100) {
		IMILog(@"%@",[folderA description]);
		return YES;
	}
	
	return NO;
}

-(NSString*)storeURL{
	NSString *vurl;
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	vurl=[info objectForKey:@"StoreID"];
	if ([vurl length]>4) {
		vurl=[@"http://itunes.apple.com/app/id" stringByAppendingString:vurl];
	}else {
		NSString *appName=[[[[info objectForKey:@"CFBundleIdentifier"] componentsSeparatedByString:@"."]lastObject] lowercaseString];
		vurl=[@"http://app.imi.im/" stringByAppendingString:appName];
	}

	return vurl;
}
-(NSString*)versionURL{
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	NSString *appName=[[[[info objectForKey:@"CFBundleIdentifier"] componentsSeparatedByString:@"."]lastObject] lowercaseString];
	NSString *vurl=[@"http://api.imi.im/version.php?app=" stringByAppendingString:appName];
	return vurl;
}
-(void)checkUpdateInBg{
	NSAutoreleasePool *pool=[NSAutoreleasePool new];
	
	@try {
		BOOL hasNew=NO;
		NSString *string=[NSString stringWithContentsOfURL:[NSURL URLWithString:[self versionURL]] 
												  encoding:NSUTF8StringEncoding error:NULL];
		if (string!=nil && [string length]>0 && [string length]<10) {
			if ([string rangeOfString:@"-"].location!=NSNotFound) {
				[AppSetting setBool:YES forKey:@"IMIDontCheckVersion"];
				
				NSLog(@"Do not need check update forever!");
			}else {
				NSLog(@"CurrentVersion: %@",[UIApplication versionString]);
				NSLog(@"ServerVersion: %@",string);
				hasNew=([string compare:[UIApplication versionString] options:NSNumericSearch]==NSOrderedDescending);
				
			}
			
			
		}
		
		[AppSetting setObject:[NSDate date] forKey:@"IMILastCheckVersionTime"];
		[AppSetting synchronize];
		
		if (hasNew) {
			[self performSelectorOnMainThread:@selector(onGetNewVersion:) withObject:string waitUntilDone:YES];
		}
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
	
	[pool release];
}
-(void)onGetNewVersion:(NSString*)version{
	[self dispatchEvent:[IMIEvent eventWithName:IMIEventNewVersion]];
	BOOL beta=([version compare:@"1.0" options:NSNumericSearch]==NSOrderedAscending);
	//beta=([version rangeOfString:@"b"].location==NSNotFound && beta);
	
	UIAlertView *av;
	if (beta) {
		av=[[UIAlertView alloc] initWithTitle:IMILocalizedString(@"TipVersionTitle")
												   message:[NSString stringWithFormat:@"%@\n%@: %@",IMILocalizedString(@"TipVersionMSG"),IMILocalizedString(@"Version"),version] 
												  delegate:self 
										 cancelButtonTitle:nil
										 otherButtonTitles:IMILocalizedString(@"TipVersionCancel"),nil];
	}else {
#ifdef FORCE_UPDATE
		av=[[UIAlertView alloc] initWithTitle:IMILocalizedString(@"TipVersionTitle")
									  message:[NSString stringWithFormat:@"%@\n%@: %@",IMILocalizedString(@"TipVersionMSG"),IMILocalizedString(@"Version"),version] 
									 delegate:self 
							cancelButtonTitle:nil
							otherButtonTitles:IMILocalizedString(@"TipVersionNow"),nil];
#else
		av=[[UIAlertView alloc] initWithTitle:IMILocalizedString(@"TipVersionTitle")
									  message:[NSString stringWithFormat:@"%@\n%@: %@",IMILocalizedString(@"TipVersionMSG"),IMILocalizedString(@"Version"),version] 
									 delegate:self 
							cancelButtonTitle:nil
							otherButtonTitles:IMILocalizedString(@"TipVersionCancel"),IMILocalizedString(@"TipVersionNow"),nil];
#endif
		
	}

	av.tag=99;
	[av show];
	[av autorelease];
	
	//IMIAlert(IMILocalizedString(@"TipVersion"),IMILocalizedString(@"TipVersionMSG") , IMILocalizedString(@"OK"));
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag==99) {
		if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:IMILocalizedString(@"TipVersionNow")]) {
			[self openURL:[NSURL URLWithString:[self storeURL]]];
		}
	}
}
-(void)checkUpdate{

#ifdef FORCE_UPDATE
	[self performSelectorInBackground:@selector(checkUpdateInBg) withObject:nil];
	return;
#endif
	
	if (![AppSetting boolForKey:@"IMIDontCheckVersion"]) {
		[self performSelectorInBackground:@selector(checkUpdateInBg) withObject:nil];
	}
}
@end
