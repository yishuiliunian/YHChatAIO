//
//  YHToastActionGroupElement.h
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastTextElement.h"
@class EventGroupChange;
@interface YHToastActionGroupElement : YHToastTextElement
{
    @protected
    //
    NSString* _userNick;
    NSString* _groupName;
    //
    EventGroupChange* _groupChange;
}
@end
