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
@property (readwrite, nonatomic, strong) NSMutableArray *filteredContacts;

@property (weak, nonatomic) IBOutlet UISearchBar *contactsSearchBar;

@end

@implementation AGContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
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
    if (self.searchDisplayController.active) {
        return [self.filteredContacts count];
    } else {
        return [self.contacts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    AGContact *contact;
    
    if (self.searchDisplayController.active) {
        contact = self.filteredContacts[indexPath.row];
    } else {
        contact = self.contacts[indexPath.row];
    }
    
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
            
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // dismiss modal dialog
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // add to our local modal
            if (!contact.recId) {
                contact.recId = responseObject[@"id"];
                [self.contacts addObject:contact];
            }
            
            // ask table to refresh
            if (self.searchDisplayController.active) {
                [self.searchDisplayController.searchResultsTableView reloadData];
            } else {
                [self.tableView reloadData];
            }
        }
    };

    if (contact.recId) { // update existing
        [[AGContactsNetworker shared] PUT:@"/contacts" parameters:[contact asDictionary] completionHandler:completionHandler];
        
    } else { // create new
        [[AGContactsNetworker shared] POST:@"/contacts" parameters:[contact asDictionary] completionHandler:completionHandler];
    }
}

- (IBAction)logoutPressed:(id)sender {
    [[AGContactsNetworker shared] logout:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) { // if an error occured
            NSLog(@"%@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Bummer"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            // back to login screen
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredContacts removeAllObjects];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname contains[c] $name OR lastname contains[c] $name"];
    self.filteredContacts = [NSMutableArray arrayWithArray:[self.contacts filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{@"name": searchText}]]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

#pragma mark - Seque methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = segue.destinationViewController;
    AGContactDetailsViewController *contactDetailsViewController = [navigationController viewControllers][0];
    contactDetailsViewController.delegate = self;

    if ([segue.identifier isEqualToString:@"EditContactSegue"]) {
        
        AGContact *contact;
        
        if (self.searchDisplayController.active) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            contact = self.filteredContacts[indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            contact = self.contacts[indexPath.row];
        }
        
        contactDetailsViewController.contact = contact;
    }
}

@end
