//  rrTest  PYHFMDBManager.h.
//  Created 2018/4/25.

#import <Foundation/Foundation.h>

@interface PYHFMDBManager : NSObject

+ (instancetype)sharedDBManager;

///创建表
- (void)creatDBTableWithTableName:(NSString *)tableName  columnNames:(NSArray <NSString *>*)columnNames;

///插入数据
- (void)inseatDataWithTableName:(NSString *)tableName datas:(NSArray <NSString *>*)datas;

///查询所有数据
- (NSArray *)selectAllDataWithTableName:(NSString *)tableName columnNames:(NSArray <NSString *>*)columnNames;

///更新数据
- (void)updateDataWithTableN:(NSString *)tableName;

///删除所有数据
- (void)deleteAllDataWithTableName:(NSString *)tableName;
@end
