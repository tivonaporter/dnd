//
//  SearchViewController.h
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchViewControllerTypeSpell,
    SearchViewControllerTypeItem,
    SearchViewControllerTypeMonster
} SearchViewControllerType;

typedef enum : NSUInteger {
    SearchViewControllerModeView,
    SearchViewControllerModeAdd
} SearchViewControllerMode;

@interface SearchViewController : UIViewController

+ (instancetype)searchViewControllerWithMode:(SearchViewControllerMode)mode;

@property (nonatomic, assign) SearchViewControllerType type;
@property (nonatomic, copy) void (^selectionAction)(id selectedItem);

@end
