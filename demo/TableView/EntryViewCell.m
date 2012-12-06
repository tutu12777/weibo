//
//  EntryViewCell.m
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#pragma mark Constants - Configure look/feel

// BOX GEOMETRY

//Height/width of the actual arrow
#define kArrowHeight 12.f

//padding within the box for the contentView
#define kBoxPadding 10.f

//control point offset for rounding corners of the main popover box
#define kCPOffset 1.8f

//radius for the rounded corners of the main popover box
#define kBoxRadius 4.f

//Curvature value for the arrow.  Set to 0.f to make it linear.
#define kArrowCurvature 4.f

//Minimum distance from the side of the arrow to the beginning of curvature for the box
#define kArrowHorizontalPadding 5.f

//Alpha value for the shadow behind the PopoverView
#define kShadowAlpha 0.4f

//Blur for the shadow behind the PopoverView
#define kShadowBlur 3.f;

//Box gradient bg alpha
#define kBoxAlpha 0.95f

//Padding along top of screen to allow for any nav/status bars
#define kTopMargin 50.f

//margin along the left and right of the box
#define kHorizontalMargin 10.f

//padding along top of icons/images
#define kImageTopPadding 3.f

//padding along bottom of icons/images
#define kImageBottomPadding 3.f


// DIVIDERS BETWEEN VIEWS

//Bool that turns off/on the dividers
#define kShowDividersBetweenViews NO

//color for the divider fill
#define kDividerColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:0.15f]


// BACKGROUND GRADIENT

//bottom color white in gradient bg
#define kGradientBottomColor [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:kBoxAlpha]

//top color white value in gradient bg
#define kGradientTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha]


// TITLE GRADIENT

//bool that turns off/on title gradient
#define kDrawTitleGradient YES

//bottom color white value in title gradient bg
#define kGradientTitleBottomColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:kBoxAlpha]

//top color white value in title gradient bg
#define kGradientTitleTopColor [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:kBoxAlpha]


// FONTS

//normal text font
#define kTextFont [UIFont fontWithName:@"HelveticaNeue" size:16.f]

//normal text color
#define kTextColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]

//normal text alignment
#define kTextAlignment UITextAlignmentCenter

//title font
#define kTitleFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]

//title text color
#define kTitleColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]




#import "EntryViewCell.h"

#import <QuartzCore/QuartzCore.h>
//#import "AsyncImageView.h"
#import "PopoverView.h"
#import "UIImageView+WebCache.h"


#define ImageHeight 80.0
#define ImageWidth 80.0


@implementation EntryViewCell

@synthesize entry = _entry;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

+ (UIFont *)titleFont {
    return [UIFont boldSystemFontOfSize:15.0f];
}

+ (UIFont *)userFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (UIFont *)dateFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (UIFont *)subtleFont {
    return [UIFont systemFontOfSize:13.0f];
}





+ (CGFloat)heightForEntry:(NSDictionary *)entry withWidth:(CGFloat)width{
    NSLog(@"%s===width==%f",__FUNCTION__,width);

    NSString *user = [[entry objectForKey:@"user"] objectForKey:@"screen_name"];
   
    CGSize titlesize = [[entry objectForKey:@"text"] sizeWithFont:[self titleFont] constrainedToSize:CGSizeMake(width - 16.0f, 200.0f) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"—%s---%@--%f",__FUNCTION__,user,45.0f + titlesize.height); 
    
    CGFloat ff = 45.0f + titlesize.height;
    
    NSDictionary *restatus = [entry objectForKey:@"retweeted_status"];
    if (restatus) {
        if ( [restatus objectForKey:@"text"]) {
            
            NSString *retweeted_user = [[restatus objectForKey:@"user"] objectForKey:@"screen_name"];
            NSString *retweet_content = [NSString stringWithFormat:@"%@:%@",retweeted_user,[restatus objectForKey:@"text"]];
            NSLog(@"%s===%@",__FUNCTION__,retweet_content);
            CGSize restatusSize = [retweet_content sizeWithFont:[self titleFont] constrainedToSize:CGSizeMake(width - 16.0f, 2000.0f) lineBreakMode:UILineBreakModeWordWrap];
            ff = ff + restatusSize.height + 50;
        }
        
    }
    
    

    NSString *imageUrl = [entry objectForKey:@"thumbnail_pic"];
    if (imageUrl) {
        ff = ff +   20.0f + ImageHeight;
    }
//    ff = ff + 60.0f;

    return ff;
}


