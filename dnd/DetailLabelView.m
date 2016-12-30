//
//  DetailLabelView.m
//  dnd
//
//  Created by Devon Tivona on 11/19/16.
//  Copyright © 2016 Tivona & Porter. All rights reserved.
//

#import "DetailLabelView.h"

@interface DetailLabelView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIStackView *verticalStackView;

@end

@implementation DetailLabelView

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];

    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    self.verticalStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.valueLabel]];
    self.verticalStackView.axis = UILayoutConstraintAxisVertical;
    self.verticalStackView.distribution = UIStackViewDistributionFill;
    self.verticalStackView.alignment = UIStackViewAlignmentFill;
    self.verticalStackView.spacing = 0.0f;
    self.verticalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.verticalStackView];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.verticalStackView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.valueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *views = @{ @"stackView" : self.verticalStackView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[stackView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[stackView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.valueLabel.text = value;
}


@end
