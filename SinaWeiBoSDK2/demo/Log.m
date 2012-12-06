
//
//  Log.m
//  QQMusic
//
//  Created by Xiaoyi liao on 11-12-8.
//  Copyright (c) 2011年 Tencent. All rights reserved.
//

#import "Log.h"
//#import "FileHelper.h"
//#import "SetupHelper.h"
//#import "FavorManager.h"
#import "pthread.h"
#import "FileManager.h"


void MyLog(NSString *format, ...)
{    
#ifdef DEBUG
    va_list argList;
    va_start(argList, format);        
    NSLogv(format, argList);
#endif
    
    
//    EnumDebugMode eDebugMode = [SetupHelper getDebugMode];
//    if (eDebugMode == eDebugModeForUser ||  eDebugMode == eDebugModeForDeveloper)
    if (1)
    {
        pthread_mutex_t* pMutex = [Log getFileMutex];
        if (pMutex == NULL)
        {
            return;
        }
        va_list argList2;
        va_start(argList2, format);      
#ifndef DEBUG
        NSLogv(format, argList2);
#endif
        pthread_mutex_lock(pMutex);
        [Log addLog:format argList:argList2];
        pthread_mutex_unlock(pMutex);
        va_end(argList2);
    }

}

@implementation Log

// 如果日志文件太大，则裁剪
+(BOOL) fixLogFile
{
    const NSUInteger iMaxFileSize = 10 * 1024 * 1024; // 10M
    const NSUInteger iMinFileSize = 1 * 1024 * 1024; // 1M
	NSString* strLogFilePath = [Log getLogFilePath];
	if (![FileManager fileIsExistWithPath:strLogFilePath])
	{
		[FileManager createFileWithPath:strLogFilePath];
        return [FileManager fileIsExistWithPath:strLogFilePath];
	}
    
    // 减少检查机会
    static int iWriteCount = 0;
    if (iWriteCount ++ < 1000) 
    {
        return YES;
    }
    iWriteCount = 0;
    
    long iFileSize = [FileManager getFileSizeWithPath:strLogFilePath];
    if (iFileSize < iMaxFileSize)
    {
        return YES;
    }
    else
    {
        // 截取最后的iMinFileSize，预计会卡一下界面
        NSString* strTmpLogFilePath = [NSString stringWithFormat:@"%@.tmp", strLogFilePath];
        [FileManager deleteFileWithPath:strTmpLogFilePath];
        [FileManager createFileWithPath:strTmpLogFilePath];

        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:strLogFilePath];
        NSFileHandle *handleTmp = [NSFileHandle fileHandleForWritingAtPath:strTmpLogFilePath];
        if ((handle != nil) && (handleTmp != nil))
        {
            @try 
            {
                [handle seekToFileOffset:iFileSize - iMinFileSize];
                NSData* dataMin = [handle readDataToEndOfFile]; // 怎么会提供这么好用的函数, :)
                [handleTmp writeData:dataMin];
            }
            @catch (NSException *exception) {
                // DO NOTHING
            }
            @finally {
                @try {
                    [handle closeFile];
                    [handleTmp closeFile];
                }
                @catch (NSException *exception) {
                    // DO NOTHING
                }
            }
            handle = nil;
            handleTmp = nil;
        }
        else
        {
            // 可能其中一个不为空
            [handle closeFile];
            [handleTmp closeFile];
        }
        
        [FileManager deleteFileWithPath:strLogFilePath];
        [FileManager moveFile:strTmpLogFilePath ToNewFile:strLogFilePath];
        [FileManager deleteFileWithPath:strTmpLogFilePath];
        return [FileManager fileIsExistWithPath:strLogFilePath];
    }
}

+(void) addLog:(NSString*)format argList:(va_list)argList
{
    if (format == nil)
    {
        format = @"<null>";
    }
    if ([Log fixLogFile] == NO)
    {
        assert(0 && "FIXME UNEXPECTED ERROR");
        return;
    }
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString* strTime = [formatter stringFromDate:[NSDate date]];
    NSString* log = [NSString stringWithFormat:@"%@:%@\r\n", strTime, [[[NSString alloc] initWithFormat:format arguments:argList] autorelease]];
    NSString* strLogFilePath = [Log getLogFilePath];
	NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:strLogFilePath];
	if(handle)
	{
		[handle seekToEndOfFile];
        @try {
            [handle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
        }
        @catch (NSException *exception) {
            // DO NOTHING
        }
        @finally {
            @try {
                [handle closeFile];
            }
            @catch (NSException *exception) {
                // DO NOTHING
            }
        }
		handle = nil;
	}
}

+(NSString*) getLogFilePath
{
    static NSString* strLogFilePath =  nil;
    if (strLogFilePath == nil)
    {   
        strLogFilePath = [[[FileManager getTempRadioDirPath] stringByAppendingPathComponent:@"log.txt"] retain]; // nerver release
    }
    return strLogFilePath;
}

+(pthread_mutex_t*) getFileMutex
{
    static pthread_mutex_t* pMutex = NULL; // 一直不删除
    
    if (pMutex == NULL) // 给mutex的mutex呢
    {
        pMutex = malloc(sizeof(pthread_mutex_t));
        if (pMutex != NULL)
        {
            pthread_mutex_init(pMutex, NULL);
        }
    }
    return  pMutex;
}

@end
