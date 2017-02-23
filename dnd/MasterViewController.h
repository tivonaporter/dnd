//
//  MasterViewController.h
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MasterViewControllerModeView,
    MasterViewControllerModeAdd
} MasterViewControllerMode;

@class CollectionViewController, Collection;

@interface MasterViewController : UIViewController

- (instancetype)initWithMode:(MasterViewControllerMode)mode;

@property (nonatomic, copy) void (^selectionAction)(Collection *selectedCollection);

@end

