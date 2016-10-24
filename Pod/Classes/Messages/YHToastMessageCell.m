//
//  YHToastMessageCell.m
//  YaoHe
//
//  Created by stonedong on 16/6/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHToastMessageCell.h"
#import "DZGeometryTools.h"

@implementation YHToastMessageCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    
    self.textContentLabel.textAlignment = NSTextAlignmentCenter;
    self.textContentLabel.userInteractionEnabled = NO;
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end