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

#import "AGContactsViewController.h"
#import "AGContactsNetworker.h"
#import "AGContact.h"

@interface AGContactsViewController ()
@property (readwrite, nonatomic, strong) NSMutableArray *contacts;
@end

@implementation AGContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AGContactsNetworker shared] GET:@"/contacts" parameters:nil
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        
                        self.contacts = [[NSMutableArray alloc] init];
                        
                        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            AGContact *contact = [[AGContact alloc] initWithDictionary:obj];
                            [self.contacts addObject:contact];
                        }];
                        
                        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    AGContact *contact = self.contacts[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
    cell.detailTextLabel.text = contact.email;
    
    return cell;
}

#pragma mark - AGContactDetailsViewControllerDelegate methods

- (void)contactDetailsViewControllerDidCancel:(AGContactDetailsViewController *)controller {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactDetailsViewController:(AGContactDetailsViewController *)controller didSave:(AGContact *)contact {

    // since completionhandler logic is common, define upfront
    id completionHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {

        if (error) { // if an error occured
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // dismiss modal dialog
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // add to our local modal
            [self.contacts addObject:contact];
            
            // ask table to refresh
            [self.tableView reloadData];
        }
    };

    if (contact.recId) { // update existing
        [[AGContactsNetworker shared] PUT:@"/contacts" parameters:[contact asDictionary] completionHandler:completionHandler];
        
    } else { // create new
        [[AGContactsNetworker shared] POST:@"/contacts" parameters:[contact asDictionary] completionHandler:completionHandler];
    }
}

#pragma mark - Seque methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ContactDetailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AGContactDetailsViewController *contactDetailsViewController = [navigationController viewControllers][0];
        contactDetailsViewController.delegate = self;
    }
}

@end
