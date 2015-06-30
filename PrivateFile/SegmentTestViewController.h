//
//  SegmentTestViewController.h
//  FileTest
//
//  Created by Sun Jin on 15/1/23.
//  Copyright (c) 2015年 ilegendsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentTestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalEventLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalConsumeLable;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ageSelector;

- (IBAction)genderValueChanged:(id)sender;

@end
