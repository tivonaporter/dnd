//
//  RaceCellNode.h
//  dnd
//
//  Created by Katie Porter on 2/5/17.
//  Copyright © 2017 Tivona & Porter. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Race;

@interface RaceCellNode : ASCellNode

- (instancetype)initWithRace:(Race *)race detailed:(BOOL)detailed;

@end