- (id)initWithReuseIdentifier:(NSString *)identifier{
    
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        [contentView setBackgroundColor:[UIColor whiteColor]];
        CALayer *layer = [contentView layer];
        [layer setContentsGravity:kCAGravityTopLeft];
        [layer setNeedsDisplayOnBoundsChange:YES];
    }
    return self;
}


- (void) drawContentView:(CGRect)rect{
    
 
    CGSize bounds = [self bounds].size;
    
    CGSize offsets = CGSizeMake(8.0f, 4.0f);

    NSString *user = [[_entry objectForKey:@"user"] objectForKey:@"screen_name"];
    NSString *title = [_entry objectForKey:@"text"];
    NSMutableString *date = [_entry objectForKey:@"created_at"];
    
    if ([date rangeOfString:@"+0800 "].length != 0) {
        [date deleteCharactersInRange:[date rangeOfString:@"+0800 "]];
    }

    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    [user drawAtPoint:CGPointMake(offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    [title drawInRect:CGRectMake(offsets.width, offsets.height + 19.0f, bounds.width - (2 * offsets.width), bounds.height - 45.0f) withFont:[[self class] titleFont] lineBreakMode:UILineBreakModeWordWrap];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGFloat datewidth = [date sizeWithFont:[[self class] dateFont]].width;
    [date drawAtPoint:CGPointMake(bounds.width - datewidth - offsets.width, offsets.height) withFont:[[self class] dateFont]];

    CGSize titlesize = [[_entry objectForKey:@"text"] sizeWithFont:[[self class] titleFont] constrainedToSize:CGSizeMake(320 - 16.0f, 200.0f) lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"—%s---%@--%f",__FUNCTION__,user,45.0f + titlesize.height);
    
    CGFloat ff = 45.0f + titlesize.height + 5.f;
    
     NSDictionary *retweeted_status = [_entry objectForKey:@"retweeted_status"];
    
    
    if (retweeted_status) {
        if ( [retweeted_status objectForKey:@"text"]) {
            NSString *retweeted_user = [[retweeted_status objectForKey:@"user"] objectForKey:@"screen_name"];
            NSLog(@"rewteee_user === %@",retweeted_user);
            NSString *retweet_content = [NSString stringWithFormat:@"%@:%@",retweeted_user,[retweeted_status objectForKey:@"text"]];
            CGSize restatusSize = [retweet_content sizeWithFont:kTextFont constrainedToSize:CGSizeMake(320 - 16.0f, 200.0f) lineBreakMode:UILineBreakModeWordWrap];

            [self drawRetweet:CGRectMake(offsets.width, ff, restatusSize.width, restatusSize.height+3)];
        }
        
    }
    NSString *retweeted_user = [[retweeted_status objectForKey:@"user"] objectForKey:@"screen_name"];
    NSLog(@"rewteee_user === %@",retweeted_user);
    NSString *retweet_content = [NSString stringWithFormat:@"%@:%@",retweeted_user,[retweeted_status objectForKey:@"text"]];
    NSLog(@"%s=restatus=%@=%f",__FUNCTION__,user,ff);
    [self showAtPoint:CGPointMake(offsets.width, ff)
             withText:retweet_content];
    

    [imageView1 setFrame:CGRectMake(offsets.width, offsets.height + 19.0f + bounds.height - 45.0f-ImageHeight, ImageHeight, ImageWidth)];

}


//这里设置并显示
- (void)setEntrys:(NSDictionary *)entry{
    NSLog(@"%s===o%@",__FUNCTION__,[entry objectForKey:@"text"]);
    [_entry release];
    
    _entry = [entry retain];

    
    NSString *imageUrl = [_entry objectForKey:@"thumbnail_pic"];
    
    
    [imageView1 removeFromSuperview];
    if (imageUrl) {

        [imageView1 setImageWithURL:[NSURL URLWithString:[entry objectForKey:@"thumbnail_pic"]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [imageView1 setFrame:CGRectMake(0, 0, 40, 40)];
        
        [self addSubview:imageView1];
    }
    
    
    
    [self setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    [self setNeedsDisplay];
}


#pragma mark - PopoverViewDelegate Methods

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"%s item:%d", __PRETTY_FUNCTION__, index);
//    
//    //Figure out which string was selected, store in "string"
//    NSString *string = [kStringArray objectAtIndex:index];
//    
//    //Show a success image, with the string from the array
//    [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
//    
//    //Dismiss the PopoverView after 0.5 seconds
//    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(pv) {
        [pv animateRotationToNewPoint:CGPointMake(self.frame.size.width*0.5f, self.frame.size.height*0.5f) inView:self withDuration:duration];
    }
}



- (void)drawRetweet:(CGRect)rect{
    CGRect frame = rect;
    
   
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = CGPointMake(xMin + 30, yMin - 10);
    
    float radius = kBoxRadius; //Radius of the curvature.
    
    float cpOffset = kCPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    
    NSLog(@"%s==xMin=%f=yMin=%f=xMax=%f=yMax%f",__FUNCTION__,xMin,yMin,xMax,yMax);
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
    //In this case, the arrow is located between LT2 and RT1
  
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
    NSLog(@"%s===arrowPoint.x==%f===%f",__FUNCTION__,arrowPoint.x,arrowPoint.y);
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x, arrowPoint.y) controlPoint1:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin) controlPoint2:CGPointMake(arrowPoint.x, arrowPoint.y)];//actual arrow point
    
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
  
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    //If the popover is positioned above the arrowPoint, then we know that the arrow must be on the bottom of the popover.
    //In this case, the arrow is located somewhere between LB1 and RB2
