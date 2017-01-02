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
#import "Carwash.h"
#import "CompanyDiscount.h"
#import "BookObject.h"
#import "CarsCollectionView.h"
#import "AddCarViewController.h"
#import "CarwashServiceCollectionView.h"
#import "IdTitleObject.h"
#import "CarwashMenuItem.h"
#import "BookChooseBoxViewController.h"

@interface BookSetCarViewController3 () <UINavigationControllerDelegate, CarsCollectionViewDelegate, AddCarViewControllerDelegate, CarwashServiceCollectionDelegate>
@property(nonatomic, strong) NSMutableArray *cars;
@property(nonatomic, strong) City *city;

@property (nonatomic, strong) NSMutableArray *checkedServices;
@property (nonatomic, strong) Car *selectedCar;
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
    self.checkedServices = [[NSMutableArray alloc] init];
    self.cars = [[NSMutableArray alloc] init];
    self.bookObject = [[BookObject alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __block User *user = [User currentUser];
    
    self.cars = [user.cars mutableCopy];
    [carsCollectionView addCars:_cars];
    
    if (self.cars.count){
        self.selectedCar = self.cars.firstObject;
        [self carTypesTabbarViewDidChangeTabWithType:self.selectedCar.carType];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.cars.count > 0){
        [carsCollectionView selectItemAtIndex:1];
    }
}

#pragma mark -
#pragma mark Actions

-(void)updatePrice {
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%ld", (long)self.selectedCar.carType]];
    CGFloat totalPrice = 0;
    CGFloat totalTime = 0;
    
    for(IdTitleObject *obj in self.checkedServices) {
        CarwashMenuItem *menuItem = prices[obj.objectId];
        if(menuItem) {
            totalPrice += [menuItem.price floatValue];
            totalTime += [menuItem.time floatValue];
        }
        //NSLog(@"%d - %d - %d", menuItem.type.intValue, menuItem.price.intValue, menuItem.time.intValue);
    }
    
    _bookObject.price = @(totalPrice);
    _bookObject.bookTime = [NSString stringWithFormat:@"%d", (int)totalTime];
    
    NSTimeInterval diff = [_carwash.discount.endDate timeIntervalSinceDate:[NSDate date]];
    if (diff > 0){
        float sum = _bookObject.price.intValue * (100 - _carwash.discount.discountValue.intValue)/100;
        priceLabel.text = [NSString stringWithFormat:@"Цена: %i - %i%% = %0.f", _bookObject.price.intValue, _carwash.discount.discountValue.intValue, sum];
    } else {
        priceLabel.text = [NSString stringWithFormat:@"Цена: %@", [_bookObject localizedPrice]];
    }
    timeLabel.text = [NSString stringWithFormat:@"Время мойки: %d мин.", (int)totalTime];
}

- (void)resetPrice {
    priceLabel.text = @"Цена: 0 тг.";
}

- (void)resetTime {
    timeLabel.text = @"Время мойки: 0 мин.";
}

- (void)continueTapped
{
    if(self.checkedServices.count == 0) {
        [UIHelper showAlertWithMessage:@"Выберите услуги"];
        return;
    }
    
    [Toast showHudWithTitle:@"Ждите"];
    //[UserApi updateProfileWithName:[[User currentUser] fio] lastname:nil cars:nil success:^(id response) {
        // Update user datas
   //     [User instanceFromDictionary:response];
        
        // Set book objects
        _bookObject.carwash = self.carwash;
        _bookObject.services = self.checkedServices;
        _bookObject.carType = self.selectedCar.carType;
        _bookObject.clientKey = [NSString stringWithFormat:@"%@ (%@)", self.selectedCar.carNumber, [[User currentUser] fio]];
        //_bookObject.bookDate = nil;
        //_bookObject.bookTime = nil;
        
        BookChooseBoxViewController *v = [[BookChooseBoxViewController alloc] init];
        v.bookObject = _bookObject;
        v.editMode = self.editMode;
        [self.navigationController pushViewController:v animated:YES];
        
//    } failure:^(NSInteger code, NSString *message) {
//        
//    }];
}

#pragma mark -
#pragma mark CarsCollectionView

- (void)CarsCollectionViewAddTapped {
    AddCarViewController *v = [AddCarViewController new];
    v.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:v];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)CarsCollectionViewCarTapped:(Car *)car {
    self.selectedCar = car;
    [self carTypesTabbarViewDidChangeTabWithType:car.carType];
}

#pragma mark -
#pragma mark AddCarViewController

- (void)AddCarViewControllerCarAdded:(Car *)car {
    [carsCollectionView addCar:car];
    [self.cars addObject:car];
}

#pragma mark -
#pragma mark CarTypesTabbarView

- (void)carTypesTabbarViewDidChangeTabWithType:(CarType)carType
{
    NSDictionary *menu = self.carwash.menu;
    NSDictionary *prices = menu[[NSString stringWithFormat:@"%ld", (long)carType]];
    
    NSMutableArray *serviceIds = [NSMutableArray array];
    for(id key in prices) [serviceIds addObject:key];
    
    if (self.carwash.services.count > 0)
        carTypeServices = self.carwash.services;
    else
        carTypeServices = serviceIds;
    
    [self.checkedServices removeAllObjects];
    [self resetPrice];
    [self resetTime];
    
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
            [carwashServiceCollectionView refreshServices:services];
        } else {
            NSLog(@"services not found");
        }
    }];
}

#pragma mark - 
#pragma mark CarwashServiceCollection Delegate

- (void)carwashServiceCollectionViewSelectedServices:(NSArray *)selectedServices {
    self.checkedServices = [NSMutableArray arrayWithArray:selectedServices];
    [self updatePrice];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setBackButtonInNavigation];
    [self setNavigationTitle:@"Бронирование"];
    [self setNavigationBarTransparent];
    
    NSString *str = [NSString stringWithFormat:@"Автомойка %@", _carwash.name];
    str = [str stringByReplacingOccurrencesOfString:@"Автомойка Автомойка" withString:@"Автомойка"];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.font = [UIFont robotoRegular:14];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subtitleLabel.text = str;
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
    carsCollectionView.selectedMode = YES;
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
    selectServiceLabel.text = @"Выберите услуги:";
    [selectServiceLabel sizeToFit];
    [self.contentView addSubview:selectServiceLabel];
    [selectServiceLabel aa_setDimensions];
    [selectServiceLabel aa_leading:self.contentView offset:10.f];
    [selectServiceLabel aa_trailing:self.contentView offset:10.f];
    [selectServiceLabel aa_pinUnderView:line2 offset:10];
    
    carwashServiceCollectionView = [CarwashServiceCollectionView newAutoLayoutView];
    carwashServiceCollectionView.delegate = self;
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
        [weakSelf continueTapped];
    }];
    [addButton commonStyleButtonWithTitle:@"ВЫБРАТЬ ВРЕМЯ"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:priceLabel offset:30];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:15];
}

@end
