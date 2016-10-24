//
//  YHUnsupportElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/24.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHUnsupportElement.h"

@implementation YHUnsupportElement

- (void) buildMsgContent
{
    [super buildMsgContent];
    _text = @"当前版本不支持该消息，请升级后查看";
}

@end
