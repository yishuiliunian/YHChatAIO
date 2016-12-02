//
//  YHMessageItemBaseElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/4.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>
#import "DZChatUI.h"
#import "RpcPushMessage.pbobjc.h"
#import "YHMessage.h"
#import "YHMessageSendManager.h"
#import "DZChatMessageBaseElement.h"
#import "YHCommonCache.h"
typedef NS_ENUM(NSInteger, YHSendingStatus) {
    YHSendingStatusNoSend = 0,
    YHSendingStatusSeding = 1,
    YHSendingStatusError = 3,
};


@class YHMessageItemBaseElement;
@protocol YHMessageItemBaseElementEvents <NSObject>
- (void) messageItemElementOccurDelete:(YHMessageItemBaseElement*)ele;
@end

@protocol YHMessageReadableReadyDelegate <NSObject>

- (void) messageElementDidReadyReadable:(YHMessageItemBaseElement*)ele;

@end




@interface YHMessageItemBaseElement : DZChatMessageBaseElement  <YHSendMessageDelegate, YHCacheFetcherObsever>
{
    @protected
    YHMessage* _msg;
    //
    CGRect _estimateContentRect;
    CGRect _nickRect;
    CGRect _avatarRect;
    
    CGRect _bubbleRect;
    CGRect _statusRect;
    
    CGRectEdge _horizontalStartEdge;
    CGRectEdge _horizontalEndEdge;
    
    NSString* _userUUID;
    UserType _userType;
    
    //
    CGFloat _bubbleArrowWidth;
    
    CGFloat _yItemSpace;
    CGFloat _xItemSpace;
    //
    UIColor* _normalTextColor;
    
    NSString* _nickName;
    NSURL* _faceURL;
}
@property (nonatomic, assign) YHSendingStatus sendingStatus;
@property (nonatomic, strong) UIImage* leftBubbleImage;
@property (nonatomic, strong) UIImage* rightBubbleImage;
@property (nonatomic,assign,readonly) BOOL sendByMe;
@property (nonatomic, strong,readonly) YHMessage* msg;
@property (nonatomic, strong, readonly) NSString* simpleDescription;
@property (nonatomic, assign) YHMessageStatue msgStatue;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSURL* faceURL;
@property (nonatomic, strong, readonly) NSAttributedString* readableContentText;
@property (nonatomic, strong, readonly) NSAttributedString* readablePrefixText;
@property (nonatomic, weak) id<YHMessageReadableReadyDelegate> readableDelegate;


+ (YHMessageItemBaseElement*) elementWithYHMessage:(YHMessage*)message;
- (instancetype) initWithMsg:(YHMessage*)msg;
- (void) prepareLayouts:(CGFloat* )cellHeight;

/**
 *  Build The identifier message content like , image text and so on
 */
- (void) buildMsgContent;

- (NSAttributedString*) indicatorStringWithText:(NSString*)text;

/**
 *  子类集成，返回在长安的时候自定义的特殊操作
 *
 *  @return 自己的长按操作
 */
- (NSArray*) customPopupMenu;


/**
 *  通知可读内容准备完毕
 */
- (void) notifyReadableReady;

- (BOOL) showNickLabel;
@end
