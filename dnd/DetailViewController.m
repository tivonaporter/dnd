//
//  DetailViewController.m
//  dnd
//
//  Created by Devon Tivona on 12/28/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Realm/Realm.h>

#import "DetailViewController.h"
#import "SpellCellNode.h"
#import "MonsterCellNode.h"
#import "CharacterClassCellNode.h"
#import "ItemCellNode.h"
#import "RaceCellNode.h"
#import "Spell.h"
#import "Monster.h"
#import "Item.h"
#import "CharacterClass.h"
#import "Race.h"

typedef enum : NSUInteger {
    DetailViewControllerTypeSpell,
    DetailViewControllerTypeItem,
    DetailViewControllerTypeMonster,
    DetailViewControllerTypeCharacterClass,
    DetailViewControllerTypeRace
} DetailViewControllerType;

@interface DetailViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) RLMObject *object;
@property (nonatomic, assign) DetailViewControllerType type;
@property (nonatomic, assign) DetailViewControllerMode mode;

@end

@implementation DetailViewController

- (instancetype)initWithObject:(RLMObject *)object mode:(DetailViewControllerMode)mode
{
    if (!(self = [super init])) return nil;
    self.object = object;
    self.mode = mode;
    
    if ([self.object isKindOfClass:[Spell class]]) {
        self.type = DetailViewControllerTypeSpell;
    } else if ([self.object isKindOfClass:[Item class]]) {
        self.type = DetailViewControllerTypeItem;
    } else if ([self.object isKindOfClass:[Monster class]]) {
        self.type = DetailViewControllerTypeMonster;
    } else if ([self.object isKindOfClass:[CharacterClass class]]) {
        self.type = DetailViewControllerTypeCharacterClass;
    } else if ([self.object isKindOfClass:[Race class]]) {
        self.type = DetailViewControllerTypeRace;
    }

    if (self.mode == DetailViewControllerModeAdd) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(addButtonTapped)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableNode.view];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (self.type) {
        case DetailViewControllerTypeSpell: identifier = ((Spell *)self.object).name; break;
        case DetailViewControllerTypeItem: identifier = ((Item *)self.object).name; break;
        case DetailViewControllerTypeMonster: identifier = ((Monster *)self.object).name; break;
        case DetailViewControllerTypeCharacterClass: identifier = ((CharacterClass *)self.object).name; break;
        case DetailViewControllerTypeRace: identifier = ((Race *)self.object).name; break;
    };
    
    __weak typeof(self) weakSelf = self;
    return ^ASCellNode *() {
        switch (weakSelf.type) {
            case DetailViewControllerTypeSpell: {
                Spell *spell = [Spell objectForPrimaryKey:identifier];
                SpellCellNode *cell = [[SpellCellNode alloc] initWithSpell:spell detailed:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case DetailViewControllerTypeItem: {
                Item *item = [Item objectForPrimaryKey:identifier];
                ItemCellNode *cell = [[ItemCellNode alloc] initWithItem:item detailed:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case DetailViewControllerTypeMonster: {
                Monster *monster = [Monster objectForPrimaryKey:identifier];
                MonsterCellNode *cell = [[MonsterCellNode alloc] initWithMonster:monster detailed:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case DetailViewControllerTypeCharacterClass: {
                CharacterClass *characterClass = [CharacterClass objectForPrimaryKey:identifier];
                CharacterClassCellNode *cell = [[CharacterClassCellNode alloc] initWithCharacterClass:characterClass detailed:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case DetailViewControllerTypeRace: {
                Race *race = [Race objectForPrimaryKey:identifier];
                RaceCellNode *cell = [[RaceCellNode alloc] initWithRace:race detailed:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            default: return nil;
        };
    };
}

- (void)addButtonTapped
{
    if (self.selectionAction) self.selectionAction(self.object);
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
