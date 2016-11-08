//
//  YHToastTextClassElement.h
//  Pods
//
//  Created by stonedong on 16/11/8.
//
//

#import "YHToastTextElement.h"

@class EventClassChange;
@interface YHToastTextClassElement : YHToastTextElement
{
    @protected
    EventClassChange* _classChange;
    NSString* _userName;
    NSString* _className;
}
@end
