//
//  DBData.m
//  zhuochenming
//
//  Created by zhuochenming on 16/1/29.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "DBData.h"

@implementation DBData

- (id)init {
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
