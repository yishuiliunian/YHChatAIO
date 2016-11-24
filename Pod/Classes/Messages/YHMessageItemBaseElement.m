//
//  YHMessageItemBaseElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHMessageItemBaseElement.h"
#import "YHMessageItemBaseCell.h"
#import "DZAuthSession.h"
#import "DZGeometryTools.h"
#import "DZImageCache.h"
#import "YHSendMessageRequest.h"
#import "YHAppearance.h"
#import "YHCoreDB.h"
#import "FLAnimatedImage.h"
#import "YHNotifications.h"
#import <DateTools/DateTools.h>
#import "YYText.h"
#import "YHMessageSendManager.h"
#import "UIView+SingleClick.h"
#import "YHUserInfoViewController.h"
#import "YHUserInfoElement.h"
#import "YHCommonCache.h"
#import "RpcAccountMessage.pbobjc.h"
#import "QBPopupMenu.h"
#import "YHTextMessageElement.h"
#import "YHC2CChatElement.h"
#import "YHActionChatElement.h"
#import "YHChatClassElement.h"
#import "YHSystemChatElement.h"
#import "YHToastMessageElement.h"
#import "YHImageMessageElement.h"
#import "YHLocationMessageElement.h"
#import "YHAudioMessageElement.h"
#import "YHUnsupportElement.h"

static CGSize kAvatarSize = {44, 44};
static CGFloat kNickHeight = 25;
static CGFloat kContentXMargin = 40;
static CGSize kSpaceSize = {20, 14};


@interface YHMessageItemBaseElement () <DZChatMessageBaseCellStatusDelegate,  YHMessageItemBaseCellInteractDelegate>
{
    CGRect _timeLineRect;
    NSAttributedString* _timeString;
    CGFloat _maxWidth;
    CGRect _bottomIndicatorRect;
    NSAttributedString* _bottomString;
}
@property (nonatomic, strong) UIImage*  leftBubble;
@property (nonatomic, strong) UIImage* rightBubble;
@property (nonatomic, strong, readonly) YHMessageItemBaseCell* messageCell;
@property (nonatomic, weak)     UIAlertController* resendAlert;
@property (nonatomic, strong) NSDate* updateUserInfoDate;
@property (nonatomic, assign) YHSendingStatus resendingOldStatus;
@end
@implementation YHMessageItemBaseElement
@synthesize sendByMe = _sendByMe;


+ (YHMessageItemBaseElement*) elementWithYHMessage:(YHMessage*)message
{
    
    YHMessageItemBaseElement* item;
    @try {
        if (message.type == MsgType_Text) {
            item = [[YHTextMessageElement alloc] initWithMsg:message];
        } else if(message.type == MsgType_Image) {
            item = [[YHImageMessageElement alloc] initWithMsg:message];
        } else if (message.type == MsgType_Voice) {
            item = [[YHAudioMessageElement alloc] initWithMsg:message];
        } else if (message.type == MsgType_Location) {
            item = [[YHLocationMessageElement alloc] initWithMsg:message];
        } else if (message.type == MsgType_Toast) {
            item  = [YHToastMessageElement toastElementWithMessage:message];
        } else if(message.type == MsgType_Event) {
            item = nil;
        }else {
            item = [[YHUnsupportElement alloc] initWithMsg:message];
        }
    } @catch (NSException *exception) {
        item = [[YHUnsupportElement alloc] initWithMsg:message];
    } @finally {
        if (!item && message.type != MsgType_Event) {
            item = [[YHUnsupportElement alloc] initWithMsg:message];
        }
    }
    return item;
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHMessageItemBaseCell class];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
    
}

- (NSAttributedString*) readableContentText
{
    NSString* content;
    switch (_msg.type) {
        case MsgType_Text:
        {
            content = @"文本消息";
        }
            break;
        case MsgType_Image:
        {
            content = @"图片消息";
        }
            break;
        case MsgType_Link:
        {
            content = @"链接消息";
        }
            break;
        case MsgType_News:
        {
            content = @"新闻";
        }
            break;
        case MsgType_Toast:
        {
            content = @"提醒消息";
        }
            break;
        case MsgType_Video:
        {
            content = @"视频消息";
        }
            break;
        case MsgType_Event:
        {
            content = @"新事件";
        }
            break;
        case MsgType_Location:
        {
            content = @"位置消息";
        }
            break;
        case MsgType_Shortvideo:
        {
            content = @"短视频消息";
        }
            break;
        case MsgType_Voice:
        {
            content = @"语音消息";
        }
            break;
        default:
            content = @"新消息";
            break;
    }
    return [[NSAttributedString alloc] initWithString:content];
}


