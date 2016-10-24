//
//  DZAIOViewController.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZAIOViewController.h"
#import "MJRefresh.h"
#import "DZAIOTableElement.h"

#import "YHRefreshNormalHeader.h"

@interface YHChatRefreshNormalHeader : YHRefreshNormalHeader

@end


@implementation YHChatRefreshNormalHeader

- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:@"下拉加载历史记录" forState:MJRefreshStateIdle];
    [self setTitle:@"松开立刻加载" forState:MJRefreshStatePulling];
    [self setTitle:@"加载..." forState:MJRefreshStateRefreshing];
}

@end
@interface DZAIOViewController ()

@end
@implementation DZAIOViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    __weak typeof(self) wSelf=self;
    YHChatRefreshNormalHeader* header =[YHChatRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([wSelf.tableElement respondsToSelector:@selector(handleLoadOldMessage)]) {
            [wSelf.tableElement performSelector:@selector(handleLoadOldMessage)];
        }
    }];
    
    [self.tableView setMj_header:header];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
}

@end
