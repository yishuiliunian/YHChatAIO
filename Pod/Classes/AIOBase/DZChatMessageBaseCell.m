//
//  DZChatMessageBaseCell.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import <Foundation/Foundation.h>
#import "DZChatMessageBaseCell.h"
#import "DZGeometryTools.h"
#import "DZProgrameDefines.h"
#import "YYText.h"
@interface DZChatMessageBaseCell()
{
    UITapGestureRecognizer* _tapGesture;
}
@end


@implementation DZChatMessageBaseCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _avatarImageView);
    INIT_SUBVIEW_UIImageView(self.contentView, _bubleImageView);
    INIT_SUBVIEW_UILabel(self.contentView, _nickLabel);
    INIT_SUBVIEW(self.contentView,FLAnimatedImageView ,_sendStatusImageView);
    INIT_SUBVIEW(self.contentView, YYLabel, _timeLineLabel);
    INIT_SUBVIEW(self.contentView, YYLabel, _bottomIndictorLabel);
    INIT_GESTRUE_TAP_IN_VIEW(_tapGesture, _sendStatusImageView, 1, 1);

    [_tapGesture addTarget:self action:@selector(handleTapStatusImageView:)];
    _sendStatusImageView.userInteractionEnabled = YES;
    _nickLabel.font = [UIFont systemFontOfSize:11];
    _nickLabel.textColor = [UIColor grayColor];
    _avatarImageView.layer.masksToBounds = YES;
    return self;
}

- (void) handleTapStatusImageView:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if ([self.chatStatusDelegate respondsToSelector:@selector(chatCellDidTapStatusView:)]) {
            [self.chatStatusDelegate chatCellDidTapStatusView:self];
        }
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end
