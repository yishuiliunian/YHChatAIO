 //
//  YHChatElement.m
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHChatElement.h"
#import "YHMessageItemBaseElement.h"
#import "DZAuthSession.h"
#import "DZImageCache.h"
#import "YHCoreDB.h"
#import "DZAuthSession.h"
#import "YHMessage.h"
#import "YHTextMessageElement.h"
#import "MagicRemind.h"
#import "YHImageMessageElement.h"
#import "DZFileUtils.h"
#import "YHAppearance.h"
#import "YHAudioMessageElement.h"
#import <AVFoundation/AVFoundation.h>
#import "YHNotifications.h"
#import "YHNetNotification.h"
#import "MJRefresh.h"
#import "YHUnsupportElement.h"
#import "Haneke.h"
#import "YHLocationMessageElement.h"
#import "YHLocation.h"
#import "YHC2CChatElement.h"
#import "YHActionChatElement.h"
#import "YHChatClassElement.h"
#import "YHSystemChatElement.h"
#import "YHToastMessageElement.h"
#import "YHAppearance.h"
#import "YHChatHotRoomElement.h"
#import "DZFunScene.h"
#import "DZInputNoticeView.h"
#import <DZChatUI.h>
#import "UIView+SingleClick.h"
#import "YHRemindDefines.h"
#import "DZObjectProxy.h"
#import "YHAppConfig.h"
#import "DZLogger.h"

#import "DZFileUtils.h"
#ifdef MESSAGE_TEST
#import "YHMessageTest.h"
#endif
@interface YHChatElement() <YHMessageItemBaseElementEvents, UIScrollViewDelegate>
{
    NSArray* _serverMessageCache;
    NSTimer* _serverCacheCheckTimer;
#ifdef MESSAGE_TEST
    NSTimer* _sendMessageMachine;
#endif
}
@property (nonatomic, strong) UIImage* leftBubbleImage;
@property (nonatomic, strong) UIImage* rightBubbleImage;
@property (nonatomic, strong) NSArray* serverMessageCache;
@property (nonatomic, assign) int unreadCount;
@end
@implementation YHChatElement
- (void) dealloc
{
    DZRemoveObserverForNewServerMessage(self);
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _leftBubbleImage  = [DZCachedImageByName(@"bubble_left") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 18, 8, 8) resizingMode:UIImageResizingModeStretch];
    _rightBubbleImage  = [DZCachedImageByName(@"bubble_right") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 8, 8, 18) resizingMode:UIImageResizingModeStretch];
    DZAddObserverForNewServerMessage(self,@selector(handleNewServerMessage:));
    self.unreadCount = 0;
    return self;
}

- (void) handleNewServerMessage:(NSNotification*)nc
{
    NSArray* messages = nc.userInfo[@"messages"];
    if (!messages.count) {
        return;
    }

    NSMutableArray* msgs = [NSMutableArray new];
    for (YHMessage* msg  in messages) {
        if ([msg.fromAccount isEqualToString:self.sessionInfo.uuid]) {
            if (msg.msgID == 0) {
                
            }
            [msgs addObject:msg];
        }
    }
    if (msgs.count) {
        [self handleServerMessages:[msgs copy]];
    }
}

+ (YHChatElement*) chatElementWithSessionInfo:(YHChatSessionInfo *)info
{
    switch (info.userType) {
        case UserType_ClassUser:
            return [[YHChatClassElement alloc] initWithSessionInfo:info];
        case UserType_NormalUser:
            return [[YHC2CChatElement alloc] initWithSessionInfo:info];
        case UserType_GroupUser:
            return [[YHActionChatElement alloc] initWithSessionInfo:info];
        case UserType_SystemUser:
            return [[YHSystemChatElement alloc] initWithSessionInfo:info];
        case UserType_ChatroomUser:
            return [[YHChatHotRoomElement alloc] initWithSessionInfo:info];
        default:
            return [[YHChatElement alloc] initWithSessionInfo:info];
            break;
    }
}
- (instancetype) initWithSessionInfo:(YHChatSessionInfo *)info
{
    self = [self init];
    if (!self) {
        return self;
    }
    _sessionInfo = info;
    return self;
}



- (YHMessageItemBaseElement*) __elementWithYHMessage:(YHMessage*)message
{
    YHMessageItemBaseElement* item = [YHMessageItemBaseElement elementWithYHMessage:message];
    item.leftBubbleImage = _leftBubbleImage;
    item.rightBubbleImage = _rightBubbleImage;
    return item;
}

