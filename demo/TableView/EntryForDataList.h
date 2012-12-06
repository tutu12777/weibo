//
//  EntryForDataList.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntryList.h"

#import "WBEngine.h"
#import "WBSendView.h"

typedef enum{
    KRefresh    = 0,
    KLoadmore   = 1,
    KUpdate     =2,
}ERefreshStatus;

@interface EntryForDataList : EntryList<WBEngineDelegate, WBSendViewDelegate>{
    NSString *appKey;
    NSString *appSecret;
    
    WBEngine *engine;
//    NSMutableArray *timeLine;
    BOOL isLoading;
    NSNumber *previousId;//最后一个微博id的下一个id
    UIActivityIndicatorView *indicatorView;
}

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;


@end
