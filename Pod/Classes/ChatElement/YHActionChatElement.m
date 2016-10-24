//
//  YHActionChatElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHActionChatElement.h"
#import "YHActionGroupDetailViewController.h"
#import "YHActionGroupDetailElement.h"
#import "YHChatViewController.h"
#import <DZCache/DZImageCache.h>
#import "UIViewController+BarItem.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHNotifications.h"
@interface YHActionChatElement () <YHCacheFetcherObsever>
{
    NSString* _title;
}
@end

@implementation YHActionChatElement

- (void) dealloc
{
    DZRemoveObserverForExitActionGroup(self);
}
- (instancetype)initWithSessionInfo:(YHChatSessionInfo *)info
{
    self = [super initWithSessionInfo:info];
    if (!self) {
        return self;
    }
    DZAddObserverForExitActionGroup(self,@selector(onHandleExistActionGroup:));
    return self;
}

- (void) onHandleExistActionGroup:(NSNotification*)nc
{
    ActionGroup* group = nc.userInfo.yh_actionGroup;
    if (![group isKindOfClass:[ActionGroup class]]) {
        return;
    }
    if ([group.groupId isEqualToString:self.sessionInfo.uuid]) {
        [self.env.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void) handleUserInfoTap:(id)sender
{
    YHActionGroupDetailElement* ele = [[YHActionGroupDetailElement alloc] initWithGroupId:self.sessionInfo.uuid profile:nil];
    YHActionGroupDetailViewController* vcx = [[YHActionGroupDetailViewController alloc] initWithElement:ele];
    DZInputViewController* inptVC= [[    DZInputViewController alloc] initWithElement:nil contentViewController:vcx];
    [self.env.navigationController pushViewController:inptVC animated:YES];
    inptVC.title = @"活动详情";
    [inptVC loadClearBackItem];
}

- (void) willBeginHandleResponser:(YHChatViewController *)responser
{
    [super willBeginHandleResponser:responser];
    UIImage* normalImage = DZCachedImageByName(@"ic_troop_white");
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:normalImage landscapeImagePhone:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(handleUserInfoTap:)];
    self.inputViewController.navigationItem.rightBarButtonItem= item;
    if (self.sessionInfo.nickName.length == 0) {
        [[YHCommonCache shareCache] fetchActionGroup:self.sessionInfo.uuid observer:self];
    }
}
- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    SUPER_COMMON_CACHE(modelId, model)
    if ([modelId isEqualToString:self.sessionInfo.uuid]) {
        ActionGroup* group = (ActionGroup*)model;
        self.sessionInfo.nickName = group.groupName;
        self.inputViewController.title = self.sessionInfo.nickName;
    }
}

@end
