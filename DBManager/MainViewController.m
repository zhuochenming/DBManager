//
//  MainViewController.m
//  Demo
//
//  Created by zhuochenming on 15/12/15.
//  Copyright © 2015年 zhuochenming. All rights reserved.
//

#import "MainViewController.h"
#import "DBManager.h"

static NSString * const tableName = @"DemoTb";
static NSString * const dbName = @"DemoDb.db";

@interface MainViewController ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSLog(@"%@", NSHomeDirectory());
    
    NSArray *titleArray = @[@"创建", @"增", @"删", @"改", @"查"];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((self.view.frame.size.width - 100) / 2.0, 50 + 70 * i, 100, 50);
        button.backgroundColor = [UIColor orangeColor];
        button.tag = 1000 + i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)touch:(UIButton *)button {
    if (button.tag == 1000) {
            NSArray *infoArray = @[@"id INTEGER PRIMARY KEY ASC",
                                   @"type INTEGER",
                                   @"content",
                                   @"time INTEGER"];
            DBManager *sqlight = [[DBManager alloc] initWithDatabaseName:dbName];
            [sqlight createTableWithName:tableName infoArray:infoArray];
            sqlight.tableName = tableName;
    } else if (button.tag == 1001) {
        _count++;
        DBManager *sqlight = [DBManager databaseFromName:dbName tableName:tableName];
        
        NSString *type = [NSString stringWithFormat:@"%ld", _count];
        NSString *content = [NSString stringWithFormat:@"我是第%ld条数据", _count];
        NSString *time = [NSString stringWithFormat:@"%@", [NSDate date]];
        
        NSDictionary *dic = @{@"type" : type,
                              @"content" : content,
                              @"time" : time};
        
        DBData *result = [sqlight insertDataDic:dic];
        
        NSLog(@"增：msg:%@ code:%ld data:%@", result.msg, result.code, result.dataArray);
        
    } else if (button.tag == 1002) {
        DBManager *sqlight = [DBManager databaseFromName:dbName tableName:tableName];
        
        DBData *result = [sqlight deleteWhere:@"type=5" bindArray:nil];
        
        NSLog(@"删：msg:%@ code:%ld data:%@", result.msg, result.code, result.dataArray);
    } else if (button.tag == 1003) {
        DBManager *sqlight = [DBManager databaseFromName:dbName tableName:tableName];
        
        NSString *type = [NSString stringWithFormat:@"%ld", _count];
        NSString *content = [NSString stringWithFormat:@"第%ld条数据被修改", _count];
        NSString *time = [NSString stringWithFormat:@"%@", [NSDate date]];
        
        NSDictionary *dic = @{@"type" : type,
                              @"content" : content,
                              @"time" : time};
        
        DBData *result = [sqlight updateDataDic:dic where:@"type=1" bindArray:nil];
        
        NSLog(@"改：msg:%@ code:%ld data:%@", result.msg, result.code, result.dataArray);
    } else {
        DBManager *sqlight = [DBManager databaseFromName:dbName tableName:tableName];
        
        DBData *result = [sqlight selectWithTypeArray:@[@"content"] where:@"" bindArray:nil];
        
        NSLog(@"查：msg:%@ code:%ld data:%@", result.msg, result.code, result.dataArray);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
