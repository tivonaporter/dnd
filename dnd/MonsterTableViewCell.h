//
//  MonsterTableViewCell.h
//  dnd
//
//  Created by Devon Tivona on 11/24/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Monster;

@interface MonsterTableViewCell : UITableViewCell

@property (nonatomic, strong) Monster *monster;

@end
