//
//  ViewController.m
//  LBProgressHUDExample
//
//  Created by 刘彬 on 2020/6/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+LBProgressHUD.h"

@interface ViewController ()<LBProgressHUDConfigProtocol>

@end

@implementation ViewController
-(void)configHUD:(MBProgressHUD *)hud withType:(LBProgressHUDType)type{
    if (type == LBProgressHUDImageStatus) {
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        hud.minShowTime = 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame)-50)/2, CGRectGetWidth(self.view.frame), 50)];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"MBProgressHUD二次封装，使其使用起来更方便";
    [self.view addSubview:label];
    
//    self.configHUDBlock = ^(MBProgressHUD * _Nonnull hud, LBProgressHUDType type) {
//
//    };
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showProgressWithStatus:@"请稍候"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSuccessWithStatus:@"显示成功"];
    });
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self viewDidAppear:YES];
}

@end
