//
//  EKSyncListElement.h
//  YaoHe
//
//  Created by stonedong on 16/7/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>
#import "EKSyncListViewController.h"

typedef NS_ENUM(NSInteger, EKSyncListElementModel) {
    EKSyncListElementModelNormal,
    EKSyncListElementModelSearch,
};

@class YHBaseRequest;
@interface EKSyncListElement : EKAdjustTableElement <EKSyncListViewControllerEvents>
@property (nonatomic, strong) NSString* keyword;
@property (nonatomic, assign, readonly) int64_t lastNewestID;
@property (nonatomic, assign, readonly) int64_t lastOldestID;
@property (nonatomic, assign, readonly) EKSyncListElementModel searchModel;
@property (nonatomic, weak, readonly) EKSyncListViewController* listViewController;
@property (nonatomic, assign) BOOL protectSearchNull;

- (instancetype) initWithModel:(EKSyncListElementModel)model;

- (void) endUISyncFooter;
- (void) endUISyncHeader;



- (YHBaseRequest*) syncNewDataReqeust;
- (YHBaseRequest*) syncOldDataReqeust;
/**
 *  服务器返回了数据,将服务器返回的数据转化成界面上可识别的Element
 *
 *  @param object 服务器返回的数据
 */
- (NSArray*) transfromResponseToElements:(id)response;


/**
 *  解析好数据之后，进行数据加载
 *
 *  @param array 需要加载的数据
 */
- (void) loadDatas:(NSArray*)array;


- (void) searchListHandleKeywords:(NSString *)keywords;

- (void) reloadAllContanierData:(NSArray*)allData;
@end
