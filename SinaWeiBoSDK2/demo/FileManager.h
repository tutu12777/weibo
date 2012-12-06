//
//  FileManager.h
//  adTest
//
//  Created by chen on 12-11-12.
//
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(NSString *) getTempRadioDirPath;
+(BOOL)fileIsExistWithPath:(NSString *)fileIsExistWithPath;
+(void) createFileWithPath:(NSString *)filePath;
+ (long) getFileSizeWithPath:(NSString*) filePath;
+ (void)deleteFileWithPath:(NSString*) filePath;
+(void)moveFile:(NSString*)file ToNewFile:(NSString*)newFile;
@end
