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

@property(nonatomic, strong) NSString *tableName;

#pragma mark - 初始化
- (id)initWithDatabaseName:(NSString *)databaseName;

- (id)initWithDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName;

#pragma mark - 获取DB
+ (id)databaseFromName:(NSString *)databaseName;

+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName;

#pragma mark - condition是SQL语句where后的参数，如id=1或者type＝'这是一条信息'
- (DBData *)createTableWithName:(NSString *)tableName infoArray:(NSArray *)infoArray;

- (DBData *)insertDataDic:(NSDictionary *)dataDic;

- (DBData *)deleteWhere:(NSString *)condition bindArray:(NSArray *)bindArray;

- (DBData *)updateDataDic:(NSDictionary *)dataDic where:(NSString *)condition bindArray:(NSArray *)bindArray;

- (DBData *)selectWithTypeArray:(NSArray *)typeArray where:(NSString *)condition bindArray:(NSArray *)bindArray;

- (DBData *)dropTable:(NSString *)table;

- (DBData *)excuteSQL:(NSString *)aSQL bindArray:(NSArray *)bindArray;

@end
