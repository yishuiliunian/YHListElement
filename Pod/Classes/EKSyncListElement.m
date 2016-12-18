//
//  EKSyncListElement.m
//  YaoHe
//
//  Created by stonedong on 16/7/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKSyncListElement.h"
#import "EKSyncListViewController.h"
#import <YHNetCore/YHNetCore.h>
#import "UIViewController+ActivityNavigationBar.h"
@interface EKSyncListElement ()
@property (nonatomic, assign) BOOL searchingNew;
@property (nonatomic, assign) BOOL searchingOld;
@end

@implementation EKSyncListElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _searchingNew = NO;
    _searchingOld = NO;
    _searchModel = EKSyncListElementModelNormal;
    self.protectSearchNull = NO;
    return self;
}
- (instancetype) initWithModel:(EKSyncListElementModel)model
{
    self = [self init];
    if (!self) {
        return self;
    }
    _searchModel = model;
    return self;
}
- (EKSyncListViewController*) listViewController
{
    return (EKSyncListViewController*)self.env;
}

- (void) reloadData
{
    if (self.searchModel == EKSyncListElementModelNormal) {
        [self EKSyncListGetNewData];
    }
}
- (int64_t) lastNewestID
{
    return 0;
}
- (void) EKSyncListGetOldData
{
    if (self.searchingOld) {
        return;
    }
    if (self.keyword.length == 0 && self.protectSearchNull) {
        [self endUISyncFooter];
        [self.tableView reloadData];
        return;
    }
    [self handleSyncOldData];
}

- (void) EKSyncListGetNewData
{
    if (self.searchingNew) {
        return;
    }
    if (self.protectSearchNull && self.keyword.length == 0) {
        [self endUISyncHeader];
        [self.tableView reloadData];
        return;
    }
    [self handleSyncNewData];
}
- (void) endUISyncFooter
{
    [self.eventBus performSelector:@selector(EKEndSyncFooter)];
}


- (YHRequest*) syncNewDataReqeust
{
    return nil;
}

- (YHRequest*) syncOldDataReqeust
{
    return nil;
}



- (void) handleSyncOldData
{
    __weak typeof(self) weakSelf = self;
    self.searchingOld = YES;
    
    YHBaseRequest* request = [self syncOldDataReqeust];
    
    [self.listViewController increaseActivityCount];
    [request setErrorHandler:^(NSError * error) {
        [weakSelf endUISyncFooter];
        weakSelf.searchingOld = NO;
        [weakSelf.listViewController decreaseActivityCount];
    }];
    
    [request setSuccessHanlder:^(SearchActionResponse* object) {
        NSArray* elements = [self transfromResponseToElements:object];
        [self loadDatas:elements];
        weakSelf.searchingOld = NO;
        [weakSelf endUISyncFooter];
        [weakSelf.listViewController decreaseActivityCount];
    }];
    
    [request start];
}
- (void) loadDatas:(NSArray*)array
{
    [_dataController updateObjects:array];
    [_dataController sortUseBlock:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [self.tableView reloadData];
}
- (void) reloadAllContanierData:(NSArray*)allData
{
    [_dataController clean];
    [_dataController updateObjects:allData];
    [_dataController sortUseBlock:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [self.tableView reloadData];
}

- (NSArray*) transfromResponseToElements:(id)response
{
    return @[];
}

- (void) handleSyncNewData
{
    __weak typeof(self) weakSelf = self;
    self.searchingNew = YES;
    YHBaseRequest* request = [self syncNewDataReqeust];
    [self.listViewController increaseActivityCount];
    [request setErrorHandler:^(NSError * error) {
        [weakSelf endUISyncHeader];
        weakSelf.searchingNew = NO;
        [weakSelf.listViewController decreaseActivityCount];
    }];
    
    [request setSuccessHanlder:^(SearchActionResponse* object) {
        NSArray* elements = [self transfromResponseToElements:object];
        [self reloadAllContanierData:elements];
        [weakSelf endUISyncHeader];
        weakSelf.searchingNew = NO;
        [weakSelf.listViewController decreaseActivityCount];
    }];
    
    [request start];
}
- (void) endUISyncHeader
{
    [self.eventBus performSelector:@selector(EKEndSyncHeader)];
}
- (void) willBeginHandleResponser:(EKSyncListViewController *)responser
{
    [super willBeginHandleResponser:responser];
    [self.eventBus addHandler:self priority:1 port:@selector(EKSyncListGetOldData)];
    [self.eventBus addHandler:self priority:1 port:@selector(EKSyncListGetNewData)];
}
- (void) searchListHandleKeywords:(NSString *)keywords
{
    [_dataController clean];
    [self.tableView reloadData];
    self.keyword = keywords;
    [self EKSyncListGetNewData];
}

- (void) onHandleSearchListCreateItem
{
    
}

- (void) didBeginHandleResponser:(EKSyncListViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(EKSyncListViewController *)responser
{
    [super willRegsinHandleResponser:responser];
}

- (void) didRegsinHandleResponser:(EKSyncListViewController *)responser
{
    [super didRegsinHandleResponser:responser];
}
@end