- (void) buildMsgContent
{
    UserProfile* profile = [[YHCommonCache shareCache] memoryFetchUserProfile:_userUUID];
    
    if (profile) {
        self.nickName = profile.readNick;
        self.faceURL = DZ_STR_2_URL(profile.faceURL);
    } else {
        self.nickName = _userUUID;
    }
}
- (instancetype) initWithMsg:(YHMessage*)msg
{
    self = [self init];
    if (!self) {
        return self;
    }

    _msg = msg;

    _sendByMe = [DZActiveAuthSession.userID isEqualToString:_msg.fromAccount];
    if (msg.fromType == UserType_GroupUser || msg.fromType == UserType_ChatroomUser || msg.fromType == UserType_ClassUser) {
        MsgExt* ext = [MsgExt parseFromData:_msg.extention error:nil];
        _userUUID = ext.senderUserName;
        _userType = ext.senderUserType;
    } else if (msg.fromType == UserType_NormalUser) {
        _userUUID = msg.fromAccount;
        _userType = msg.fromType;
    } else if (_sendByMe) {
        _userUUID = DZActiveAuthSession.userID;
        _userType = UserType_NormalUser;
    }
    _yItemSpace = 5;
    _xItemSpace = 3;
    
    if (_msg.msgStatus != YHMessageStatueNormal) {
        if ([[YHMessageSendManager shareManager] isSendingMessage:_msg.msgID]) {
            _sendingStatus = YHSendingStatusSeding;
        } else {
            _sendingStatus = YHSendingStatusError;
        }
    } else {
        _sendingStatus = YHSendingStatusNoSend;
    }
    if (self.sendByMe) {
        _normalTextColor = [UIColor whiteColor];
    } else {
        _normalTextColor = [UIColor blackColor];
    }
    [self buildMsgContent];
    [self caculateLayout];
    [self reloadUserInfoIfCan];
    return self;
}

- (void) caculateLayout
{
    CGFloat cellHeight  = 0;
    [self prepareLayouts:&cellHeight];
    self.cellHeight =cellHeight;
    [self prepareStatueLayouts];
}

- (NSString*) simpleDescription
{
    return @"新消息";
}

- (BOOL) showNickLabel
{
    return _msg.fromType != UserType_NormalUser && !self.sendByMe && _msg.fromType != UserType_SystemUser;
}

