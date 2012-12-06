//
//  WeiBoDetailController.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-30.
//
//

#import <UIKit/UIKit.h>
@class WeiBoDetailView;

@interface WeiBoDetailController : UIViewController{
    NSString         *user;
    NSString         *imageUrl;
    UITableView      *tableView;
    WeiBoDetailView  *detailView;
/*
 
 
 
 
*/
    
}
@property (nonatomic, retain)WeiBoDetailView  *detailView;

@end
