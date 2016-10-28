//
//  YHToastMessageElement.m
//  YaoHe
//
//  Created by stonedong on 16/6/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
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

 int32_t const EVENT_TROOP_MEMBER_KILL = 0x4001;//事件（全员） + 被踢者收系统消息
 static  int32_t  const  EVENT_TROOP_CLOSE = 0x4002;//群关闭 = 事件 （非全员，群主不用收该事件） + 所有人收到关群的系统消息(包括群主)
 static  int32_t  const EVENT_TROOP_MEMBER_JOIN = 0x4003;//事件（非全员，入群者不用收该事件）
 static  int32_t  const EVENT_TROOP_MEMBER_QUIT = 0x4004;//事件（非全员，退群者不用收该事件）
 static  int32_t const  EVENT_CLASS_CLOSE = 0x4010;//群关闭 = 事件 （非全员，班长不用收该事件） + 所有人收到班级关闭的系统消息（包括班长）
static int32_t const EVENT_CLASS_JOIN = 0x4011; //有人申请加入班级
 static  int32_t const  EVENT_LOVEWALL_NEW = 0x4020;//有人表白

@interface YHToastMessageElement () <YHCacheFetcherObsever>
{
    Toast* _toast;
    YYTextLayout* _textLayout;
    
    NSString* _userID;
    NSString* _userNick;
    NSString* _groupID;
    NSString* _groupName;
    NSString* _className;
    NSString* _classID;
}
@end

@implementation YHToastMessageElement


- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHToastMessageCell class];
    return self;
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
    if ([_userID isEqualToString:modelId]) {
        UserProfile* userProfile = (UserProfile*)model;
        _userNick = userProfile.nick.length ? userProfile.nick : _userID;
        ReloadUI();
        [self notifyReadableReady];
    } else if ([_groupID isEqualToString:modelId]) {
        ActionGroup* actionGroup = (ActionGroup*)model;
        _groupName = actionGroup.groupName.length ? actionGroup.groupName : _groupID;
        [self notifyReadableReady];
    } else if ([_classID isEqualToString:modelId] && [model isKindOfClass:[ClassInfo class]]) {
        ClassInfo* classInfo = (ClassInfo*)model;
        _className = classInfo.clazzName?:_groupID;
        [self notifyReadableReady];
    }
}
- (NSAttributedString*) readableContentText
{
    if ([_textLayout.text isKindOfClass:[NSAttributedString class]]) {
        return [[NSAttributedString alloc] initWithString:(_textLayout.text.string.length?_textLayout.text.string:@"")];
     } else
     {
         return [[NSAttributedString alloc] initWithString:@""];
     }
}

- (void) buildMsgContent
{
    [super buildMsgContent];
    NSError* error;
    _contentData = (id<YHToastValueData>)[Toast parseFromData:self.msg.data error:&error];
    if (error) {
        DDLogError(@"%@",error);
    }
    switch ([_contentData subType]) {
        case EVENT_TROOP_MEMBER_JOIN:
            case EVENT_TROOP_MEMBER_KILL:
            case EVENT_TROOP_MEMBER_QUIT:
        {
            EventGroupChange* change = [EventGroupChange parseFromData:[_contentData subBody] error:nil];
            _userID = _userNick = change.userName;
            _groupID =_groupName = change.groupId;
            [[YHCommonCache shareCache] fetchUserProfile:_userID observer:self];
            [[YHCommonCache shareCache] fetchActionGroup:_groupID observer:self];
            break;
        }
            case EVENT_CLASS_JOIN:
            case EVENT_CLASS_CLOSE:
        {
            EventClassChange* change = [EventClassChange parseFromData:[_contentData subBody] error:nil];
            _userID = _userNick = change.userName;
            _classID =  change.classId;
            _className  = change.clazzName;
            if (_userID.length) {
                [[YHCommonCache shareCache] fetchUserProfile:_userNick observer:self];
            }
            if (_classID.length && _className.length == 0) {
                [[YHCommonCache shareCache] fetchClassRoomProfile:_classID observer:self];
            }
            break;
        }
    }
}

