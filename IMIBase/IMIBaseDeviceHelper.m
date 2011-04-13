//
//  IMIBaseDeviceHelper.m
//  IMIKit
//
//  Created by Travis on 09-8-7.
//  Copyright 2009 imi.im All rights reserved.
//


#import "IMIBase/IMIBaseDeviceHelper.h"
#import "IMIBase/IMIBaseAppHelper.h"
#import <QuartzCore/QuartzCore.h>
//Memory
#include <sys/sysctl.h>  
#include <mach/mach.h>

//IP
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation UIDevice(IMIBase)

+(double)availableMemory{
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
	
	if(kernReturn != KERN_SUCCESS) 
		return NSNotFound;
	
	return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}
+(BOOL)isLandscape{
	if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
		return YES;
	}
	return NO;
}
+(UIImage*)screenShot{
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	UIGraphicsBeginImageContext(screenRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx , screenRect);
	
	UIApplication * app = [UIApplication sharedApplication];
	UIWindow * win = [app keyWindow];
	[win.layer renderInContext:ctx];
	CGContextFlush(ctx);
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return img;
}
+(CGSize)screenSize{
	CGSize s=[UIScreen mainScreen].bounds.size;
	CGSize ret=s;
	if ([UIDevice isLandscape]) {
		ret=CGSizeMake(s.height, s.width);
	}
	IMILog(@"ScreenSize: %@",NSStringFromCGSize(ret));
	return ret;
}
+(NSString*)trackInformation{
	NSString *versionString=[UIApplication versionString];
	
	NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
	NSString *appName=[info objectForKey:@"CFBundleIdentifier"];
	
	NSString *ret=[NSString stringWithFormat:@"Name:%@\nVersion:%@\nModel:%@\nOSVersion:%@\nUDID:%@\nFreeMem:%.3fMB",
				   appName,
				   versionString,
				   [[UIDevice currentDevice] model],
				   [[UIDevice currentDevice] systemVersion],
				   [[UIDevice currentDevice] uniqueIdentifier],
				   [UIDevice availableMemory]
				];
	
	
	ret=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%.3f",
		 appName,
		 versionString,
		 [[UIDevice currentDevice] model],
		 [[UIDevice currentDevice] systemVersion],
		 [[UIDevice currentDevice] uniqueIdentifier],
		 [UIDevice availableMemory]
		];
	
	return ret;
}

+(NSString*)WIFIAddress{
	NSString *address=nil ;
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				NSString *ifa=[NSString stringWithUTF8String:temp_addr->ifa_name];
				if([ifa isEqualToString:@"en0"])
				{
					// Get NSString from C String
					
#if TARGET_IPHONE_SIMULATOR 
#else
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
#endif
				}else if([ifa isEqualToString:@"en1"]){
					
#if TARGET_IPHONE_SIMULATOR 
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
#endif
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

+(BOOL)isWIFIConnected{
	return [UIDevice WIFIAddress]!=nil;
}

+(BOOL)isBackgroundSupported{
	return [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)];
}

+(BOOL)isIPad{
	NSString *ver=[UIDevice currentDevice].model;
	return [ver rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location!=NSNotFound;
}

+(NSUInteger)installedAppsCount{
	NSString *folder=[[[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
	NSArray *items=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:NULL];
	return items.count;
}
@end

