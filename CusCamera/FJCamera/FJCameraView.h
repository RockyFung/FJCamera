//
//  FJCameraView.h
//  CusCamera
//
//  Created by rocky on 2020/4/2.
//  Copyright © 2020 rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FJCaptureFlashMode) {
    FJCaptureFlashModeOff  = 0,
    FJCaptureFlashModeOn   = 1,
    FJCaptureFlashModeAuto = 2
};


@interface FJCameraView : UIView
@property (assign, nonatomic) CGRect effectiveRect;//拍摄有效区域（（可不设置，不设置则不显示遮罩层和边框）

//有效区边框色
@property (nonatomic, strong) UIColor *effectiveRectBorderColor;

//遮罩层颜色，默认黑色半透明
@property (nonatomic, strong) UIColor *maskColor;

@property (nonatomic) UIView *focusView;//聚焦的view

/**如果用代码初始化，一定要调这个方法初始化*/
- (instancetype)initWithFrame:(CGRect)frame;

/**获取摄像头方向*/
- (BOOL)isCameraFront;

/**获取闪光灯模式*/
- (FJCaptureFlashMode)getCaptureFlashMode;

/**切换闪光灯*/
- (void)switchLight:(FJCaptureFlashMode)flashMode;

/**切换摄像头*/
- (void)switchCamera:(BOOL)isFront;

/**拍照*/
- (void)takePhoto:(void (^)(UIImage *img))resultBlock;

/**重拍*/
- (void)restart;

/**调整图片朝向*/
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

NS_ASSUME_NONNULL_END
