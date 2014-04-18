//
//  TTTableViewController.m
//  UITableViewStaticCells
//
//  Created by sergey on 4/13/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTTableViewController.h"

#define LASTFIELD_TAG 7

static NSString* kSettingsThumbnail = @"kSettingsThumbnail";
static NSString* kSettingsName = @"kSettingsName";
static NSString* kSettingsSecondName = @"kSettingsSecondName";
static NSString* kSettingsLogin = @"kSettingsLogin";
static NSString* kSettingsPassword = @"kSettingsPassword";
static NSString* kSettingsEmail = @"kSettingsEmail";
static NSString* kSettingsPhone = @"kSettingsPhone";
static NSString* kSettingsLocation = @"kSettingsLocation";
static NSString* kSettingsGender = @"kSettingsGender";
static NSString* kSettingsSubscribe = @"kSettingsSubscribe";
static NSString* kSettingsAge = @"kSettingsAge";

@interface TTTableViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,assign) NSInteger currentTextField;

@end

@implementation TTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    for (UITextField *field in self.infiTextFeild) {
        field.delegate = self;
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self loadSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    for (UITextField *field in self.infiTextFeild) {
        [field resignFirstResponder];
    }
}

- (UITextField *)getTextFieldByTag:(int)index {
    UITextField *tempField;
    tempField = nil;
    for (UITextField *field in self.infiTextFeild) {
        if (field.tag == index) {
            tempField = field;
            break;
        }
    }
    
    return tempField;
}

- (void) saveSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[self getTextFieldByTag:1].text forKey:kSettingsName];
    [userDefaults setObject:[self getTextFieldByTag:2].text forKey:kSettingsSecondName];
    [userDefaults setObject:[self getTextFieldByTag:3].text forKey:kSettingsEmail];
    [userDefaults setObject:[self getTextFieldByTag:4].text forKey:kSettingsPhone];
    [userDefaults setObject:[self getTextFieldByTag:5].text forKey:kSettingsLocation];
    [userDefaults setObject:[self getTextFieldByTag:6].text forKey:kSettingsLogin];
    [userDefaults setObject:[self getTextFieldByTag:7].text forKey:kSettingsPassword];
    
    [userDefaults setInteger:self.genderSegmentedControl.selectedSegmentIndex forKey:kSettingsGender];
    [userDefaults setBool:self.subscribeSwitch.isOn forKey:kSettingsSubscribe];
    [userDefaults setDouble:self.ageSlider.value forKey:kSettingsAge];
    
    [userDefaults synchronize];
}

- (void) loadSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [self getTextFieldByTag:1].text = [userDefaults objectForKey:kSettingsName];
    [self getTextFieldByTag:2].text = [userDefaults objectForKey:kSettingsSecondName];
    [self getTextFieldByTag:3].text = [userDefaults objectForKey:kSettingsEmail];
    [self getTextFieldByTag:4].text = [userDefaults objectForKey:kSettingsPhone];
    [self getTextFieldByTag:5].text = [userDefaults objectForKey:kSettingsLocation];
    [self getTextFieldByTag:6].text = [userDefaults objectForKey:kSettingsLogin];
    [self getTextFieldByTag:7].text = [userDefaults objectForKey:kSettingsPassword];
    
    self.genderSegmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kSettingsGender];
    self.subscribeSwitch.on = [userDefaults boolForKey:kSettingsSubscribe];
    self.ageSlider.value = [userDefaults doubleForKey:kSettingsAge];
    
    UIImage* img = [UIImage imageWithData:[userDefaults objectForKey:kSettingsThumbnail]];
    
    if (img != nil) {
        self.thumbNail.image = img;
    }
}

- (BOOL)validationPhoneFor:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    NSMutableString* resultString = [NSMutableString string];
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
}

- (BOOL)validationEmailFor:(UITextField *)textField inRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@",string);
    NSLog(@"%lu",(unsigned long)[string rangeOfString:@"@"].location);
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@0123456789!#$%&'*+-/=?^_`{|}~"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if ([textField.text rangeOfString:@"@"].location == NSNotFound && [string rangeOfString:@"@"].location != NSNotFound) {
        return [string isEqualToString:filtered];
        
    } else if ([string rangeOfString:@"@"].location == NSNotFound) {
        
        return [string isEqualToString:filtered];
    } else {
        return NO;
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.currentTextField = textField.tag;
    
    if (textField.tag != LASTFIELD_TAG) {
        self.currentTextField ++;
        UITextField *field = (UITextField *)[self.view viewWithTag:self.currentTextField];
        [field becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL state;
    NSCharacterSet* textValidationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    switch (textField.tag) {
        case 1:
            state = ([[string componentsSeparatedByCharactersInSet:textValidationSet] count] > 1) ? NO : YES;
            break;
        case 2:
            state = ([[string componentsSeparatedByCharactersInSet:textValidationSet] count] > 1) ? NO : YES;
            break;
        case 3:
            state = [self validationEmailFor:textField inRange:range replacementString:string];
            break;
        case 4:
            state = [self validationPhoneFor:textField inRange:range replacementString:string];
            break;
        case 5:
            state = ([[string componentsSeparatedByCharactersInSet:textValidationSet] count] > 1) ? NO : YES;
            break;
        case 6:
            return YES;
            break;
        case 7:
            return YES;
            break;
        default:
            break;
    }
    
    return state;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.thumbNail.image = chosenImage;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:UIImagePNGRepresentation(self.thumbNail.image) forKey:kSettingsThumbnail];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBAction

- (IBAction)infoEditingDidEnd:(id)sender {
    [self saveSettings];
}

- (IBAction)genderValueChanged:(id)sender {
    [self saveSettings];
}

- (IBAction)ageValueChange:(id)sender {
    [self saveSettings];
}

- (IBAction)setAvatar:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];

}

@end
