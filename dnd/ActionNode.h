//
//  ActionNode.h
//  dnd
//
//  Created by Devon Tivona on 12/26/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class Action;

@interface ActionNode : ASDisplayNode

- (instancetype)initWithAction:(Action *)action;

@end
