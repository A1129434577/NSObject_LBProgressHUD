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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame)-50)/2, CGRectGetWidth(self.view.frame), 50)];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"MBProgressHUD二次封装，使其使用起来更方便";
    [self.view addSubview:label];
    
    self.configHUDBlock = ^(MBProgressHUD * _Nonnull hud) {
        hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.minShowTime = 1;
        hud.contentColor = [UIColor whiteColor];
    };
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
