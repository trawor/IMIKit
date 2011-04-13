//
//  IMIBaseNSStringHelper.h
//  IMIBase
//
//  Created by Travis on 09-7-12.
//  Copyright 2009 imi.im All rights reserved.
//

#import "IMIBasePrefix.h"

@interface NSString (IMIBase)

NSString* IMILocalizedString(NSString* key);
NSString* IMIBundledString(NSString* key, NSString *languageCode);

//generate a new uuid string
+ (NSString *) stringWithUUID;

//return unix timestamp
+ (NSString *) timestamp;

-(NSString *)SHA1WithSecret:(NSString *)inSecret;
//return the string's md5 value as string
@property(nonatomic,readonly) NSString* MD5;
+ (NSString *) MD5OfFile:(NSString*)path;
//return nsstring without any whitespace
- (NSString *)trimWhitespace;

//return a url encoded string
@property(nonatomic,readonly) NSString* URLEncodeString;

//return plain string from html
@property(nonatomic,readonly) NSString* plainString;

#pragma mark base64
//return the string's base64 value as string
@property(nonatomic,readonly) NSString* base64;
- (NSString *) encodeToBase64;

//decode the string's base64 value as string
- (NSString *) decodeFromBase64;

- (NSDate*) toNSDate;
#pragma mark File
//make sure the string self is a file path!
//return file name without extention, eg: "the big bang"
@property(nonatomic,readonly) NSString* fileName;
- (NSString*)fileName;
//return file extention, eg: mp3,caf,png...
@property(nonatomic,readonly) NSString* fileType;
- (NSString*)fileType;
//return file's parent folder, eg: /tmp/ab/
@property(nonatomic,readonly) NSString* fileParentFolder;
- (NSString*)fileParentFolder;
@end


@interface NSDate(IMIBase)

-(NSString*)stringWithDateFormat:(NSString*)format;

@end

@interface NSData(IMIBase)
-(NSData*)encryptWithKey:(NSString*)key;
-(NSData*)decryptWithKey:(NSString*)key;
@end

