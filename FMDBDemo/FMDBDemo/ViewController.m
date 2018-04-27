//
//  ViewController.m
//  FMDBDemo
//
//  Created by reset on 2018/4/27.
//  Copyright © 2018年 HangzhouVongi. All rights reserved.
//

#import "ViewController.h"
#import "PYHFMDBManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *insertBT;

@property (nonatomic, strong) UIButton *deleteBT;

@property (nonatomic, strong) UIButton *updateBT;

@property (nonatomic, strong) UIButton *selectBT;
@end

@implementation ViewController
- (UIButton *)insertBT {
    if (!_insertBT) {
        _insertBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
        _insertBT.backgroundColor = [UIColor redColor];
        [_insertBT setTitle:@"插入数据" forState:UIControlStateNormal];
        [_insertBT addTarget:self action:@selector(insertClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _insertBT;
}
- (UIButton *)deleteBT {
    if (!_deleteBT) {
        _deleteBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 100)];
        _deleteBT.backgroundColor = [UIColor blueColor];
        [_deleteBT setTitle:@"删除数据" forState:UIControlStateNormal];
        [_deleteBT addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBT;
}
- (UIButton *)updateBT {
    if (!_updateBT) {
        _updateBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 100)];
        _updateBT.backgroundColor = [UIColor lightGrayColor];
        [_updateBT setTitle:@"更新数据" forState:UIControlStateNormal];
        [_updateBT addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateBT;
}
- (UIButton *)selectBT {
    if (!_selectBT) {
        _selectBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 100)];
        _selectBT.backgroundColor = [UIColor orangeColor];
        [_selectBT setTitle:@"查询数据" forState:UIControlStateNormal];
        [_selectBT addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBT;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.insertBT];
    [self.view addSubview:self.deleteBT];
    [self.view addSubview:self.updateBT];
    [self.view addSubview:self.selectBT];
    
    //创建表
    [[PYHFMDBManager sharedDBManager] creatDBTableWithTableName:@"tableN" columnNames:@[@"one",@"two",@"three",@"four",@"five",@"six"]];
}
- (void)insertClick {
    [[PYHFMDBManager sharedDBManager] inseatDataWithTableName:@"tableN" datas:@[@"oneMessage",@"twoMessage",@"threeMessage",@"fourMessage",@"fiveMessage",@"sixMessage"]];
}
- (void)deleteClick {
    [[PYHFMDBManager sharedDBManager] deleteAllDataWithTableName:@"tableN"];
}
- (void)updateClick {
    [[PYHFMDBManager sharedDBManager] updateDataWithTableN:@"tableN"];
}
- (void)selectClick {
    NSArray *array = [[PYHFMDBManager sharedDBManager] selectAllDataWithTableName:@"tableN" columnNames:@[@"one",@"two",@"three",@"four",@"five",@"six"]];
    NSLog(@"%@",array);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
