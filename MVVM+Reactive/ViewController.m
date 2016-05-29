//
//  ViewController.m
//  MVVM+Reactive
//
//  Created by ChenWei on 16/5/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "ViewController.h"
#import "RequireViewModel.h"


@interface ViewController ()<UITableViewDataSource>
@property (strong, nonatomic) RequireViewModel *requireViewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupRequestViewModel {
    
}

#pragma mark - properties
- (RequireViewModel *)requireViewModel {
    if (_requireViewModel == nil) {
        _requireViewModel = [[RequireViewModel alloc] init];
        [_requireViewModel.requestCommand execute:@1];
    }
    return _requireViewModel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.requireViewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(Book *book) {
        NSLog(@"订阅 = %@",book);
    }];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
    self.tableView.contentOffset = CGPointMake(0, 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requireViewModel.book.books ? self.requireViewModel.book.books.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.requireViewModel.book.books[indexPath.row][@"publisher"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", self.requireViewModel.book.count];
    
    return cell;
}

@end
