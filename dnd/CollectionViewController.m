//
//  CollectionViewController.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//


#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Realm/Realm.h>
#import <Masonry/Masonry.h>

#import "CollectionViewController.h"
#import "SearchViewController.h"
#import "SpellCellNode.h"
#import "MonsterCellNode.h"
#import "CharacterClassCellNode.h"
#import "ItemCellNode.h"
#import "Spell.h"
#import "Monster.h"
#import "Item.h"
#import "CharacterClass.h"
#import "Collection.h"
#import "CollectionItem.h"
#import "DetailViewController.h"

@interface CollectionViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) RLMResults *results;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addButtonTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    [self.view addSubview:self.tableNode.view];
    
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [self.results addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error) return;
        if (!change) [weakSelf.tableNode reloadData];
        
        [weakSelf.tableNode performBatchUpdates:^{
            [weakSelf.tableNode deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableNode insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableNode reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
        } completion:nil];
    }];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addButtonTapped:(UIBarButtonItem *)sender
{
    SearchViewController *searchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeAdd];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Spell" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchViewController.type = SearchViewControllerTypeSpell;
        searchViewController.selectionAction = ^(id selectedItem) {
            Spell *spell = (Spell *)selectedItem;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CollectionItem *collectionItem = [CollectionItem createInRealm:realm withValue:@{ @"spell" : spell }];
            [self.collection.items addObject:collectionItem];
            [realm commitWriteTransaction];
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchViewController.type = SearchViewControllerTypeItem;
        searchViewController.selectionAction = ^(id selectedItem) {
            Item *item = (Item *)selectedItem;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CollectionItem *collectionItem = [CollectionItem createInRealm:realm withValue:@{ @"item" : item }];
            [self.collection.items addObject:collectionItem];
            [realm commitWriteTransaction];
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Monster" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchViewController.type = SearchViewControllerTypeMonster;
        searchViewController.selectionAction = ^(id selectedItem) {
            Monster *monster = (Monster *)selectedItem;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CollectionItem *collectionItem = [CollectionItem createInRealm:realm withValue:@{ @"monster" : monster }];
            [self.collection.items addObject:collectionItem];
            [realm commitWriteTransaction];
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Class" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchViewController.type = SearchViewControllerTypeCharacterClass;
        searchViewController.selectionAction = ^(id selectedItem) {
            CharacterClass *characterClass = (CharacterClass *)selectedItem;
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            CollectionItem *collectionItem = [CollectionItem createInRealm:realm withValue:@{ @"characterClass" : characterClass }];
            [self.collection.items addObject:collectionItem];
            [realm commitWriteTransaction];
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.barButtonItem = sender;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setCollection:(Collection *)collection
{
    _collection = collection;
    self.navigationItem.title = collection.name;
    
    NSArray *descriptors = @[
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"characterClass.name" ascending:YES],
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"spell.level" ascending:YES],
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"spell.name" ascending:YES],
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"item.name" ascending:YES],
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"monster.challengeRating" ascending:YES],
                             [RLMSortDescriptor sortDescriptorWithKeyPath:@"monster.name" ascending:YES],
                             ];
    
    self.results = [self.collection.items sortedResultsUsingDescriptors:descriptors];
}

- (void)dealloc
{
    [self.notificationToken stop];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionItem *collectionItem = [self.results objectAtIndex:indexPath.row];
    DetailViewController *viewController;
    if (collectionItem.spell) {
        viewController = [[DetailViewController alloc] initWithObject:collectionItem.spell mode:DetailViewControllerModeView];
    } else if (collectionItem.item) {
        viewController = [[DetailViewController alloc] initWithObject:collectionItem.item mode:DetailViewControllerModeView];
    } else if (collectionItem.monster) {
        viewController = [[DetailViewController alloc] initWithObject:collectionItem.monster mode:DetailViewControllerModeView];
    } else if (collectionItem.characterClass) {
        viewController = [[DetailViewController alloc] initWithObject:collectionItem.characterClass mode:DetailViewControllerModeView];
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CollectionItem *collectionItem = [self.results objectAtIndex:indexPath.row];
    NSString *collectionItemId = collectionItem.identifier;
    
    return ^ASCellNode *() {
        CollectionItem *threadCollectionItem = [CollectionItem objectForPrimaryKey:collectionItemId];
        
        if (threadCollectionItem.spell) {
            SpellCellNode *cell = [[SpellCellNode alloc] initWithSpell:threadCollectionItem.spell detailed:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (threadCollectionItem.item) {
            ItemCellNode *cell = [[ItemCellNode alloc] initWithItem:threadCollectionItem.item detailed:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (threadCollectionItem.monster) {
            MonsterCellNode *cell = [[MonsterCellNode alloc] initWithMonster:threadCollectionItem.monster detailed:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (threadCollectionItem.characterClass) {
            CharacterClassCellNode *cell = [[CharacterClassCellNode alloc] initWithCharacterClass:threadCollectionItem.characterClass detailed:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        return nil;
    };
}

- (BOOL)tableView:(ASTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(ASTableNode *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CollectionItem *item = self.results[indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:item];
        [realm commitWriteTransaction];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
