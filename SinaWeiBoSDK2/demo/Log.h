//
//  Log.h
//  QQMusic
//
//  Created by Xiaoyi liao on 11-12-8.
//  Copyright (c) 2011年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

// 替代NSLog和写文件，该文件会被上传，如果点击了更多里面的上传
#ifdef __cplusplus
extern "C"
{
#endif
    
    void MyLog(NSString *format, ...);   

#ifdef __cplusplus
}
#endif

@interface Log : NSObject
+(NSString*) getLogFilePath;
+(void)addLog:(NSString*)format argList:(va_list)argList;
//+(NSData*) getUploadData:(long)iMaxSize needGZip:(BOOL)isNeedGZip;
+(pthread_mutex_t*) getFileMutex;
@end
