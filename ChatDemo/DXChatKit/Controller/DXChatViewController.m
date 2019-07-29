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
#import "DXChatVoiceCell.h"

#import <TZImagePickerController.h>
#import <AVFoundation/AVFoundation.h>
#import "DXChatSession.h"

#import "DXChatFile.h"

@interface DXChatViewController ()<UITableViewDataSource, UITableViewDelegate, DXChatInputViewDelegate, DXBaseChatCellDelegate, AVAudioPlayerDelegate, DXChatMessageManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXChatInputView *inputView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) DXChatVoiceCell *playingCell;

@end

@implementation DXChatViewController

- (void)dealloc {
    [[DXChatClient share].messageManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"chat";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[DXChatClient share].messageManager addDelegate:self];
    
    [self _setupUI];
    [self _addMoreViewItems];
    [self _loadData];
}

- (void)tableViewScrollToBottom {
    if (self.dataSource.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataSource.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)_addMoreViewItems {
    DXWeakSelf
    [self.inputView addMoreItemImageName:@"ChatImages.bundle/message_chat_pic" itemName:@"照片" click:^{
        DXStrongSelf
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.showSelectBtn = YES;
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [NSUUID UUID].UUIDString];
            [[SDWebImageManager sharedManager] saveImageToCache:photos.firstObject forURL:[NSURL URLWithString:fileName]];
            
            DXChatFile *chatFile = [DXChatFile new];
            chatFile.FileName = fileName;
            DXChatMessage *message = [DXChatMessage messageWithContent:chatFile.mj_JSONString sessionId:strongSelf.session.sessionId contentType:DXChatMessageTypeImage chatRoomType:strongSelf.session.chatRoomType];
            
            [strongSelf.dataSource addObject:message];
            [strongSelf.tableView reloadData];
            [strongSelf tableViewScrollToBottom];
            
            [[DXChatClient share].sessionManager insertMessage:message];
            [strongSelf _uploadAndSendFileWithMessage:message];
        }];
        [strongSelf presentViewController:imagePickerVc animated:YES completion:nil];
        
    }];
}

- (void)_uploadAndSendFileWithMessage:(DXChatMessage *)message {
    [[DXChatClient share].fileManager uploadFileWithMessage:message success:^(id obj) {
        
        DXChatFile *chatFile = [DXChatFile mj_objectWithKeyValues:obj];
        
        if (message.ContentType == DXChatMessageTypeVoice) {
            chatFile.second = [DXChatFile mj_objectWithKeyValues:message.Content].second;
        }
        
        NSString *newContent = chatFile.mj_JSONString;
        [[DXChatClient share].sessionManager updateLocalMessage:message content:newContent];
        message.Content = newContent;
        [[DXChatClient share].messageManager sendMessage:message];
    } failed:^(NSError *error) {
        message.status = DXChatMessageStatusUploadFailed;
        DXBaseChatCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataSource indexOfObject:message] inSection:0]];
        [cell loadData:message];
        [[DXChatClient share].sessionManager updateLocalMessage:message sendStatus:DXChatMessageStatusUploadFailed];
    }];
}

- (void)_loadData {
    
    [self.dataSource addObjectsFromArray:[[DXChatClient share].sessionManager queryLocalMessagesWithSessionId:self.session.sessionId]];
    
    [self.tableView reloadData];
    
    //这里进来的时候tableview数据还未加载完, 直接滚动到底部有问题, 所以加个伪延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tableViewScrollToBottom];
    });
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

