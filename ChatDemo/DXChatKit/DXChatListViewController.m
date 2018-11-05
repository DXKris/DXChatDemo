//
//  DXChatListViewController.m
//  ChatDemo
//
//  Created by Xu Du on 2018/11/5.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import "DXChatListViewController.h"

@interface DXChatListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DXChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HexColor(0xf0f3f5);
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
