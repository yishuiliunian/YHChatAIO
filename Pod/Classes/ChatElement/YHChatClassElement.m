//
//  YHChatClassElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHChatClassElement.h"
#import "DZImageCache.h"
#import "YHClassRoomDetailElement.h"
#import "YHCoreDB.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHTableViewController.h"
#import "YHNotifications.h"
@interface YHChatClassElement () <YHCacheFetcherObsever>

@end
@implementation YHChatClassElement
- (void) dealloc
{
    DZRemoveObserverForDismissClassroom(self);
}
- (instancetype) initWithSessionInfo:(YHChatSessionInfo *)info
{
    self = [super initWithSessionInfo:info];
    if (!self) {
        return self;
    }
    DZAddObserverForDismissClassroom(self,@selector(onHandleExistClassroom:));
    return self;
}

- (void) onHandleExistClassroom:(NSNotification*)nc
{
    ClassInfo* c = nc.userInfo.yh_classInfo;
    if (![c isKindOfClass:[ClassInfo class]]) {
        return;
    }
    if ([c.classId isEqualToString:self.sessionInfo.uuid]) {
        [self.env.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) handleClassTap:(id)sender
{
    YHClassRoomDetailElement* ele = [[YHClassRoomDetailElement alloc] initWithClasID:self.sessionInfo.uuid];
    YHTableViewController* detalvc = [[YHTableViewController alloc] initWithElement:ele];
    [self.env.navigationController pushViewController:detalvc animated:YES];
}

- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    UIImage* normalImage = DZCachedImageByName(@"ic_class_white");
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:normalImage landscapeImagePhone:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(handleClassTap:)];
    self.inputViewController.navigationItem.rightBarButtonItem= item;
    if (self.sessionInfo.nickName.length == 0) {
        [[YHCommonCache shareCache] fetchClassRoomProfile:self.sessionInfo.uuid observer:self];
    }
}

- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    SUPER_COMMON_CACHE(modelId, model)
    if ([modelId isEqualToString:self.sessionInfo.uuid]) {
        ClassInfo* group = (ClassInfo*)model;
        self.sessionInfo.nickName = group.clazzName;
        self.inputViewController.title = self.sessionInfo.nickName;
    }
}
@end
