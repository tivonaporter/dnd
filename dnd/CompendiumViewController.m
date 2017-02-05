//
//  CompendiumViewController.m
//  dnd
//
//  Created by Katie Porter on 2/4/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Masonry/Masonry.h>
#import <UIColor_HexString/UIColor+HexString.h>

#import "CompendiumViewController.h"
#import "SearchViewController.h"
#import "CompendiumCellNode.h"

typedef enum : NSUInteger {
    CompendiumRowSpell,
    CompendiumRowItem,
    CompendiumRowMonster,
    CompendiumRowClass,
    CompendiumRowRace,
    CompendiumRowCount
} CompendiumRow;

@interface CompendiumViewController () <ASCollectionDelegate, ASCollectionDataSource>

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation CompendiumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.93f alpha:1.0f];
    self.navigationItem.title = @"Compendium";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15.0f;
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - (layout.minimumInteritemSpacing * 3.0f)) / 2.0f;
    layout.itemSize = CGSizeMake(size, size);
    layout.sectionInset = UIEdgeInsetsMake(layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing, layout.minimumInteritemSpacing);
    
    self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    self.collectionNode.delegate = self;
    self.collectionNode.dataSource = self;
    [self.view addSubview:self.collectionNode.view];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.collectionNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode
{
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section
{
    return CompendiumRowCount;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewController *searchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeView];
    switch (indexPath.row) {
        case CompendiumRowItem:
            searchViewController.type = SearchViewControllerTypeItem;
            break;
        case CompendiumRowSpell:
            searchViewController.type = SearchViewControllerTypeSpell;
            break;
        case CompendiumRowMonster:
            searchViewController.type = SearchViewControllerTypeMonster;
            break;
        case CompendiumRowClass:
            searchViewController.type = SearchViewControllerTypeCharacterClass;
            break;
        case CompendiumRowRace:
            searchViewController.type = SearchViewControllerTypeRace;
            break;
    }
    [self.navigationController pushViewController:searchViewController animated:YES];
    [self.collectionNode deselectItemAtIndexPath:indexPath animated:YES];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return ^ASCellNode *() {
        CompendiumCellNode *cellNode;
        switch (indexPath.row) {
            case CompendiumRowItem:
                cellNode = [CompendiumCellNode compendiumNodeWithType:CompendiumNodeTypeItem];
                break;
            case CompendiumRowSpell:
                cellNode = [CompendiumCellNode compendiumNodeWithType:CompendiumNodeTypeSpell];
                break;
            case CompendiumRowMonster:
                cellNode = [CompendiumCellNode compendiumNodeWithType:CompendiumNodeTypeMonster];
                break;
            case CompendiumRowClass:
                cellNode = [CompendiumCellNode compendiumNodeWithType:CompendiumNodeTypeClass];
                break;
            case CompendiumRowRace:
                cellNode = [CompendiumCellNode compendiumNodeWithType:CompendiumNodeTypeRace];
                break;
        }
        return cellNode;
    };
}

@end
