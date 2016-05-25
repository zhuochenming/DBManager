//
//  DBManager.h
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBStore.h"
#import "DBData.h"

@interface DBManager : NSObject

#pragma mark - 初始化 自动创建DB
+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName infoArray:(NSArray *)infoArray;

#pragma mark - 获取DB
+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName;

#pragma mark - 插入数据
- (DBData *)insertDataDic:(NSDictionary *)dataDic;

#pragma mark - 删除数据
- (DBData *)deleteWhere:(NSString *)condition bindArray:(NSArray *)bindArray;

#pragma mark - 更新数据
- (DBData *)updateDataDic:(NSDictionary *)dataDic where:(NSString *)condition bindArray:(NSArray *)bindArray;

#pragma mark - 遍历数据
- (DBData *)selectWithTypeArray:(NSArray *)typeArray where:(NSString *)condition bindArray:(NSArray *)bindArray;

- (DBData *)dropTable:(NSString *)table;

- (DBData *)excuteSQL:(NSString *)aSQL bindArray:(NSArray *)bindArray;

@end
