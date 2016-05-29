//
//  GreenView.h
//  RACSingal
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIButton *btnDelegate;
- (IBAction)btnDidClick:(id)sender;
@end
