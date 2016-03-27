//
//  MusicInfoModel.m
//  MusicPlayer
//
//  Created by 王龙 on 16/3/21.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel

- (instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:info];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end
