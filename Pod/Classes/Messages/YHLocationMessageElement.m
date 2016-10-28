//
//  YHLocationMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/20.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHLocationMessageElement.h"
#import "YHLocationMessageCell.h"
#import "DZGeometryTools.h"
#import "DZImageCache.h"
#import "YHAppearance.h"
#import "YHMapViewController.h"
#import "YHLocation.h"
#import "DZLogger.h"
#import "YHUtils.h"
#import "QBPopupMenuItem.h"
@interface YHLocationMessageElement ()
{
    Location* _location;
    UIFont* _font;
    YYTextLayout* _textLayout;
    
    CGRect _textRect;
    CGRect _mapImageRect;
}

@end

@implementation YHLocationMessageElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHLocationMessageCell class];
     _font = DZFontCellDetail();
    return self;
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    NSError* error;
    _location = [Location parseFromData:self.msg.data error:&error];
    if(error){
        DDLogError(@"%@",error);
    }
}

- (NSAttributedString*) readableContentText
{
    NSString* location = [NSString stringWithFormat:@"位置消息-%@ %@",_location.title, _location.label];
    return [[NSAttributedString alloc] initWithString:location];
}


- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    
    CGSize imageSize = {55, 55};
    CGRect contentRect = _estimateContentRect;
    contentRect  = CGRectShrink(contentRect, _bubbleArrowWidth, _horizontalStartEdge);
    CGFloat marginHeight = 20;
    CGFloat marginWidth = 20;
    
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake(marginWidth, 0));
    
    CGFloat maxWidth = CGRectGetWidth(contentRect) - imageSize.width - _xItemSpace;
    NSMutableAttributedString* attributeString = [[NSMutableAttributedString alloc] initWithString:YHLocationTitleJoin(_location.title, _location.label)];
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    attributes[NSFontAttributeName] = _font;
    attributes[NSForegroundColorAttributeName] = _normalTextColor;
    
    [attributeString yy_setAttributes:attributes];
    YYTextLayout* layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, CGFLOAT_MAX) text:attributeString];
    CGSize size  = layout.textBoundingSize;
    _textLayout = layout;
    
    CGFloat height = MAX(imageSize.height + 10, size.height + marginHeight);
    CGRectDivide(_estimateContentRect, &_bubbleRect, &contentRect, height, CGRectMinYEdge);
    CGRectDivide(_bubbleRect,
                 &_bubbleRect,
                 &contentRect, // 占位无意义
                 size.width + //地址长度
                 marginWidth+ // 两边间距
                 _bubbleArrowWidth // 箭头宽度
                 + imageSize.width // 图片宽度
                 + _xItemSpace, // 文字图片间距
                 _horizontalStartEdge);
    
    contentRect = CGRectShrink(_bubbleRect, _bubbleArrowWidth, _horizontalStartEdge);
    contentRect  = CGRectCenterSubSize(contentRect, CGSizeMake(marginWidth, 0));

    CGRectDivide(contentRect, &_textRect, &_mapImageRect, size.width, _horizontalStartEdge);
    _textRect = CGRectCenter(_textRect, size);
    _mapImageRect = CGRectCenter(_mapImageRect, imageSize);
    *cellHeight+= height;
    
}

- (void) layoutCell:(YHLocationMessageCell *)cell
{
    [super layoutCell:cell];
    cell.textView.frame = _textRect;
    cell.locationImageView.frame = _mapImageRect;
    
}
- (void) willBeginHandleResponser:(YHLocationMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.textView.textLayout = _textLayout;
}

- (void) didBeginHandleResponser:(YHLocationMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHLocationMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHLocationMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    YHLocation* location = [YHLocation new];
    location.latitude = _location.locationX;
    location.longtitude = _location.locationY;
    location.name = _location.title;
    location.address = _location.label;
    YHMapViewController* mapVC = [[YHMapViewController alloc] initWithLocation:location];
    mapVC.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:mapVC animated:YES];
}

- (void) copyLocationText
{
    [[UIPasteboard generalPasteboard] setString:_textLayout.text.string];
}
- (NSArray*) customPopupMenu
{
    QBPopupMenuItem* item = [[QBPopupMenuItem alloc] initWithTitle:@"复制位置" target:self action:@selector(copyLocationText)];
    return @[item];
}
@end
