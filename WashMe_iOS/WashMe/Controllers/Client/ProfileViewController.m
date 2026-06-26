//
// Created by Almas Adilbek on 10/2/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "ProfileViewController.h"
#import "UIViewController+Ext.h"
#import "RowButtonDisclosureView.h"
#import "BooksHistoryViewController.h"
#import "User.h"
#import "UserBookingsViewController.h"
#import "AppDelegate.h"
#import "ImageBundle.h"
#import "UtilsApi.h"
#import "UserApi.h"
#import "ObjectImage.h"
#import "NSObject+PWObject.h"
#import "UserNotificationsViewController.h"
#import "UIViewController+NavigationBar.h"
#import "InputTextField.h"
#import "UIView+ConcisePureLayout.h"
// IQKeyboardManager removed (incompatible with iOS 18+); was imported but unused here.
#import "RowButtonDropdownView.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "City.h"
#import "NSArray+ObjectiveSugar.h"
#import "AAButton+Styles.h"
#import "InputTextField+Validation.h"
#import "NotificationsHelper.h"
#import "UserSettings.h"
#import "SelectCityViewController.h"

@interface ProfileViewController () <SelectCityViewControllerDelegate>
@property(nonatomic, strong) NSMutableArray *cars;
@property(nonatomic, strong) City *city;
@end

@implementation ProfileViewController {

    CirclePictureView *avatarView;
    InputTextField *_nameField;
    InputTextField *_telField;
    CarsCollectionView *_carsCollectionView;
    RowButtonDropdownView *_cityRowButton;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {
    self.cars = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __block User *user = [User currentUser];

    _nameField.textField.text = [user fio];
    [_telField setValue:user.mobile];

    self.cars = [user.cars mutableCopy];
    [_carsCollectionView addCars:_cars];

    self.city = user.city;
    [_cityRowButton setTitle:self.city.title];
}

#pragma mark -
#pragma mark Actions

- (void)tapSave {
    if(!_nameField.validate) return;
    if(!_telField.validate) return;
    if(self.cars.count == 0) {
        [UIHelper showAlertWithMessage:@"Добавьте автомобиль"];
        return;
    }
    if(!self.city) {
        [UIHelper showAlertWithMessage:@"Выберите город"];
        return;
    }

    [SVProgressHUD showWithStatus:@"Сохранение"];
    [UserApi updateProfileWithName:_nameField.value lastname:nil cars:self.cars city:self.city success:^(id response) {
        [UserSettings setCurrentCity:self.city];

        [SVProgressHUD showSuccessWithStatus:@"Сохранено"];
        User *user = [User instanceFromDictionary:response];

        // Store user data
        [User setAuthorizedUserData:response withMobile:user.mobile];

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserProfileUpdated object:nil];

    } failure:^(NSInteger code, NSString *message) {
        [SVProgressHUD dismiss];
    }];
}

- (void)avatarTapped {
    //[UIHelper showAlertWithMessage:[NSString stringWithFormat:@"%f, %f", [LocationHelper sharedInstance].longitude, [LocationHelper sharedInstance].latitude]];
}

- (void)myBookingsTapped {
    UserBookingsViewController *v = [[UserBookingsViewController alloc]  init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)visitsHistoryTapped {
    BooksHistoryViewController *v = [[BooksHistoryViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)tapCity
{
    NSArray *cities = [Cache carwashRefs].cities;
//    NSArray *cityNames = [cities map:^id(City *object) {
//        return object.title;
//    }];
    
    SelectCityViewController *v = [[SelectCityViewController alloc] init];
    v.cities = cities;
    v.delegate = self;
    [self.navigationController pushViewController:v animated:YES];

//    [UIActionSheet showInView:self.view
//                    withTitle:@"Выберите город"
//            cancelButtonTitle:@"Отмена"
//       destructiveButtonTitle:nil
//            otherButtonTitles:cityNames
//                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//                         if(buttonIndex != actionSheet.cancelButtonIndex) {
//                             self.city = cities[buttonIndex];
//                             [_cityRowButton setTitle:_city.title];
//                         }
//                     }];
}

- (void)tapLogout {
    [[User currentUser] logoutQuestion:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(actionSheet.cancelButtonIndex != buttonIndex) {
            [[User currentUser] logout];
            [[UIHelper appDelegate] gotoWelcomeViewController];
        }
    }];
}

- (void)notificationsTapped
{
    UserNotificationsViewController *v = [[UserNotificationsViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark - 
#pragma mark SelectCityViewControllerDelegate

- (void)changeCurrentCity : (City *)city; {
     self.city = city;
     [_cityRowButton setTitle:self.city.title];
}

#pragma mark -
#pragma mark CirclePictureView

- (void)circlePictureViewTapped {
    [self avatarTapped];

    NSMutableArray *optionButtons = [NSMutableArray array];
    if(avatarView.hasImage) {
        [optionButtons addObject:@"Открыть фото"];
    }
    [optionButtons addObject:@"Сделать снимок"];
    [optionButtons addObject:@"Выбрать из альбома"];

    [UIActionSheet showInView:self.view withTitle:@"Загрузить фото" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:optionButtons tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if(buttonIndex != actionSheet.cancelButtonIndex)
        {
            if(optionButtons.count == 3) {
                if(buttonIndex == 0) {
                    [self showAvatar];
                } if(buttonIndex == 1) {
                    [self takePhoto];
                } if(buttonIndex == 2) {
                    [self choosePhoto];
                }
            } else {
                if(buttonIndex == 0) {
                    [self takePhoto];
                } if(buttonIndex == 1) {
                    [self choosePhoto];
                }
            }
        }
    }];
}

- (void)showAvatar
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];

    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:nc animated:YES completion:^{

    }];

    [self performBlock:^{
        [UIHelper setupWhiteStatusBar:YES];
    } afterDelay:0.15];
}

- (void)takePhoto 
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setDelegate:self];

        [UIHelper setupBlackStatusBar:YES];
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)choosePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerController setDelegate:self];

    [UIHelper setupBlackStatusBar:YES];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray *userImages = [[User currentUser] images];
    if(userImages.count > 0) {
        ImageBundle *imageBundle = userImages[0];
        MWPhoto *mwPhoto = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:[imageBundle.original webUrl]]];
        return mwPhoto;
    }
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [Toast showHudLoading];
    [UtilsApi uploadImage:image success:^(id response) {
        [avatarView setImage:image];

        ImageBundle *imageBundle = (ImageBundle *)response;
        if(imageBundle)
        {
            // Set new upload image to default
            [Toast showHudWithTitle:@"Сохранение"];
            [UserApi setImageDefault:imageBundle.imagesId success:^(id response) {
                [Toast showSuccessToastWithMessage:@"Фото загружено!"];

                // Update cached user data images
                [User updateUserDataAttribute:response forAttributeName:[User imagesKey]];

            } failure:^(NSInteger code, NSString *message) {
//
            }];
        }

    } failure:^(NSInteger code, NSString *message) {
        [UIHelper showAlertTryAgain];
    }];

    [self performBlock:^{
        [UIHelper setupWhiteStatusBar:YES];
    } afterDelay:0.1];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [UIHelper setupWhiteStatusBar:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
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

}

