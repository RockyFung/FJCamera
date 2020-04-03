//
//  DemoCamerVC.m
//  CusCamera
//
//  Created by rocky on 2020/4/3.
//  Copyright © 2020 rocky. All rights reserved.
//

#import "DemoCamerVC.h"
#import "Masonry.h"
#import "FJCameraView.h"
#import "AppDelegate.h"
#import "UIDevice+FJAdd.h"


#define kScreenSize [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.width
#define FitValue(value) ((value) / 375.0) * [UIScreen mainScreen].bounds.size.height

@interface DemoCamerVC ()

@property (strong, nonatomic) FJCameraView *fjCamera;
@property (nonatomic, strong) UIButton *takeBtn;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UILabel *tipL;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIImageView *cusBorder;
@end

@implementation DemoCamerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置横屏
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用横屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];

    
    self.fjCamera = [FJCameraView new];
    [self.view insertSubview:self.fjCamera atIndex:0];
    [self.fjCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.fjCamera.effectiveRectBorderColor = [UIColor clearColor];
    self.fjCamera.effectiveRect = CGRectMake(FitValue(80), (kScreenWidth - FitValue(300))/2, FitValue(456), FitValue(300));
    
    // 有效边框图层
    _cusBorder = [[UIImageView alloc]initWithFrame:self.fjCamera.effectiveRect];
    [self.view addSubview:_cusBorder];
    _cusBorder.image = [UIImage imageNamed:@"border"];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton new];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(20);
        
    }];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];


    // 拍摄按钮
    _takeBtn = [UIButton new];
    [self.view addSubview:_takeBtn];
    [_takeBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    [_takeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_takeBtn setBackgroundColor:[UIColor whiteColor]];
    _takeBtn.layer.cornerRadius = 30;
    [_takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.centerY.equalTo(self.view);
        make.width.height.mas_equalTo(60);
    }];
    [_takeBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
   // 闪光灯
      _flashBtn = [UIButton new];
      [self.view addSubview:_flashBtn];
      [_flashBtn setTitle:[self transferFlashTitle:[self.fjCamera getCaptureFlashMode]] forState:UIControlStateNormal];
      [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(_cusBorder);
          make.centerX.equalTo(_takeBtn);
      }];
    [_flashBtn addTarget:self action:@selector(clickFlash:) forControlEvents:UIControlEventTouchUpInside];
    
    // 重新拍摄按钮
    _resetBtn = [UIButton new];
    [self.view addSubview:_resetBtn];
    [_resetBtn setHidden:YES];
    [_resetBtn setTitle:@"重新拍摄" forState:UIControlStateNormal];
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_takeBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_takeBtn);
    }];
    [_resetBtn addTarget:self action:@selector(resetPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 提示框
    _tipL = [UILabel new];
    [self.view addSubview:_tipL];
    _tipL.textColor = [UIColor whiteColor];
    _tipL.font = [UIFont systemFontOfSize:14];
    _tipL.text = @"请放正凭证，并调整好光线";
    [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.equalTo(self.fjCamera.mas_top);
        make.centerX.equalTo(self.fjCamera);
    }];
    
}
// 拍摄
- (void)takePhoto:(UIButton *)btn{
    if (self.selectedImage) {
        NSLog(@"完成");
    }else{
       
        __weak typeof(self) WeakSelf = self;
        [self.fjCamera takePhoto:^(UIImage *img) {
            NSLog(@"%@",img);
            [WeakSelf.resetBtn setHidden:NO];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            WeakSelf.tipL.text = @"拍摄成功";
            WeakSelf.selectedImage = img;
            [WeakSelf.flashBtn setHidden:YES];
        }];
    }
}

// 重新拍摄
- (void)resetPhoto:(UIButton *)btn{
    [self.fjCamera restart];
    [self.resetBtn setHidden:YES];
    [_takeBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    self.tipL.text = @"请放正凭证，并调整好光线";
    self.selectedImage = nil;
    [self.flashBtn setHidden:NO];
}

// 切换闪光灯
- (void)clickFlash:(UIButton *)btn{
    FJCaptureFlashMode flashModel = [self.fjCamera getCaptureFlashMode];
    FJCaptureFlashMode current = flashModel;
    switch (flashModel) {
        case 0:
            current = 1;
            break;
        case 1:
            current = 2;
            break;
        
        case 2:
            current = 0;
            break;
            
        default:
            break;
    }
    [btn setTitle:[self transferFlashTitle:current] forState:UIControlStateNormal];
    [self.fjCamera switchLight:current];
}

- (NSString *)transferFlashTitle:(FJCaptureFlashMode)model{
    NSString *title = @"";
    switch (model) {
        case FJCaptureFlashModeOn:
            title = @"开";
            break;
        case FJCaptureFlashModeOff:
            title = @"关";
            break;
        case FJCaptureFlashModeAuto:
        title = @"自动";
        break;
        default:
            break;
    }
    return title;
}

- (void)close:(UIButton *)btn{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
       appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
       //切换到竖屏
       [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
       
       [self dismissViewControllerAnimated:YES completion:nil];
}


@end