#pragma mark - DXChatMessageManagerDelegate
- (void)receiveMessage:(DXChatMessage *)message {
    if (![message.sessionId isEqualToString:self.session.sessionId]) {
        return;
    }
    
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)receiveReceiptMessage:(DXChatMessage *)message {
    
    [self.dataSource enumerateObjectsUsingBlock:^(DXChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.MessageID isEqualToString:message.MessageID]) {
            obj.status = DXChatMessageStatusSuccess;
            DXBaseChatCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            [cell loadData:obj];
            *stop = YES;
        }
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
    
    DXChatMessage *message = self.dataSource[indexPath.row];
    NSString *identifier = [DXChatMessage generateIdentifierWithMessage:message];
    DXBaseChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        Class class = NSClassFromString([identifier componentsSeparatedByString:@"_"].firstObject);
        cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell loadData:message];
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - DXBaseChatCellDelegate
- (void)tapCell:(DXBaseChatCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DXChatMessage *message = self.dataSource[indexPath.row];
    switch (message.ContentType) {
        case DXChatMessageTypeVoice: {
            //FIXME: 待完善播放细节
            if (self.playingCell) {
                [self.player stop];
                [self.playingCell.voiceImageView stopAnimating];
                if (self.playingCell == cell) {
                    self.playingCell = nil;
                    return;
                }
            }
            
            self.playingCell = (DXChatVoiceCell *)cell;
            [self.playingCell.voiceImageView startAnimating];
            
            DXChatFile *chatFile = [DXChatFile mj_objectWithKeyValues:message.Content];
            
            if ([[DXChatClient share].fileManager isExistMp3File:chatFile.FileName]) {
                [self mp3PlayWithFileName:[[DXChatClient share].fileManager getCachePathWithMp3FileName:chatFile.FileName]];
            }else if ([[DXChatClient share].fileManager isExistMp3File:chatFile.NewFileName]) {
                [self mp3PlayWithFileName:[[DXChatClient share].fileManager getCachePathWithMp3FileName:chatFile.NewFileName]];
            }else {
                [[DXChatClient share].fileManager downloadMp3:chatFile.FileLink fileName:chatFile.NewFileName success:^{
                    [self mp3PlayWithFileName:[[DXChatClient share].fileManager getCachePathWithMp3FileName:chatFile.NewFileName]];
                } failure:^(NSError *error) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)mp3PlayWithFileName:(NSString *)fileName {
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileName] error:nil];
    self.player.delegate = self;
    [self.player play];
}

- (void)tapSendFailButtonWithCell:(DXBaseChatCell *)cell {
    DXChatMessage *sendFailMessage = self.dataSource[[self.tableView indexPathForCell:cell].row];
    sendFailMessage.status = DXChatMessageStatusSending;
    [cell loadData:sendFailMessage];
    
    [[DXChatClient share].sessionManager updateLocalMessage:sendFailMessage sendStatus:DXChatMessageStatusSending];
    
    //FIXME: 发送消息失败后续逻辑
    if (sendFailMessage.status == DXChatMessageStatusUploadFailed) {
        [self _uploadAndSendFileWithMessage:sendFailMessage];
    }else {
        [[DXChatClient share].messageManager sendMessage:sendFailMessage];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.playingCell.voiceImageView stopAnimating];
    self.playingCell = nil;
}

#pragma mark - DXChatInputViewDelegate
- (void)sendText:(NSString *)text {
    DXChatMessage *message = [DXChatMessage messageWithContent:text sessionId:self.session.sessionId contentType:DXChatMessageTypeText chatRoomType:self.session.chatRoomType];
    
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
    
    [[DXChatClient share].sessionManager insertMessage:message];
    [[DXChatClient share].messageManager sendMessage:message];
}

- (void)endConvertWithMP3FileName:(NSString *)fileName seconds:(NSInteger)seconds {
    
    DXChatFile *chatFile = [DXChatFile new];
    chatFile.FileName = fileName;
    chatFile.second = seconds;
    
    DXChatMessage *message = [DXChatMessage messageWithContent:chatFile.mj_JSONString sessionId:self.session.sessionId contentType:DXChatMessageTypeVoice chatRoomType:self.session.chatRoomType];
    
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
    
    [[DXChatClient share].sessionManager insertMessage:message];
    [self _uploadAndSendFileWithMessage:message];
}

- (void)inputViewShow {
    [self tableViewScrollToBottom];
}

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
        _tableView.allowsSelection = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapTableView)];
        tap.cancelsTouchesInView = YES;
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (UIView *)inputView {
    if (_inputView == nil) {
        _inputView = [DXChatInputView new];
        _inputView.delegate = self;
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