- (void) prepareLayouts:(CGFloat* )cellHeight
{
    CGRect contentRect =  [UIScreen mainScreen].bounds;
    contentRect.size.height = 10000;
    static CGFloat timeHeight = 30;
    contentRect = CGRectCenterSubSize(contentRect, kSpaceSize);
    _maxWidth = CGRectGetWidth(contentRect);
    if (_msg.bShowTime && _msg.createTime > 100) {
        CGRectDivide(contentRect, &_timeLineRect, &contentRect, timeHeight, CGRectMinYEdge);
        _timeLineRect = CGRectCenterSubSize(_timeLineRect, CGSizeMake(30, 0));
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:_msg.createTime];
        NSDate* now = [NSDate date];
        
        NSString* tStr;
        if ([date isToday]) {
                tStr = [date formattedDateWithFormat:@"hh:mm a"];
        } else if (date.year == now.year) {
            if ([now daysFrom:date] < 4) {
                tStr = [date formattedDateWithFormat:@"dd日 hh:mm a"];
            } else {
                tStr = [date formattedDateWithFormat:@"MM-dd"];
            }
        } else {
            tStr = [date formattedDateWithFormat:@"yy-MM-dd"];
        }
        _timeString = [self indicatorStringWithText:tStr];
        *cellHeight+= timeHeight;
    } else {
        _timeLineRect = CGRectZero;
    }
    *cellHeight += kSpaceSize.height;
    
    if (self.sendByMe) {
        _horizontalStartEdge = CGRectMaxXEdge;
        _horizontalEndEdge = CGRectMinXEdge;
        
    } else {
        _horizontalStartEdge = CGRectMinXEdge;
        _horizontalEndEdge = CGRectMaxXEdge;
    }
    _bubbleArrowWidth = 10;
   
    if ([self showNickLabel]) {
        CGRectDivide(contentRect, &_nickRect, &contentRect, kNickHeight, CGRectMinYEdge);
        *cellHeight += kNickHeight;
        _nickRect = CGRectShrink(_nickRect, _bubbleArrowWidth, _horizontalStartEdge);
        *cellHeight -=kSpaceSize.height/2;
    } else {
        _nickRect = CGRectZero;
    }
    
    contentRect = CGRectShrink(contentRect, kContentXMargin, _horizontalEndEdge);
    CGRectDivide(contentRect, &_avatarRect, &contentRect, kAvatarSize.width, _horizontalStartEdge);
    _avatarRect.size = kAvatarSize;
    contentRect = CGRectShrink(contentRect, _xItemSpace, _horizontalStartEdge);
    
    if ([self showNickLabel]) {
        _nickRect= CGRectShrink(_nickRect, _xItemSpace + kAvatarSize.width, CGRectMinXEdge);
    }
    _estimateContentRect = contentRect;
}

- (NSAttributedString*) readablePrefixText
{
    NSString* prefix = @"";
    if (_msg.fromType == UserType_GroupUser || _msg.fromType == UserType_ChatroomUser || _msg.fromType == UserType_ClassUser) {
        prefix = _nickName?:prefix;
    } else if (_msg.fromType == UserType_NormalUser) {
        if ([_msg.fromAccount isEqualToString:DZActiveAuthSession.userID]) {
            prefix = @"我";
        }
    }
    prefix = prefix.length ? [NSString stringWithFormat:@"%@:",prefix]: @"";
    return [[NSAttributedString alloc] initWithString:prefix];
}

- (void) prepareStatueLayouts
{
    CGRect statuRect;
    CGSize statuSize = {25,25};
    
    statuRect = CGRectShrink(_bubbleRect, - statuSize.width - _xItemSpace, _horizontalEndEdge);
    CGRect nullRect;
    CGRectDivide(statuRect, &nullRect, &statuRect, CGRectGetWidth(_bubbleRect), _horizontalStartEdge);
    
    statuRect = CGRectCenter(statuRect, statuSize);
    _statusRect = statuRect;
    if (_sendingStatus == YHSendingStatusError) {
        NSString* tStr=  _msg.errorMessage;
        if (tStr.length) {
            _bottomString = [self indicatorStringWithText:tStr];
            CGRect bottomRect;
            bottomRect.origin = (CGPoint) {0, CGRectGetMaxY(_bubbleRect)};
            bottomRect.size = (CGSize) {_maxWidth, 30};
            bottomRect = CGRectCenterSubSize(bottomRect, CGSizeMake(0, 10));
            _bottomIndicatorRect = bottomRect;
            self.cellHeight += 30;
        }

    }
    self.cellHeight += 8;
}

- (NSAttributedString*) indicatorStringWithText:(NSString*)text
{
    YYTextBorder* boarder = [YYTextBorder borderWithFillColor:[UIColor lightGrayColor] cornerRadius:4];
    boarder.insets = UIEdgeInsetsMake(-2, -2, -3, -2);
    NSMutableAttributedString* mAStr = [[NSMutableAttributedString alloc] initWithString:text];
    mAStr.yy_font = [UIFont systemFontOfSize:11];
    mAStr.yy_color = [UIColor whiteColor];
    mAStr.yy_textBackgroundBorder = boarder;
    return mAStr;
}



