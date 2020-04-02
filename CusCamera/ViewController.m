//
//  ViewController.m
//  CusCamera
//
//  Created by rocky on 2020/4/2.
//  Copyright © 2020 rocky. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "FJCameraView.h"


@interface ViewController ()
@property (strong, nonatomic) FJCameraView *fjCamera;
@property (nonatomic, strong) UIButton *takeBtn;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UILabel *tipL;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIButton *flashBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];

    
    self.fjCamera = [FJCameraView new];
    [self.view insertSubview:self.fjCamera atIndex:0];
    [self.fjCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.mas_equalTo(60);
        make.size.mas_equalTo(CGSizeMake(430, 300));
        
    }];


    // 拍摄按钮
    _takeBtn = [UIButton new];
    [self.view addSubview:_takeBtn];
    [_takeBtn setTitle:@"拍摄" forState:UIControlStateNormal];
    [_takeBtn setBackgroundColor:[UIColor grayColor]];
    _takeBtn.layer.borderWidth = 1;
    _takeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _takeBtn.layer.cornerRadius = 50;
    [_takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-30);
        make.centerY.equalTo(self.view);
        make.width.height.mas_equalTo(100);
    }];
    [_takeBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
   // 闪光灯
      _flashBtn = [UIButton new];
      [self.view addSubview:_flashBtn];
      [_flashBtn setTitle:[self transferFlashTitle:[self.fjCamera getCaptureFlashMode]] forState:UIControlStateNormal];
      [_flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.equalTo(_takeBtn.mas_top).offset(-10);
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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}


@end
