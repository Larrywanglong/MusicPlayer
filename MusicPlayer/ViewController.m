//
//  ViewController.m
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayerManager.h"
#import "DetailViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"音乐列表";
    self.view.backgroundColor = [UIColor greenColor];
    myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MusicPlayerManager defaultManger].musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ID" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    MusicInfoModel *model = [MusicPlayerManager defaultManger].musicList[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:25];
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    cell.imageView.image = [UIImage imageNamed:model.singerIcon];
    cell.textLabel.text = model.music;
    cell.detailTextLabel.text = model.singer;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.musicIndex = indexPath.row;
    [self.navigationController pushViewController:detail animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
