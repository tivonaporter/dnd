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

@import MessageUI;

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

@interface SettingsViewController () <ASTableDelegate, ASTableDataSource, MFMailComposeViewControllerDelegate>

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
                        cellNode.text = @"Send us feedback 📣";
                        break;
                    case SettingsSectionGeneralRowNewsletter:
                        cellNode.text = @"Sign up for our rad newsletter 📰";
                        break;
                    case SettingsSectionGeneralRowShare:
                        cellNode.text = @"Share with your party 🎉";
                        break;
                }
                break;
        }
        return cellNode;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SettingsSectionImport:
            switch (indexPath.row) {
                case SettingsSectionImportRowImport:
                    
                    break;
            }
            break;
        case SettingsSectionGeneral:
            switch (indexPath.row) {
                case SettingsSectionGeneralRowFeedback: {
                    NSString *feedbackEmail = @"katie@janekporter.com";
                    if ([MFMailComposeViewController canSendMail]) {
                        MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
                        viewController.mailComposeDelegate = self;
                        [viewController setToRecipients:@[feedbackEmail]];
                        [self presentViewController:viewController animated:YES completion:nil];
                    } else {
                        NSString *alertMessage = [NSString stringWithFormat:@"We'd love to hear from you! Email us at %@.", feedbackEmail];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Feedback"
                                                                                                 message:alertMessage
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Sounds good" style:UIAlertActionStyleDefault handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    break;
                }
                case SettingsSectionGeneralRowNewsletter: {
                    NSString *alertMessage = @"Sign up for our newsletter and we'll let you know when we add super cool stuff to the app.";
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Newsletter"
                                                                                             message:alertMessage
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.keyboardType = UIKeyboardTypeEmailAddress;
                        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        textField.autocorrectionType = UITextAutocorrectionTypeNo;
                    }];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Sign up"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                                          NSLog(@"We're done, dawg.");
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    break;
                }
                case SettingsSectionGeneralRowShare: {
                    NSURL *URL = [NSURL URLWithString:@"https://www.google.com"];
                    NSString *shareMessage = @"Check out this awesome app I downloaded to help us play D&D.";
                    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareMessage, URL]
                                                                                                 applicationActivities:nil];
                    viewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList];
                    [self presentViewController:viewController animated:YES completion:nil];
                    break;
                }
            }
            break;
    }
    [tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableNode.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