- (void) layoutCell:(YHMessageItemBaseCell *)cell
{
    [super layoutCell:cell];
    cell.avatarImageView.frame = _avatarRect;
    cell.nickLabel.frame = _nickRect;
    cell.bubleImageView.frame = _bubbleRect;
    cell.sendStatusImageView.frame = _statusRect;
    cell.timeLineLabel.frame = _timeLineRect;
    cell.bottomIndictorLabel.frame = _bottomIndicatorRect;
}
- (void) willBeginHandleResponser:(YHMessageItemBaseCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.chatStatusDelegate = self;

    [self reloadUserInfoIfCan];
    [self loadUI];
    [self showSendingStatusWithCell:cell];
    if (!self.sendByMe && self.msg.fromType != UserType_SystemUser) {
        [cell.avatarImageView addSingleClick:self selector:@selector(handleCheckUserInfo)];
        cell.avatarImageView.userInteractionEnabled = YES;
    }
    cell.interactDelegate = self;
}

- (void) handleCheckUserInfo
{
        YHUserInfoElement* ele = [[YHUserInfoElement alloc] initWithUserID:_userUUID];
        YHUserInfoViewController* vcx = [[YHUserInfoViewController alloc] initWithElement:ele];
    vcx.hidesBottomBarWhenPushed = YES;
        [self.hostViewController.navigationController pushViewController:vcx animated:YES];
}

- (void) reloadUserInfoIfCan
{
    if (self.updateUserInfoDate && [self.updateUserInfoDate timeIntervalSinceNow] < 15*60) {
        return;
    }
    [[YHCommonCache shareCache] fetchUserProfile:_userUUID observer:self];
}

- (void) updateUserInfo:(NSString*)nickName faceURL:(NSString*)faceURL
{
    self.nickName = nickName;
    self.faceURL = DZ_STR_2_URL(faceURL);
    [self loadUI];
    self.updateUserInfoDate = [NSDate date];
}

- (void) loadUI
{
    YHMessageItemBaseCell* cell = self.messageCell;
    if (self.sendByMe) {
        cell.bubleImageView.image = _rightBubbleImage;
        cell.nickLabel.textAlignment = NSTextAlignmentRight;
    } else {
        cell.bubleImageView.image = _leftBubbleImage;
        cell.nickLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (!self.sendByMe) {
        cell.nickLabel.text = self.nickName;
        if (self.msg.fromType == UserType_SystemUser) {
            cell.avatarImageView.image = DZCachedImageByName(@"face_system");
        } else {
            [cell.avatarImageView loadAvatarURL:_faceURL];
        }
    }else {
        [cell.avatarImageView loadAvatarURL:_faceURL];
    }
}

- (void) notifyReadableReady
{
    if (self.readableDelegate) {
        [self.readableDelegate messageElementDidReadyReadable:self];
    }
}

- (void) commonCacheFetchUID:(NSString *)modelId withModel:(id)model
{
  
    SUPER_COMMON_CACHE(modelId, model)
    if (![modelId isEqualToString:_userUUID]) {
        return;
    }
    if ([model isKindOfClass:[UserProfile class]]) {
        UserProfile* userProfile = (UserProfile*)model;
        _faceURL = [NSURL URLWithString:userProfile.faceURL];
        _nickName = userProfile.nick.length ? userProfile.nick : userProfile.userName;
        [self loadUI];
        [self notifyReadableReady];
    }
}
- (void) didBeginHandleResponser:(YHMessageItemBaseCell *)cell
{
    [super didBeginHandleResponser:cell];
    if (!_msg.isRead) {
        _msg.isRead = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [YHActiveDBConnection updateMessage:_msg];
        });
    }
    if (_timeString) {
        cell.timeLineLabel.attributedText = _timeString;
        cell.timeLineLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (_bottomString.length) {
        cell.bottomIndictorLabel.attributedText = _bottomString;
        cell.bottomIndictorLabel.textAlignment = NSTextAlignmentCenter;
    }

}

