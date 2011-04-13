//
//  IMIBaseNSStringHelper.m
//  IMIBase
//
//  Created by Travis on 09-7-12.
//  Copyright 2009 imi.im All rights reserved.
//
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "IMIBaseNSStringHelper.h"
#import "GTMBase64.h"
#import "IMIBaseAppHelper.h"
@implementation NSString (IMIBase)

NSString* IMILocalizedString(NSString* key){
	NSBundle *baseBundle=[NSBundle bundleWithPath:ResourceFilePath(nil,@"IMIResources.bundle")];
	NSString *ret=[baseBundle localizedStringForKey:key value:key table:@"Base"];
	
	return ret;
}
NSString* IMIBundledString(NSString* key, NSString *languageCode){
	NSBundle *baseBundle=[NSBundle bundleWithPath:ResourceFilePath(nil,@"IMIResources.bundle")];
	NSString *sfile=[baseBundle pathForResource:@"Base" ofType:@"strings" inDirectory:nil forLocalization:languageCode];
	NSDictionary *linfo=[NSDictionary dictionaryWithContentsOfFile:sfile];
	NSString *ret=[linfo objectForKey:key];
	if (ret==nil) {
		ret=key;
	}
	return ret;
}
+ (NSString *) stringWithUUID
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    return [uuidString autorelease];
}
+ (NSString *) timestamp{
	return [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
}
-(NSString *)SHA1WithSecret:(NSString *)inSecret{
	NSData *secretData = [inSecret dataUsingEncoding:NSUTF8StringEncoding];
	NSData *textData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	
	CCHmacContext hmacContext;
	bzero(&hmacContext, sizeof(CCHmacContext));
    CCHmacInit(&hmacContext, kCCHmacAlgSHA1, secretData.bytes, secretData.length);
    CCHmacUpdate(&hmacContext, textData.bytes, textData.length);
    CCHmacFinal(&hmacContext, result);
	
	
	NSString *s = [NSString  stringWithFormat:
				   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
				   result[0], result[1], result[2], result[3], result[4],
				   result[5], result[6], result[7],
				   result[8], result[9], result[10], result[11], result[12],
				   result[13], result[14], result[15],
				   result[16], result[17], result[18], result[19]
				   ];
	return [[s lowercaseString] base64];
}
- (NSString *) MD5{
	const char* string = [self UTF8String];
	unsigned char result[16];
	CC_MD5(string, strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
					  result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
	
	return [hash lowercaseString];
}

+ (NSString *) MD5OfFile:(NSString*)path
{
	NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
	if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
	
	CC_MD5_CTX md5;
	
	CC_MD5_Init(&md5);
	
	BOOL done = NO;
	while(!done)
	{
		NSData* fileData = [handle readDataOfLength: 3000 ];
		CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
		if( [fileData length] == 0 ) done = YES;
	}
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0], digest[1], 
				   digest[2], digest[3],
				   digest[4], digest[5],
				   digest[6], digest[7],
				   digest[8], digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return s;
}


-(NSString*)URLEncodeString{
	NSMutableString *result = [NSMutableString string];
	const char *p = [self UTF8String];
	unsigned char c;
	
	for(; c = *p; p++)
	{
		switch(c)
		{
			case '0' ... '9':
			case 'A' ... 'Z':
			case 'a' ... 'z':
			case '.':
			case '-':
			case '~':
			case '_':
				[result appendFormat:@"%c", c];
				break;
			default:
				[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

- (NSString *) plainString
{
	NSString *result = self;
	
	if (![self isEqualToString:@""])	// if empty string, don't do this!  You get junk.
	{
		IMIToDo(@"this does NOT work now!");
	}
	return result;
}

- (NSString *) base64{
	return [self encodeToBase64];
}
- (NSString *) encodeToBase64{
	NSString *r=[GTMBase64 stringByEncodingData:[NSData dataWithBytes:[self UTF8String] 
															   length:strlen([self UTF8String])]];
	return r;
}

- (NSString *) decodeFromBase64{
	NSString *r;
	if(self!=@""){
		NSData *data=[GTMBase64 decodeData:[NSData dataWithBytes:[self UTF8String] 
														  length:strlen([self UTF8String])]];
		r=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	}else {
		r=@"";
	}
	return r;
}

- (NSString *)trimWhitespace
{
	NSMutableString *mStr = [self mutableCopy];
	CFStringTrimWhitespace((CFMutableStringRef)mStr);
	
	NSString *result = [mStr copy];
	
	[mStr release];
	return [result autorelease];
}
#pragma mark CGPoint

- (CGPoint) toCGPoint{
	CGPoint p;
	
    NSArray *a=[self componentsSeparatedByString:@","];
	p.x=[[a objectAtIndex:0] floatValue];
	p.y=[[a objectAtIndex:1] floatValue];
	
    return p;
}

#pragma mark CGSize

- (CGSize) toCGSize{
	CGSize p;
	
    NSArray *a=[self componentsSeparatedByString:@","];
	p.width=[[a objectAtIndex:0] floatValue];
	p.height=[[a objectAtIndex:1] floatValue];
	
    return p;
}

#pragma mark Date
- (NSDate*) toNSDate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [formatter dateFromString:self];
    [formatter release];
    return date;
}

#pragma mark File
//make sure the string self is a file path!
//return file name without extention, eg: I'm Sorry
- (NSString*)fileName{
	return [[self lastPathComponent] stringByDeletingPathExtension];
}
//return file extention, eg: mp3,caf,png...
- (NSString*)fileType{
	return [self pathExtension];
}
//return file's parent folder, eg: /tmp/ab/
- (NSString*)fileParentFolder{
	return [self stringByDeletingPathExtension];
}
@end


@implementation NSDate(IMIBase)

-(NSString*)stringWithDateFormat:(NSString*)format{
	NSString *ret=nil;
	if (format!=nil) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:format];
		
		ret=[formatter stringFromDate:self];
		[formatter release];
	}
	
	return ret;
}

@end

@implementation NSData(IMIBase)
- (NSData *)DESEncryptWithKey:(NSString *)key forData:(NSData*)data encode:(BOOL)flag{
    char keyPtr[kCCKeySizeDES + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
    NSUInteger dataLength = [data length];
	
    size_t bufferSize           = dataLength + kCCBlockSizeDES;
    void* buffer                = malloc(bufferSize);
	
	
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(flag?kCCEncrypt:kCCDecrypt,
										  kCCAlgorithmDES, 
										  kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, 
										  kCCKeySizeDES,
                                          NULL,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
	
    if (cryptStatus == kCCSuccess)
    {
		NSData *data=[NSData dataWithBytes:buffer length:numBytesEncrypted];
		free(buffer);
		return data;
    }else {
		IMIDevLog(@"Error Code:%i",cryptStatus);
	}
	
	
    free(buffer);
    return nil;
}
-(NSData*)encryptWithKey:(NSString*)key{
	return [self DESEncryptWithKey:key forData:self encode:YES];
}
-(NSData*)decryptWithKey:(NSString*)key{
	return [self DESEncryptWithKey:key forData:self encode:NO];
}
@end