//
//  YHJoinClassElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHJoinClassElement.h"
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
#import "YHURLRouteDefines.h"

@implementation YHJoinClassElement
- (void) buildMsgContent
{
    [super buildMsgContent];
    _classChange = [EventClassChange parseFromData:[_toast subBody] error:nil];
    _userName = _classChange.userName;
    _className = _classChange.clazzName;
    if (_className.length == 0) {
        [[YHCommonCache shareCache] fetchClassRoomProfile:_classChange.classId observer:self];
    }
    [[YHCommonCache shareCache] fetchUserProfile:_classChange.userName observer:self];
}
- (NSMutableAttributedString*) buildToastConentString
{
    NSString* output = [NSString stringWithFormat:@"[%@]申请加入班级[%@]", _userName, _className];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}

- (NSString*) gotoDetailText
{
    return @"点击去审批";
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

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setValue:_classChange.classId forKey:kYHURLQueryParamterUID];
    NSURL* location = DZURLRouteQueryLink(kYHURLYohooClassAuth, params);
    [[DZURLRoute defaultRoute] routeURL:location];
}

@end
