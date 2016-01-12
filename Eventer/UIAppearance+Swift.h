//
//  UIAppearance.h
//  Eventer
//
//  Created by Grisha on 21/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIAppearance+Swift.h
@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end
