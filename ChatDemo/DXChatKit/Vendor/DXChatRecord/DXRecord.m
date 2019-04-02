//
//  DXRecord.m
//  ChatDemo
//
//  Created by Xu Du on 2018/11/6.
//  Copyright © 2018 Xu Du. All rights reserved.
//

#import "DXRecord.h"
#import <AVFoundation/AVFoundation.h>
#if __has_include(<lame/lame.h>)
#import <lame/lame.h>
#else
#import "lame.h"
#endif

@interface DXRecord ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation DXRecord

- (void)_setSesstion
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
}

#pragma mark - Public
- (void)startRecord {
    [self _setSesstion];
    [self.recorder prepareToRecord];
    [self.recorder record];
}

- (void)stopRecord {
    double cTime = self.recorder.currentTime;
    [self.recorder stop];
    
    if (cTime > 1) {
        [self _cafToMp3];
    } else {
        
        [self.recorder deleteRecording];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(failRecord)]) {
            [self.delegate failRecord];
        }
    }
}

- (void)cancelRecord {
    [_recorder stop];
    [_recorder deleteRecording];
}

- (void)_cafToMp3
{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [[self mp3Path] stringByAppendingPathComponent:[self mp3FileName]];
    
//    ////NSLog(@"MP3转换开始");
//    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)]) {
//        [_delegate beginConvert];
//    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        //NSLog(@"%@",[exception description]);
        mp3FilePath = nil;
    }
    @finally {
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        //NSLog(@"MP3转换结束");
        if (self.delegate && [self.delegate respondsToSelector:@selector(endConvertWithMP3FileName:)]) {
            [self.delegate endConvertWithMP3FileName:[mp3FilePath componentsSeparatedByString:@"/"].lastObject];
        }
        [self _deleteCafCache];
    }
}

- (void)_deleteCafCache
{
    [self _deleteFileWithPath:[self cafPath]];
}

- (void)_deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        //NSLog(@"删除以前的mp3文件");
    }
}

#pragma mark - Getter
- (NSString *)cafPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
}

- (NSString *)mp3Path {
    return [[DXChatClient share].fileManager getMp3CacheDirectory];
}

- (NSString *)mp3FileName {
    return [NSString stringWithFormat:@"%@.mp3", [NSUUID UUID]];
}

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        NSError *recorderSetupError = nil;
        NSURL *url = [NSURL fileURLWithPath:[self cafPath]];
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        //采样率
        [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
        //通道数
        [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        //音频质量,采样质量
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        _recorder = [[AVAudioRecorder alloc] initWithURL:url
                                                settings:settings
                                                   error:&recorderSetupError];
        if (recorderSetupError) {
            //NSLog(@"%@",recorderSetupError);
        }
        _recorder.meteringEnabled = YES;
//        _recorder.delegate = self;
//        [_recorder prepareToRecord];
    }
    return _recorder;
}

@end
