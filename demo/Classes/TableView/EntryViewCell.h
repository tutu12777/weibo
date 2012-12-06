//
//  EntryViewCell.h
//  SinaWeiBoSDKDemo
//
//  Created by chen on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell.h"

@interface EntryViewCell : TableViewCell{
 
}
@property (nonatomic, retain)NSDictionary *entry;

- (void)setEntrys:(NSDictionary *)entry;

+ (CGFloat)heightForEntry:(NSDictionary *)entry withWidth:(CGFloat)width;
- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
