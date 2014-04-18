//
//  TTTableViewController.h
//  UITableViewStaticCells
//
//  Created by sergey on 4/13/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTableViewController : UITableViewController

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *infiTextFeild;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;
@property (weak, nonatomic) IBOutlet UISwitch *subscribeSwitch;


- (IBAction)infoEditingDidEnd:(id)sender;
- (IBAction)genderValueChanged:(id)sender;
- (IBAction)ageValueChange:(id)sender;
- (IBAction)setAvatar:(id)sender;

@end
