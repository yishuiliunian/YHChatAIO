//
//  YHCardMessageItemCell.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHCardMessageItemCell.h"
#import <DZGeometryTools/DZGeometryTools.h>
#import <Chameleon.h>

@implementation YHCardMessageItemCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW_UIImageView(self.contentView, _actionBackgroundView);
    INIT_SUBVIEW_UILabel(self.contentView, _gotoLabel);
    INIT_SUBVIEW(self.contentView, YYLabel, _actionDetailLabel);
    _actionBackgroundView.backgroundColor = [UIColor whiteColor];
    _actionBackgroundView.layer.cornerRadius = 4;
    _gotoLabel.textColor = [UIColor colorWithHexString:@"0773ff"];
    _gotoLabel.textAlignment = NSTextAlignmentRight;
    _actionDetailLabel.textColor = [UIColor colorWithHexString:@"5a5f6b"];
    _actionDetailLabel.userInteractionEnabled = NO;
    //
    return self;
}
@end
