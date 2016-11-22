//
//  YHToastCardMessageElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastCardMessageElement.h"
#import "YHToastMessageElement.h"
#import "YHToastMessageCell.h"
#import "DZLogger.h"
#import <DZGeometryTools/DZGeometryTools.h>
#import "YHToastMessageCell.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHClassMemberListElement.h"
#import "YHClassMemberListViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "DZURLRoute.h"
#import "YHCardMessageItemCell.h"


@interface YHToastCardMessageElement ()
{
    CGRect _toastBackgroundRect;
    CGRect _toastContentRect;
    CGRect _toastGotoRect;
    //
    YYTextLayout* _toastContentTextLayout;
}
@end

@implementation YHToastCardMessageElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHCardMessageItemCell class];
    return self;
}
- (NSMutableAttributedString*) buildToastConentString
{
    return nil;
}
- (NSString*) gotoDetailText
{
    return @"点击查看详情";
}

- (NSAttributedString*) readableContentText
{
    return [_toastContentTextLayout.text copy];
}

- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    _avatarRect = CGRectZero;
    _bubbleRect = CGRectZero;
    CGRect contentRect =  _estimateContentRect;
    contentRect.origin.x = 0;
    contentRect.size.width = CGRectLoadViewFrame.size.width;
    contentRect.size.height = CGFLOAT_MAX;
    
    contentRect.size.width = CGRectLoadViewFrame.size.width;
    
    CGSize subSize = {30, 20};
    contentRect = CGRectCenterSubSize(contentRect, subSize);
    _toastBackgroundRect = contentRect;
    _toastBackgroundRect.size.height = subSize.height;

    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(20, 15));
    
    NSMutableAttributedString* mAstr = [self buildToastConentString];
    mAstr.yy_font = [UIFont systemFontOfSize:14];
    mAstr.yy_alignment = NSTextAlignmentLeft;
    _toastContentTextLayout = [YYTextLayout layoutWithContainerSize:contentRect.size text:mAstr];
    
    CGRectDivide(contentRect, &_toastContentRect, &contentRect, _toastContentTextLayout.textBoundingSize.height, CGRectMinYEdge);
    _toastBackgroundRect.size.height += _toastContentTextLayout.textBoundingSize.height;
    
    
    CGFloat space = 5;
    contentRect = CGRectShrink(contentRect, 5, CGRectMinYEdge);
    CGFloat gotoHeight = 20;
    
    CGRectDivide(contentRect, &_toastGotoRect, &contentRect, gotoHeight, CGRectMinYEdge);
    _toastBackgroundRect.size.height += gotoHeight;
    
    *cellHeight += (_toastBackgroundRect.size.height + subSize.height);
}

- (void) layoutCell:(YHCardMessageItemCell *)cell
{
    [super layoutCell:cell];
    cell.gotoLabel.frame = _toastGotoRect;
    cell.actionDetailLabel.frame = _toastContentRect;
    cell.actionBackgroundView.frame = _toastBackgroundRect;
}

- (void) willBeginHandleResponser:(YHCardMessageItemCell *)cell
{
    [super willBeginHandleResponser:cell];
    cell.actionDetailLabel.textLayout = _toastContentTextLayout;
    cell.gotoLabel.text = [self gotoDetailText];
}
@end
