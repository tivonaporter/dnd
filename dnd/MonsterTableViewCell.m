//
//  MonsterTableViewCell.m
//  dnd
//
//  Created by Devon Tivona on 11/24/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "MonsterTableViewCell.h"
#import "Monster.h"
#import "DetailLabelView.h"

@interface MonsterTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) DetailLabelView *strengthLabel;
@property (nonatomic, strong) DetailLabelView *dexterityLabel;
@property (nonatomic, strong) DetailLabelView *constitutionLabel;
@property (nonatomic, strong) DetailLabelView *intelligenceLabel;
@property (nonatomic, strong) DetailLabelView *wisdomLabel;
@property (nonatomic, strong) DetailLabelView *charismaLabel;

@property (nonatomic, strong) UIStackView *statsStackView;

@property (nonatomic, strong) DetailLabelView *sizeLabel;
@property (nonatomic, strong) DetailLabelView *alignmentLabel;
@property (nonatomic, strong) DetailLabelView *ACLabel;
@property (nonatomic, strong) DetailLabelView *HPLabel;
@property (nonatomic, strong) DetailLabelView *passiveWisdomLabel;
@property (nonatomic, strong) DetailLabelView *challengeRatingLabel;
@property (nonatomic, strong) DetailLabelView *typeLabel;
@property (nonatomic, strong) DetailLabelView *speedLabel;
@property (nonatomic, strong) DetailLabelView *languagesLabel;
@property (nonatomic, strong) DetailLabelView *resistLabel;
@property (nonatomic, strong) DetailLabelView *immuneLabel;
@property (nonatomic, strong) DetailLabelView *conditionImmuneLabel;
@property (nonatomic, strong) DetailLabelView *sensesLabel;
@property (nonatomic, strong) DetailLabelView *spellsLabel;

