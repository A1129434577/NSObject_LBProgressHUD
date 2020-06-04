//
//  NSObject+LBProgressHUD.m
//  TestDome
//
//  Created by 刘彬 on 2020/6/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "NSObject+LBProgressHUD.h"

#define LB_MAX_SHOW_SECOND 20
static NSString *const LBProgressHUDBundleName = @"LBProgressHUD";

@interface LBMBProgressHUDCustomView : UIImageView
@property (nonatomic, assign) CGSize size;
@end

@interface NSBundle (AssociatedBundle)
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName;
@end

@implementation NSObject (LBProgressHUD)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    NSTimeInterval displayDuration = MIN((CGFloat)string.length * 0.06 + 0.5, 5);
    return displayDuration;
}

- (MBProgressHUD *)configHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:LB_KEY_WINDOW animated:YES];
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    hud.contentColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    hud.removeFromSuperViewOnHide = YES;
    hud.minShowTime = 1;
    return hud;
}

- (MBProgressHUD *)showWithStatus:(NSString *_Nullable)status{
    [self dismissWithAnimated:NO];
    MBProgressHUD *hud = [self configHUD];
    
    hud.label.text = status;
    hud.mode = MBProgressHUDModeText;
    
    [hud hideAnimated:YES afterDelay:[self displayDurationForString:status]];
    
    return hud;
}

- (MBProgressHUD *)showProgressWithStatus:(NSString *_Nullable)status{
    [self dismissWithAnimated:NO];
    MBProgressHUD *hud = [self configHUD];

    hud.label.text = status;
    hud.mode = MBProgressHUDModeCustomView;
    
    
    LBMBProgressHUDCustomView *customView = [[LBMBProgressHUDCustomView alloc] init];
    customView.size = CGSizeMake(70, 70);
    customView.backgroundColor = [UIColor clearColor];
    hud.customView = customView;
    
    CGFloat customViewSide = customView.intrinsicContentSize.width;
    CGFloat loadingSide = customView.intrinsicContentSize.width-15;
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(customViewSide/2, customViewSide/2) radius:loadingSide/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    CAShapeLayer *indefiniteAnimatedLayer = [CAShapeLayer layer];
    indefiniteAnimatedLayer.contentsScale = [[UIScreen mainScreen] scale];
    indefiniteAnimatedLayer.frame = CGRectMake(0, 0, customViewSide, customViewSide);
    indefiniteAnimatedLayer.fillColor = [UIColor clearColor].CGColor;
    indefiniteAnimatedLayer.strokeColor = [UIColor blackColor].CGColor;
    indefiniteAnimatedLayer.lineWidth = 2;
    indefiniteAnimatedLayer.lineCap = kCALineCapRound;
    indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
    indefiniteAnimatedLayer.path = smoothedPath.CGPath;

    CALayer *maskLayer = [CALayer layer];
        
    NSBundle *bundle = [NSBundle bundleWithBundleName:LBProgressHUDBundleName];
    maskLayer.contents = (__bridge id)[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"angle-mask" ofType:@"png"]] CGImage];
    maskLayer.frame = indefiniteAnimatedLayer.bounds;
    indefiniteAnimatedLayer.mask = maskLayer;
    
    [customView.layer addSublayer:indefiniteAnimatedLayer];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 1;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //缓入缓出
    rotationAnimation.repeatCount = INT_MAX;
    [indefiniteAnimatedLayer addAnimation:rotationAnimation forKey:@"progress"];
        
    [hud hideAnimated:YES afterDelay:LB_MAX_SHOW_SECOND];
    
    return hud;
}

-(MBProgressHUD *)showWithImage:(UIImage *)image status:(NSString *_Nullable)status{
    [self dismissWithAnimated:NO];
    MBProgressHUD *hud = [self configHUD];

    hud.label.text = status;
    hud.mode = MBProgressHUDModeCustomView;
    
    
    LBMBProgressHUDCustomView *customView = [[LBMBProgressHUDCustomView alloc] init];
    customView.size = CGSizeMake(35, 35);
    customView.backgroundColor = [UIColor clearColor];
    customView.image = image;
    hud.customView = customView;
    
    [hud hideAnimated:YES afterDelay:[self displayDurationForString:status]];
    
    return hud;
}

-(MBProgressHUD *)showWithImage:(UIImage *)image status:(NSString *)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showWithImage:image status:status];
    hud.completionBlock = completion;
    return hud;
}

- (MBProgressHUD *)showSuccessWithStatus:(NSString *_Nullable)status{
    NSBundle *bundle = [NSBundle bundleWithBundleName:LBProgressHUDBundleName];
    MBProgressHUD *hud = [self showWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"success" ofType:@"png"]] status:status];
    return hud;
}
- (MBProgressHUD *)showSuccessWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showSuccessWithStatus:status];
    hud.completionBlock = completion;
    return hud;;
}

- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status{
    NSBundle *bundle = [NSBundle bundleWithBundleName:LBProgressHUDBundleName];
    MBProgressHUD *hud = [self showWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"info" ofType:@"png"]] status:status];
    return hud;
}
- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showInfoWithStatus:status];
    hud.completionBlock = completion;
    return hud;
}

- (MBProgressHUD *)showErrorWithStatus:(NSString *_Nullable)status{
    NSBundle *bundle = [NSBundle bundleWithBundleName:LBProgressHUDBundleName];
    MBProgressHUD *hud = [self showWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"error" ofType:@"png"]] status:status];
    return hud;
}
- (MBProgressHUD *)showErrorWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showErrorWithStatus:status];
    hud.completionBlock = completion;
    return hud;
}

- (void)dismiss{
    [self dismissWithAnimated:YES];
}

- (void)dismissWithAnimated:(BOOL)animated{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:LB_KEY_WINDOW];
    [hud hideAnimated:animated];
}



#pragma clang diagnostic pop
@end

@implementation LBMBProgressHUDCustomView
- (CGSize)intrinsicContentSize {
    return self.size;
}
@end


@implementation NSBundle (AssociatedBundle)
/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @return bundle
 */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName{
    NSString *podName = @"NSObject_LBProgressHUD";
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}
@end
