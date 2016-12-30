//
//  ItemTableViewCell.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "DetailLabelView.h"

@interface ItemTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) DetailLabelView *typeLabel;
@property (nonatomic, strong) DetailLabelView *weightLabel;
@property (nonatomic, strong) DetailLabelView *strengthLabel;
@property (nonatomic, strong) DetailLabelView *ACLabel;
@property (nonatomic, strong) DetailLabelView *damageLabel;
@property (nonatomic, strong) DetailLabelView *damageTypeLabel;
@property (nonatomic, strong) DetailLabelView *modifierLabel;
@property (nonatomic, strong) DetailLabelView *propertyLabel;
@property (nonatomic, strong) DetailLabelView *rangeLabel;
@property (nonatomic, strong) DetailLabelView *stealthLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIStackView *verticalStackView;
@property (nonatomic, strong) UIStackView *horizontalStackView;
@property (nonatomic, strong) UIStackView *titleStackView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation ItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Name label
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item-icon"]];
    
    self.titleStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.nameLabel, self.iconImageView]];
    self.titleStackView.axis = UILayoutConstraintAxisHorizontal;
    self.titleStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.titleStackView.alignment = UIStackViewAlignmentCenter;
    self.titleStackView.spacing = 10.0f;
    self.titleStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Horizontal label stack
    self.typeLabel = [[DetailLabelView alloc] init];
    self.typeLabel.title = @"Level";
    
    self.weightLabel = [[DetailLabelView alloc] init];
    self.weightLabel.title = @"Weight";
    
    self.strengthLabel = [[DetailLabelView alloc] init];
    self.strengthLabel.title = @"Strength";
    
    self.ACLabel = [[DetailLabelView alloc] init];
    self.ACLabel.title = @"AC";
    
    self.damageLabel = [[DetailLabelView alloc] init];
    self.damageLabel.title = @"Damage";
    
    self.damageTypeLabel = [[DetailLabelView alloc] init];
    self.damageTypeLabel.title = @"Damage Type";
    
    self.modifierLabel = [[DetailLabelView alloc] init];
    self.modifierLabel.title = @"Modifier";
    
    self.propertyLabel = [[DetailLabelView alloc] init];
    self.propertyLabel.title = @"Property";
    
    self.rangeLabel = [[DetailLabelView alloc] init];
    self.rangeLabel.title = @"Range";
    
    self.stealthLabel = [[DetailLabelView alloc] init];
    self.stealthLabel.title = @"Stealth";
    
    self.horizontalStackView = [[UIStackView alloc] init];
    self.horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    self.horizontalStackView.distribution = UIStackViewDistributionEqualSpacing;
    self.horizontalStackView.alignment = UIStackViewAlignmentFill;
    self.horizontalStackView.spacing = 10.0f;
    self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Description label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descriptionLabel.numberOfLines = 0;
    
    // Vertical view stack
    self.verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleStackView, self.horizontalStackView, self.descriptionLabel]];
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

- (void)setItem:(Item *)item
{
    _item = item;
    self.nameLabel.text = item.name;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.paragraphSpacing = 8.0f;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                 NSParagraphStyleAttributeName: style
                                 };
    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:item.text attributes:attributes];
    
    for (UIView *view in self.horizontalStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    if (item.type) {
        self.typeLabel.value = item.type;
        [self.horizontalStackView addArrangedSubview:self.typeLabel];
    }
    
    if (item.modifier) {
        self.modifierLabel.value = [item.modifier capitalizedString];
        [self.verticalStackView insertArrangedSubview:self.modifierLabel atIndex:2];
    } else {
        [self.modifierLabel removeFromSuperview];
    }
    
    if (item.weight) {
        self.weightLabel.value = item.weight;
        [self.horizontalStackView addArrangedSubview:self.weightLabel];
    }
    
    if (item.strength) {
        self.strengthLabel.value = item.strength;
        [self.horizontalStackView addArrangedSubview:self.strengthLabel];
    }
    
    if (item.AC) {
        self.ACLabel.value = item.AC;
        [self.horizontalStackView addArrangedSubview:self.ACLabel];
    }
    
    if (item.damage) {
        self.damageLabel.value = item.damage;
        [self.horizontalStackView addArrangedSubview:self.damageLabel];
    }
    
    if (item.damageType) {
        self.damageTypeLabel.value = item.damageType;
        [self.horizontalStackView addArrangedSubview:self.damageTypeLabel];
    }
    
    if (item.property) {
        self.propertyLabel.value = item.property;
        [self.horizontalStackView addArrangedSubview:self.propertyLabel];
    }
    
    if (item.range) {
        self.rangeLabel.value = item.range;
        [self.horizontalStackView addArrangedSubview:self.rangeLabel];
    }
    
    if (item.stealth) {
        self.stealthLabel.value = item.stealth;
        [self.horizontalStackView addArrangedSubview:self.stealthLabel];
    }
}

@end
