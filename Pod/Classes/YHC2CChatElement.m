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

@interface YHC2CChatElement () <YHCacheFetcherObsever>

@end

@implementation YHC2CChatElement
- (void) handleUserInfoTap:(id)sender
{
    NSMutableDictionary* info = [NSMutableDictionary new];
    [info safeSetObject:self.sessionInfo.uuid forKey:kYHURLQueryParamterUID];
    [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLUserDetail, info)];
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
