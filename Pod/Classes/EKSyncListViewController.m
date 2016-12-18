//
//  EKSyncListViewController.m
//  YaoHe
//
//  Created by stonedong on 16/7/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKSyncListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "YHRefreshNormalHeader.h"
#import "UIViewController+BarItem.h"
#import "EKSyncListViewController.h"
#import "UIViewController+ActivityNavigationBar.h"
@interface EKSyncListViewController () <EKSyncListViewControllerEvents>
@property(nonatomic ,strong) YHRefreshNormalHeader* pullHeader;
@property (nonatomic, strong) MJRefreshBackNormalFooter* pullFooter;
@end

@implementation EKSyncListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    _pullHeader = [YHRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(toggleRefresh)];
    self.tableView.mj_header = _pullHeader;
    
    _pullFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(togglePullOldData)];
    self.tableView.mj_footer = _pullFooter;
    [self.eventBus addHandler:self priority:1 port:@selector(EKEndSyncFooter)];
    [self.eventBus addHandler:self priority:1 port:@selector(EKEndSyncHeader)];
    
    self.tableView.canCancelContentTouches = NO;
    self.tableView.delaysContentTouches = YES;
    [self loadClearBackItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void) EKEndSyncHeader
{
    [_pullHeader endRefreshing];
}

- (void)EKEndSyncFooter
{
    [_pullFooter endRefreshing];
}

- (void) togglePullOldData
{
    [self.eventBus performSelector:@selector(EKSyncListGetOldData) withObject:self];
}

- (void) toggleRefresh
{
    [self.eventBus performSelector:@selector(EKSyncListGetNewData) withObject:self];
}

@end