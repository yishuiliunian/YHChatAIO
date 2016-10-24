//
//  YHAudioMessageCell.m
//  YaoHe
//
//  Created by stonedong on 16/5/8.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHAudioMessageCell.h"
#import "DZGeometryTools.h"
#import <DZCache/DZImageCache.h>

@implementation YHAudioMessageCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UILabel(self.contentView, _timeLabel);
    INIT_SUBVIEW_UIImageView(self.contentView, _audioImageView);
    INIT_SUBVIEW_UIImageView(self.contentView, _playedIndicatorImageView);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _audioImageView.contentMode = UIViewContentModeScaleAspectFit;
    _playedIndicatorImageView.image =  DZCachedImageByName(@"red_point");
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end