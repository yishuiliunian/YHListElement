//
//  EKSyncListElement.h
//  YaoHe
//
//  Created by stonedong on 16/7/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>


@protocol EKSyncListViewControllerEvents <NSObject>
@optional
- (void) EKSyncListGetNewData;
- (void) EKSyncListGetOldData;

- (void) EKEndSyncFooter;
- (void) EKEndSyncHeader;

@end

@interface EKSyncListViewController : EKTableViewController
- (void) endHeaderRefresh;
- (void) endFooterRefresh;
@end
