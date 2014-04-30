/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGUserRegistrationViewController.h"
#import "AGUser.h"
#import "AGValidationTextfield.h"

@interface AGUserRegistrationViewController ()

@property (weak, nonatomic) IBOutlet AGValidationTextfield *usernameTxtField;
@property (weak, nonatomic) IBOutlet AGValidationTextfield *passwordTxtField;
@property (weak, nonatomic) IBOutlet AGValidationTextfield *firstnameTxtField;
@property (weak, nonatomic) IBOutlet AGValidationTextfield *lastnameTxtField;
@property (weak, nonatomic) IBOutlet AGValidationTextfield *phoneTxtField;
@property (weak, nonatomic) IBOutlet AGValidationTextfield *birthdateTxtField;

@property (strong, nonatomic) NSArray *textfields;

@end

@implementation AGUserRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textfields = @[self.usernameTxtField, self.passwordTxtField, self.firstnameTxtField, self.lastnameTxtField, self.phoneTxtField, self.birthdateTxtField];
}

#pragma mark - Action methods

- (IBAction)cancel:(id)sender {
    [self.delegate userRegistrationViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender {
    __block BOOL invalidForm = NO;
    
    // enumare all textfields and ask them to validate themselves
    [self.textfields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![(AGValidationTextfield *)obj validate]) {
            invalidForm = YES;
        }
    }];
    
    // if invalid entries found, no need to continue
    if (invalidForm)
        return;
    
    // else time to create contact
    
    AGUser *user = [[AGUser alloc] init];
    
    user.firstname = self.firstnameTxtField.text;
    user.lastname = self.lastnameTxtField.text;
    user.phoneNumber = self.phoneTxtField.text;
    user.email = self.usernameTxtField.text;
    user.password = self.passwordTxtField.text;
    
    // since server expects epoch timestamp, we need to convert
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.birthdateTxtField.text];
    user.birthdate = [NSNumber numberWithDouble:floor(date.timeIntervalSince1970) * 1000 /* to millis */];
    
    // call delegate to add it
    [self.delegate userRegistrationViewController:self didSave:user];
}

@end
