//
//  DXChatListViewController.m
//  ChatDemo
//
//  Created by Xu Du on 2018/11/5.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import "DXChatListViewController.h"
#import "DXChatViewController.h"

#import "DXChatSession.h"

@interface DXChatListViewController ()<UITableViewDataSource, UITableViewDelegate, DXChatSessionManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<DXChatSession *> *sessions;

@end

@implementation DXChatListViewController

- (void)dealloc {
    [[DXChatClient share].sessionManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadData];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [[DXChatClient share].sessionManager addDelegate:self];
}

- (void)_loadData {
    
    self.sessions = [[DXChatClient share].sessionManager querySessions];
    [self.tableView reloadData];
}

#pragma mark - DXChatSessionManagerDelegate
- (void)sessionUpdated {
    [self _loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DXChatSession *session = self.sessions[indexPath.row];
    
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.textLabel.text = session.lastMessage.Content;
    
    return cell;
}

#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DXChatViewController *chatViewVc = [DXChatViewController new];
    chatViewVc.session = self.sessions[indexPath.row];
    [self.navigationController pushViewController:chatViewVc animated:YES];
}

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
