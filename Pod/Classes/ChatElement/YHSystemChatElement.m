//
//  YHSystemChatElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSystemChatElement.h"

@implementation YHSystemChatElement
- (instancetype) initWithSessionInfo:(YHChatSessionInfo *)info
{
    self = [super initWithSessionInfo:info];
    if (!self) {
        return self;
    }
    self.AIOToolbarType = DZAIOToolbarTypeNone;
    return self;
}

- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    self.inputViewController.title = @"系统消息";
}
@end