- (void) handleLoadOldMessage
{
    __block int64_t min = INT64_MAX;
    CGFloat offsetY = self.tableView.contentOffset.y;
    YHMessageItemBaseElement* ele = nil;
    if (_dataController.numbersOfObject >0) {
       ele =  [_dataController objectAtIndexPath:EKCreateIndexPath(0, 0)];
    }
    
    [_dataController map:^(id e) {
        if ([e isKindOfClass:[YHMessageItemBaseElement class]]) {
            YHMessageItemBaseElement* ele = (YHMessageItemBaseElement*)e;
            min = MIN(min, ele.msg.msgID);
        }
    }];
    NSArray* array =  [YHActiveDBConnection  message10WithFromMsgID:min sessionID:_sessionInfo.uuid];
    NSMutableArray* eles = [NSMutableArray new];
    for (YHMessage* msg in array) {
        YHMessageItemBaseElement* ele = [self __elementWithYHMessage:msg];
        if (ele) {
            [eles addObject:ele];
            offsetY += ele.cellHeight;
        }
    }
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    NSArray* indexs = [_dataController  insertHeaderObjects:eles atSection:0];
    if (indexs.count) {
        [self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
    }

    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    if (ele) {
        NSIndexPath* indexpath = [_dataController indexPathOfObject:ele];
        CGRect rect = [self.tableView rectForRowAtIndexPath:indexpath];
        [self.tableView setContentOffset:CGPointMake(0, offsetY)];
        [self.tableView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    [self.tableView.mj_header endRefreshing];
}

- (void) reloadData
{
    
    NSArray* array =  [YHActiveDBConnection  message10WithFromMsgID:INT64_MAX sessionID:_sessionInfo.uuid];
    for (YHMessage* msg in array) {
        YHMessageItemBaseElement* ele = [self __elementWithYHMessage:msg];
        if (ele) {
            [_dataController addObject:ele];
        }
    }
    [super reloadData];
    if (array.count) {
        [self scrollToEnd];
    }

}

- (void) createBaseMessageWithData:(void(^)(YHMessage*message))dataProvider
{
    YHMessage* message = [YHMessage new];
    message.msgStatus = YHMessageStatueLocal;
    message.isRead = YES;
    message.createTime = [[NSDate date] timeIntervalSince1970];
    message.fromAccount = DZActiveAuthSession.userID;
    message.fromType = UserType_NormalUser;
    message.toAccount = _sessionInfo.uuid;
    message.toType = _sessionInfo.userType;
    message.msgID = YHActiveDBConnection.genNextMsgId;
    message.seqID = 0;
    message.updateTime = message.createTime;
    if (dataProvider) {
        dataProvider(message);
    }
    message.bShowTime = [YHActiveDBConnection checkWillShowTime:message];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [YHActiveDBConnection updateMessage:message];
        DZPostMessageChangedWithMessage(message);
    });
    YHMessageItemBaseElement* element = [self __elementWithYHMessage:message];
    [[YHMessageSendManager shareManager] sendMessage:message  withDelegate:element];
    
    EKIndexPath indexpath = [_dataController addObject:element];
    NSIndexPath* ocIndexPath = [NSIndexPath indexPathForRow:indexpath.row inSection:indexpath.section];
    [self.tableView beginUpdates];
    if (ocIndexPath.row == 0) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertRowsAtIndexPaths:@[ocIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self.tableView endUpdates];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.tableView.isDragging && !self.tableView.isDecelerating) {
            [self.tableView scrollToRowAtIndexPath:ocIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });


}

- (void) setAllMessageReaded
{
    [YHActiveDBConnection.dbhelper executeDB:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"update  YHMessage set isRead=1 where fromAccount=='%@' or toAccount=='%@'", _sessionInfo.uuid, _sessionInfo.uuid]];
        [[MRStorage shareStorage] updateRemind:YHBuildRemindKey(_sessionInfo.uuid) number:0];
    }];
}
- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    [self setAllMessageReaded];
    self.inputViewController.title = _sessionInfo.nickName ? _sessionInfo.nickName : _sessionInfo.uuid;
    self.inputViewController.backgroundImageView.backgroundColor = DZColorBackgroundGray();
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.eventBus addHandler:self priority:1 port:@selector(messageItemElementOccurDelete:)];
    [self startCheckTimer];
}


