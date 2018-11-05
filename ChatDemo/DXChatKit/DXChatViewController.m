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

#import "DXChatMessage.h"
#import "DXChatDBManager.h"


@interface DXChatViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXChatInputView *inputView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DXChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"chat";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.inputView addMoreItemImageName:@"message_chat_pic" itemName:@"照片" click:^{
        NSLog(@"照片");
    }];
    [self.inputView addMoreItemImageName:@"message_chat_case" itemName:@"病历" click:^{
        NSLog(@"病历");
    }];
    [self.inputView addMoreItemImageName:@"message_chat_voice" itemName:@"语音" click:^{
        NSLog(@"语音");
    }];
    [self.inputView addMoreItemImageName:@"message_chat_video" itemName:@"视频" click:^{
        NSLog(@"视频");
    }];
    [self.inputView addMoreItemImageName:@"message_chat_video" itemName:@"视频" click:^{
        NSLog(@"照片");
    }];
    
    [[DXChatManager share] loginWithUsername:nil password:nil clientId:nil];
    
    [self _loadData];
    [self _setupUI];
}

- (void)_loadData {
    NSArray *messages = [[DXChatDBManager share] queryChatMessages];
    [self.dataSource addObjectsFromArray:messages];
    [self.tableView reloadData];
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *rId = nil;
//    if (indexPath.row == 0) {
//        rId = @"DXChatTextCell_1_1";
//    }else if (indexPath.row == 1) {
//        rId = @"DXChatTextCell_1_2";
//    }else if (indexPath.row == 2) {
//        rId = @"DXChatTextCell_2_1";
//    }else if (indexPath.row == 3) {
//        rId = @"DXChatTextCell_2_2";
//    }else {
//        rId = @"DXChatImageCell_1_1";
//    }
    DXChatMessage *message = self.dataSource[indexPath.row];
    NSString *identifier = [DXChatMessage generateIdentifierWithMessage:message];
    DXBaseChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class class = NSClassFromString([identifier componentsSeparatedByString:@"_"].firstObject);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell loadData:message];
    
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
