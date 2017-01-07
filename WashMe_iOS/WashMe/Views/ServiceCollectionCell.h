//
//  ServiceCollectionCell.h
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "CarsCollectionCell.h"
#import "CarwashGroupMenuItem.h"

@interface ServiceCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) CarwashGroupMenuItem *groupItem;

@end
