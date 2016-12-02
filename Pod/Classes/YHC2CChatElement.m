//
//  YHC2CChatElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHC2CChatElement.h"
#import "DZImageCache.h"
#import "YHChatViewController.h"
#import "YHURLRouteDefines.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHAppConfig.h"
#import "KxMenu.h"
@interface YHC2CChatElement () <YHCacheFetcherObsever>

@end

@implementation YHC2CChatElement
- (void) handleUserInfoTap:(id)sender
{
#ifdef MESSAGE_TEST
    NSMutableArray* items = [NSMutableArray new];

    if (self.isAutoSending) {
        KxMenuItem* close = [KxMenuItem menuItem:@"关闭自动发送" image:DZCachedImageByName(@"ic_action_exit") target:self action:@selector(stopAutoSend)];
        [items addObject:close];
    } else {
        KxMenuItem* close = [KxMenuItem menuItem:@"开始自动发送" image:DZCachedImageByName(@"ic_action_exit") target:self action:@selector(startAutoSend)];
        [items addObject:close];
    }

    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.origin.x = CGRectGetWidth(self.env.view.bounds) - 20;
    rect.origin.y = CGRectGetHeight(self.env.navigationController.navigationBar.bounds) + 20;
    [KxMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:rect menuItems:items];
#else
    NSMutableDictionary* info = [NSMutableDictionary new];
    [info safeSetObject:self.sessionInfo.uuid forKey:kYHURLQueryParamterUID];
    [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLUserDetail, info)];

#endif
}

- (void) willBeginHandleResponser:(YHChatViewController *)responser
{
    [super willBeginHandleResponser:responser];
    UIImage* normalImage = DZCachedImageByName(@"ic_user_white");
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:normalImage landscapeImagePhone:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(handleUserInfoTap:)];
    self.inputViewController.navigationItem.rightBarButtonItem= item;
    if (self.sessionInfo.nickName.length == 0) {
        [[YHCommonCache shareCache] fetchUserProfile:self.sessionInfo.uuid observer:self];
    }
}

- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    SUPER_COMMON_CACHE(modelId, model)
    if ([modelId isEqualToString:self.sessionInfo.uuid]) {
        UserProfile* userInfo = (UserProfile*)model;
        self.sessionInfo.nickName = userInfo.nick.length ? userInfo.nick : userInfo.userName;
        self.inputViewController.title = self.sessionInfo.nickName;
    }
}

- (void) didBeginHandleResponser:(YHChatViewController *)responser
{
    [super didBeginHandleResponser:responser];
}
@end
