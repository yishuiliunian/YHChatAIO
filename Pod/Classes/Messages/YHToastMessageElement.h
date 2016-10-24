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

@protocol YHToastValueData <NSObject>
/// 子类型
@property(nonatomic, readwrite) int32_t subType;

/// 子内容
@property(nonatomic, readwrite, copy, null_resettable) NSData *subBody;
@end

@interface YHToastMessageElement : YHMessageItemBaseElement
{
    id<YHToastValueData> _contentData;
    CGRect _toastRect;
}
@end
