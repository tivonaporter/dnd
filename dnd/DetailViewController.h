//
//  DetailViewController.h
//  dnd
//
//  Created by Devon Tivona on 12/28/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DetailViewControllerModeView,
    DetailViewControllerModeViewInCollection,
    DetailViewControllerModeAdd
} DetailViewControllerMode;

@interface DetailViewController : UIViewController

- (instancetype)initWithObject:(RLMObject *)object mode:(DetailViewControllerMode)mode;

@property (nonatomic, copy) void (^selectionAction)(id selectedItem);

@end
