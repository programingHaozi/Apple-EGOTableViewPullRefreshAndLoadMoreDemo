//
//  ViewController.h
//  EGOTableViewPullRefreshAndLoadMore
//
//  Created by chenhao on 14/11/13.
//  Copyright (c) 2014年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
@interface ViewController : UIViewController<EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate,UITableViewDataSource,UITableViewDelegate>


@end

