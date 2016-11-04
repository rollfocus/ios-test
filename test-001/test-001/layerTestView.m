//
//  layerTestView.m
//  test-001
//
//  Created by lin zoup on 11/3/16.
//  Copyright © 2016 cDuozi. All rights reserved.
//

#import "layerTestView.h"

@implementation layerTestView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.layer drawInContext:UIGraphicsGetCurrentContext()];
}


- (UIImage *)imageOfCurrentContent
{
    /*  
     在 iOS 7 之後我們通常不會用這種方式產生畫面截圖，原因是 iOS 7 之後 UIView 有新的
     API drawViewHierarchyInRect:afterScreenUpdates: 可以使用。
     新的 API 與透過 CALayer 繪圖的差別是，iOS 7 之後的 UI 設計大量使用半透明毛玻璃效果的 view，
     而用 CALayer 截出的圖片無法抓到這部份，而新的 API 就蘋果的說法，
     可以抓到無論是 UIKit、Quartz、OpenGL ES、SpriteKit 等這種繪圖系統產生的畫面
     */
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
