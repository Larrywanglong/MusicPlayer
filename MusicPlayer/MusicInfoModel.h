//
//  MusicInfoModel.h
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfoModel : NSObject

@property (nonatomic,copy) NSString *singer;
@property (nonatomic,copy) NSString *music;
@property (nonatomic,copy) NSString *singerIcon;
@property (nonatomic,copy) NSArray *desList;

- (instancetype)initWithInfo:(NSDictionary *)info;

@end
