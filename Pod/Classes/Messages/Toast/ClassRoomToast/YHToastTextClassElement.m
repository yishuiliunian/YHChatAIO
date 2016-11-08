//
//  YHToastTextClassElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastTextClassElement.h"
#import "YHAppearance.h"
#import "YHCommonCache.h"
#import "YHToastMessageElement.h"
#import "YHToastMessageCell.h"
#import "DZLogger.h"
#import <DZGeometryTools/DZGeometryTools.h>
#import "YHToastMessageCell.h"
#import "YHCommonCache.h"
#import <YHNetCore.h>
#import "YHClassMemberListElement.h"
#import "YHClassMemberListViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "DZURLRoute.h"
@implementation YHToastTextClassElement
- (void) buildMsgContent
{
    [super buildMsgContent];
    _classChange = [EventClassChange parseFromData:[_toast subBody] error:nil];
    
    [[YHCommonCache shareCache] fetchClassRoomProfile:_classChange.classId observer:self];
    [[YHCommonCache shareCache] fetchUserProfile:_classChange.userName observer:self];
}

- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    SUPER_COMMON_CACHE(modelId, model);
    
    void(^ReloadUI)(void) = ^(void) {
        CGFloat height;
        [self prepareLayouts:&height];
        self.cellHeight = height;
        [self reloadUI];
    };
    if ([modelId isEqualToString:_classChange.classId]) {
        ClassInfo* classInfo = (ClassInfo*)model;
        _className = classInfo.clazzName?:classInfo.classId;
        ReloadUI();
        [self notifyReadableReady];
    } else if ([modelId isEqualToString:_classChange.userName]) {
        UserProfile* userProfile = (UserProfile*)model;
        _userName = userProfile.nick.length ? userProfile.nick : userProfile.userName;
        ReloadUI();
        [self notifyReadableReady];
    }
}

@end