- (void) didRegsinHandleResponser:(UIResponder *)responser
{
    [super didRegsinHandleResponser:responser];
    [self.eventBus removeHandler:self prot:@selector(messageItemElementOccurDelete:)];
    [self stopCheckTimer];
}

- (void) didBeginHandleResponser:(UIResponder *)responser
{
    [super didBeginHandleResponser:responser];

}

- (void) startCheckTimer
{
    if (_serverCacheCheckTimer.isValid) {
        return;
    }
    _serverCacheCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkServerCache) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_serverCacheCheckTimer forMode:NSDefaultRunLoopMode];
}

- (void) stopCheckTimer
{
    [_serverCacheCheckTimer invalidate];
    _serverCacheCheckTimer = nil;
}
- (void) checkServerCache
{
    NSArray* serverMessages = nil;
    @synchronized (self) {
        serverMessages = [_serverMessageCache copy];
    }
    if (!serverMessages.count) {
        return;
    }
    NSMutableArray* insertRows = [NSMutableArray new];
    BOOL insertSection = NO;
    for (YHMessage* message in serverMessages) {
        message.isRead = YES;
        YHMessageItemBaseElement* ele = [self __elementWithYHMessage:message];
        if (![_dataController  containsObject:ele]) {
            NSInteger sectionCount = _dataController.numberOfSections;
            EKIndexPath path = [_dataController addObject:ele];
            if (sectionCount != _dataController.numberOfSections) {
                insertSection = YES;
            }
#ifdef MESSAGE_TEST
            int msgID = 0;
            if (message.type == MsgType_Text) {
                Text* text = [Text parseFromData:message.data error:nil];
                NSString* content = [[NSString alloc] initWithData:text.context encoding:NSUTF8StringEncoding];
                if ([content hasPrefix:@"auto-"]) {
                    content = [content substringFromIndex:5];
                }
                msgID = [content intValue];
            }
            [YHMessageTest reportUIReciveMessage:msgID];
#endif
            [insertRows addObject:[NSIndexPath indexPathForRow:path.row inSection:path.section]];
        } else {

            DDLogInfo(@"exist message %@",message);
        }
    }
    if (!insertRows.count) {
        return;
    }
    @try {
        [self.tableView beginUpdates];
        if (insertSection) {
            NSMutableIndexSet* indexSet = [NSMutableIndexSet new];
            for (NSIndexPath* index in insertRows) {
                [indexSet addIndex:index.section];
            }
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [self.tableView insertRowsAtIndexPaths:insertRows withRowAnimation:UITableViewRowAnimationBottom];
        }
        [self.tableView endUpdates];
        NSIndexPath* maxPath = nil;
        for (NSIndexPath* path  in insertRows) {
            if (maxPath.row <= path.row) {
                maxPath = path;
            }
        }
        if (maxPath &&
            !self.tableView.dragging &&
            !self.tableView.isDecelerating &&
            self.tableView.contentOffset.y > (self.tableView.contentSize.height - 4*CGRectGetHeight(self.tableView.bounds))) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:maxPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        } else {
            self.unreadCount += serverMessages.count;
            DZInputTextNoticeView* notice = [DZInputTextNoticeView new];
            notice.text = [NSString stringWithFormat:@"你有%d条新消息",self.unreadCount];
            __weak typeof(self) weakSelf = self;
            [notice setAction:^() {
                [weakSelf scrollToEnd];
                weakSelf.unreadCount = 0;
            }];
            [self.inputViewController showNoticeView:notice];
        }
    } @catch (NSException *exception) {
        [self.tableView reloadData];
    } @finally {
        NSMutableArray* msgs = [NSMutableArray arrayWithArray:_serverMessageCache];
        [msgs removeObjectsInArray:serverMessages];
        if (msgs.count != 0) {
            
        }
        
        _serverMessageCache  = msgs;
    }
}
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.width) {
        
    }
}
- (void) handleServerMessages:(NSArray *)messages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        YHDataBaseConnection* connection = YHActiveDBConnection;
        for (YHMessage* message in messages) {
            message.isRead = YES;
            [connection updateMessageMsg:message.msgID read:YES];
        }
        DZPostMessageChangedWithMessage(messages.lastObject);
        @synchronized (self) {
            NSMutableArray* msgs = [NSMutableArray arrayWithArray:_serverMessageCache];
            for (YHMessage* message in messages) {
                if (![msgs containsObject:message]) {
                    [msgs addObject:message];
#ifdef MESSAGE_TEST
                    int msgID = 0;
                    if (message.type == MsgType_Text) {
                        Text* text = [Text parseFromData:message.data error:nil];
                        NSString* content = [[NSString alloc] initWithData:text.context encoding:NSUTF8StringEncoding];
                        if ([content hasPrefix:@"auto-"]) {
                            content = [content substringFromIndex:5];
                        }
                        msgID = [content intValue];
                    }
                    [YHMessageTest reportServerCacheRecive:msgID];
#endif

                } else
                {
                    NSLog(@"重复了");
                }
            }
            _serverMessageCache = msgs;
        }
    });

}

