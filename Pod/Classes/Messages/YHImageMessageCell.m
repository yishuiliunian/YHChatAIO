//
//  YHImageMessageCell.m
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHImageMessageCell.h"
#import "DZGeometryTools.h"
#import "DZProgrameDefines.h"
#import "YHAppearance.h"

@implementation YHImageMessageCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }

    INIT_SUBVIEW(self.contentView, UIImageView, _contentImageView);
    _contentImageView.hnk_cacheFormat = LTHanekeCacheFormatThumb();
    _contentImageView.layer.masksToBounds= YES;
    _contentImageView.layer.shouldRasterize = YES;
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.layer.cornerRadius = 8;
    _contentImageView.layer.shouldRasterize  = YES;
    INIT_SUBVIEW(self.contentView,DALabeledCircularProgressView , _uploadProgressView);
    _uploadProgressView.trackTintColor = [UIColor clearColor];
    _uploadProgressView.progressTintColor = [UIColor lightGrayColor];
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end
