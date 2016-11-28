//
//  DZFunScene.m
//  YaoHe
//
//  Created by stonedong on 16/8/11.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "DZFunScene.h"
#import "DZFunSprite.h"
@interface DZFunScene ()
{
    NSMutableArray* _sprites;
    int _firedCount;
}
@end

@implementation DZFunScene

 +(NSDictionary*) funKeyImgeNameMap
{
    return @{
             @"生日快乐":@"97px-Emote14",
             @"谢谢哈":@"fun_crab",
             @"下雪":@"emoji_177",
             @"音乐响起":@"emoji_203",
             @"开饭":@"emoji_040",
             @"下课啦":@"emoji_060",
             @"嫁给我":@"emoji_066",
             @"上课了":@"emoji_069",
             @"打雷了":@"emoji_078",
             @"吃屎去吧":@"emoji_080",
             @"吓死我了":@"emoji_018",
             @"掌声响起":@"emoji_024",
             @"吃我一拳":@"emoji_021",
             @"打篮球去":@"emoji_206",
             @"这个软件的作者是谁？":@"AuthAvatar"
             };
}

- (instancetype) initWithRootView:(UIScrollView *)aView
{
    self = [super init];
    if (!self) {
        return self;
    }
    _rootView = aView;
    _sprites = [NSMutableArray new];
    _spriteCount = 40;
    return self;
}

- (void) fireASprite
{
    _firedCount--;
    float randomTime = 1.5+rand()%100/100.0*0.5;
    float randomStartTime = rand()%100/100.0*1.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomStartTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DZFunSprite* sprite = [DZFunSprite new];
        sprite.image = self.image;
        CGFloat startX = CGRectGetWidth(self.rootView.frame) * (rand()%100)/100.0;
        CGFloat startY = self.rootView.contentOffset.y + rand()%100/100.0*20;
        
        CGPoint startPoint = CGPointMake(startX, startY);
        CGPoint endPoint = CGPointMake(startX, CGRectGetHeight(self.rootView.frame) + self.rootView.contentOffset.y);
        
        CGSize imageSize = sprite.randomSize;
        float randomRitio = (0.8 + 0.4* (rand()%100)/100.0);
        imageSize.width = imageSize.width * randomRitio;
        imageSize.height= imageSize.height* randomRitio;
 
        CGRect startR = (CGRect){startPoint, imageSize};
        CGRect  endR = (CGRect){endPoint, imageSize};
        
        [self.rootView addSubview:sprite];
        sprite.frame = startR;
        [UIView animateWithDuration:randomTime animations:^{
            sprite.frame = endR;
        } completion:^(BOOL finished) {
            [sprite removeFromSuperview];
            if (_firedCount > 0) {
                [self fireASprite];
            } else {
                [self stop];
            }
        }];
    });
}

- (void) startWithImage:(UIImage*)image
{
    self.image = image;
    _firedCount = self.spriteCount;
    for (int i = 0; i < 15; i++) {
        [self fireASprite];
    }
}

- (void) stop
{
    _firedCount = 0;
}

@end
