//
//  UIDevice+FJAdd.m
//  CusCamera
//
//  Created by rocky on 2020/4/3.
//  Copyright © 2020 rocky. All rights reserved.
//

#import "UIDevice+FJAdd.h"

@implementation UIDevice (FJAdd)
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
}
@end
