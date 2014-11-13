//
//  ViewController.m
//  EGOTableViewPullRefreshAndLoadMore
//
//  Created by chenhao on 14/11/13.
//  Copyright (c) 2014年 chenhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //初始化上拉View，下拉View，tableView
    EGORefreshTableHeaderView *_egoRefreshTableHeaderView;
    BOOL isRefreshing;
    
    LoadMoreTableFooterView *_loadMoreTableFooterView;
    BOOL isLoadMoreing;
    
    UITableView *_tableView;
    
    int dataRows;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isRefreshing = NO;
    isLoadMoreing = NO;
    dataRows = 20;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
   
    //设置委托
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    if (_egoRefreshTableHeaderView == nil) {
        _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0, 0.0-_tableView.bounds.size.height, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        _egoRefreshTableHeaderView.delegate = self;
        [_tableView addSubview:_egoRefreshTableHeaderView];
    }
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    if (_loadMoreTableFooterView == nil) {
        _loadMoreTableFooterView = [[LoadMoreTableFooterView alloc]initWithFrame:CGRectMake(0.0, _tableView.contentSize.height, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        _loadMoreTableFooterView.delegate = self;
        [_tableView addSubview:_loadMoreTableFooterView];
    }
    [self reloadData];
    
}

//每次更新完执行数据源更新和下拉菜单位置更新
- (void)reloadData
{
    [_tableView reloadData];
    _loadMoreTableFooterView.frame = CGRectMake(0.0, _tableView.contentSize.height, _tableView.bounds.size.width, _tableView.bounds.size.height);
}

//ScrollView 的代理方法存在于TableView的delegate代理方法中，一定要设置tableView的delegate
#pragma ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{   
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreTableFooterView loadMoreScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreTableFooterView loadMoreScrollViewDidEndDragging:scrollView];
}

#pragma EGORefreshTableHeaderDelegate Methods

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    isRefreshing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //此处更新处理
        
        sleep(3);
        //重置tableView行数
        dataRows = 20;
        dispatch_sync(dispatch_get_main_queue(), ^{
            //此处完成更新，做数据处理
            isRefreshing = NO;
            [self reloadData];
            
            //更新完成egoView消失动画
            [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
        });
    });
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isRefreshing;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma LoadMoreTableFooterDelegate Methods

-(void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    isLoadMoreing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //加载处理
        
        sleep(3);
        dataRows +=20;
        dispatch_sync(dispatch_get_main_queue(), ^{
            //加载完成处理
            isLoadMoreing = NO;
            [self reloadData];
            
            //加载完成，loadView消失动画
            [_loadMoreTableFooterView loadMoreScrollViewDataSourceDidFinishedLoading:_tableView];
        });
    });
}

-(BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return isLoadMoreing;
}

#pragma TableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UITableViewCellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    
     cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", [indexPath row] + 1];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
