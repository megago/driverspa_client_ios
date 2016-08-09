//
//  BookSetCarViewController3.m
//  WashMe
//
//  Created by Ivan Korotkikh on 07.08.16.
//  Copyright © 2016 Almas Adilbek. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "BookSetCarViewController3.h"
#import "UIViewController+Ext.h"
#import "RowButtonDisclosureView.h"
#import "BooksHistoryViewController.h"
#import "User.h"
#import "UserBookingsViewController.h"
#import "AppDelegate.h"
#import "UtilsApi.h"
#import "UserApi.h"
#import "UserNotificationsViewController.h"
#import "UIViewController+NavigationBar.h"
#import "UIView+ConcisePureLayout.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "City.h"
#import "NSArray+ObjectiveSugar.h"
#import "AAButton+Styles.h"
#import "InputTextField+Validation.h"
#import "NotificationsHelper.h"

#import "CarwashComplex.h"
#import "BookObject.h"
#import "CarwashServiceCollectionView.h"

@interface BookSetCarViewController3 ()
@property(nonatomic, strong) NSMutableArray *cars;
@property(nonatomic, strong) City *city;
@end

@implementation BookSetCarViewController3 {
    UILabel *subtitleLabel;
    UIView *line1;
    UILabel *selectCarLabel;
    CarsCollectionView *carsCollectionView;
    UIView *line2;
    UILabel *selectServiceLabel;
    CarwashServiceCollectionView *carwashServiceCollectionView;
    UIView *line3;
    UILabel *timeLabel;
    UILabel *priceLabel;
    
    NSArray *carTypeServices;
    NSArray *checkedServices;
    
    NSArray *services;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    checkedServices = [[NSArray alloc] init];
    self.cars = [[NSMutableArray alloc] init];
    self.bookObject = [[BookObject alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block User *user = [User currentUser];
    
    self.cars = [user.cars mutableCopy];
    [carsCollectionView addCars:_cars];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.cars.count > 0){
        [carsCollectionView selectItemAtIndex:1];
    }
}

#pragma mark -
#pragma mark Actions


#pragma mark -
#pragma mark CarsCollectionView

- (void)CarsCollectionViewAddTapped {
    AddCarViewController *v = [AddCarViewController new];
    v.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)CarsCollectionViewCarTapped:(Car *)car {
    [self carTypesTabbarViewDidChangeTabWithType:car.carType];
}

#pragma mark -
#pragma mark CarTypesTabbarView

- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType
{
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%d", carType]];
    
    NSMutableArray *serviceIds = [NSMutableArray array];
    for(id key in prices) [serviceIds addObject:key];
    carTypeServices = serviceIds;
    
    checkedServices = @[];
    
    [Cache carwashRefs:^(id obj) {
        NSMutableArray *array = [NSMutableArray array];
        NSDictionary *servicesDictionary = [(CarwashRefs *)obj servicesDictionary];
        
        for(id serviceId in carTypeServices) {
            if(servicesDictionary[serviceId] != nil) {
                [array addObject:servicesDictionary[serviceId]];
            }
        }
        
        services = array;
        
        if(services.count > 0) {
            [carwashServiceCollectionView reloadData];
        } else {
            NSLog(@"services not found");
        }
    }];

}


#pragma mark -
#pragma mark AddCarViewController

- (void)AddCarViewControllerCarAdded:(Car *)car {
    [carsCollectionView addCar:car];
    [self.cars addObject:car];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Бронировать"];
    [self setNavigationBarTransparent];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [UIFont robotoRegular:14];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subtitleLabel.text = _carwash.name;
    [subtitleLabel sizeToFit];
    [self.contentView addSubview:subtitleLabel];
    [subtitleLabel aa_setDimensions];
    [subtitleLabel aa_superviewTop:10];
    [subtitleLabel aa_centerHorizontal];
    
    line1 = [[UIView alloc] initWithFrame:CGRectZero];
    [line1 setBackgroundColor:[UIColor whiteColor]];
    line1.alpha = 0.2;
    line1.height = 0.5;
    [self.contentView addSubview:line1];
    [line1 aa_setDimensions];
    [line1 aa_leading:self.contentView offset:10.f];
    [line1 aa_trailing:self.contentView offset:10.f];
    [line1 aa_pinUnderView:subtitleLabel offset:10];
    
    selectCarLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    selectCarLabel.backgroundColor = [UIColor clearColor];
    selectCarLabel.font = [UIFont robotoRegular:14];
    selectCarLabel.textColor = [UIColor whiteColor];
    selectCarLabel.textAlignment = NSTextAlignmentLeft;
    selectCarLabel.numberOfLines = 0;
    selectCarLabel.lineBreakMode = NSLineBreakByWordWrapping;
    selectCarLabel.text = @"Выберите автомобиль:";
    [selectCarLabel sizeToFit];
    [self.contentView addSubview:selectCarLabel];
    [selectCarLabel aa_setDimensions];
    [selectCarLabel aa_leading:self.contentView offset:10.f];
    [selectCarLabel aa_trailing:self.contentView offset:10.f];
    [selectCarLabel aa_pinUnderView:line1 offset:10];

    carsCollectionView = [CarsCollectionView newAutoLayoutView];
    carsCollectionView.delegate = self;
    [carsCollectionView addAddButton];
    [self.contentView addSubview:carsCollectionView];
    [carsCollectionView aa_pinUnderView:selectCarLabel offset:15];
    [carsCollectionView aa_superviewFitWidth];
    
    line2 = [[UIView alloc] initWithFrame:CGRectZero];
    [line2 setBackgroundColor:[UIColor whiteColor]];
    line2.alpha = 0.2;
    line2.height = 0.5;
    [self.contentView addSubview:line2];
    [line2 aa_setDimensions];
    [line2 aa_leading:self.contentView offset:10.f];
    [line2 aa_trailing:self.contentView offset:10.f];
    [line2 aa_pinUnderView:carsCollectionView offset:10];
    
    selectServiceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    selectServiceLabel.backgroundColor = [UIColor clearColor];
    selectServiceLabel.font = [UIFont robotoRegular:14];
    selectServiceLabel.textColor = [UIColor whiteColor];
    selectServiceLabel.textAlignment = NSTextAlignmentLeft;
    selectServiceLabel.numberOfLines = 0;
    selectServiceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    selectServiceLabel.text = @"Выберите автомобиль:";
    [selectServiceLabel sizeToFit];
    [self.contentView addSubview:selectServiceLabel];
    [selectServiceLabel aa_setDimensions];
    [selectServiceLabel aa_leading:self.contentView offset:10.f];
    [selectServiceLabel aa_trailing:self.contentView offset:10.f];
    [selectServiceLabel aa_pinUnderView:line2 offset:10];
    
    carwashServiceCollectionView = [CarwashServiceCollectionView newAutoLayoutView];
    [self.contentView addSubview:carwashServiceCollectionView];
    [carwashServiceCollectionView aa_pinUnderView:selectServiceLabel offset:10];
    [carwashServiceCollectionView aa_superviewFitWidth];
    
    line3 = [[UIView alloc] initWithFrame:CGRectZero];
    [line3 setBackgroundColor:[UIColor whiteColor]];
    line3.alpha = 0.2;
    line3.height = 0.5;
    [self.contentView addSubview:line3];
    [line3 aa_setDimensions];
    [line3 aa_leading:self.contentView offset:10.f];
    [line3 aa_trailing:self.contentView offset:10.f];
    [line3 aa_pinUnderView:carwashServiceCollectionView offset:10];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont robotoRegular:14];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.numberOfLines = 0;
    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    timeLabel.text = @"Время мойки: 0 мин.";
    [timeLabel sizeToFit];
    [self.contentView addSubview:timeLabel];
    [timeLabel aa_setDimensions];
    [timeLabel aa_leading:self.contentView offset:10.f];
    [timeLabel aa_trailing:self.contentView offset:10.f];
    [timeLabel aa_pinUnderView:line3 offset:10];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont robotoBold:14];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.numberOfLines = 0;
    priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    priceLabel.text = @"Цена: 0 тг.";
    [priceLabel sizeToFit];
    [self.contentView addSubview:priceLabel];
    [priceLabel aa_setDimensions];
    [priceLabel aa_leading:self.contentView offset:10.f];
    [priceLabel aa_trailing:self.contentView offset:10.f];
    [priceLabel aa_pinUnderView:timeLabel offset:10];
    
    __weak BookSetCarViewController3 * weakSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:170 onTap:^(UIView *_self) {
        
    }];
    [addButton commonStyleButtonWithTitle:@"Выбрать время"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:priceLabel offset:30];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:15];
}

@end