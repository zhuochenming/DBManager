//
//  DBManager.m
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "DBManager.h"

@interface DBManager ()

@property (nonatomic, strong) NSString *databaseName;

@property (nonatomic, strong) NSString *tableName;

@property (nonatomic, strong) DBStore *dbStore;

@end

@implementation DBManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert(NO, @"+ (id)databaseFromName:(NSString *)databaseName，或者+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName初始化");
    }
    return self;
}

#pragma mark - 初始化
- (id)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
        self.dbStore = [[DBStore alloc] initWithDatabaseName:databaseName];
    }
    return self;
}

#pragma mark - 从文件名或者表名和文件名获取表
+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName infoArray:(NSArray *)infoArray {
    static dispatch_once_t once_token;
    static NSMutableDictionary *handlePool;
    dispatch_once(&once_token, ^{
        handlePool = [[NSMutableDictionary alloc] init];
    });
    
    NSString *token = [databaseName stringByAppendingPathExtension:tableName];
    if (![[handlePool allKeys] containsObject:token] || [handlePool objectForKey:token] == nil) {
        DBManager *manager = [[DBManager alloc] initWithDatabaseName:databaseName];
        [manager setTableName:tableName];
        [manager createTableWithName:tableName infoArray:infoArray];
        DBData *daData = [manager selectWithTypeArray:[NSMutableArray arrayWithObjects:@"1", nil] where:@"" bindArray:nil];
        if (SQLITE_DONE == daData.code) {
            [handlePool setValue:manager forKey:token];
        } else {
            return nil;
        }
    }
    return [handlePool objectForKey:token];
}

#pragma mark - 获取DB
+ (id)databaseFromName:(NSString *)databaseName tableName:(NSString *)tableName {
    static dispatch_once_t once_token;
    static NSMutableDictionary *handlePool;
    dispatch_once(&once_token, ^{
        handlePool = [[NSMutableDictionary alloc] init];
    });
    
    NSString *token = [databaseName stringByAppendingPathExtension:tableName];
    if (![[handlePool allKeys] containsObject:token] || nil == [handlePool objectForKey:token]) {
        DBManager *manager = [[DBManager alloc] initWithDatabaseName:databaseName];
        [manager setTableName:tableName];
        DBData *daData = [manager selectWithTypeArray:[NSMutableArray arrayWithObjects:@"1", nil]
                                                where:@"" bindArray:nil];
        if (SQLITE_DONE == daData.code) {
            [handlePool setValue:manager forKey:token];
        } else {
            return nil;
        }
    }
    return [handlePool objectForKey:token];
}

#pragma mark - 建表
- (DBData *)createTableWithName:(NSString *)tableName infoArray:(NSArray *)infoArray {
    NSString *fields = @"";
    for (NSString *key in infoArray) {
        fields = [fields stringByAppendingString:key];
        fields = [fields stringByAppendingString:@","];
    }
    fields = [fields substringToIndex:[fields length] - 1];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", tableName, fields];
    return [self.dbStore querySql:sql];
}

#pragma mark - 增
- (DBData *)insertDataDic:(NSDictionary *)dataDic {
    NSArray *keys = [dataDic allKeys];
    NSMutableArray *bind = [[NSMutableArray alloc] init];
    
    NSString *fields = @"";
    NSString *values = @"";
    
    for (NSString *key in keys) {
        fields = [fields stringByAppendingString:key];
        fields = [fields stringByAppendingString:@","];
        values = [values stringByAppendingString:@"?,"];
        
        [bind addObject:[dataDic objectForKey:key]];
    }
    fields = [fields substringToIndex:[fields length] - 1];
    values = [values substringToIndex:[values length] - 1];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", self.tableName, fields, values];
    
    return [self excuteSQL:sql bindArray:bind];
}

#pragma mark - 删
- (DBData *)deleteWhere:(NSString *)condition bindArray:(NSMutableArray *)bindArray {
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];
    
    if (condition && 0 < [condition length]) {
        sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
    }
    
    return [self excuteSQL:sql bindArray:bindArray];
}

- (DBData *)selectWithTypeArray:(NSArray *)typeArray where:(NSString *)condition bindArray:(NSArray *)bindArray {
    NSString *fieldsString = @"";
    for (int i = 0; i < [typeArray count]; i ++) {
        fieldsString = [fieldsString stringByAppendingString:[typeArray objectAtIndex:i]];
        fieldsString = [fieldsString stringByAppendingString:@","];
    }
    fieldsString = [fieldsString substringToIndex:[fieldsString length] - 1];
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldsString, self.tableName];
    if (condition && 0 < [condition length]) {
        sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
    }
    
    return [self excuteSQL:sql bindArray:bindArray];
}

#pragma mark - 改
- (DBData *)updateDataDic:(NSDictionary *)dataDic where:(NSString *)condition bindArray:(NSArray *)bindArray {
    NSArray *keys = [dataDic allKeys];
    NSMutableArray *newBind = [[NSMutableArray alloc] init];
    NSString *fields = @"";
    
    for (NSString *key in keys) {
        fields = [fields stringByAppendingString:key];
        fields = [fields stringByAppendingString:@"=? ,"];
        [newBind addObject:[dataDic objectForKey:key]];
    }
    fields = [fields substringToIndex:[fields length] - 1];
    [newBind addObjectsFromArray:bindArray];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", self.tableName, fields];
    if (condition && 0 < [condition length]) {
        sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
    }
    return [self.dbStore querySql:sql bindArray:newBind];
}

- (DBData *)excuteSQL:(NSString *)aSQL bindArray:(NSArray *)bindArray {
    if (nil == bindArray || 0 >= [bindArray count]) {
        return [self.dbStore querySql:aSQL];
    } else {
        return [self.dbStore querySql:aSQL bindArray:bindArray];
    }
}

- (DBData *)dropTable:(NSString *)table {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@ ", table];
    return [self excuteSQL:sql bindArray:nil];
}

@end
