//
//  YHTextMessageCell.m
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTextMessageCell.h"
#import "DZGeometryTools.h"
#import "YYText.h"
#import "DZEmojiMapper.h"


@implementation YHTextMessageCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW(self.contentView, YYLabel, _textContentLabel);

    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end