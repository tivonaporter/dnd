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
#import "ItemCellNode.h"
#import "Spell.h"
#import "Monster.h"
#import "Item.h"

typedef enum : NSUInteger {
    DetailViewControllerTypeSpell,
    DetailViewControllerTypeItem,
    DetailViewControllerTypeMonster
} DetailViewControllerType;

@interface DetailViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) RLMObject *object;
@property (nonatomic, assign) DetailViewControllerType type;

@end

@implementation DetailViewController

- (instancetype)initWithObject:(RLMObject *)object
{
    if (!(self = [super init])) return nil;
    self.object = object;
    
    if ([self.object isKindOfClass:[Spell class]]) {
        self.type = DetailViewControllerTypeSpell;
    } else if ([self.object isKindOfClass:[Item class]]) {
        self.type = DetailViewControllerTypeItem;
    } else if ([self.object isKindOfClass:[Monster class]]) {
        self.type = DetailViewControllerTypeMonster;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    [self.view addSubview:self.tableNode.view];
    
    [self updateViewConstraints];
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
            default: return nil;
        };
    };
}

@end
