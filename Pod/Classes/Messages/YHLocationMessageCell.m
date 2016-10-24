//
//  YHLocationMessageCell.m
//  YaoHe
//
//  Created by stonedong on 16/6/20.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHLocationMessageCell.h"
#import "DZGeometryTools.h"
#import "DZImageCache.h"
@implementation YHLocationMessageCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _locationImageView);
    INIT_SUBVIEW(self.contentView, YYLabel, _textView);
    _locationImageView.image = DZCachedImageByName(@"ic_map_big");
    _locationImageView.layer.cornerRadius = 8;
    _textView.userInteractionEnabled = NO;
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end