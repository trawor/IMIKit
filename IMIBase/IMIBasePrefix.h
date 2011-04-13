/*
 *  IMIBasePrefix.h
 *  IMIBase
 *
 *  Created by Travis on 09-7-12.
 *  Copyright 2009 imi.im All rights reserved.
 *
 */
#import <Foundation/Foundation.h>

#pragma mark Base

#define REVISION 671

#define IMIDefine static inline
#define IMIExtend extern NSString* const
#define IMIConst NSString* const

#if TARGET_IPHONE_SIMULATOR
	#define IMI_IPHONE_SIMULATOR 1
	#define IMI_IPHONE_DEVICE 0
#else
	#define IMI_IPHONE_SIMULATOR 0
	#define IMI_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR

#ifdef DEBUG

IMIDefine void
FunctionInfo(char* sourceFile, char* functionName, int lineNumber, NSString* format,...){
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	va_list ap;
	NSString *print, *file, *function;
	va_start(ap,format);
	file = [[NSString alloc] initWithBytes: sourceFile length: strlen(sourceFile) encoding: NSUTF8StringEncoding];
	
	function = [NSString stringWithCString: functionName encoding:NSUTF8StringEncoding];
	print = [[NSString alloc] initWithFormat: format arguments: ap];
	va_end(ap);
	NSLog(@"%@:%d %@ >>> %@", [file lastPathComponent], lineNumber, function, print);
	[print release];
	[file release];
	[pool release];
}

	#define IMIDevLog(...) FunctionInfo(__FILE__, (char*)__FUNCTION__, __LINE__, __VA_ARGS__)
	#define IMILog NSLog
	#define IMIToDo(s) IMIDevLog(@"TODO: %@",s)
	#define MARK IMIDevLog(@"----- MARK -----")

#else
	//do not log anything
	#define IMIDevLog(...)
	#define IMILog(...)
	#define IMIToDo(s)
	#define MARK

#endif

