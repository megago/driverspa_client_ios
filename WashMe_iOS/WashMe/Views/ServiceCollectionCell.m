//
//  ServiceCollectionCell.m
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ServiceCollectionCell.h"
#import "UIFont+Custom.h"

@interface ServiceCollectionCell () {
    UILabel *titleLabel;
}
@end

@implementation ServiceCollectionCell

- (void)setTitleService : (NSString *)nameService {
    
    self.backgroundColor = [UIColor clearColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2f];
    titleLabel.font = [UIFont robotoRegular:11];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 10.f;
    [self addSubview:titleLabel];
    
    titleLabel.text = nameService;
}

@end
