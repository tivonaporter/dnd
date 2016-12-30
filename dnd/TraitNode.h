//
//  TraitNode.h
//  dnd
//
//  Created by Devon Tivona on 12/26/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Trait;

@interface TraitNode : ASDisplayNode

- (instancetype)initWithTrait:(Trait *)trait;

@end
