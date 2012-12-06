//
//  EntryList.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntryList.h"
#import "EntryViewCell.h"
#import "UIImageView+WebCache.h"
#import "LoadMoreVIew.h"
#import "TableCell.h"
#import "WbGlobal.h"

#define DEFAULT_HEIGHT 60
#define Default_LoadMore_Rect CGRectMake(0, 0, 320, 40)//加载更多的默认尺寸

@interface EntryList ()

- (void) doElseThing;

@end

@implementation EntryList
@synthesize Lastcell = _Lastcell;
@synthesize entries = _entries;
@synthesize tableView = _tableView;
@synthesize pullToRefreshView = _pullToRefreshView;


#pragma mark -default-Funciton

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [[self view] addSubview:_tableView];

    Lastcell = nil;
    [self doElseThing];
	// Do any additional setup after loading the view.
}



//view加载时，可以在这里加载默认数据
- (void) doElseThing{
    return;//viewDidLoda 没有做完的事情
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    WBSafeRelese(pullToRefreshView);
    WBSafeRelese(_tableView);
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -TableView Delegate

//请求数据插入cell
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s===%d",__FUNCTION__,__LINE__);
    if ([indexPath section] == 0) {

        NSDictionary *dataCell = [self entryAtIndexPath:indexPath];

        NSString *cellString =  [NSString stringWithFormat:@"Cell"];
        if (!dataCell) {
            cellString = @"lastCell";
            TableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
            if (cell == nil) {
                cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
                Lastcell = cell;
//                [Lastcell LoadMoreAction];
            }else{
                Lastcell = cell;
            }
            
            return cell;
        
        }else{
            TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
            if (cell == nil) {
                cell = [[[[[self class] cellClass] alloc]initWithReuseIdentifier:cellString] autorelease];
            }
            [self configureCell:cell forEntry:dataCell];
            return cell;
        }

    }
    return nil;
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    
    return 1;
}


- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = [self entryAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self cellSelected:cell forEntry:entry];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = [self entryAtIndexPath:indexPath];
    if (entry) {
        return [self cellHeightForEntry:entry];
    }else{
        return DEFAULT_HEIGHT;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        NSLog(@"numberOfRowsInSection====%d",[entries count]);
        return ([entries count]+1 );
    } else {
        return 1;
    }
    
}

// 通过索引路径返回条目
- (NSDictionary *)entryAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] < [entries count]) {
        return [entries objectAtIndex:[indexPath row]];

    }
    return nil;
    
}

//通过entry返回索引路径
- (NSIndexPath *)indexPathOfEntry:(NSDictionary *)entry{

    return [NSIndexPath indexPathForRow:[entries indexOfObject:entry] inSection:0];
    
}

+ (Class)cellClass{
    return [EntryViewCell class];
}


- (CGFloat)cellHeightForEntry:(NSDictionary *)entry{
    return 0.0f;
}


- (void)configureCell:(UITableViewCell *)cell forEntry:(NSDictionary *)entry{
    
//    EntryViewCell *cell_ = (EntryViewCell *) cell;
//    [cell_ setEntry:entry];
}

//选中后需要修改的函数
- (void)cellSelected:(UITableViewCell *)cell forEntry:(NSDictionary *)entry{

    return;
}


- (void)deselectWithAnimation:(BOOL)animated{
    //判断iphone 还是ipad
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    
}


@end
