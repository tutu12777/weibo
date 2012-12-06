//
//  WeiBoDetailController.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-30.
//
//

#import "WeiBoDetailController.h"
#import "WeiBoDetailView.h"

@interface WeiBoDetailController ()

@end

@implementation WeiBoDetailController
@synthesize detailView = _detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WeiBoDetailView *temp_detailView = [[WeiBoDetailView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    _detailView = temp_detailView;
    [self.view addSubview:_detailView];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
