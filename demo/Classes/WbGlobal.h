//
//  WbGlobal.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-30.
//
//

#import <Foundation/Foundation.h>


#define WBAutorelease(__v) ([__v autorelease]);
#define WBReturnAutorelease WBAutorelease

#define WBRetain(__v) ([__v retain]);
#define WBReturnRetained WBRetain


#define WBRelease(__v) ([__v release]);
#define WBSafeRelese(__v) ([__v release], __v = nil);
#define WBSuperDealloc [super dealloc];

