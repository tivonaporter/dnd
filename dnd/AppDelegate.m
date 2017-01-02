//
//  AppDelegate.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import <MMPopupView/MMAlertView.h>

#import "AppDelegate.h"
#import "CollectionViewController.h"
#import "ImportManager.h"
#import "RollManager.h"
#import "SearchViewController.h"
#import "MasterViewController.h"
#import "NSString+Extra.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ImportManager import];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    
    MasterViewController *masterViewController = [[MasterViewController alloc] init];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    splitViewController.viewControllers = @[masterNavigationController];
    splitViewController.tabBarItem.title = @"Collections";
    splitViewController.tabBarItem.image = [UIImage imageNamed:@"collection-tab-icon"];

    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    SearchViewController *spellSearchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeView];
    spellSearchViewController.type = SearchViewControllerTypeSpell;
    UINavigationController *spellNavigationController = [[UINavigationController alloc] initWithRootViewController:spellSearchViewController];
    spellNavigationController.tabBarItem.title = @"Spells";
    spellNavigationController.tabBarItem.image = [UIImage imageNamed:@"spell-tab-icon"];
    
    SearchViewController *itemSearchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeView];
    itemSearchViewController.type = SearchViewControllerTypeItem;
    UINavigationController *itemNavigationController = [[UINavigationController alloc] initWithRootViewController:itemSearchViewController];
    itemNavigationController.tabBarItem.title = @"Items";
    itemNavigationController.tabBarItem.image = [UIImage imageNamed:@"item-tab-icon"];
    
    SearchViewController *monsterSearchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeView];
    monsterSearchViewController.type = SearchViewControllerTypeMonster;
    UINavigationController *monsterNavigationController = [[UINavigationController alloc] initWithRootViewController:monsterSearchViewController];
    monsterNavigationController.tabBarItem.title = @"Monsters";
    monsterNavigationController.tabBarItem.image = [UIImage imageNamed:@"monster-tab-icon"];
    
    SearchViewController *characterClassSearchViewController = [SearchViewController searchViewControllerWithMode:SearchViewControllerModeView];
    characterClassSearchViewController.type = SearchViewControllerTypeCharacterClass;
    UINavigationController *characterClassNavigationController = [[UINavigationController alloc] initWithRootViewController:characterClassSearchViewController];
    characterClassNavigationController.tabBarItem.title = @"Classes";
    characterClassNavigationController.tabBarItem.image = [UIImage imageNamed:@"class-tab-icon"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.viewControllers = @[spellNavigationController, itemNavigationController, monsterNavigationController, characterClassNavigationController, splitViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [MMAlertViewConfig globalConfig].defaultTextOK = @"Okay";
    [MMAlertViewConfig globalConfig].defaultTextCancel = @"Cancel";
    [MMAlertViewConfig globalConfig].defaultTextConfirm = @"Confirm";
     
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[CollectionViewController class]] && ([(CollectionViewController *)[(UINavigationController *)secondaryViewController topViewController] collection] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - ASTextNodeDelegate

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    RollResult roll = [RollManager resultOfRollString:value];
    NSString *reaction = @"";
    NSString *prefix = @"";
    
    switch (roll.quality) {
        case RollQualityTerrible:
            reaction = @"🖕";
            prefix = @"Bugbears!";
            break;
        case RollQualityBad:
            reaction = @"👎";
            prefix = @"Darn.";
            break;
        case RollQualityAverage:
            reaction = @"👍";
            break;
        case RollQualityGood:
            reaction = @"🙌";
            prefix = @"Yay!";
            break;
        case RollQualityGreat:
            reaction = @"🎉";
            prefix = @"Praise Tymora!";
            break;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ You got %lu.", prefix, (unsigned long)roll.result];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD hideAnimated:YES];
        NSArray *items = @[MMItemMake(reaction, MMItemTypeNormal, nil)];
        MMAlertView *alert = [[MMAlertView alloc] initWithTitle:title detail:nil items:items];
        [alert showWithBlock:nil];
    });
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point
{
    return YES;
}

#pragma mark - AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
