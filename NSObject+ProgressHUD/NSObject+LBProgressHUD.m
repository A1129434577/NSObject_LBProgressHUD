//
//  NSObject+LBProgressHUD.m
//  TestDome
//
//  Created by 刘彬 on 2020/6/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "NSObject+LBProgressHUD.h"
#import <objc/runtime.h>

#define LB_MAX_SHOW_SECOND 20

static NSString *LB_ConfigHUDBlockKey = @"LB_ConfigHUDBlockKey";


@interface LBMBProgressHUDCustomView : UIImageView
@property (nonatomic, assign) CGSize size;
@end

@implementation NSObject (LBProgressHUD)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

-(void)setConfigHUDBlock:(void (^)(MBProgressHUD * _Nonnull))configHUDBlock{
    objc_setAssociatedObject(self, &LB_ConfigHUDBlockKey, configHUDBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(MBProgressHUD * _Nonnull))configHUDBlock{
    return objc_getAssociatedObject(self, &LB_ConfigHUDBlockKey);
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    NSTimeInterval displayDuration = MIN((CGFloat)string.length * 0.06 + 0.5, 5);
    return displayDuration;
}

- (MBProgressHUD *)configHUD{
    MBProgressHUD *hud;
    if (self.configHUDBlock) {
        hud = [MBProgressHUD showHUDAddedTo:LB_KEY_WINDOW animated:YES];
        self.configHUDBlock(hud);
    }else{
        hud = [MBProgressHUD showHUDAddedTo:LB_KEY_WINDOW animated:YES];
        hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor whiteColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.minShowTime = 1;
    }
    
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
    indefiniteAnimatedLayer.strokeColor = hud.contentColor.CGColor;
    indefiniteAnimatedLayer.lineWidth = 2;
    indefiniteAnimatedLayer.lineCap = kCALineCapRound;
    indefiniteAnimatedLayer.lineJoin = kCALineJoinBevel;
    indefiniteAnimatedLayer.path = smoothedPath.CGPath;

    CALayer *maskLayer = [CALayer layer];
        
    NSBundle *bundle = [self LBProgressHUDBundle];
    UIImage *progressImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"angle-mask" ofType:@"png"]];
    maskLayer.contents = (__bridge id)progressImage.CGImage;
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
    customView.image = [self lb_changImage:image withColor:hud.contentColor];
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
    NSBundle *bundle = [self LBProgressHUDBundle];
    MBProgressHUD *hud = [self showWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"success" ofType:@"png"]] status:status];
    return hud;
}
- (MBProgressHUD *)showSuccessWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showSuccessWithStatus:status];
    hud.completionBlock = completion;
    return hud;;
}

- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status{
    NSBundle *bundle = [self LBProgressHUDBundle];
    MBProgressHUD *hud = [self showWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"info" ofType:@"png"]] status:status];
    return hud;
}
- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion{
    MBProgressHUD *hud = [self showInfoWithStatus:status];
    hud.completionBlock = completion;
    return hud;
}

- (MBProgressHUD *)showErrorWithStatus:(NSString *_Nullable)status{
    NSBundle *bundle = [self LBProgressHUDBundle];
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

- (NSBundle *)LBProgressHUDBundle{
    NSString *bundleName = @"LBProgressHUD";
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:bundleName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}


- (UIImage *)lb_changImage:(UIImage *)image withColor:(UIColor *)color
{
    @autoreleasepool{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, image.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextClipToMask(context, rect, image.CGImage);
        [color setFill];
        CGContextFillRect(context, rect);
        UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
}

#pragma clang diagnostic pop
@end

@implementation LBMBProgressHUDCustomView
- (CGSize)intrinsicContentSize {
    return self.size;
}
@end

