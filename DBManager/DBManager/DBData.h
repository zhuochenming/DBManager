//
//  DBData.h
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBData : NSObject

#pragma mark - 返回code
@property (nonatomic, assign) NSInteger code;

#pragma mark - 正确为nil，否则是错误信息
@property (nonatomic, strong) NSString *msg;

#pragma mark - 数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
