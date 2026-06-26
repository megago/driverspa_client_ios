//
//  CarwashMapViewController.h
//  WashMe
//
//  Created by Ivan Korotkikh on 30.07.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CarwashMapViewController : UIViewController <GMSMapViewDelegate>

@property(nonatomic, strong) NSArray *carwashes;
@property(nonatomic, assign) BOOL annotationsEnabled;

@end
