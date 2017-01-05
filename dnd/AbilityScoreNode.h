//
//  AbilityScoreNode.h
//  dnd
//
//  Created by Katie Porter on 1/3/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface AbilityScoreNode : ASDisplayNode

+ (instancetype)abilityScoreNodeWithTitle:(NSString *)title score:(NSNumber *)score;

@end