- (NSMutableAttributedString*) buildContentText
{
    UIFont* font = [UIFont systemFontOfSize:14];
    NSString* output = @"";
    switch ([_contentData subType]) {
        case EVENT_TROOP_MEMBER_KILL:
            output = [output stringByAppendingFormat:@"成员[%@]被移出了群[%@]", _userNick, _groupName];
            break;
        case EVENT_TROOP_CLOSE:
            output = [output stringByAppendingFormat:@"群[%@]已关闭", _groupName];
            break;
        case EVENT_TROOP_MEMBER_JOIN:
            output = [output stringByAppendingFormat:@"[%@]加入了群[%@]", _userNick,_groupName];
            break;
        case EVENT_TROOP_MEMBER_QUIT:
            output = [output stringByAppendingFormat:@"[%@]退出了群[%@]",_userNick, _groupName];
            break;
        case EVENT_CLASS_CLOSE:
            output = [output stringByAppendingFormat:@"班级[%@]已经解散", _className];
            break;
        case EVENT_LOVEWALL_NEW:
            output = [output stringByAppendingFormat:@"有人向您表白了，啦啦啦"];
            break;
        case EVENT_CLASS_JOIN:
            output = [output stringByAppendingFormat:@"[%@]申请加入班级[%@]", _userNick, _className];
            break;
        default:
            output = @"系统通知，请升级版本查看";
            break;
    }
    YYTextBorder* boarder = [YYTextBorder borderWithFillColor:[UIColor flatWhiteColorDark] cornerRadius:4];
    boarder.insets = UIEdgeInsetsMake(-2, -2, -3, -2);
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:output];
    mAStr.yy_font = font;
    mAStr.yy_color = [UIColor whiteColor];
    mAStr.yy_textBackgroundBorder = boarder;
    return mAStr;
}
- (void) prepareLayouts:(CGFloat *)cellHeight
{
    [super prepareLayouts:cellHeight];
    CGRect contentRect =  [UIScreen mainScreen].bounds;
    contentRect = CGRectCenter(contentRect, _estimateContentRect.size);
    contentRect.origin.y = _estimateContentRect.origin.y;
    NSMutableAttributedString* str = [self buildContentText];
    if ([_contentData subType] == EVENT_CLASS_JOIN) {
        str.yy_color = [UIColor flatBlueColor];
    }
    YYTextLayout* layout = [YYTextLayout layoutWithContainerSize:contentRect.size text:str];
    CGSize size  = layout.textBoundingSize;
    _textLayout = layout;
    size.height += 4;
    size.width += 4;
    *cellHeight += size.height;
    
    CGRect restRect;
    CGRectDivide(contentRect, &_toastRect, &restRect, size.height, CGRectMinYEdge);
    _avatarRect = CGRectZero;
    _bubbleRect = CGRectZero;
}

- (void) layoutCell:(YHToastMessageCell *)cell
{
    [super layoutCell:cell];
    cell.textContentLabel.frame = _toastRect;
}
- (void) willBeginHandleResponser:(YHToastMessageCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.textContentLabel.textLayout = _textLayout;
    cell.textContentLabel.textAlignment = NSTextAlignmentCenter;
}

- (void) didBeginHandleResponser:(YHToastMessageCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHToastMessageCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHToastMessageCell *)cell
{
    [super didRegsinHandleResponser:cell];
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    [super handleSelectedInViewController:vc];
    if ([_contentData subType] == EVENT_CLASS_JOIN) {
        YHClassMemberListElement* ele =[[YHClassMemberListElement alloc] initWithClassID:_classID];
        ele.state  = 0;
        YHClassMemberListViewController* classVC = [[YHClassMemberListViewController alloc] initWithElement:ele];
        [self.hostViewController.navigationController pushViewController:classVC animated:YES];
    }
}

@end
