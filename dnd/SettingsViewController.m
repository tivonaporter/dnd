//
//  SettingsViewController.m
//  dnd
//
//  Created by Katie Porter on 2/5/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <Masonry/Masonry.h>

#import "SettingsViewController.h"

typedef enum : NSUInteger {
    SettingsSectionImport,
    SettingsSectionGeneral,
    SettingsSectionCount
} SettingsSection;

typedef enum : NSUInteger {
    SettingsSectionImportRowImport,
    SettingsSectionImportRowCount
} SettingsSectionImportRow;

typedef enum : NSUInteger {
    SettingsSectionGeneralRowFeedback,
    SettingsSectionGeneralRowNewsletter,
    SettingsSectionGeneralRowShare,
    SettingsSectionGeneralRowCount
} SettingsSectionGeneralRow;

@interface SettingsViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    self.tableNode.dataSource = self;
    self.tableNode.delegate = self;
    [self.view addSubview:self.tableNode.view];
    
    self.navigationItem.title = @"Settings";
    
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SettingsSectionImport: return @"Import";
        case SettingsSectionGeneral: return @"General";
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return SettingsSectionCount;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SettingsSectionImport: return SettingsSectionImportRowCount;
        case SettingsSectionGeneral: return SettingsSectionGeneralRowCount;
    }
    return 0;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return ^ASCellNode *() {
        ASTextCellNode *cellNode = [[ASTextCellNode alloc] init];
        cellNode.backgroundColor = [UIColor whiteColor];
        switch (indexPath.section) {
            case SettingsSectionImport:
                switch (indexPath.row) {
                    case SettingsSectionImportRowImport:
                        cellNode.text = @"Import";
                        break;
                }
                break;
            case SettingsSectionGeneral:
                switch (indexPath.row) {
                    case SettingsSectionGeneralRowFeedback:
                        cellNode.text = @"Feedback";
                        break;
                    case SettingsSectionGeneralRowNewsletter:
                        cellNode.text = @"Newsletter";
                        break;
                    case SettingsSectionGeneralRowShare:
                        cellNode.text = @"Share";
                        break;
                }
                break;
        }
        return cellNode;
    };
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
