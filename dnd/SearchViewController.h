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

@interface SearchViewController : UIViewController

@property (nonatomic, assign) SearchViewControllerType type;
@property (nonatomic, copy) void (^selectionAction)(id selectedItem);

@end