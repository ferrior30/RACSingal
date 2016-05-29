//
//  Flag.h
//  RACSingal
//
//  Created by ChenWei on 16/5/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
+ (instancetype)flagWithDict:(NSDictionary *)dict;
@end
