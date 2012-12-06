//
//  WeiBoManager.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-30.
//
//

#import "WeiBoManager.h"
static WeiBoManager *instance;

@implementation WeiBoManager
@synthesize entries = _entries;

- (id)init{
    if (self = [super init]) {
        _entries = [[NSMutableArray alloc] init];
    }
    return self;

}

- (void)dealloc{
    
    [super dealloc];
}


+ (id)shareWeiBoManagere{
    @synchronized(self){
        if(self == nil){
            self = [[self alloc] init];
        }
        
    }
    return self;
    
}



@end