@property (nonatomic, strong) UIStackView *verticalStackView;
@property (nonatomic, strong) UIStackView *firstHorizontalStackView;
@property (nonatomic, strong) UIStackView *secondHorizontalStackView;
@property (nonatomic, strong) UIStackView *titleStackView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation MonsterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Name label
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monster-icon"]];
    
    self.titleStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.iconImageView]];
    self.titleStackView.axis = UILayoutConstraintAxisHorizontal;
    self.titleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.titleStackView.alignment = UIStackViewAlignmentCenter;
    self.titleStackView.spacing = 10.0f;
    self.titleStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.strengthLabel = [[DetailLabelView alloc] init];
    self.strengthLabel.title = @"Strength";
    
    self.dexterityLabel = [[DetailLabelView alloc] init];
    self.dexterityLabel.title = @"Dexterity";
    
    self.constitutionLabel = [[DetailLabelView alloc] init];
    self.constitutionLabel.title = @"Constitution";
    
    self.intelligenceLabel = [[DetailLabelView alloc] init];
    self.intelligenceLabel.title = @"Intelligence";
    
    self.wisdomLabel = [[DetailLabelView alloc] init];
    self.wisdomLabel.title = @"Wisdom";
    
    self.charismaLabel = [[DetailLabelView alloc] init];
    self.charismaLabel.title = @"Charisma";
    
    self.statsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.strengthLabel, self.dexterityLabel, self.constitutionLabel, self.intelligenceLabel, self.wisdomLabel, self.charismaLabel]];
    self.statsStackView.axis = UILayoutConstraintAxisHorizontal;
    self.statsStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.statsStackView.alignment = UIStackViewAlignmentFill;
    self.statsStackView.spacing = 10.0f;
    self.statsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // First horizontal label stack
    self.sizeLabel = [[DetailLabelView alloc] init];
    self.sizeLabel.title = @"Size";
    
    self.alignmentLabel = [[DetailLabelView alloc] init];
    self.alignmentLabel.title = @"Alignment";
    
    self.ACLabel = [[DetailLabelView alloc] init];
    self.ACLabel.title = @"AC";
    
    self.HPLabel = [[DetailLabelView alloc] init];
    self.HPLabel.title = @"HP";
    
    self.passiveWisdomLabel = [[DetailLabelView alloc] init];
    self.passiveWisdomLabel.title = @"Passive Wisdom";
    
    self.challengeRatingLabel = [[DetailLabelView alloc] init];
    self.challengeRatingLabel.title = @"CR";

    self.firstHorizontalStackView = [[UIStackView alloc] init];
    self.firstHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    self.firstHorizontalStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.firstHorizontalStackView.alignment = UIStackViewAlignmentFill;
    self.firstHorizontalStackView.spacing = 10.0f;
    self.firstHorizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Second horizontal stack
    self.typeLabel = [[DetailLabelView alloc] init];
    self.typeLabel.title = @"Type";
    
    self.speedLabel = [[DetailLabelView alloc] init];
    self.speedLabel.title = @"Speed";
    
    self.languagesLabel = [[DetailLabelView alloc] init];
    self.languagesLabel.title = @"Languages";
    
    self.secondHorizontalStackView = [[UIStackView alloc] init];
    self.secondHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    self.secondHorizontalStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.secondHorizontalStackView.alignment = UIStackViewAlignmentFill;
    self.secondHorizontalStackView.spacing = 10.0f;
    self.secondHorizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.resistLabel = [[DetailLabelView alloc] init];
    self.resistLabel.title = @"Resistances";
    
    self.immuneLabel = [[DetailLabelView alloc] init];
    self.immuneLabel.title = @"Immunities";
    
    self.conditionImmuneLabel = [[DetailLabelView alloc] init];
    self.conditionImmuneLabel.title = @"Condition Immunities";
    
    self.sensesLabel = [[DetailLabelView alloc] init];
    self.sensesLabel.title = @"Senses";
    
    self.spellsLabel = [[DetailLabelView alloc] init];
    self.spellsLabel.title = @"Spells";
    
    // Vertical view stack
    self.verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleStackView, self.statsStackView, self.firstHorizontalStackView, self.secondHorizontalStackView]];
    self.verticalStackView.axis = UILayoutConstraintAxisVertical;
    self.verticalStackView.distribution = UIStackViewDistributionFill;
    self.verticalStackView.alignment = UIStackViewAlignmentFill;
    self.verticalStackView.spacing = 10.0f;
    self.verticalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.verticalStackView];
    
    NSDictionary *views = @{ @"stackView" : self.verticalStackView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[stackView]-20-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[stackView]-20-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setMonster:(Monster *)monster
{
    _monster = monster;
    
    self.nameLabel.text = monster.name;
        
    self.strengthLabel.value = [monster.strength stringValue];
    self.dexterityLabel.value = [monster.dexterity stringValue];
    self.constitutionLabel.value = [monster.constitution stringValue];
    self.intelligenceLabel.value = [monster.intelligence stringValue];
    self.wisdomLabel.value = [monster.wisdom stringValue];
    self.charismaLabel.value = [monster.charisma stringValue];
    
    // First horizontal stack view
    for (UIView *view in self.firstHorizontalStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    if (monster.size) {
        self.sizeLabel.value = monster.size;
        [self.firstHorizontalStackView addArrangedSubview:self.sizeLabel];
    }
    
    if (monster.alignment) {
        self.alignmentLabel.value = [monster.alignment capitalizedString];
        [self.firstHorizontalStackView addArrangedSubview:self.alignmentLabel];
    }
    
    if (monster.AC) {
        self.ACLabel.value = monster.AC;
        [self.firstHorizontalStackView addArrangedSubview:self.ACLabel];
    }
    
    if (monster.HP) {
        self.HPLabel.value = monster.HP;
        [self.firstHorizontalStackView addArrangedSubview:self.HPLabel];
    }
    
    if (monster.passiveWisdom) {
        self.passiveWisdomLabel.value = [monster.passiveWisdom stringValue];
        [self.firstHorizontalStackView addArrangedSubview:self.passiveWisdomLabel];
    }
    
    if (monster.challengeRating) {
        self.challengeRatingLabel.value = [NSString stringWithFormat:@"%.1f", [monster.challengeRating floatValue]];
        [self.firstHorizontalStackView addArrangedSubview:self.challengeRatingLabel];
    }
    
    // Second horizontal stack view
    for (UIView *view in self.secondHorizontalStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }

    if (monster.type) {
        self.typeLabel.value = [monster.type capitalizedString];
        [self.secondHorizontalStackView addArrangedSubview:self.typeLabel];
    }
    
    if (monster.speed) {
        self.speedLabel.value = [monster.speed capitalizedString];
        [self.secondHorizontalStackView addArrangedSubview:self.speedLabel];
    }
    
    // Everything else
    if (monster.languages) {
        self.languagesLabel.value = [monster.languages capitalizedString];
        [self.verticalStackView addArrangedSubview:self.languagesLabel];
    }
    
    if (monster.resist) {
        self.resistLabel.value = [monster.resist capitalizedString];
        [self.verticalStackView addArrangedSubview:self.resistLabel];
    }
    
    if (monster.immune) {
        self.immuneLabel.value = [monster.immune capitalizedString];
        [self.verticalStackView addArrangedSubview:self.immuneLabel];
    }
    
    if (monster.conditionImmune) {
        self.conditionImmuneLabel.value = [monster.conditionImmune capitalizedString];
        [self.verticalStackView addArrangedSubview:self.conditionImmuneLabel];
    }
    
    if (monster.senses) {
        self.sensesLabel.value = [monster.senses capitalizedString];
        [self.verticalStackView addArrangedSubview:self.sensesLabel];
    }
    
    if (monster.speed) {
        self.speedLabel.value = [monster.speed capitalizedString];
        [self.verticalStackView addArrangedSubview:self.speedLabel];
    }

    [self sizeToFit];
}

@end
