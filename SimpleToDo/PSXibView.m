//
//  PSXibView.m
//  Pistop
//
//  Created by Alex Zimin on 08/11/14.
//  Copyright (c) 2014 alex. All rights reserved.
//

#import "PSXibView.h"

@interface PSXibView ()

@property (nonatomic) UIView *customXib;

@end

@implementation PSXibView

- (instancetype)initWithNibName:(NSString*)name andCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if ( ![[self subviews] count] )
    {
        self.customXib = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] firstObject];
        [self addSubview:self.customXib];
    }
    
    return self;
}

- (void)layoutSubviews {
    self.customXib.frame = self.bounds;
    [self.customXib layoutIfNeeded];
}

@end
