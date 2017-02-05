//
//  AppDelegate.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <MMPopupView/MMAlertView.h>

#import "AppDelegate.h"
#import "CollectionViewController.h"
#import "ImportManager.h"
#import "RollManager.h"
#import "MasterViewController.h"
#import "CompendiumViewController.h"
#import "NSString+Extra.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ImportManager import];
    
    CompendiumViewController *compendiumViewController = [[CompendiumViewController alloc] init];
    UINavigationController *compendiumNavigationController = [[UINavigationController alloc] initWithRootViewController:compendiumViewController];
    compendiumNavigationController.tabBarItem.title = @"Compendium";
    compendiumNavigationController.tabBarItem.image = [UIImage imageNamed:@"compendium-tab-icon"];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    
    MasterViewController *masterViewController = [[MasterViewController alloc] init];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    
    splitViewController.viewControllers = @[masterNavigationController];
    splitViewController.tabBarItem.title = @"Collections";
    splitViewController.tabBarItem.image = [UIImage imageNamed:@"collection-tab-icon"];

    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.viewControllers = @[compendiumNavigationController, splitViewController];
    
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
    [RollManager showAlertForRollResult:roll];
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
