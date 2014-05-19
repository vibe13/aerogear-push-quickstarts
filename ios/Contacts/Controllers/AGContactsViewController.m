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
#import "AGContactPushMessageViewController.h"
#import "AGContactsNetworker.h"
#import "AGContact.h"

@interface AGContactsViewController ()
@property (readwrite, nonatomic, strong) NSMutableDictionary *contacts;
@property (readwrite, nonatomic, strong) NSMutableArray *filteredContacts;

@property (readwrite, nonatomic, strong) NSMutableArray *contactsSectionTitles;

@property (weak, nonatomic) IBOutlet UISearchBar *contactsSearchBar;

- (IBAction)logoutPressed:(id)sender;

@end

@implementation AGContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup "pull to refresh" control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // hide the back button, logout button is used instead
    self.navigationItem.hidesBackButton = YES;
    
     // load initial data
    [self refresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.contactsSectionTitles count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return self.contactsSectionTitles[section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredContacts count];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[section];
        
        return [self.contacts[sectionTitle] count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        // user-locale alphabet list
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.contactsSectionTitles indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];

    AGContact *contact;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = self.filteredContacts[indexPath.row];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section];
        contact = self.contacts[sectionTitle][indexPath.row];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
    cell.detailTextLabel.text = contact.email;
    
    return cell;
}

#pragma mark - Table delete

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AGContact *contact;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = self.filteredContacts[indexPath.row];
    } else {
        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section] ;
        contact = self.contacts[sectionTitle][indexPath.row];
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // attempt to delete
        [[AGContactsNetworker shared] DELETE:@"/contacts" parameters:[contact asDictionary] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

            if (error) { // if an error occured
                NSLog(@"%@", error);

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Bummer"
                                                      otherButtonTitles:nil];
                [alert show];

            } else { // success

                NSMutableArray *contacts = self.contacts[self.contactsSectionTitles[indexPath.section]];
                
                // care if delete was performed under search mode
                if (tableView == self.searchDisplayController.searchResultsTableView) {
                    // remove from filtered local model
                    [self.filteredContacts removeObjectAtIndex:indexPath.row];

                    // we also need to remove from local model

                    // determine the row using the contact id
                    __block NSInteger index;
                    [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        AGContact *current = (AGContact *)obj;

                        if ([contact.recId isEqualToNumber:current.recId]) {
                            index = idx;
                            *stop = YES; // no need to continue
                        }
                    }];

                    // time to delete it
                    [contacts removeObjectAtIndex:index];

                    // remove from search tableview
                    NSArray *paths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];

                } else {
                    // delete from local model
                    [contacts removeObjectAtIndex:indexPath.row];

                    // remove from tableview
                    NSArray *paths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }];
    }
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
                
                [self addContact:contact];
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

# pragma mark - Actions

- (void)refresh {
    [[AGContactsNetworker shared] GET:@"/contacts" parameters:nil
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

            [self.refreshControl endRefreshing];

            self.contacts = [[NSMutableDictionary alloc] init];
            
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AGContact *contact = [[AGContact alloc] initWithDictionary:obj];
                
                [self addContact:contact];
                
            }];
                        
            // refresh section alphabet
            self.contactsSectionTitles = [[self.contacts allKeys] mutableCopy];
            [self.contactsSectionTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                        
            [self.tableView reloadData];
        }];
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredContacts removeAllObjects];

    // will store the filtered results
    __block NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // apply predicate to each array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstname contains[c] $name OR lastname contains[c] $name"];
    
    [[self.contacts allValues] enumerateObjectsUsingBlock:^(id arr, NSUInteger idx, BOOL *stop) {
        [results addObjectsFromArray:[arr filteredArrayUsingPredicate:
                                      [predicate predicateWithSubstitutionVariables:@{@"name": searchText}]]];
    }];
    
    self.filteredContacts = results;
}

#pragma mark - UISearchBarDelegate Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.tableView reloadData];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

#pragma mark - Seque methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddContactSegue"] || [segue.identifier isEqualToString:@"EditContactSegue"]) {
        // for both "Add" and "Edit" mode, attach delegate to self
        UINavigationController *navigationController = segue.destinationViewController;
        AGContactDetailsViewController *contactDetailsViewController = [navigationController viewControllers][0];
        contactDetailsViewController.delegate = self;
        
        // for "Edit", pass the Contact to the controller
        if ([segue.identifier isEqualToString:@"EditContactSegue"]) {
            AGContact *contact = [self activeContactFromCell:sender];
            contactDetailsViewController.contact = contact;
        }
        
    } else if ([segue.identifier isEqualToString:@"SendMessageSegue"]) {
        AGContactPushMessageViewController *contactMessageViewControler = segue.destinationViewController;
        
        AGContact *contact = [self activeContactFromCell:sender];
        contactMessageViewControler.contact = contact;
    }
}

#pragma mark - utility method

- (AGContact *)activeContactFromCell:(UITableViewCell *)cell {
    AGContact *contact;
    
    if (self.searchDisplayController.active) { // if we are in 'search' mode
        // retrieve active contact from search tableview
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
        contact = self.filteredContacts[indexPath.row];
    } else {
        // just normal tableview
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        NSString *sectionTitle = self.contactsSectionTitles[indexPath.section];
        contact = self.contacts[sectionTitle][indexPath.row];
    }

    return contact;
}

- (void)addContact:(AGContact *)contact {
    // determine section by first letter of "first name"
    NSString *letter = [contact.firstname substringToIndex:1];
    NSMutableArray *contactsInSection = self.contacts[letter];
    
    // if the section doesn't exist
    if (!contactsInSection) {
        // create it
        [self.contactsSectionTitles addObject:letter];
        // sort newly inserted section name
        [self.contactsSectionTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        // create arr to hold contacts in section
        contactsInSection = [[NSMutableArray alloc] init];
        
        // assign
        self.contacts[letter] = contactsInSection;
    }
    
    /// add it
    [contactsInSection addObject:contact];
    // sort contacts "section" by "first name" (see :compare on AGContact)
    [contactsInSection sortUsingSelector:@selector(compare:)];
}

@end
