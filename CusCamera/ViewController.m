//
//  ViewController.m
//  CusCamera
//
//  Created by rocky on 2020/4/2.
//  Copyright © 2020 rocky. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "DemoCamerVC.h"
#import "AipOcrSdk.h"
@interface ViewController ()

@end

@implementation ViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *btn = [UIButton new];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.equalTo(self.view);
    }];
    [btn setTitle:@"打开相机" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton new];
      [self.view addSubview:btn2];
      [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(btn.mas_bottom).offset(10);
          make.centerX.equalTo(self.view);
      }];
      [btn2 setTitle:@"baidu" forState:UIControlStateNormal];
      [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [btn2 addTarget:self action:@selector(baiduOcr) forControlEvents:UIControlEventTouchUpInside];
    
    [[AipOcrService shardService] authWithAK:@"w1KcbGon6nkGFUAjMci3qUzo" andSK:@"XtUZU5adurv9acuAHX2pKWbNL0GRM1tR"];
    [self configCallback];
    
}

- (void)baiduOcr{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                      withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickBtn:(UIButton *)btn{
    DemoCamerVC *vc = [[DemoCamerVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}


-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