//     {
//        [popoverPath addLineToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMax)];//right side
//        [popoverPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMax) controlPoint2:arrowPoint];//arrow point
//        [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMax) controlPoint1:arrowPoint controlPoint2:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMax)];
//    }

    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:kShadowAlpha];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = kShadowBlur;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = 0 ;
    float topOffset =  kArrowHeight;
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)showAtPoint:(CGPoint)point  withText:(NSString *)text {
    UIFont *font = kTextFont;
    
    CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - kHorizontalMargin*2.f, 1000.f) lineBreakMode:UILineBreakModeWordWrap];
    
    
//    self.textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.textLabel.userInteractionEnabled = NO;
//    [self.textLabel setNumberOfLines:0]; //This is so the label word wraps instead of cutting off the text
//    self.textLabel.font = font;
//    self.textLabel.textAlignment = kTextAlignment;
//    self.textLabel.textColor = [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1];
//    self.textLabel.text = text;
//    [self addSubview:self.textLabel];

    
    
    
//    [text drawAtPoint:point forWidth:( 320 - 16) withFont:font fontSize:14 lineBreakMode:UILineBreakModeWordWrap baselineAdjustment:kTextAlignment];
    
    
//
   [text drawInRect:CGRectMake(point.x, point.y, textSize.width , textSize.height) withFont:font lineBreakMode:UILineBreakModeWordWrap];
    
    
//    [textView removeFromSuperview];
//    self.textLabel = textView;
//    [self addSubview:textView];
//    [self.textLabel setFrame:CGRectMake(point.x, point.y, textSize.width, textSize.height)];
}


@end


