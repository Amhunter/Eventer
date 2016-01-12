//
//  UIAppearance.m
//  Eventer
//
//  Created by Grisha on 21/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

#import "UIAppearance+Swift.h"

@implementation UIView (UIViewAppearance_Swift)
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}
@end
