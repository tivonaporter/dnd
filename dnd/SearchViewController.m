//
//  SearchViewController.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Realm/Realm.h>
#import <Masonry/Masonry.h>
#import <BKDeltaCalculator/BKDeltaCalculator.h>
#import <BKDeltaCalculator/BKDelta.h>

#import "SearchViewController.h"
#import "Spell.h"
#import "Item.h"
#import "Monster.h"
#import "SpellCellNode.h"
#import "ItemCellNode.h"
#import "MonsterCellNode.h"

@interface SearchViewController () <UISearchResultsUpdating, ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) dispatch_queue_t jobQueue;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[NSArray alloc] init];
    self.jobQueue = dispatch_queue_create([[[NSUUID UUID] UUIDString] UTF8String], NULL);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = addButton;

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    self.tableNode.view.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableNode.view];
    
    switch (self.type) {
        case SearchViewControllerTypeSpell:
            self.navigationItem.title = @"Add a Spell";
            break;
        case SearchViewControllerTypeItem:
            self.navigationItem.title = @"Add an Item";
            break;
        case SearchViewControllerTypeMonster:
            self.navigationItem.title = @"Add a Monster";
            break;
        default:
            break;
    }
    
    [self updateSearchResults];
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)cancelButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateSearchResults
{
    Class objectClass;
    switch (self.type) {
        case SearchViewControllerTypeSpell: objectClass = [Spell class]; break;
        case SearchViewControllerTypeItem: objectClass = [Item class]; break;
        case SearchViewControllerTypeMonster: objectClass = [Monster class]; break;
        default: break;
    }
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", self.searchController.searchBar.text];
    RLMResults *newResults = [objectClass performSelector:@selector(objectsWithPredicate:) withObject:newPredicate];
    NSMutableArray *newDataSource = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < MIN(10, newResults.count); index++) {
        [newDataSource addObject:newResults[index]];
    }
    
    BKDeltaCalculator *calculator = [BKDeltaCalculator deltaCalculatorWithEqualityTest:^BOOL(RLMObject *A, RLMObject *B) {
        return [A isEqualToObject:B];
    }];
    BKDelta *delta = [calculator deltaFromOldArray:self.dataSource toNewArray:newDataSource];
    
    [self.tableNode performBatchAnimated:YES updates:^{
        [delta applyUpdatesToTableView:self.tableNode.view inSection:0 withRowAnimation:UITableViewRowAnimationFade];
        self.dataSource = newDataSource;
    } completion:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self updateSearchResults];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    id object = self.dataSource[indexPath.row];
    NSString *identifier;
    switch (self.type) {
        case SearchViewControllerTypeSpell: identifier = ((Spell *)object).name;
        case SearchViewControllerTypeItem: identifier = ((Item *)object).name;
        case SearchViewControllerTypeMonster: identifier = ((Monster *)object).name;
    };
    
    __weak typeof(self) weakSelf = self;
    return ^ASCellNode *() {
        switch (weakSelf.type) {
            case SearchViewControllerTypeSpell: {
                Spell *spell = [Spell objectForPrimaryKey:identifier];
                SpellCellNode *cell = [[SpellCellNode alloc] initWithSpell:spell detailed:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case SearchViewControllerTypeItem: {
                Item *item = [Item objectForPrimaryKey:identifier];
                ItemCellNode *cell = [[ItemCellNode alloc] initWithItem:item detailed:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case SearchViewControllerTypeMonster: {
                Monster *monster = [Monster objectForPrimaryKey:identifier];
                MonsterCellNode *cell = [[MonsterCellNode alloc] initWithMonster:monster detailed:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            default: return nil;
        };
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id result = [self.dataSource objectAtIndex:indexPath.row];
    if (self.selectionAction) self.selectionAction(result);
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
