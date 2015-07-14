//
//  LeftViewController.m
//  mystock
//
//  Created by Ryan on 14-5-19.
//  Copyright (c) 2014年 Ryan. All rights reserved.
//

#import "LeftViewController.h"
#import "MainViewController.h"
#import "SelectionViewController.h"
#import "SettingViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    [self.view addSubview:_menuTableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    _menuTableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellDefaultIdentifier = @"cellDefault";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDefaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDefaultIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"推荐";
        }
            break;
        case 1:{
            cell.textLabel.text = @"自选股";
        }
            break;
        case 2:{
            cell.textLabel.text = @"设置";
        }
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id centerVC;
    
    
    switch (indexPath.row) {
        case 0:{
            centerVC = [[MainViewController alloc] init];
        }
            break;
        case 1:{
            centerVC = [[SelectionViewController alloc] init];
        }
            break;
        case 2:{
            centerVC = [[SettingViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    [_drawerVC setPaneViewController:[[UINavigationController alloc] initWithRootViewController:centerVC] animated:NO completion:^{
        [_drawerVC setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:^{
            
        }];
    }];
}

@end
