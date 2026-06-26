//
//  BoxAdminCell.h
//  WashMe
//
//  Created by Ivan Korotkikh on 22.09.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import "SimpleDisclosureCell.h"
@class BoxSetting;

@interface BoxAdminCell : SimpleDisclosureCell

- (void)setBoxSetting: (BoxSetting *)box;
+ (CGFloat)cellHeight: (BoxSetting *)box;

@end
