//
//  DBStore.m
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "DBStore.h"

static NSString * const DBDicName = @"/UserData/DBFile/";

@interface DBStore ()

@property (strong, nonatomic) NSString *databasePath;

@property (assign, nonatomic) sqlite3 *dbHandler;

@end

@implementation DBStore
#pragma mark - 创建表本地文件
- (void)checkAndCreateDatabase:(NSString *)database {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(! [fileManager fileExistsAtPath:self.databasePath]) {
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:database];
        [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
    }
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *dbPath = [documentPath stringByAppendingString:DBDicName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.databasePath = [dbPath stringByAppendingPathComponent:databaseName];
        
        [self checkAndCreateDatabase:databaseName];
        if(SQLITE_OK == sqlite3_open([self.databasePath UTF8String], &_dbHandler)) {
            return self;
        } else {
            return nil;
        }
    }
    return nil;
}

#pragma mark - 查表
- (DBData *)querySql:(NSString *)sql bindArray:(NSArray *)bindArray {
    DBData *dbData = [[DBData alloc] init];
    
    sqlite3_stmt *compiledStatement;
    
    const char *sqlStatement = [[NSString stringWithString:sql] UTF8String];
    dbData.code = sqlite3_prepare_v2(self.dbHandler, sqlStatement, -1, &compiledStatement, NULL);
    if(SQLITE_OK != dbData.code) {
        dbData.msg = [NSString stringWithUTF8String:sqlite3_errmsg(self.dbHandler)];
        return dbData;
    }
    
    if (bindArray != nil) {
        for (int i = 0; i < [bindArray count]; i++) {
            sqlite3_bind_text(compiledStatement, i + 1, [[NSString stringWithFormat:@"%@", [bindArray objectAtIndex:i]] UTF8String], -1, SQLITE_TRANSIENT);
        }
    }
    while ((dbData.code = sqlite3_step(compiledStatement)) && SQLITE_DONE != dbData.code && SQLITE_ROW == dbData.code) {
        NSMutableArray *rowData = [[NSMutableArray alloc] init];
        
        int columnNum = sqlite3_column_count(compiledStatement);
        for (int i = 0; i < columnNum; i ++) {
            if (NULL != (char *)sqlite3_column_text(compiledStatement, i)) {
                [rowData addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)]];
            } else {
                [rowData addObject:@""];
            }
        }
        [dbData.dataArray addObject:rowData];
    }
    
    sqlite3_reset(compiledStatement);
    
    return dbData;
}

- (DBData *)querySql:(NSString *)sql {
    DBData *dbData = [[DBData alloc] init];
    
    sqlite3_stmt *compiledStatement;
    const char *sqlStatement = [[NSString stringWithString:sql] UTF8String];
    
    dbData.code = sqlite3_prepare_v2(self.dbHandler, sqlStatement, -1, &compiledStatement, NULL);
    if(SQLITE_OK != dbData.code) {
        dbData.msg = [NSString stringWithUTF8String:sqlite3_errmsg(self.dbHandler)];
        return dbData;
    }
    
    while ((dbData.code = sqlite3_step(compiledStatement)) && SQLITE_DONE != dbData.code && SQLITE_ROW == dbData.code) {
        NSMutableArray *rowData = [[NSMutableArray alloc] init];
        
        int columnNum = sqlite3_column_count(compiledStatement);
        for (int i = 0; i < columnNum; i ++) {
            if (NULL != (char *)sqlite3_column_text(compiledStatement, i)) {
                [rowData addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)]];
            } else {
                [rowData addObject:@""];
            }
        }
        
        [dbData.dataArray addObject:rowData];
    }
    
    sqlite3_reset(compiledStatement);
    
    return dbData;
}

- (void)dealloc {
    if (self.dbHandler) {
        sqlite3_close(self.dbHandler);
    }
}

@end
