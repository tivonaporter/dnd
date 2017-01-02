//
//  FeatureNode.h
//  dnd
//
//  Created by Katie Porter on 1/1/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Feature;

@interface FeatureNode : ASDisplayNode

- (instancetype)initWithFeature:(Feature *)feature;

@end
