//
//  FavoritesViewController.h
//  WashMe
//
//  Created by Almas Adilbek on 2/12/15.
//  Copyright (c) 2015 Almas Adilbek. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"

#define kNotificationCarwashAddedToFavorites @"notificationCarwashAddedToFavorites"
#define kNotificationCarwashRemovedFromFavorites @"notificationCarwashRemovedFromFavorites"

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end
