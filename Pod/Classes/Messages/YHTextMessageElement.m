//
//  YHTextMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTextMessageElement.h"
#import "YHTextMessageCell.h"
#import "YHAppearance.h"
#import "DZGeometryTools.h"
#import "DZEmojiMapper.h"
#import "QBPopupMenu.h"
#import "DZFunScene.h"
#import <YHCoreDB.h>
#import <DZAuthSession/DZAuthSession.h>
#import "YHLinkedTextParser.h"
#import <TOWebViewController.h>
#import "AppDelegate.h"

@interface YHTextMessageElement()
{
    UIFont* _font;
    CGRect _textRect;
    YYTextLayout* _textLayout;
}
@property (nonatomic, strong) DZFunScene* funScene;
@end
@implementation YHTextMessageElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHTextMessageCell class];
    _font = [UIFont systemFontOfSize:15];
    return self;
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    NSError* error;
    Text* originText = [Text parseFromData:self.msg.data error:&error];
    if (originText) {
        _text = [[NSString alloc] initWithData:originText.context encoding:NSUTF8StringEncoding];
    } else {
        _text = @"";
    }
}
- (NSAttributedString*) readableContentText
{
    NSMutableAttributedString* str =  [_textLayout.text mutableCopy];
    str.yy_color = [UIColor lightGrayColor];
    return str;
}

- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    CGRect contentRect = _estimateContentRect;
    contentRect  = CGRectShrink(contentRect, _bubbleArrowWidth, _horizontalStartEdge);
    CGFloat marginHeight = 20;
    CGFloat marginWidth = 20;
    
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(marginWidth, 0));
    CGFloat maxWidth = CGRectGetWidth(contentRect);
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:_text];
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    attributes[NSFontAttributeName] = _font;
    attributes[NSForegroundColorAttributeName] = _normalTextColor;
    
    [attributeString yy_setAttributes:attributes];
    [[DZEmojiMapper mapper].textEmojiParser parseText:attributeString selectedRange:NULL];
    [YHLinkedTextParser parseText:attributeString];
    [attributeString yy_setLineSpacing:3 range:NSMakeRange(0, attributeString.length)];
    YYTextLayout* layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, CGFLOAT_MAX) text:attributeString];
    CGSize size  = layout.textBoundingSize;
    _textLayout = layout;
    
    CGFloat height = MAX(CGRectGetHeight(_avatarRect), size.height + marginHeight);
    CGRectDivide(_estimateContentRect, &_bubbleRect, &contentRect, height, CGRectMinYEdge);
    CGRectDivide(_bubbleRect, &_bubbleRect, &contentRect, size.width + marginWidth+ _bubbleArrowWidth, _horizontalStartEdge);
    
    _textRect = CGRectShrink(_bubbleRect, _bubbleArrowWidth, _horizontalStartEdge);
    _textRect = CGRectCenter(_textRect, size);
    *cellHeight+= height;
}

- (void) layoutCell:(YHTextMessageCell *)cell
{
    [super layoutCell:cell];
    cell.textContentLabel.frame = _textRect;
  
}
- (void) willBeginHandleResponser:(YHTextMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    [cell.contentView bringSubviewToFront:cell.textContentLabel];
    if (self.sendByMe) {
        cell.textContentLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.textContentLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.textContentLabel.textLayout = _textLayout;
}

- (void) didBeginHandleResponser:(YHTextMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
    [self checkWillShowFun];
}

- (void) willRegsinHandleResponser:(YHTextMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHTextMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}

- (NSString*) simpleDescription
{
    return _text;
}

- (void) copyText
{
    [[UIPasteboard generalPasteboard] setString:_text];
}

- (NSArray*) customPopupMenu
{
    QBPopupMenuItem* item = [[QBPopupMenuItem alloc] initWithTitle:@"复制文本" target:self action:@selector(copyText)];
    return @[item];
}

- (void) checkWillShowFun
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString* text = _text;
        if (weakSelf.msg.isCheckedDetail) {
            return ;
        }
        NSDictionary* map = [DZFunScene funKeyImgeNameMap];
        for (NSString* key in map.allKeys) {
            if ([text containsString:key]) {
                UIImage* image = DZCachedImageByName(map[key]);
                if (image) {
                    [weakSelf showFunSceneWithImage:image];
                }
            }
        }
        weakSelf.msg.isCheckedDetail = YES;
        [YHActiveDBConnection updateMessage:weakSelf.msg];
    });
}

- (void) showFunSceneWithImage:(UIImage*)image
{
      self.funScene =[[DZFunScene alloc] initWithRootView:self.superTableView];
      [self.funScene startWithImage:image];
}

@end
