//
//  WorkAroundViewController.m
//  Eventer
//
//  Created by Grisha on 21/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

#import "WorkAroundViewController.h"
@interface WorkAroundViewController ()

@end

@implementation WorkAroundViewController

- (void)setSearchBarPlaceholderColor:(UIColor *)foregroundColor {
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{ NSForegroundColorAttributeName : foregroundColor,
//        NSFontAttributeName : [UIFont systemFontOfSize:15],
//        NSBackgroundColorAttributeName : backgroundColor
//  }];
    [UILabel appearanceWhenContainedIn:[UISearchBar class], nil].text = @"Search new events here...";
    [UILabel appearanceWhenContainedIn:[UISearchBar class], nil].textColor = [UIColor whiteColor];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];


//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:backgroundColor];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setPlaceholder:@"Search for new"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    
//    return nil;
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
