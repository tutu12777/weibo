//
//  LoadMoreVIew.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-27.
//
//

#import <UIKit/UIKit.h>

@interface LoadMoreVIew : UIView{
    UIActivityIndicatorView *activity;
}

- (void)LoadMoreAction;
- (void)cancelLoading;

@end


