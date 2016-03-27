//
//  MusicPlayerManager.m
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "MusicPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicInfoModel.h"

@interface MusicPlayerManager ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;//音乐播放器的对象
    NSInteger curMusicIndex;//当前音乐播放的下标
    
    
    NSTimer *timer;//用于更新进度和当前播放的时间
}
@end

@implementation MusicPlayerManager

+ (instancetype)defaultManger{
    static MusicPlayerManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[MusicPlayerManager alloc]init];
    });
    return manger;
}

- (NSMutableArray<MusicInfoModel *> *)musicList{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MusicList" ofType:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfFile:path];
    
    if (list.count == _musicList.count) {
        return _musicList;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *info in list) {
        
        [result addObject:[[MusicInfoModel alloc] initWithInfo:info]];
        
    }
    
    
    
    return result;
}

/**
 *  播放音乐的方法
 *
 *  @param musicIndex 当前播放音乐在数组里的下标
 */
- (void)playMusicWithIndex:(NSInteger)musicIndex{
//    获得当前播放的音乐
    self.curMusicInfo = self.musicList[musicIndex];
    
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
        audioPlayer.delegate = nil;
//        TODO:定时器销毁
        
        [timer invalidate];timer = nil;//销毁定时器并置空
    }
    
//    更新 当前播放的音乐下标
    curMusicIndex = musicIndex;
    NSURL *url = [[NSBundle mainBundle]URLForResource:self.musicList[musicIndex].music withExtension:nil];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    self.durations = audioPlayer.duration;
    
    
//    将要播放的时候  提醒使用的类
    [[NSNotificationCenter defaultCenter]postNotificationName:KDidPlayFinish object:nil];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startUpdate) userInfo:nil repeats:YES];
    
    
}
//定时器开启的方法  更新当前时间  当前进度
- (void)startUpdate{
    //    self.curPlayTime = [self returnTime:audioPlayer.currentTime];
    //    self.progress = audioPlayer.currentTime;
    
    //    换成block实现  可以把值传到控制器中
    self.curPlayTime([self returnTime:audioPlayer.currentTime]);
    self.progress(audioPlayer.currentTime);
    
    
}

- (void)setCurTime:(NSTimeInterval)curTime{
    _curTime = curTime;
    audioPlayer.currentTime = _curTime;
}


//设置音量
- (void)setVolume:(float)volume{
    _volume = volume;
    audioPlayer.volume = _volume;
}

//播放的当前时间
//- (void)setCurPlayTime:(NSString *)curPlayTime{
//    NSString *time = [self returnTime:audioPlayer.currentTime];
//    _curPlayTime = [time copy];
//}

//音频的总时间
- (NSString *)allTime{
    NSString *time = [self returnTime:audioPlayer.duration];
    return time;
}

//时间间隔转换成分秒
- (NSString *)returnTime:(NSTimeInterval)timeInterval{
    NSInteger m  = timeInterval/60;
    NSInteger s = (int)timeInterval%60;
    
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
    
    return time;
}

- (void)play{
    if (!audioPlayer.isPlaying) {
        [audioPlayer play];
        timer.fireDate = [NSDate distantPast];
    }
}

- (void)pause{
    if (audioPlayer.isPlaying) {
        [audioPlayer pause];
        timer.fireDate = [NSDate distantFuture];
    }
}
- (void)stop{
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
        [timer invalidate];timer = nil;
    }
}
- (void)next{
    curMusicIndex++;
    //    self.musicList.count 全部音乐的个数 不能超过
    //    超过就返回第0曲
    curMusicIndex = curMusicIndex >= self.musicList.count ? 0 : curMusicIndex;
    [self playMusicWithIndex:curMusicIndex];
    
}
- (void)back{
    curMusicIndex--;
    curMusicIndex = curMusicIndex <0 ?self.musicList.count-1:curMusicIndex;
    [self playMusicWithIndex:curMusicIndex];
    
}

//音乐播放完毕调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.loopType) {
        case Order:{
            [self next];
            break;
        }
        case Shuffle:{
            curMusicIndex = arc4random()%self.musicList.count;
            [self playMusicWithIndex:curMusicIndex];
            break;
        }
        case Once:{
            [self playMusicWithIndex:curMusicIndex];
            break;
        }
        default:
            break;
    }
}






@end
