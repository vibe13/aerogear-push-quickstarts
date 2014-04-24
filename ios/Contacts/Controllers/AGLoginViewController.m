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

#import "AGLoginViewController.h"
#import "AGContactsNetworker.h"

@interface AGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;

- (IBAction)login:(id)sender;

@end

@implementation AGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Action methods

- (IBAction)login:(id)sender {
    NSString *username = self.usernameTxtField.text;
    NSString *password = self.passwordTxtField.text;
    
    // check if the fields are empty
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Required fields missing!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // attempt to login
    [[AGContactsNetworker shared] loginWithUsername:username password:password
                                  completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) { //success
            // move to the Contacts view
            [self performSegueWithIdentifier:@"ContactsViewSegue" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Authentication failed!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
