//
//  UIView+Transfrom.m
//  BabyBox
//
//  Created by Bruce on 16/1/15.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "UIView+Transfrom.h"


#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
@implementation UIView (Transfrom)

- (void)jamp{
    
    static int scale = 1;
    
    [UIView animateWithDuration:0.2 animations:^{
        scale = scale==1?2:1;
        self.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            scale = scale==1?2:1;
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }];
}

- (void)rotation{
   
    [UIView animateWithDuration:0.5 animations:^{
       
        self.transform = CGAffineTransformMakeRotation(180*M_PI/180);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            self.alpha = 1.0;
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}



- (void)move{
    
    CGPoint myCenter = self.center;
    [UIView animateWithDuration:3   animations:^{

        self.center = CGPointMake(SCREEN_WIDTH, self.center.y);
        
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            self.alpha = 1.0;
            self.center = myCenter;
        }];
    }];
}
@end
