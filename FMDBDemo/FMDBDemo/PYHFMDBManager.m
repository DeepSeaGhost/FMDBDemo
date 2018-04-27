//  rrTest  PYHFMDBManager.m.
//  Created 2018/4/25.

#import "PYHFMDBManager.h"
#import "FMDB.h"
@interface PYHFMDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end
@implementation PYHFMDBManager
+ (instancetype)sharedDBManager {
    static PYHFMDBManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PYHFMDBManager alloc]init];
        _manager.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"dbName.db"]];
    });
    return _manager;
}

#pragma mark - 创建表
- (void)creatDBTableWithTableName:(NSString *)tableName  columnNames:(NSArray <NSString *>*)columnNames {
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(",tableName];
            for (int i = 0; i < columnNames.count; i ++) {
                NSString *columnName = columnNames[i];
                if (i == columnNames.count -1) {
                    sql = [sql stringByAppendingFormat:@"%@ varchar(255))",columnName];
                }else {
                    sql = [sql stringByAppendingFormat:@"%@ varchar(255),",columnName];
                }
            }
            BOOL result = [db executeUpdate:sql];
            NSLog(@"%@",result ? @"创建表成功" : @"创建表失败");
//            [db close];
        }
    }];
    
}

#pragma mark - 插入数据
- (void)inseatDataWithTableName:(NSString *)tableName datas:(NSArray <NSString *>*)datas{
    if (![self isTableExist:tableName]) return;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(",tableName];
            for (int i = 0; i < datas.count; i ++) {
                NSString *data = datas[i];
                if (i == datas.count - 1) {
                    sql = [sql stringByAppendingFormat:@"'%@')",data];
                }else {
                    sql = [sql stringByAppendingFormat:@"'%@',",data];
                }
            }
            
            BOOL result = [db executeUpdate:sql];
            NSLog(@"%@",result ? @"插入数据成功" : @"插入数据失败");
//            [db close];
        }
    }];
}

#pragma mark - 查询所有数据
- (NSArray *)selectAllDataWithTableName:(NSString *)tableName columnNames:(NSArray <NSString *>*)columnNames {
    if (![self isTableExist:tableName]) return @[];
    NSString *sql = [NSString stringWithFormat:@"select *from %@",tableName];
    NSMutableArray *allDatas = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (NSString *columnName in columnNames) {
                    NSString *columnData = [set stringForColumn:columnName];
                    [dict setValue:columnData forKey:columnName];
                }
                [allDatas addObject:dict];
            }
            [db close];
        }
    }];
    return allDatas.copy;
}

#pragma mark - 删除所有数据
- (void)deleteAllDataWithTableName:(NSString *)tableName {
    if (![self isTableExist:tableName]) return;
    NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL result = [db executeUpdate:sql];
            NSLog(@"%@",result ? @"删除数据成功" : @"删除数据失败");
//            [db close];
        }
    }];
}

#pragma mark - 更新数据
- (void)updateDataWithTableN:(NSString *)tableName {
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set one = 'newMessage' where two = 'twoMessage'",tableName];
            BOOL result = [db executeUpdate:sql];
            if (!result) {
                //当最后*rollback的值为YES的时候，事务回退，如果最后*rollback为NO，事务提交
                *rollback = YES;
                return;
            }
        }
    }];
}




#pragma mark - 判断指定表是否存在
- (BOOL)isTableExist:(NSString *)tableName {
    __block BOOL isTabelExist = NO;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
            while ([rs next]) {
                NSInteger count = [rs intForColumn:@"count"];
                isTabelExist = count == 0 ? NO : YES;
            }
            [db close];
        }
    }];
    return isTabelExist;
}
@end
