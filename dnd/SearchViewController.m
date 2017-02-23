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
#import "DetailViewController.h"
#import "Spell.h"
#import "Item.h"
#import "Monster.h"
#import "CharacterClass.h"
#import "Race.h"
#import "SpellCellNode.h"
#import "ItemCellNode.h"
#import "MonsterCellNode.h"
#import "CharacterClassCellNode.h"
#import "RaceCellNode.h"

@interface SearchViewController () <UISearchResultsUpdating, ASTableDelegate, ASTableDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) RLMResults *results;
@property (nonatomic, strong) RLMResults *filteredResults;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) SearchViewControllerMode mode;

@end

@implementation SearchViewController

+ (instancetype)searchViewControllerWithMode:(SearchViewControllerMode)mode
{
    SearchViewController *viewController = [[SearchViewController alloc] init];
    viewController.mode = mode;
    
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Class objectClass = [self classForCurrentType];
    self.results = [objectClass performSelector:@selector(allObjects)];
    switch (self.type) {
        case SearchViewControllerTypeSpell: {
            RLMSortDescriptor *levelDescriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"level" ascending:YES];
            RLMSortDescriptor *nameDescriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"name" ascending:YES];
            self.results = [self.results sortedResultsUsingDescriptors:@[levelDescriptor, nameDescriptor]];
            break;
        }
        case SearchViewControllerTypeItem:
            self.results = [self.results sortedResultsUsingKeyPath:@"name" ascending:YES];
            break;
        case SearchViewControllerTypeMonster:
            self.results = [self.results sortedResultsUsingKeyPath:@"challengeRating" ascending:YES];
            break;
        case SearchViewControllerTypeCharacterClass:
            self.results = [self.results sortedResultsUsingKeyPath:@"name" ascending:YES];
            break;
        case SearchViewControllerTypeRace:
            self.results = [self.results sortedResultsUsingKeyPath:@"name" ascending:YES];
            break;
        default:
            break;
    }
    
    if (self.mode == SearchViewControllerModeAdd) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }

    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    tableViewController.tableView.delegate = self;
    tableViewController.tableView.dataSource = self;
    
    self.tableView = tableViewController.tableView;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:tableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    self.tableNode.view.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableNode.view];
    
    switch (self.mode) {
        case SearchViewControllerModeAdd:
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
                case SearchViewControllerTypeCharacterClass:
                    self.navigationItem.title = @"Add a Class";
                    break;
                case SearchViewControllerTypeRace:
                    self.navigationItem.title = @"Add a Race";
                    break;
                default:
                    break;
            }
            break;
        case SearchViewControllerModeView:
            switch (self.type) {
                case SearchViewControllerTypeSpell:
                    self.navigationItem.title = @"Spells";
                    break;
                case SearchViewControllerTypeItem:
                    self.navigationItem.title = @"Items";
                    break;
                case SearchViewControllerTypeMonster:
                    self.navigationItem.title = @"Monsters";
                    break;
                case SearchViewControllerTypeCharacterClass:
                    self.navigationItem.title = @"Classes";
                    break;
                case SearchViewControllerTypeRace:
                    self.navigationItem.title = @"Races";
                    break;
                default:
                    break;
            }
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
    Class objectClass = [self classForCurrentType];
    
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", self.searchController.searchBar.text];
    self.filteredResults = [objectClass performSelector:@selector(objectsWithPredicate:) withObject:newPredicate];
    self.filteredResults = [self.filteredResults sortedResultsUsingKeyPath:@"name" ascending:YES];
    [self.tableView reloadData];
}

- (Class)classForCurrentType
{
    Class objectClass;
    switch (self.type) {
        case SearchViewControllerTypeSpell: objectClass = [Spell class]; break;
        case SearchViewControllerTypeItem: objectClass = [Item class]; break;
        case SearchViewControllerTypeMonster: objectClass = [Monster class]; break;
        case SearchViewControllerTypeCharacterClass: objectClass = [CharacterClass class]; break;
        case SearchViewControllerTypeRace: objectClass = [Race class]; break;
        default: break;
    }
    return objectClass;
}

- (void)showDetailViewControllerForObject:(id)object
{
    DetailViewControllerMode mode;
    
    switch (self.mode) {
        case SearchViewControllerModeAdd:
            mode = DetailViewControllerModeAdd;
            break;
        case SearchViewControllerModeView:
            mode = DetailViewControllerModeView;
            break;
    }
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithObject:object mode:mode];
    detailViewController.selectionAction = self.selectionAction;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self updateSearchResults];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.filteredResults[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    switch (self.type) {
        case SearchViewControllerTypeSpell: {
            Spell *spell = (Spell *)object;
            cell.textLabel.text = spell.name;
        }
        case SearchViewControllerTypeItem: {
            Item *item = (Item *)object;
            cell.textLabel.text = item.name;
        }
        case SearchViewControllerTypeMonster: {
            Monster *monster = (Monster *)object;
            cell.textLabel.text = monster.name;
        }
        case SearchViewControllerTypeCharacterClass: {
            CharacterClass *characterClass = (CharacterClass *)object;
            cell.textLabel.text = characterClass.name;
        }
        case SearchViewControllerTypeRace: {
            Race *race = (Race *)object;
            cell.textLabel.text = race.name;
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.filteredResults objectAtIndex:indexPath.row];
    [self showDetailViewControllerForObject:object];
}

#pragma mark - ASTableViewDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    id object = self.results[indexPath.row];
    NSString *identifier;
    switch (self.type) {
        case SearchViewControllerTypeSpell: identifier = ((Spell *)object).name;
        case SearchViewControllerTypeItem: identifier = ((Item *)object).name;
        case SearchViewControllerTypeMonster: identifier = ((Monster *)object).name;
        case SearchViewControllerTypeCharacterClass: identifier = ((CharacterClass *)object).name;
        case SearchViewControllerTypeRace: identifier = ((Race *)object).name;
    };
    
    __weak typeof(self) weakSelf = self;
    return ^ASCellNode *() {
        switch (weakSelf.type) {
            case SearchViewControllerTypeSpell: {
                Spell *spell = [Spell objectForPrimaryKey:identifier];
                SpellCellNode *cell = [[SpellCellNode alloc] initWithSpell:spell detailed:NO];
                return cell;
            }
            case SearchViewControllerTypeItem: {
                Item *item = [Item objectForPrimaryKey:identifier];
                ItemCellNode *cell = [[ItemCellNode alloc] initWithItem:item detailed:NO];
                return cell;
            }
            case SearchViewControllerTypeMonster: {
                Monster *monster = [Monster objectForPrimaryKey:identifier];
                MonsterCellNode *cell = [[MonsterCellNode alloc] initWithMonster:monster detailed:NO];
                return cell;
            }
            case SearchViewControllerTypeCharacterClass: {
                CharacterClass *characterClass = [CharacterClass objectForPrimaryKey:identifier];
                CharacterClassCellNode *cell = [[CharacterClassCellNode alloc] initWithCharacterClass:characterClass detailed:NO];
                return cell;
            }
            case SearchViewControllerTypeRace: {
                Race *race = [Race objectForPrimaryKey:identifier];
                RaceCellNode *cell = [[RaceCellNode alloc] initWithRace:race detailed:NO];
                return cell;
            }
            default: return nil;
        };
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.results objectAtIndex:indexPath.row];
    [self showDetailViewControllerForObject:object];
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

@end
