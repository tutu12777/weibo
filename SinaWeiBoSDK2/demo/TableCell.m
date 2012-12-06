//
//  TableCell.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-27.
//
//

#import "TableCell.h"
#define ClickLoadMore @"点击加载更多"
#define LoadingMore @"正在加载更多"



@implementation TableCell
@synthesize showStatus = _showStatus;
@synthesize isLoading = _isLoading;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        UIView *backgroundView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
        [backgroundView setBackgroundColor:[UIColor grayColor]];
        [backgroundView setAlpha:0.1];
        [self setSelectedBackgroundView:backgroundView];
        [backgroundView release];
        
        _showStatus = [[NSString alloc] initWithString:ClickLoadMore];
        isLoading = NO;
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity setColor:[UIColor grayColor]];
        activity.center = self.center;
        [self addSubview: activity];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setNeedsDisplay];

    // Configure the view for the selected state
}

- (void)dealloc{
    [LoadImage release];
    LoadImage = nil;
    [super dealloc];
}

-(void)drawRect:(CGRect)rect{
    NSLog(@"%s===%@",__FUNCTION__,showStatus);
    [_showStatus drawInRect:rect withFont:[UIFont systemFontOfSize:20.0f] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];

}

- (void)LoadMoreAction{
    NSLog(@"%s",__FUNCTION__);
    if (![activity isAnimating]) {
        _showStatus = LoadingMore;
         NSLog(@"%s==startAnimating",__FUNCTION__);
        if (activity) {
            NSLog(@"zhen");
        }else{
            NSLog(@"jia");
        }
        [activity startAnimating];
    }
}

- (void)cancelLoading{
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
}


@end