- (void) inputImage:(UIImage*)image
{
    [self createBaseMessageWithData:^(YHMessage *message) {
        Image* imageData = [Image new];
        imageData.width = image.size.width;
        imageData.height = image.size.height;
        NSString* path = DZTempFilePathWithExtension(@"jpeg");
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:path atomically:YES];
        imageData.URL = DZFilteLocalPath(path);
        message.data = imageData.data;
        message.type = MsgType_Image;
        message.isCheckedDetail = YES;
        [[HNKCache sharedCache] setImage:image forKey:DZGenerateLocalPath(path) formatName:LTHanekeCacheFormatThumb().name];
        message.isCheckedDetail = YES;
    }];
}

- (void) inputVoice:(NSURL*)url
{
    [self createBaseMessageWithData:^(YHMessage *message) {
        Voice* voice = [Voice new];
        voice.mediaId = DZFilteLocalPath(url.path);
        NSURL *urlFile = url;
        AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:nil];
        NSTimeInterval time = audioPlayer.duration;
        voice.duration = time;
        voice.format = @"aac";
        message.type = MsgType_Voice;
        message.data = voice.data;
        message.isCheckedDetail = YES;
    }];
}

- (void) inputText:(NSString*)text
{
    [self createBaseMessageWithData:^(YHMessage *message) {
        Text* textObject = [Text new];
        textObject.context = [text dataUsingEncoding:NSUTF8StringEncoding];
        message.data = textObject.data;
        message.type = MsgType_Text;
        message.isCheckedDetail = NO;
    }];
}

- (void) inputToolbarWillShowMoreFunctions:(DZInputToolbar*)toolbar
{
    [self scrollToEnd];
}

- (void) inputLocation:(YHLocation *)location
{
    [self createBaseMessageWithData:^(YHMessage *message) {
        Location* l = [Location new];
        l.locationX = location.latitude;
        l.locationY = location.longtitude;
        l.title = location.name;
        l.label = location.address;
        message.data = l.data;
        message.type = MsgType_Location;
    }];
}

- (void) messageItemElementOccurDelete:(YHMessageItemBaseElement *)ele
{
    if (ele) {
        NSIndexPath* indexpath = [_dataController indexPathOfObject:ele];
        if (indexpath && indexpath.row!= NSNotFound) {
            [_dataController removeObjectAtIndexPath:EKIndexPathFromNS(indexpath)];
            [self.tableView beginUpdates];
            if (indexpath.row == 0 && [_dataController numberAtSection:indexpath.section] == 0) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [YHActiveDBConnection.dbhelper deleteToDB:ele.msg];
            [self.tableView endUpdates];
        }
    }
}

- (void) tryRemoveNoticeView
{
    if (self.tableView.contentOffset.y > (self.tableView.contentSize.height - CGRectGetHeight(self.tableView.bounds)) - 30) {
        self.inputViewController.inputNoticeView  = nil;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.unreadCount = 0;
    [self tryRemoveNoticeView];
}
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self tryRemoveNoticeView];
}


#ifdef MESSAGE_TEST
- (void) startAutoSend
{
    [_sendMessageMachine invalidate];
    _sendMessageMachine = [NSTimer scheduledTimerWithTimeInterval:0.1 target:[DZWeakProxy proxyWithTarget:self] selector:@selector(autoSendMessage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_sendMessageMachine forMode:NSDefaultRunLoopMode];
    _isAutoSending = YES;
}

- (void) stopAutoSend
{
    [_sendMessageMachine invalidate];
    _sendMessageMachine = nil;
    _isAutoSending = NO;
}
- (void) autoSendMessage
{
    NSString* prefix = @"auto-";
    static int index = 0;
    [self inputText:[NSString stringWithFormat:@"%@%d",prefix,index++]];
}
#endif

@end
