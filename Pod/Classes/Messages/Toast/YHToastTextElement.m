//
//  YHToastTextElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastTextElement.h"
#import "YHAppearance.h"
#import "YHCommonCache.h"
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

@interface YHToastTextElement ()
{
    YYTextLayout* _textLayout;
    CGRect _toastRect;
}
@end

@implementation YHToastTextElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _toastContentFont = [UIFont systemFontOfSize:14];
    return self;
}

- (NSAttributedString*) readableContentText
{
    if ([_textLayout.text isKindOfClass:[NSAttributedString class]]) {
        return [[NSAttributedString alloc] initWithString:(_textLayout.text.string.length?_textLayout.text.string:@"")];
    } else
    {
        return [[NSAttributedString alloc] initWithString:@""];
    }
}


- (NSMutableAttributedString*) buildContentText
{
    NSString* output = @"请升级APP查看该消息！";
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    mAStr.yy_color = [UIColor whiteColor];
    return mAStr;
}

- (NSMutableAttributedString*) __buildToastText
{
    YYTextBorder* boarder = [YYTextBorder borderWithFillColor:[UIColor flatWhiteColorDark] cornerRadius:4];
    boarder.insets = UIEdgeInsetsMake(-2, -2, -3, -2);
    NSMutableAttributedString* mAStr = [self buildContentText];
    mAStr.yy_font = _toastContentFont;
    mAStr.yy_textBackgroundBorder = boarder;
    return mAStr;
}

- (BOOL) showNickLabel
{
    return NO;
}
- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    CGRect contentRect =  [UIScreen mainScreen].bounds;
    contentRect = CGRectCenter(contentRect, _estimateContentRect.size);
    contentRect.origin.y = _estimateContentRect.origin.y;
    NSMutableAttributedString* str = [self __buildToastText];

    YYTextLayout* layout = [YYTextLayout layoutWithContainerSize:contentRect.size text:str];
    CGSize size  = layout.textBoundingSize;
    _textLayout = layout;
    size.height += 4;
    size.width += 4;
    *cellHeight += size.height;
    
    CGRect restRect;
    CGRectDivide(contentRect, &_toastRect, &restRect, size.height, CGRectMinYEdge);
    _avatarRect = CGRectZero;
    _bubbleRect = CGRectZero;
}

- (void) layoutCell:(YHToastMessageCell *)cell
{
    [super layoutCell:cell];
    cell.textContentLabel.frame = _toastRect;
}

- (void) willBeginHandleResponser:(YHToastMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.textContentLabel.textLayout = _textLayout;
    cell.textContentLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) didBeginHandleResponser:(YHToastMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHToastMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHToastMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}
@end
