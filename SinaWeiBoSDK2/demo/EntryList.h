//
//  EntryList.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "EGORefreshTableFootView.h"
@class TableCell;
@interface EntryList : UIViewController <UITableViewDelegate, UITableViewDataSource, PullToRefreshViewDelegate>{
    UITableView *tableView;
    NSMutableArray     *entries;
    PullToRefreshView *pullToRefreshView;
    TableCell *Lastcell;
    
    CGPoint point;//判断是上拉还是下拉
}

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)NSMutableArray *entries;
@property (nonatomic, retain)PullToRefreshView *pullToRefreshView;
@property (nonatomic, retain)TableCell *Lastcell;

- (NSDictionary *)entryAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathOfEntry:(NSDictionary *)entry;

+ (Class)cellClass;
- (CGFloat)cellHeightForEntry:(NSDictionary *)entry;
- (void)configureCell:(UITableViewCell *)cell forEntry:(NSDictionary *)entry;
- (void)cellSelected:(UITableViewCell *)cell forEntry:(NSDictionary *)entry;
- (void)deselectWithAnimation:(BOOL)animated;


@end
