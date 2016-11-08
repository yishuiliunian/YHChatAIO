//
//  YHToastActionGroupElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastActionGroupElement.h"
#import "YHProtoBuff.h"
#import "YHAppearance.h"
#import <Chameleon.h>

@implementation YHToastActionGroupElement

- (void) buildMsgContent
{
    [super buildMsgContent];
    _groupChange = [EventGroupChange parseFromData:[_toast subBody] error:nil];
    
    [[YHCommonCache shareCache] fetchUserProfile:_groupChange.userName observer:self];
    [[YHCommonCache shareCache] fetchActionGroup:_groupChange.groupId observer:self];
}
- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
    
    NSLog(@"Get Current Class %@",__SEL_CLASS__);
    SUPER_COMMON_CACHE(modelId, model);
    
    void(^ReloadUI)(void) = ^(void) {
        CGFloat height;
        [self prepareLayouts:&height];
        self.cellHeight = height;
        [self reloadUI];
    };
    if ([_groupChange.userName isEqualToString:modelId]) {
        UserProfile* userProfile = (UserProfile*)model;
        _userNick = userProfile.readNick;
        ReloadUI();
        [self notifyReadableReady];
    } else if ([_groupChange.groupId isEqualToString:modelId]) {
        ActionGroup* actionGroup = (ActionGroup*)model;
        _groupName = actionGroup.groupName.length ? actionGroup.groupName : actionGroup.groupId;
        ReloadUI();
        [self notifyReadableReady];
    }
}



@end
