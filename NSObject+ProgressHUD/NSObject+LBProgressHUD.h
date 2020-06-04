//
//  NSObject+LBProgressHUD.h
//  TestDome
//
//  Created by 刘彬 on 2020/6/3.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "LBUIMacro.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (LBProgressHUD)
- (MBProgressHUD *)showWithStatus:(NSString *_Nullable)status;

- (MBProgressHUD *)showProgressWithStatus:(NSString *_Nullable)status;

- (MBProgressHUD *)showWithImage:(UIImage *)image status:(NSString *_Nullable)status;
- (MBProgressHUD *)showWithImage:(UIImage *)image status:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion;


- (MBProgressHUD *)showSuccessWithStatus:(NSString *_Nullable)status;
- (MBProgressHUD *)showSuccessWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion;

- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status;
- (MBProgressHUD *)showInfoWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion;

- (MBProgressHUD *)showErrorWithStatus:(NSString *_Nullable)status;
- (MBProgressHUD *)showErrorWithStatus:(NSString *_Nullable)status completion:(MBProgressHUDCompletionBlock)completion;

- (void)dismiss;
- (void)dismissWithAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
