//
//  DZFunSprite.m
//  YaoHe
//
//  Created by stonedong on 16/8/11.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "DZFunSprite.h"

@implementation DZFunSprite


- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    _randomSize = (CGSize){20, 20};
    return self;
}
@end
