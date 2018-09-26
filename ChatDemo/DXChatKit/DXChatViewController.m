//
//  DXChatViewController.m
//  ChatDemo
//
//  Created by Xu Du on 2018/8/21.
//  Copyright © 2018年 Xu Du. All rights reserved.
//

#import "DXChatViewController.h"

#import "DXChatInputView.h"

#import "DXBaseChatCell.h"

@interface DXChatViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXChatInputView *inputView;

@end

@implementation DXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"chat";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[DXChatManager share] loginWithUsername:nil password:nil clientId:nil];
    
    [self _setupUI];
}

- (void)_setupUI {
    
    //inputView的高度在内部根据内容自适应
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.inputView.mas_top);
    }];
}

#pragma mark - Listen
- (void)_tapTableView {
    [self.inputView initChatToolBar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *rId = nil;
    if (indexPath.row == 0) {
        rId = @"DXChatTextCell_1_1";
    }else if (indexPath.row == 1) {
        rId = @"DXChatTextCell_1_2";
    }else if (indexPath.row == 2) {
        rId = @"DXChatTextCell_2_1";
    }else if (indexPath.row == 3) {
        rId = @"DXChatTextCell_2_2";
    }else {
        rId = @"DXChatImageCell_1_1";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rId];
    if (cell == nil) {
        Class class = NSClassFromString([rId componentsSeparatedByString:@"_"].firstObject);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rId];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HexColor(0xf0f3f5);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapTableView)];
        tap.cancelsTouchesInView = YES;
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (UIView *)inputView {
    if (_inputView == nil) {
        _inputView = [DXChatInputView new];
    }
    return _inputView;
}

@end
