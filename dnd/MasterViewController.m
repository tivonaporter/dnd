//
//  MasterViewController.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Masonry/Masonry.h>
#import <Realm/Realm.h>
#import <MMPopupView/MMAlertView.h>

#import "MasterViewController.h"
#import "CollectionViewController.h"
#import "Collection.h"
#import "CollectionCellNode.h"

@interface MasterViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) RLMResults *collections;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    [self.view addSubview:self.tableNode.view];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Collections";

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self.view setNeedsUpdateConstraints];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.collections = [[Collection allObjectsInRealm:realm] sortedResultsUsingKeyPath:@"name" ascending:YES];
    
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [self.collections addNotificationBlock:^(RLMResults<Collection *> *results, RLMCollectionChange *change, NSError *error) {
        if (error) return;
        if (!change) [weakSelf.tableNode reloadData];
        
        [weakSelf.tableNode performBatchAnimated:YES updates:^{
            [weakSelf.tableNode deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableNode insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableNode reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
        } completion:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.tableNode indexPathForSelectedRow]) {
        [self.tableNode deselectRowAtIndexPath:[self.tableNode indexPathForSelectedRow] animated:YES];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)dealloc
{
    [self.notificationToken stop];
}

- (void)insertNewObject:(id)sender
{
    MMAlertView *alert = [[MMAlertView alloc] initWithInputTitle:@"Start a new collection" detail:nil placeholder:@"New collection" handler:^(NSString *name) {
        [alert hide];
        if (!name || [name isEqualToString:@""]) name = @"New collection";
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [Collection createInRealm:realm withValue:@{ @"name" : name }];
        [realm commitWriteTransaction];
    }];
    [alert showWithBlock:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableNode.view setEditing:editing animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return self.collections.count;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Collection *collection = self.collections[indexPath.row];
    
    CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
    collectionViewController.collection = collection;
    UINavigationController *collectionNavigationController = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    
    collectionViewController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    collectionViewController.navigationItem.leftItemsSupplementBackButton = YES;
    
    UISplitViewController *splitController = (UISplitViewController *)self.parentViewController;
    [splitController showDetailViewController:collectionNavigationController sender:self];
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Collection *collection = self.collections[indexPath.row];
    CollectionCellNode *cell = [CollectionCellNode collectionCellNodeWithCollection:collection];
    return cell;
}

- (BOOL)tableView:(ASTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(ASTableNode *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
