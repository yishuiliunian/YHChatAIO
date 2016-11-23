//
//  YHChatHotRoomElement.m
//  YaoHe
//
//  Created by stonedong on 16/7/23.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHChatHotRoomElement.h"
#import <KxMenu.h>
#import "YHExitClassRequest.h"
#import <DZAuthSession/DZAuthSession.h>
#import <DZAlertPool.h>
#import "YHDeleteClassRequest.h"
#import "YHTextFieldViewController.h"
#import "YHUpdateClassRequest.h"
#import "YHCenterUploadImageElement.h"
#import <DZCache/DZImageCache.h>
#import "YHAppearance.h"
#import "YHExitChatroomRequest.h"
#import "YHMineInfoManager.h"
#import "YHContactsManager.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHReportRequest.h"
#import "YHTextViewInputViewController.h"
#import "YHAppConfig.h"
@interface YHChatHotRoomElement () <YHCacheFetcherObsever>

@end

@implementation YHChatHotRoomElement

- (void) willBeginHandleResponser:(UIViewController *)responser
{
    [super willBeginHandleResponser:responser];
    responser.view.backgroundColor = DZColorBackgroundGray();
    UIImage* normalImage = DZCachedImageByName(@"ic_coin_more");
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:normalImage landscapeImagePhone:normalImage style:UIBarButtonItemStylePlain target:self action:@selector(showActions)];
    self.inputViewController.navigationItem.rightBarButtonItem= item;
    if (self.sessionInfo.nickName.length == 0) {
        [[YHCommonCache shareCache] fetchRoomProfile:self.sessionInfo.uuid observer:self];
    }
    
}
- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    SUPER_COMMON_CACHE(modelId, model)
    if ([modelId isEqualToString:self.sessionInfo.uuid]) {
        ChatRoomInfo* group = (ChatRoomInfo*)model;
        self.sessionInfo.nickName = group.roomName;
        self.inputViewController.title = self.sessionInfo.nickName;
    }
}


- (void) reportThisRoom
{
    __weak typeof(self) weakSelf = self;
    YHTextViewInputViewController* vc = [[YHTextViewInputViewController alloc] initWithTitle:@"填写举报信息"];
    vc.maxLength = 2000;
    [vc setInputCompleteBlock:^(NSString * text) {
        [weakSelf reportThisRoomAfterInput:text];
    }];
    [self.env.navigationController pushViewController:vc animated:YES];
}
- (void) reportThisRoomAfterInput:(NSString*)text
{
    YHReportRequest* req = [YHReportRequest new];
    req.report.contentType = 2;
    req.report.contentId = self.sessionInfo.uuid;
    req.report.content = text;
    req.skey =DZActiveAuthSession.token;
    DZAlertShowLoading(@"举报中...");
    [req setErrorHandler:^(NSError * error) {
        DZAlertShowError(error.localizedDescription);
    }];
    
    [req setSuccessHanlder:^(ActionGroupResponse* response) {
        DZAlertShowSuccess(@"我们已经收到了您的举报，将会处理");
    }];
    [req start];
}
- (void) exitThisRoom
{
   
    YHExitChatroomRequest* req =[YHExitChatroomRequest new];
    req.exit.roomId= self.sessionInfo.uuid;
    req.skey = DZActiveAuthSession.token;
    
    DZAlertShowLoading(@"退出...");
    DZAlertDisableIntereact;
    [req setErrorHandler:^(NSError *error) {
        DZAlertEnableIntereact;
        DZAlertShowError(error.localizedDescription);
    }];
    
    __weak typeof(self) weakSelf = self;
    [req setSuccessHanlder:^(id object) {
        DZAlertHideLoading
        DZAlertEnableIntereact;
        [weakSelf onHanldeExit];
    }];
    
    [req start];
}

- (void) onHanldeExit
{
    [self.env.navigationController popViewControllerAnimated:YES];
    [[YHContactsManager shareManager] registerActiveRoominfo:nil];
}

- (void) showActions
{
    
    NSMutableArray* items = [NSMutableArray new];
    KxMenuItem* firend = [KxMenuItem menuItem:@"举报房间" image:DZCachedImageByName(@"ic_action_report") target:self action:@selector(reportThisRoom)];
    [items addObject:firend];
    KxMenuItem* exit = [KxMenuItem menuItem:@"退出房间" image:DZCachedImageByName(@"ic_action_exit") target:self action:@selector(exitThisRoom)];
    [items addObject:exit];
    
#ifdef MESSAGE_TEST
    if (self.isAutoSending) {
        KxMenuItem* close = [KxMenuItem menuItem:@"关闭自动发送" image:DZCachedImageByName(@"ic_action_exit") target:self action:@selector(stopAutoSend)];
        [items addObject:close];
    } else {
        KxMenuItem* close = [KxMenuItem menuItem:@"开始自动发送" image:DZCachedImageByName(@"ic_action_exit") target:self action:@selector(startAutoSend)];
        [items addObject:close];
    }
#endif
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.origin.x = CGRectGetWidth(self.env.view.bounds) - 20;
    rect.origin.y = CGRectGetHeight(self.env.navigationController.navigationBar.bounds) + 20;
    [KxMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:rect menuItems:items];
}
@end
