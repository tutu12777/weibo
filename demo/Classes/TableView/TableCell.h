//
//  TableCell.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-27.
//
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell{
    BOOL isLoading;
    NSString *showStatus;//显示加载状态 
    UIImageView *LoadImage;//
    UIActivityIndicatorView *activity;
}
@property(nonatomic, retain)NSString *showStatus;
@property(nonatomic, assign)BOOL isLoading;

- (void)LoadMoreAction;
- (void)cancelLoading;

@end


