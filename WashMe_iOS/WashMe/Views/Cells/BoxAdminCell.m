//
//  BoxAdminCell.m
//  WashMe
//
//  Created by Ivan Korotkikh on 22.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "BoxAdminCell.h"
#import "BoxSetting.h"
#import "UIView+Ext.h"

@interface BoxAdminCell () {
    UILabel *boxLabel;
    UILabel *statusLabel;
}
@end

@implementation BoxAdminCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *disclosureIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-disclosure-indicator-white"]];
        self.accessoryView = disclosureIndicator;
        self.selectedBackgroundView = [UIView cellSelectionBackground];
        
        boxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        boxLabel.backgroundColor = [UIColor clearColor];
        boxLabel.font = kTitleFont;
        boxLabel.textColor = [UIColor whiteColor];
        boxLabel.lineBreakMode = NSLineBreakByWordWrapping;
        boxLabel.numberOfLines = 1;
        boxLabel.x = kPaddingTitleLeft;
        [self addSubview:boxLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.font = kTitleFont;
        statusLabel.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        statusLabel.numberOfLines = 1;
        statusLabel.x = kPaddingTitleLeft;
        [self addSubview:statusLabel];
        
    }
    return self;
}

-(void)setBoxSetting:(BoxSetting *)box
{
    boxLabel.text = box.boxName;
    boxLabel.y = kTitlePaddingTop;
    [boxLabel sizeToFit];
    
    statusLabel.text = [box localizedBoxType];
    statusLabel.y = boxLabel.bottom;
    [statusLabel sizeToFit];
}

+ (CGFloat)cellHeight: (BoxSetting *)box {
    CGSize boxSize = [box.boxName sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize statusSize = [@"Оналайн" sizeWithFont:kTitleFont constrainedToSize:CGSizeMake([[self class] titleWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return boxSize.height + statusSize.height + 2 * kTitlePaddingTop;
}

@end
