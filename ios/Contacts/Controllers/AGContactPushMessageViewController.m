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

#import "AGContactPushMessageViewController.h"
#import "AGContactsNetworker.h"
#import "AGContact.h"

@interface AGContactPushMessageViewController ()

@property (weak, nonatomic) IBOutlet UITextView *messageTxtField;

- (IBAction)send:(id)sender;

@end

@implementation AGContactPushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the title to the Contact name
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.contact.firstname, self.contact.lastname];
}

- (IBAction)send:(id)sender {
    // validate input
    if ([self.messageTxtField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please enter your message first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
 
    }
    
    // time to send message..
    
    // construct message payload
    NSDictionary *payload = @{@"author":  [AGContactsNetworker shared].username,
                              @"receiver": self.contact.email,
                              @"message": self.messageTxtField.text};
    

    // send it
    [[AGContactsNetworker shared] POST:@"/contacts/sendMessage" parameters:payload
            completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
                // verify result
                NSString *result;
                
                if (!error) { // success
                    result = @"Message sent successfully!";
                } else {
                    result = [error localizedDescription];
                }
                
                // inform user
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status"
                                                                message:result
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
    }];
}

@end