#pragma mark -
#pragma mark AddCarViewController

- (void)AddCarViewControllerCarAdded:(Car *)car {
    [_carsCollectionView addCar:car];
    [self.cars addObject:car];
}

#pragma mark -

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationTitle:@"Профиль"];
    [self showMenuButton];
    [self setNavigationBarTransparent];
    //[self setNavigationButtonWithIcon:@"iconLogout" atLeft:NO selector:@selector(tapLogout)];

    // Picture
    avatarView = [[CirclePictureView alloc] initWithDimension:80];
    avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    avatarView.delegate = self;
    [avatarView setPlaceholder:@"carwash-image-placeholder"];
    [self.contentView addSubview:avatarView];
    [avatarView setImages:[[User currentUser] images] showBadge:NO noImagePlaceholder:@"carwash-no-image"];
    [avatarView aa_setDimensions];
    [avatarView aa_superviewTop:10];
    [avatarView aa_centerHorizontal];

    _nameField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    _nameField.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [_nameField setPlaceholder:@"Имя"];
    [self.contentView addSubview:_nameField];
    [_nameField aa_setDimensions];
    [_nameField aa_pinUnderView:avatarView offset:10];
    [_nameField aa_centerHorizontal];

    _telField = [[InputTextField alloc] initWithWidth:kContentWidth height:45];
    [_telField enabled:NO];
    _telField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_telField setPlaceholder:@"Номер телефона"];
    [self.contentView addSubview:_telField];
    [_telField aa_setDimensions];
    [_telField aa_pinUnderView:_nameField offset:5];
    [_telField aa_centerHorizontal];

    _carsCollectionView = [CarsCollectionView newAutoLayoutView];
    _carsCollectionView.selectedMode = NO;
    _carsCollectionView.delegate = self;
    [_carsCollectionView addAddButton];
    [self.contentView addSubview:_carsCollectionView];
    [_carsCollectionView aa_pinUnderView:_telField offset:15];
    [_carsCollectionView aa_superviewFitWidth];

    _cityRowButton = [[RowButtonDropdownView alloc] initWithWidth:kContentWidth icon:nil title:@"Город" target:self selector:@selector(tapCity)];
    [_cityRowButton aa_setDimensions];
    [self.contentView addSubview:_cityRowButton];
    [_cityRowButton aa_pinUnderView:_carsCollectionView offset:15];
    [_cityRowButton aa_centerHorizontal];

    __weak ProfileViewController * weakSelf = self;
    AAButton *addButton = [[AAButton alloc] initWithWidth:170 onTap:^(UIView *_self) {
        [weakSelf tapSave];
    }];
    [addButton commonStyleButtonWithTitle:@"СОХРАНИТЬ"];
    [addButton setTitleFont:[UIFont robotoRegular:18]];
    addButton.height = 40;
    [self.contentView addSubview:addButton];
    [addButton aa_setDimensions];
    [addButton aa_pinUnderView:_cityRowButton offset:30];
    [addButton aa_centerHorizontal];
    [addButton aa_superviewBottom:15];

    /*RowButtonView *logoutButton = [[RowButtonView alloc] initWithWidth:kContentWidth icon:nil title:@"Выход" target:self selector:@selector(logoutTapped)];
    [logoutButton removeTopLine];
    [logoutButton aa_setDimensions];
    [self.contentView addSubview:logoutButton];
    [logoutButton aa_pinUnderView:_cityRowButton offset:15];
    [logoutButton aa_centerHorizontal];
    [logoutButton aa_superviewBottom:10];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
}

@end
