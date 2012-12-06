//
//  EntryForDataList.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntryForDataList.h"

#import "EntryViewCell.h"
#import "LoadMoreVIew.h"
#import "TableCell.h"

@interface EntryForDataList (Private)

- (void)refreshTimeline:(ERefreshStatus)status;

@end

@implementation EntryForDataList


- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    if (self = [super init])
    {
        appKey = [theAppKey retain];
        appSecret = [theAppSecret retain];
        
        engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
        [engine setDelegate:self];
        point = CGPointMake(0, 0);
        entries = [[NSMutableArray alloc] init];
        previousId = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoading = NO;
    
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
    
    pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:tableView];
    [tableView addSubview:pullToRefreshView];
    [pullToRefreshView setDelegate:self];

//    [self doElseThing];
	// Do any additional setup after loading the view.
}

- (void) doElseThing{
    [self refreshTimeline:KRefresh];
}



#pragma mark- CEll SETTING
+ (Class)cellClass {

    return [EntryViewCell class];
}

- (CGFloat)cellHeightForEntry:(NSDictionary *)entry {
    
    return [EntryViewCell heightForEntry:entry withWidth:[[self view] bounds].size.width];
    
}


//需要显示的cell
- (void)configureCell:(UITableViewCell *)cell forEntry:(NSDictionary *)entry {
    EntryViewCell *cell_ = (EntryViewCell *) cell;
    NSString *str = [entry objectForKey:@"text"];
    NSLog(@"%s=%d==%@",__FUNCTION__, __LINE__,str);
    
    [cell_ setEntrys:entry];

    
//    [tableView reloadData];
}

- (void)cellSelected:(UITableViewCell *)cell forEntry:(NSDictionary *)entry {
//    EntryForDataList *controller = [[EntryForDataList alloc] initWithSource:entry];
//    [[self navigationController] pushController:[controller autorelease] animated:YES];
}


- (NSUInteger)getStatus{
    if ([engine.request.params objectForKey:@"since_id"]) {
        return 1;
    }else if ([engine.request.params objectForKey:@"max_id"]){
        return -1;
    }
    return 0;
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    
    NSLog(@"requestDidSucceedWithResult: %@", result);
    if ([result isKindOfClass:[NSDictionary class]])
    {
         NSDictionary *dict = (NSDictionary *)result;
 
        if (![entries count]) {
            NSLog(@"%s==1=%d",__FUNCTION__,[entries count]);
            [entries addObjectsFromArray:[dict objectForKey:@"statuses"]];
            previousId = [[dict objectForKey:@"next_cursor"]retain];
        }else{
            
            
//            NSUInteger status = [self getStatus:[dict objectForKey:@"statuses"]];
            NSUInteger status = [self getStatus];
            if (status == 1) {
                NSMutableArray *templeArray = [dict objectForKey:@"statuses"];
                NSLog(@"%s==2=%d",__FUNCTION__,[entries count]);
                for (NSUInteger index = 0; index < [templeArray count]; index++) {
                    [entries insertObject:[templeArray objectAtIndex:index] atIndex:index];
                }
              
                [pullToRefreshView finishedLoading];
            }else if (status == -1){

                [entries addObjectsFromArray:[dict objectForKey:@"statuses"]];
                [Lastcell cancelLoading];
                [previousId release]; previousId = nil;
                previousId =[[dict objectForKey:@"next_cursor"] retain];
            }

        }
        [tableView reloadData];
    }
    
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    
    NSUInteger status = [self getStatus];
    if (status == 1) {
         [pullToRefreshView finishedLoading];
    }else if( status == -1){
         [Lastcell cancelLoading];
    }
    
    
    
    NSLog(@"%s: %@",__FUNCTION__, error);
}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refreshTimeline:KUpdate];
}


- (void)deselectWithAnimation:(BOOL)animated {
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [super deselectWithAnimation:animated];
    }
}



- (void)refreshTimeline:(ERefreshStatus)status
{
    NSMutableDictionary *parament = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"5",@"count", nil];
    switch (status) {
        case KLoadmore:{
            if ([entries count]) {
                NSLog(@"refreshTimeline===kloadmore");
                if (previousId) {
                    NSLog(@"KLoadmore==%@",[ previousId stringValue]);
                    NSString *string = [ previousId stringValue];
                    [parament setValue:string forKey:@"max_id"];
                }
            }
        }   
            break;
        case KUpdate:{
            if ([entries count]) {
                NSDictionary *cell = [entries objectAtIndex:(0)];
                NSNumber *number = [cell objectForKey:@"id"]; 
                NSString *string = [number stringValue];
                [parament setValue:string forKey:@"since_id"];
                NSLog(@"cell object of key =KUpdate=%@",string);
            }
        }
            break;
        case KRefresh:
        default:
            break;
    }
    

    NSLog(@"%s=-since==%@=%d",__FUNCTION__,[parament objectForKey:@"since_id"],[parament count]);
    

    
    
    [engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:parament
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return self.tableView.tableFooterView;
//}
#pragma  mark uiscrollview
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSLog(@"%s==contentOffset.y==%f=contentSize.height=%f=size.height=%f",__FUNCTION__,
          scrollView.contentOffset.y,scrollView.contentSize.height,scrollView.frame.size.height);
    
    if(!isLoading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        self.tableView.tableFooterView.hidden = NO;
        LoadMoreVIew *loadView = (LoadMoreVIew *)self.tableView.tableFooterView;
        [loadView LoadMoreAction];

        if (Lastcell) {
            [Lastcell LoadMoreAction];
            self.Lastcell.showStatus = @"正在加载更多";
            NSLog(@"scrollViewDidEndDragging=== %@",self.Lastcell.showStatus);
            [Lastcell setNeedsDisplay];
            [self refreshTimeline:KLoadmore];
        }
    }else{
        self.tableView.tableFooterView.hidden = YES;
//        point =scrollView.contentOffset;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	point =scrollView.contentOffset;
}


@end
