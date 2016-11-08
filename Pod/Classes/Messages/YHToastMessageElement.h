//
//  YHToastMessageElement.h
//  YaoHe
//
//  Created by stonedong on 16/6/30.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>
#import "YHMessageItemBaseElement.h"
#import "YHTextMessageElement.h"


@interface YHToastMessageElement : YHMessageItemBaseElement
{
    
    @protected
    Toast* _toast;
}

+ (YHToastMessageElement*) toastElementWithMessage:(YHMessage*)message;
@end
