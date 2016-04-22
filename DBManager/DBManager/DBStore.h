//
//  DBStore.h
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBData.h"

@interface DBStore : NSObject

#pragma mark - 创建表本地文件
- (instancetype)initWithDatabaseName:(NSString *)databaseName;

- (void)checkAndCreateDatabase:(NSString *)database;

- (DBData *)querySql:(NSString *)sql bindArray:(NSArray *)bindArray;

- (DBData *)querySql:(NSString *)sql;

@end
