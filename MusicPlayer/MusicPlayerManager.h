//
//  MusicPlayerManager.h
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicInfoModel.h"

#define KDidPlayFinish @"Finish"

typedef NS_ENUM(NSInteger, MusicLoopType) {
    Order,//顺序播放
    Shuffle,//随机播放
    Once//单曲循环
};

@interface MusicPlayerManager : NSObject

@property (nonatomic,assign) float volume;//音量
@property (nonatomic,assign) MusicLoopType loopType; // 音乐播放模式
@property (nonatomic,copy) void(^curPlayTime)(NSString *curPlayTime);//播放的当前时间
@property (nonatomic,copy) NSString *allTime;//音乐总时长
@property (nonatomic,strong) MusicInfoModel *curMusicInfo;//当前播放音乐信息
@property (nonatomic,retain) NSMutableArray <MusicInfoModel *>*musicList;//音乐列表
@property (nonatomic,copy) void(^progress)(float progress) ;//进度
@property (nonatomic,assign) NSTimeInterval durations;//用于进度条
@property (nonatomic,assign) NSTimeInterval curTime;



- (void)play;//播放
- (void)stop;//停止
- (void)pause;//暂停
- (void)next;//下一曲
- (void)back;//上一曲
+ (instancetype)defaultManger;

//根据下标播放音乐的方法
- (void)playMusicWithIndex:(NSInteger)musicIndex;



@end



