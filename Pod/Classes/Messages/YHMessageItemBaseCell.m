//
//  YHMessageItemBaseCell.m
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHMessageItemBaseCell.h"
#import "DZGeometryTools.h"
#import "YHAppearance.h"
#import <QBPopupMenu/QBPopupMenu.h>
#import "AppDelegate.h"
@interface YHMessageItemBaseCell ()
{
    UILongPressGestureRecognizer* _longPressRecognizer;
}
@end

@implementation YHMessageItemBaseCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    self.avatarImageView.hnk_cacheFormat = LTHanekeCacheFormatAvatar();

    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:_longPressRecognizer];
    _longPressRecognizer.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) handleLongPress:(UILongPressGestureRecognizer*)r
{
    if (r.state == UIGestureRecognizerStateBegan) {
        NSLog(@"handle long press");

        
        NSArray* items = [self.interactDelegate messagePopUpMenus];
        QBPopupMenu* menu = [[QBPopupMenu alloc] initWithItems:items];
        
        UIWindow* keywindow = YHApplicationDelegate.director.keyWindow;
        CGPoint point = [r locationInView:keywindow];
        CGRect rect = [self.bubleImageView convertRect:self.bounds toView:keywindow];
        CGPoint pointInCell = [r locationInView:self];
        rect.origin.y = point.y - pointInCell.y/2;
        rect.origin.x = point.x;
        rect.size.width = 20;
        [menu showInView:keywindow targetRect:rect animated:YES];
    }
}
- (void) layoutSubviews
{
    [super layoutSubviews];
}


@end