//
//  YHJoinClassElement.h
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastCardMessageElement.h"
@class EventClassChange;
@interface YHJoinClassElement : YHToastCardMessageElement
{
@protected
    EventClassChange* _classChange;
    NSString* _userName;
    NSString* _className;
}
@end
