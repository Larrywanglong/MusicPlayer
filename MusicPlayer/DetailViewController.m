//
//  DetailViewController.m
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "DetailViewController.h"
#import "MusicPlayerManager.h"
#import "UIView+Transfrom.h"
#import "UIViewExt.h"


#define SCREEN_HEIGHT  CGRectGetHeight([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)


@interface DetailViewController ()
{
    __block UISlider *slider;
    UILabel *labelOne;
    UILabel *labelThree;
    UILabel *labelTwo;
    
    UIScrollView *singerDesView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusic) name:KDidPlayFinish object:nil];
    
    self.view.backgroundColor = [UIColor orangeColor];
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    singerDesView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
    singerDesView.backgroundColor = [UIColor brownColor];
    MusicInfoModel *model = [MusicPlayerManager defaultManger].musicList[self.musicIndex];
    
    singerDesView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*model.desList.count, 0);
    singerDesView.pagingEnabled = YES;
    [self.view addSubview:singerDesView];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(singerDesView.frame)+20, CGRectGetWidth(self.view.frame), 20)];
    pageControl.numberOfPages = model.desList.count;
    pageControl.hidesForSinglePage = YES;
    [self.view addSubview:pageControl];
    
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(singerDesView.frame)+80, SCREEN_WIDTH-40, 20)];
    slider.minimumValue = 0.0;
    slider.value = 5;
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(moveTime:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat space = (SCREEN_WIDTH-100-80*3)/2;
    
    NSArray *list = @[@"上一曲",@"播放",@"下一曲"];
    for (int i=0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50+i*(space+80), SCREEN_HEIGHT-40-80, 80, 80);
        button.layer.cornerRadius = 40;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        [button setTitle:list[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        if (i==1) {
            button.selected = YES;
            [button setTitle:@"暂停" forState:UIControlStateSelected];
        }
        button.backgroundColor = [UIColor brownColor];
        [button addTarget:self action:@selector(doit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    
    labelOne = [[UILabel alloc]initWithFrame:CGRectMake(20, singerDesView.bottom+20, 120, 60)];
    labelOne.text = @"小明《好听》";
    labelOne.numberOfLines = 2;
    [self.view addSubview:labelOne];
    
    labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(20, slider.bottom+10, 80, 30)];
    labelTwo.text = @"00:00";
    [self.view addSubview:labelTwo];
    
    labelThree = [[UILabel alloc]initWithFrame:CGRectMake(slider.right-60, slider.bottom+10, 60, 30)];
    labelThree.text = @"00:00";
    [self.view addSubview:labelThree];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(singerDesView.right-100, singerDesView.bottom+20, 80, 40);
    [button setTitle:@"顺序" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)changeType:(UIButton *)sender{
    [sender jamp];
    static int index = 0;
    index++;
    NSArray *titles = @[@"顺序",@"随机",@"单曲"];
    index = index >= titles.count ? 0 : index ;
    [sender setTitle:titles[index] forState:UIControlStateNormal];
    [MusicPlayerManager defaultManger].loopType = index;
}

- (void)doit:(UIButton *)sender{
    [sender rotation];
    
    switch (sender.tag) {
        case 100:{
            [[MusicPlayerManager defaultManger] back];
            break;
        }
        case 101:{
            sender.selected = !sender.selected;
            sender.selected != YES ? [[MusicPlayerManager defaultManger] pause] :[[MusicPlayerManager defaultManger] play];
            break;
        }
        case 102:{
            [[MusicPlayerManager defaultManger] next];
            break;
        }
            
        default:
            break;
    }
    
}

//滑杆的调用方法
- (void)moveTime:(UISlider *)sender{
    [MusicPlayerManager defaultManger].curTime = sender.value;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    MusicPlayerManager *manager = [MusicPlayerManager defaultManger];
    [manager playMusicWithIndex:self.musicIndex];
    manager.curPlayTime = ^(NSString *curPlayTime){
        labelTwo.text = curPlayTime;
        
    };
    
}

- (void)playMusic{
    
    UIButton *button = [self.view viewWithTag:101];
    button.selected = YES;
    MusicPlayerManager *manager = [MusicPlayerManager defaultManger];
    
    [singerDesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    NSLog(@"%ld",manager.curMusicInfo.desList.count);
    
    //    通过plist里面的图片数据  计算 滚动视图内容的宽度
    singerDesView.contentSize = CGSizeMake(SCREEN_WIDTH*manager.curMusicInfo.desList.count, 0);
    
    //    添加图片到滚动视图
    for (int i=0; i<manager.curMusicInfo.desList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+SCREEN_WIDTH*i, 0, SCREEN_WIDTH, CGRectGetHeight(singerDesView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:manager.curMusicInfo.desList[i]];
        [singerDesView addSubview:imageView];
        
    }
    
    
    slider.maximumValue = [MusicPlayerManager defaultManger].durations;
    
    manager.progress = ^(float progress){
        
        slider.value = progress;
        
    };
    
    labelOne.text = [NSString stringWithFormat:@"  %@《%@》",[MusicPlayerManager defaultManger].curMusicInfo.singer,[MusicPlayerManager defaultManger].curMusicInfo.music];
    [labelOne move];
    labelThree.text = [MusicPlayerManager defaultManger].allTime;
    
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
