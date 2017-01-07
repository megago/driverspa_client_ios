//
//  ServiceCollectionCell.m
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "ServiceCollectionCell.h"
#import "UIFont+Custom.h"
#import "ALView+PureLayout.h"
#import "UIView+ConcisePureLayout.h"
#import "UIAlertView+Blocks.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "IdTitleObject.h"

@implementation ServiceCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
    
        UIView *container = [UIView newAutoLayoutView];
        [self addSubview:container];
        [container aa_superviewFitWidthWithInset:10];
        [container aa_centerVertical];
        
        self.serviceLabel = [UILabel newAutoLayoutView];
        _serviceLabel.backgroundColor = [UIColor clearColor];
        _serviceLabel.font = [UIFont robotoRegular:10];
        _serviceLabel.textColor = [UIColor whiteColor];
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.numberOfLines = 0;
        _serviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [container addSubview:_serviceLabel];
        [_serviceLabel aa_superviewFillWithInset:0];
        
        self.infoBtn.hidden = YES;
        
        [self.contentView addSubview:container];
        
        self.contentView.layer.borderWidth = 0.f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:0.25f];
    }
    return self;
}

-(void)setGroupItem:(CarwashGroupMenuItem *)groupItem {
    _groupItem = groupItem;
    
    self.infoBtn = [UIButton newAutoLayoutView];
    _infoBtn.backgroundColor = [UIColor clearColor];
    [_infoBtn setImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [_infoBtn addTarget:self action:@selector(showGroupInfo) forControlEvents:UIControlEventTouchUpInside];
    [_infoBtn setHidden:NO];
    [self addSubview:_infoBtn];
    [_infoBtn aa_setWidth:10];
    [_infoBtn aa_setHeight:20];
    [_infoBtn aa_trailing:self];
}

- (void)showGroupInfo {
    [Cache carwashRefs:^(id obj) {
        NSString *msg = @"Описание не найдено";
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *servicesDictionary = [(CarwashRefs *)obj servicesDictionary];
        
        for(id serviceId in _groupItem.services) {
            if(servicesDictionary[serviceId] != nil) {
                IdTitleObject *obj = servicesDictionary[serviceId];
                [array addObject:obj.title];
            }
        }
        
        if(array.count > 0) {
            msg = [array componentsJoinedByString:@"+"];
        } else {
            NSLog(@"services not found");
        }
        
        [UIAlertView showWithTitle:_groupItem.name message:msg cancelButtonTitle:@"ОK" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.layer.borderWidth = 1.f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:1.f];
    } else {
        self.contentView.layer.borderWidth = 0.f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.backgroundColor = [[UIColor fromRGB:0x184977] colorWithAlphaComponent:0.25f];
    }
}

@end
