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

#import "AGContactDetailsViewController.h"
#import "AGContact.h"
#import "AGValidator.h"

@interface AGContactDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateTxtField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation AGContactDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if set, edit existing one
    if (self.contact) {
        self.firstnameTxtField.text = self.contact.firstname;
        self.lastnameTxtField.text = self.contact.lastname;
        self.phoneTxtField.text = self.contact.phone;
        self.emailTxtField.text = self.contact.email;
        self.birthdateTxtField.text = self.contact.birthdate;
    }
}


#pragma mark - Action methods

- (IBAction)cancel:(id)sender {
    [self.delegate contactDetailsViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender {
    NSString *firstname = self.firstnameTxtField.text;
    
    // first name
    if (![AGValidator isValidText:firstname]) {
        [self toggleColorForTextField:self.firstnameTxtField withColor:kInvalidTextFieldColor];
        return;
    } else {
        [self toggleColorForTextField:self.firstnameTxtField withColor:kValidTextFieldColor];
    }

    // last name
    NSString *lastname = self.lastnameTxtField.text;
    if (![AGValidator isValidText:lastname]) {
        [self toggleColorForTextField:self.lastnameTxtField withColor:kInvalidTextFieldColor];
        return;
    } else {
        [self toggleColorForTextField:self.lastnameTxtField withColor:kValidTextFieldColor];
    }
    
    // phone
    NSString *phone = self.phoneTxtField.text;
    if (![AGValidator isValidPhone:phone]) {
        [self toggleColorForTextField:self.phoneTxtField withColor:kInvalidTextFieldColor];
        return;
    } else {
        [self toggleColorForTextField:self.phoneTxtField withColor:kValidTextFieldColor];
    }
    
    // email
    NSString *email = self.emailTxtField.text;
    if (![AGValidator isValidEmail:email]) {
        [self toggleColorForTextField:self.emailTxtField withColor:kInvalidTextFieldColor];
        return;
    } else {
        [self toggleColorForTextField:self.emailTxtField withColor:kValidTextFieldColor];
    }
    
    // birthdate
    NSString *birthdate = self.birthdateTxtField.text;
    if (![AGValidator isValidBirthdate:birthdate]) {
        [self toggleColorForTextField:self.birthdateTxtField withColor:kInvalidTextFieldColor];
        return;
    } else {
        [self toggleColorForTextField:self.birthdateTxtField withColor:kValidTextFieldColor];
    }
    
    AGContact *contact;
    
    // if we reach here, create contact
    if (!self.contact) {
        contact = [[AGContact alloc] init];
        self.contact = contact;
    }

    contact.firstname = firstname;
    contact.lastname = lastname;
    contact.phone = phone;
    contact.email = email;
    contact.birthdate = birthdate;

    // call delegate to add it
    [self.delegate contactDetailsViewController:self didSave:contact];
}

#pragma mark - Utility method

- (void)toggleColorForTextField:(UITextField *)textfield withColor:(UIColor *)color {
    textfield.layer.borderWidth = 2.0;
    textfield.layer.borderColor = color.CGColor;
}

@end
