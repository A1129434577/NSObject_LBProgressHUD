//
//  ViewController.m
//  LBProgressHUDExample
//
//  Created by 刘彬 on 2020/6/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+LBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showProgressWithStatus:@"请稍候"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSuccessWithStatus:@"显示成功"];
    });
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self viewDidAppear:YES];
}

@end