- (void) showSendingStatusWithCell:(YHMessageItemBaseCell*)cell
{
    switch (_sendingStatus) {
        case YHSendingStatusError:
        {
            self.messageCell.sendStatusImageView.animatedImage = nil;
            self.messageCell.sendStatusImageView.image = DZCachedImageByName(@"alert_error");
        }
            break;
            
        case YHSendingStatusNoSend:
        {
            self.messageCell.sendStatusImageView.animatedImage = nil;
            self.messageCell.sendStatusImageView.image = nil;
        }
            break;
        case YHSendingStatusSeding:
        {
            NSString* path = [[NSBundle mainBundle] pathForResource:@"loading-blue" ofType:@"gif"];
            NSData* data = [NSData dataWithContentsOfFile:path];
            FLAnimatedImage* image = [FLAnimatedImage animatedImageWithGIFData:data];
            self.messageCell.sendStatusImageView.animatedImage = image;
        }
            break;
        default:
            break;
    }
}

- (void) willRegsinHandleResponser:(YHMessageItemBaseCell *)cell
{
    [super willRegsinHandleResponser:cell];
    if (!self.sendByMe) {
        cell.avatarImageView.dz_singleClickTapGesture = nil;
    }
}

- (void) didRegsinHandleResponser:(YHMessageItemBaseCell *)cell
{
    [super didRegsinHandleResponser:cell];
}

- (void) sendOperationDidStart:(YHSendMessageOperation *)op
{
    _sendingStatus = YHSendingStatusSeding;
    [self showSendingStatusWithCell:self.messageCell];

}

- (void) sendOperation:(YHSendMessageOperation *)op onProgress:(float)progress
{
    
}
- (void) sendOperation:(YHSendMessageOperation *)op faild:(NSError *)error
{
    _sendingStatus = YHSendingStatusError;
    [self caculateLayout];
    [self reloadUI];
    [self showSendingStatusWithCell:self.messageCell];
   NSIndexPath* indexPath =  [self visibleIndexPath];
    if (indexPath && indexPath.row != NSNotFound) {
        [self.superTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationBottom animated:YES];
    }

}

- (void) sendOperationSuccess:(YHSendMessageOperation *)op message:(YHMessage *)message
{
    if (self.resendingOldStatus == YHSendingStatusError) {
        _sendingStatus = YHSendingStatusNoSend;
        [self caculateLayout];
        [self reloadUI];
    } else {
        _sendingStatus = YHSendingStatusNoSend;
        [self showSendingStatusWithCell:self.messageCell];
    }
}

- (YHMessageItemBaseCell*) messageCell
{
    return (YHMessageItemBaseCell*)self.uiEventPool;
}


- (BOOL) isEqual:(id)object
{
    if (![object isKindOfClass:[YHMessageItemBaseElement class]]) {
        return NO;
    }
    if ([(YHMessageItemBaseElement*)object msg].msgID == self.msg.msgID) {
        return YES;
    }
    return NO;
}

- (void) chatCellDidTapStatusView:(DZChatMessageBaseCell *)cell
{
    if (_sendingStatus == YHSendingStatusError) {
        if (self.resendAlert) {
            return;
        }
        UIAlertController* alert= [[UIAlertController alloc] init];
        alert.title = @"重发";
        alert.message = @"您将要重新发送该消息，是否发送？";
        __weak typeof(self) weakSelf = self;
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.resendAlert dismissViewControllerAnimated:YES completion:nil];
            weakSelf.resendAlert = nil;
        }];
        
        UIAlertAction* resendAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.resendingOldStatus = self.sendingStatus;
            [[YHMessageSendManager shareManager] sendMessage:_msg withDelegate:self];
            [weakSelf sendOperationDidStart:nil];
            weakSelf.resendAlert = nil;
            [weakSelf.resendAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:resendAction];
        [self.hostViewController presentViewController:alert animated:YES completion:nil];
        self.resendAlert = alert;
        
    }
}

- (void) deleteCurrentMessage
{
    [self.eventBus performSelector:@selector(messageItemElementOccurDelete:) withObject:self];
}

- (NSArray*) customPopupMenu
{
    return nil;
}

- (NSArray*) messagePopUpMenus
{
    NSMutableArray* items = [NSMutableArray new];
    QBPopupMenuItem* item = [[QBPopupMenuItem alloc] initWithTitle:@"删除" target:self action:@selector(deleteCurrentMessage)];
    NSArray* custom = [self customPopupMenu];
    [items addObject:item];
    [items addObjectsFromArray:custom];
    return items;
}

@end
