//
//  SpellTableViewCell.m
//  dnd
//
//  Created by Devon Tivona on 11/18/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "SpellTableViewCell.h"
#import "DetailLabelView.h"

@interface SpellTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) DetailLabelView *levelLabel;
@property (nonatomic, strong) DetailLabelView *schoolLabel;
@property (nonatomic, strong) DetailLabelView *timeLabel;
@property (nonatomic, strong) DetailLabelView *componentsLabel;
@property (nonatomic, strong) DetailLabelView *durationLabel;
@property (nonatomic, strong) DetailLabelView *classesLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIStackView *verticalStackView;
@property (nonatomic, strong) UIStackView *horizontalStackView;
@property (nonatomic, strong) UIStackView *titleStackView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end


@implementation SpellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Name label
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spell-icon"]];
    
    self.titleStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.iconImageView]];
    self.titleStackView.axis = UILayoutConstraintAxisHorizontal;
    self.titleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.titleStackView.alignment = UIStackViewAlignmentCenter;
    self.titleStackView.spacing = 10.0f;
    self.titleStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Horizontal label stack
    self.levelLabel = [[DetailLabelView alloc] init];
    self.levelLabel.title = @"Level";
    
    self.schoolLabel = [[DetailLabelView alloc] init];
    self.schoolLabel.title = @"School";
    
    self.timeLabel = [[DetailLabelView alloc] init];
    self.timeLabel.title = @"Time";
    
    self.durationLabel = [[DetailLabelView alloc] init];
    self.durationLabel.title = @"Duration";
    
    self.horizontalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.levelLabel, self.schoolLabel, self.timeLabel, self.durationLabel]];
    self.horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    self.horizontalStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.horizontalStackView.alignment = UIStackViewAlignmentFill;
    self.horizontalStackView.spacing = 10.0f;
    self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Components label
    self.componentsLabel = [[DetailLabelView alloc] init];
    self.componentsLabel.title = @"Components";
    
    // Classes label
    self.classesLabel = [[DetailLabelView alloc] init];
    self.classesLabel.title = @"Classes";
    
    // Description label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.numberOfLines = 0;
    
    // Vertical view stack
    self.verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleStackView, self.horizontalStackView, self.componentsLabel, self.classesLabel, self.descriptionLabel]];
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

- (void)setSpell:(Spell *)spell
{
    _spell = spell;
    self.nameLabel.text = spell.name;
    self.levelLabel.value = spell.level;
    self.schoolLabel.value = spell.school;
    self.timeLabel.value = spell.time;
    self.componentsLabel.value = spell.components;
    self.durationLabel.value = spell.duration;
    self.classesLabel.value = spell.classes;

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 8.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                 NSParagraphStyleAttributeName: style
                                 };
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:spell.text attributes:attributes];
    
}

@end
