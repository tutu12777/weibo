//
//  LoadMoreVIew.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-11-27.
//
//

#import "LoadMoreVIew.h"

@implementation LoadMoreVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1014109870bd9c702d.jpg"]];
        [image setFrame:CGRectMake(0, 0, 320, 40)];
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = self.center;
        [self addSubview: activity];
        

    }
    return self;
}

- (void)LoadMoreAction{
    if (![activity isAnimating]) {
        [activity startAnimating];
    }


}

- (void)cancelLoading{
    if ([activity isAnimating]) {
        [activity stopAnimating];
    }
}

- (void)dealloc{
    [activity release];
    activity = nil;
    
    [super dealloc];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
