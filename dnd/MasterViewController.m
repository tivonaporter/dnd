//
//  MasterViewController.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "MasterViewController.h"
#import "CollectionViewController.h"
#import <Realm/Realm.h>
#import "Collection.h"

@interface MasterViewController ()

@property (nonatomic, strong) RLMResults *collections;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.collectionViewController = (CollectionViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.collections = [[Collection allObjectsInRealm:realm] sortedResultsUsingProperty:@"name" ascending:YES];
    
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [self.collections addNotificationBlock:^(RLMResults<Collection *> *results, RLMCollectionChange *change, NSError *error) {
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tableView = weakSelf.tableView;
        if (!change) {
            [tableView reloadData];
            return;
        }
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }];
}

- (void)dealloc
{
    [self.notificationToken stop];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)insertNewObject:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Start a new collection"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New collection";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeYes;
    }];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Create"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                UITextField *textField = alert.textFields.firstObject;
                                                NSString *name = textField.text;
                                                if (!name || [name isEqualToString:@""]) name = @"New collection";
                                                
                                                RLMRealm *realm = [RLMRealm defaultRealm];
                                                [realm beginWriteTransaction];
                                                [Collection createInRealm:realm withValue:@{ @"name" : name }];
                                                [realm commitWriteTransaction];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Collection *collection = self.collections[indexPath.row];
        CollectionViewController *controller = (CollectionViewController *)[[segue destinationViewController] topViewController];
        controller.collection = collection;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Collection *collection = self.collections[indexPath.row];
    cell.textLabel.text = collection.name;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Collection *collection = self.collections[indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:collection];
        [realm commitWriteTransaction];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
