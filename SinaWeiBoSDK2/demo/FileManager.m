//
//  FileManager.m
//  adTest
//
//  Created by chen on 12-11-12.
//
//

#import "FileManager.h"
#include "sys/stat.h"

@implementation FileManager

+(NSString *) getTempRadioDirPath{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    return documentsDirectory;
}

+(BOOL)fileIsExistWithPath:(NSString *)filePath{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (fileExists) {
        return true;
    }else{
        return false;
    }
}

+(void)createFileWithPath:(NSString *)filePath{

    NSMutableData  *writer = [[NSMutableData alloc] init];
    [writer appendData:nil];
    [writer writeToFile:filePath atomically:YES];
    [writer release];
    
}


+ (long) getFileSizeWithPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

+ (void)deleteFileWithPath:(NSString*) filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

//+ (void)deleteFileWithPath:(NSString*) filePath{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:filePath error:nil];
//}


+(void)moveFile:(NSString*)file ToNewFile:(NSString*)newFile
{
    // 如果新旧文件地址非法，或者源文件根本不存在，直接返回
    if (file == nil || newFile == nil || ![self fileIsExistWithPath:file]) {
        return;
    }
     NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager moveItemAtPath:file toPath:newFile error:nil];
}





@end
