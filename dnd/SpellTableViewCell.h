//
//  SpellTableViewCell.h
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "Spell.h"

@interface SpellTableViewCell : UITableViewCell

@property (nonatomic, strong) Spell *spell;

@end
