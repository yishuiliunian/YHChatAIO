//
//  DZFunScene.h
//  YaoHe
//
//  Created by stonedong on 16/8/11.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DZFunScene : NSObject
+ (NSDictionary*) funKeyImgeNameMap;
@property (nonatomic, strong, readonly) UIScrollView* rootView;
@property (nonatomic, assign) int spriteCount;
@property (nonatomic, strong) UIImage* image;
- (instancetype) initWithRootView:(UIScrollView*)aView;
- (void) startWithImage:(UIImage*)image;
@end
