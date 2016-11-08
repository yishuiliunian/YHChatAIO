//
//  YHPasswordChangeElement.m
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHPasswordChangeElement.h"
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


@interface YHPasswordChangeElement()
{
    EventPwdChange* _pwdChange;
}
@end
@implementation YHPasswordChangeElement
- (void) buildMsgContent
{
    [super buildMsgContent];
    _pwdChange = [EventPwdChange parseFromData:_toast.subBody error:nil];
}
- (NSMutableAttributedString*) buildToastConentString
{
    NSString* action = nil;
    if (_pwdChange.action == 0) {
        action = @"注册";
    } else if (_pwdChange.action ==1){
        action = @"重置密码";
    } else {
        action = @"未定义操作";
    }
    NSString* output  = [NSString stringWithFormat:@"[%@]%@",action, _pwdChange.content];
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    return mAStr;
}

- (NSString*) gotoDetailText
{
    return @"点击去修改";
}


- (void) handleSelectedInViewController:(UIViewController *)vc
{
 
        [[DZURLRoute defaultRoute] routeURL:[NSURL URLWithString:_pwdChange.URL]];
}


@end
