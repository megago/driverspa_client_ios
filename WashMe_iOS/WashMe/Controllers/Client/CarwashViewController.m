//
// Created by Almas Adilbek on 9/18/14.
// Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "CarwashViewController.h"
#import "UIViewController+Ext.h"
#import "Carwash.h"
#import "CarwashMapView.h"
#import "CarwashComplex.h"
#import "CarwashSchedule.h"
#import "SchedulePeriod.h"
#import "CarwashApi.h"
#import "IconTitleView.h"
#import "AAButton+Styles.h"
#import "UIActionSheet+Blocks.h"
#import "NSString+Ext.h"
#import "RowButtonView.h"
#import "RowButtonDisclosureView.h"
#import "CarwashMapViewController.h"
#import "BookSetCarViewController.h"
#import "UserApi.h"
#import "BookmarksHelper.h"
#import "ImageBundle.h"
#import "ObjectImage.h"
#import "NSObject+PWObject.h"
#import "CarwashPricesViewController.h"
#import "FavoritesViewController.h"
#import "BookChooseBoxViewController.h"
#import "BookObject.h"
#import "Cache.h"
#import "CarwashRefs.h"
#import "IdTitleObject.h"
#import "UIViewController+NavigationBar.h"
#import "CompanyDiscount.h"
#import "UIAlertView+Blocks.h"

#import "BookSetCarViewController3.h"

@interface CarwashViewController ()
@property(nonatomic, strong) CarwashComplex *carwashComplex;
@end

@implementation CarwashViewController {
    IconTitleView *telTitleView;
    CarwashMapView *carwashMapView;
    RowButtonDisclosureView *feedbacksButton;
    RowButtonView *toggleFavoriteButton;

    BOOL isBookmarked;
    NSMutableArray *carwashPhotos;
    RowButtonDisclosureView *pricesButton;
    RowButtonDisclosureView *reservationTableButton;
    IconTitleView *emailTitleView;
    IconTitleView *websiteTitleView;
}

-(id)init {
    self = [super init];
    if(self) {
        [self initVars];
    }
    return self;
}

-(void)initVars {}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self addObservers];

    // Check bookmarked
    isBookmarked = [BookmarksHelper isCarwashBookmarked:self.carwash.carwashId];

    [Toast showHudLoading];
    [CarwashApi getCarwashDetails:self.carwash.carwashId success:^(id response) {
        _carwashComplex = response;
        [self buildUI];
        [self configAction];
    } failure:^(NSInteger code, NSString *message) {

    }];
}

- (void)configAction
{
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telTapped)];
    [telTitleView addGestureRecognizer:ges];

    UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailTapped)];
    [emailTitleView addGestureRecognizer:ges2];

    UITapGestureRecognizer *ges3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteTapped)];
    [websiteTitleView addGestureRecognizer:ges3];

    // Carwash map tap
    UITapGestureRecognizer *mapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped)];
    [carwashMapView addGestureRecognizer:mapGes];
}

#pragma mark -
#pragma mark Actions

- (void)mapTapped {
    CarwashMapViewController *v = [[CarwashMapViewController alloc] init];
    v.carwashes = @[_carwashComplex];
    v.annotationsEnabled = NO;
    v.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:v animated:YES completion:nil];
}

- (void)bookButtonTapped
{
    BookSetCarViewController3 *v = [[BookSetCarViewController3 alloc] init];
    v.carwash = _carwashComplex;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)telTapped
{
    NSString *tel = [_carwashComplex contactsMobilePhone];
    if(tel) {
        [UIActionSheet showInView:self.view withTitle:@"Позвонить?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[tel] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [tel phoneNumberValidForCall]]]];
            }
        }];
    }
}

- (void)websiteTapped
{
    NSString *website = [_carwashComplex contactsWebsite];
    if(website) {
        [UIActionSheet showInView:self.view withTitle:@"Открыть сайт?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[website] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
            }
        }];
    }
}

- (void)emailTapped
{
    NSString *email = [_carwashComplex contactsEmail];
    if(email) {
        [UIActionSheet showInView:self.view withTitle:@"Написать электронную почту?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[email] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", email]]];
            }
        }];
    }
}

- (void)feedbacksTapped {
    FeedbacksViewController *v = [[FeedbacksViewController alloc] init];
    v.delegate = self;
    v.carwash = _carwashComplex;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)pricesTapped {
    CarwashPricesViewController *v = [[CarwashPricesViewController alloc] init];
    v.menu = _carwashComplex.menu;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)toggleBookmarkTapped
{
    [Toast showHudLoading];
    if(!isBookmarked) {
        [UserApi bookmarkCarwash:self.carwash.carwashId success:^(id response) {
            [Toast showSuccessToast];
            isBookmarked = YES;
            [self updateToggleBookmarkButtonTitle];

            // Cache bookmark
            [BookmarksHelper carwashBookmarked:self.carwash.carwashId];

            // Add carwash to favorites in parent list
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarwashAddedToFavorites object:nil userInfo:@{@"carwash":_carwashComplex}];

        } failure:^(NSInteger code, NSString *message) {

        }];
    } else {
        [UserApi removeCarwashBookmark:self.carwash.carwashId success:^(id response) {
            isBookmarked = NO;
            [self updateToggleBookmarkButtonTitle];

            // Remove carwash from bookmark
            [BookmarksHelper carwashBookmarkRemoved:self.carwash.carwashId];

            // Remove carwash from favorites in parent list
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarwashRemovedFromFavorites object:nil userInfo:@{@"carwash":_carwash}];

        } failure:^(NSInteger code, NSString *message) {

        }];
    }
}

- (void)reservationTableButtonTapped
{
    BookObject *bookObject = [[BookObject alloc] init];
    bookObject.carwash = _carwashComplex;

    BookChooseBoxViewController *v = [[BookChooseBoxViewController alloc] init];
    v.preview = YES;
    v.bookObject = bookObject;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)tapDetailDiscount {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm dd.MM.yyyy"];
    NSString *title = [NSString stringWithFormat:@"Скидка %i%%", _carwash.discount.discountValue.intValue];
    NSString *msg = [NSString stringWithFormat:@"%@\nАкция действительна до\n%@", _carwash.discount.discountDescription, [formatter stringFromDate:_carwash.discount.endDate]];
    [UIAlertView showWithTitle:title message:msg cancelButtonTitle:@"ОК" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        //code
    }];
}

#pragma mark -
#pragma mark FeedbacksViewController

-(void)feedbacksViewControllerCarwashFeedbacksUpdated:(CarwashComplex *)updatedCarwash {
    _carwashComplex = updatedCarwash;
    [self updateFeedbacksRowTitle];
}

#pragma mark -
#pragma mark CarwashPictureView

- (void)circlePictureViewTapped
{
    if(_carwashComplex.carwashImages.count > 0)
    {
        carwashPhotos = [[NSMutableArray alloc] init];
        for(ImageBundle *imageBundle in _carwashComplex.carwashImages) {
            [carwashPhotos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[imageBundle.original webUrl]]]];
        }

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];

        browser.displayActionButton = YES;
        browser.displayNavArrows = YES;
        browser.displaySelectionButtons = NO;
        browser.zoomPhotosToFill = YES;
        browser.alwaysShowControls = NO;
        browser.enableGrid = YES;
        browser.startOnGrid = NO;

        [browser showNextPhotoAnimated:YES];
        [browser showPreviousPhotoAnimated:YES];

        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [self presentViewController:nc animated:YES completion:^{

        }];

        [self performBlock:^{
            [UIHelper setupWhiteStatusBar:YES];
        } afterDelay:0.15];
    }
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return carwashPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < carwashPhotos.count) {
        return carwashPhotos[index];
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    ImageBundle *imageBundle = _carwashComplex.carwashImages[index];
    return [MWPhoto photoWithURL:[NSURL URLWithString:[imageBundle.medium webUrl]]];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

-(void)updateFeedbacksRowTitle {
    [feedbacksButton setTitle:[NSString stringWithFormat:@"Отзывы (%i)", _carwashComplex.reviews.count]];
}

- (void)updateToggleBookmarkButtonTitle {
    if(!isBookmarked) {
        [toggleFavoriteButton setIcon:@"icon-favorite"];
        [toggleFavoriteButton setTitle:@"Добавить в избранные"];
    } else {
        [toggleFavoriteButton setIcon:@"icon-favorite-filled"];
        [toggleFavoriteButton setTitle:@"Удалить из избранных"];
    }
}

#pragma mark -
#pragma mark Notifications

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carwashAddedToFavorites:) name:kNotificationCarwashAddedToFavorites object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carwashRemovedFromFavorites:) name:kNotificationCarwashRemovedFromFavorites object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCarwashAddedToFavorites object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationCarwashRemovedFromFavorites object:nil];
}

- (void)carwashAddedToFavorites:(NSNotification *)notification
{
    [self carwashBookmarkChangedNotification:notification favorited:YES];
}

- (void)carwashRemovedFromFavorites:(NSNotification *)notification {
    [self carwashBookmarkChangedNotification:notification favorited:NO];
}

- (void)carwashBookmarkChangedNotification:(NSNotification *)notification favorited:(BOOL)favorited {
    NSDictionary *userInfo = notification.userInfo;
    Carwash *carwash = userInfo[@"carwash"];

    if([self.carwash.carwashId isEqual:carwash.carwashId]) {
        isBookmarked = favorited;
        [self updateToggleBookmarkButtonTitle];
    }
}

#pragma mark -

-(void)buildUI
{
    sv.height = [ASize screenHeightWithoutStatusBarAndNavigationBar] - 3;
    
    __weak CarwashViewController *wSelf = self;
    float yPoint = 5.f;
    if ([_carwashComplex.status isEqualToString:@"approved"] || [_carwashComplex.carwashId isEqualToString:@"578dabe7ff42375f6308a9fc"]){
        AAButton *bookButton1 = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
            [wSelf bookButtonTapped];
        }];
        if(_carwashComplex.isBookable) {
            [bookButton1 commonStyleButtonWithTitle:@"ЗАБРОНИРОВАТЬ"];
        } else {
            bookButton1.hidden = YES;
        }
        
        [bookButton1 setTitleFont:[UIFont robotoRegular:18]];
        bookButton1.centerX = self.view.centerX;
        bookButton1.y = yPoint;
        bookButton1.height = 40;
        [sv addSubview:bookButton1];
        
        yPoint = bookButton1.height + 30.f;
    }

    NSString *iconName = [NSString new];
    if ([_carwashComplex.status isEqualToString:@"approved"]){
        iconName = @"carwash-annotation-online2";
    } else {
        iconName = @"carwash-annotation-offline";
    }
    NSTimeInterval diff = [_carwashComplex.discount.endDate timeIntervalSinceDate:[NSDate date]];
    if (diff > 0){
        iconName = @"carwash-annotation-discount";
    }
    carwashMapView = [[CarwashMapView alloc] initWithCoordinate:_carwashComplex.coordinate andIconName:iconName];
    carwashMapView.x = (CGFloat) ((self.view.width - carwashMapView.width) * 0.5);
    carwashMapView.y = yPoint;
    [sv addSubview:carwashMapView];

    CirclePictureView *carwashPictureView = [[CirclePictureView alloc] initWithDimension:80];
    carwashPictureView.delegate = self;
    [carwashPictureView setPlaceholder:@"carwash-image-placeholder"];
    carwashPictureView.x = carwashMapView.x;
    carwashPictureView.y = carwashMapView.bottom + 15;
    [sv addSubview:carwashPictureView];
    [carwashPictureView setImages:_carwashComplex.carwashImages showBadge:YES noImagePlaceholder:@"carwash-no-image"];

    CGFloat rowsSpacing = 2;
    CGFloat colWidth = [ASize screenWidth] - carwashPictureView.right - 30;
    CGFloat nextY = carwashPictureView.y;
    
    if (diff > 0){
        UILabel *discountTitle = [[UILabel alloc] initWithFrame:CGRectMake(carwashPictureView.right + 10, nextY, colWidth, 1)];
        discountTitle.backgroundColor = [UIColor clearColor];
        discountTitle.font = [UIFont robotoRegular:14];
        discountTitle.textColor = [UIColor whiteColor];
        discountTitle.lineBreakMode = NSLineBreakByWordWrapping;
        discountTitle.numberOfLines = 0;
        discountTitle.text = @"Скидка";
        [discountTitle sizeToFit];
        [sv addSubview:discountTitle];
        
        UIImageView *discountIconView = [[UIImageView alloc] initWithFrame:CGRectMake(discountTitle.right + 5, nextY, 20, 20)];
        discountIconView.backgroundColor = [UIColor clearColor];
        discountIconView.image = [UIImage imageNamed:@"promo_orange"];
        [sv addSubview:discountIconView];
        
        UILabel *discountLbl = [[UILabel alloc] initWithFrame:discountIconView.frame];
        discountLbl.backgroundColor = [UIColor clearColor];
        discountLbl.textColor = [UIColor whiteColor];
        discountLbl.textAlignment = NSTextAlignmentCenter;
        discountLbl.font = [UIFont robotoRegular:7];
        discountLbl.text = [NSString stringWithFormat:@"%i%%", _carwash.discount.discountValue.intValue];
        [sv addSubview:discountLbl];
        
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        UILabel *detailDiscountLbl = [[UILabel alloc] initWithFrame:CGRectMake(discountIconView.right + 5, nextY, colWidth, 1)];
        detailDiscountLbl.backgroundColor = [UIColor clearColor];
        detailDiscountLbl.font = [UIFont robotoThin:14];
        detailDiscountLbl.textColor = [UIColor whiteColor];
        detailDiscountLbl.lineBreakMode = NSLineBreakByWordWrapping;
        detailDiscountLbl.numberOfLines = 0;
        detailDiscountLbl.attributedText = [[NSAttributedString alloc] initWithString:@"подробнее"
                                                                           attributes:underlineAttribute];
        detailDiscountLbl.userInteractionEnabled = YES;
        [detailDiscountLbl sizeToFit];
        [sv addSubview:detailDiscountLbl];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetailDiscount)];
        [detailDiscountLbl addGestureRecognizer:tapGesture];
        
        nextY = detailDiscountLbl.bottom + rowsSpacing;
    }

    // Address
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(carwashPictureView.right + 10, nextY, colWidth, 1)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont robotoBold:15];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel.numberOfLines = 0;
    addressLabel.text = _carwashComplex.address;
    [addressLabel sizeToFit];
    [sv addSubview:addressLabel];
    nextY = addressLabel.bottom + rowsSpacing;
    

    // Additional Infos
    NSMutableArray * additionalInfoTitles = [NSMutableArray array];
    for(IdTitleObject *obj in [Cache companyCarwashRefs].additionalInfos) {
        if([_carwashComplex.additionalInfos containsObject:obj.objectId]) {
            [additionalInfoTitles addObject:obj.title];
        }
    }

    if(additionalInfoTitles.count > 0)
    {
        UILabel *infosLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.x, nextY, colWidth , 1)];
        infosLabel.backgroundColor = [UIColor clearColor];
        infosLabel.font = [UIFont systemFontOfSize:13];
        infosLabel.textColor = [UIColor whiteColor];
        infosLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infosLabel.numberOfLines = 0;
        infosLabel.text = [additionalInfoTitles componentsJoinedByString:@", "];
        [infosLabel sizeToFit];
        [sv addSubview:infosLabel];

        nextY = infosLabel.bottom + rowsSpacing;
    }
    
    //Shedule
    NSArray *periods = [_carwashComplex.schedule todaySchedules];
    NSString *workingTime = @"";
    if (periods.count > 0){
        SchedulePeriod *period = periods.firstObject;
        workingTime = [period workingTime];
    }
    if (workingTime.length > 0)
    {
        IconTitleView *workingTitleView = [[IconTitleView alloc] initWithIcon:@"icon-24hours" title:workingTime];
        workingTitleView.x = addressLabel.x;
        workingTitleView.y = nextY + 5;
        [sv addSubview:workingTitleView];
        
        nextY = workingTitleView.bottom;
    }
    
    NSString *workingComment = _carwashComplex.schedule.comment;
    if (workingComment.length > 0)
    {
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.x, nextY, colWidth , 1)];
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.font = [UIFont systemFontOfSize:13];
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.numberOfLines = 0;
        commentLabel.text = workingComment;
        [commentLabel sizeToFit];
        [sv addSubview:commentLabel];
        
        nextY = commentLabel.bottom + rowsSpacing;
    }

    //Contacts
    NSString *contactMobilePhone = [_carwashComplex contactsMobilePhone];
    if(contactMobilePhone.length > 0)
    {
        telTitleView = [[IconTitleView alloc] initWithIcon:@"icon-tel" title:contactMobilePhone];
        telTitleView.x = addressLabel.x;
        telTitleView.y = nextY + 5;
        [sv addSubview:telTitleView];

        nextY = telTitleView.bottom;
    }

    NSString *contactEmail = [_carwashComplex contactsEmail];
    if(contactEmail.length > 0)
    {
        emailTitleView = [[IconTitleView alloc] initWithIcon:@"icon-email" title:contactEmail];
        emailTitleView.x = addressLabel.x;
        emailTitleView.y = nextY + 5;
        [sv addSubview:emailTitleView];

        nextY = emailTitleView.bottom;
    }

    NSString *contactWebsite = [_carwashComplex contactsWebsiteAlias];
    if(contactWebsite.length > 0)
    {
        websiteTitleView = [[IconTitleView alloc] initWithIcon:@"icon-website" title:contactWebsite];
        websiteTitleView.x = addressLabel.x;
        websiteTitleView.y = nextY + 5;
        [sv addSubview:websiteTitleView];

        nextY = websiteTitleView.bottom;
    }

    nextY = MAX(carwashPictureView.bottom, nextY);

    // Favorites and feedbacks
    toggleFavoriteButton = [[RowButtonView alloc] initWithIcon:@"icon-favorite" title:@"" target:self selector:@selector(toggleBookmarkTapped)];
    toggleFavoriteButton.y = nextY + 30;
    [sv addSubview:toggleFavoriteButton];
    [self updateToggleBookmarkButtonTitle];

    pricesButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-menu" title:@"Цены" target:self selector:@selector(pricesTapped)];
    pricesButton.y = toggleFavoriteButton.bottom;
    [pricesButton removeTopLine];
    [sv addSubview:pricesButton];

    feedbacksButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-feedbacks" title:nil target:self selector:@selector(feedbacksTapped)];
    feedbacksButton.y = pricesButton.bottom;
    [sv addSubview:feedbacksButton];
    [self updateFeedbacksRowTitle];
    yPoint = feedbacksButton.bottom;

    //reservationTableButton = [[RowButtonDisclosureView alloc] initWithIcon:@"icon-grid" title:@"Расписание" target:self selector:@selector(reservationTableButtonTapped)];
    //reservationTableButton.y = feedbacksButton.bottom;
    //[reservationTableButton removeTopLine];
    //[sv addSubview:reservationTableButton];

    // Bron
    if ([_carwashComplex.status isEqualToString:@"approved"] || [_carwashComplex.carwashId isEqualToString:@"578dabe7ff42375f6308a9fc"]){
        AAButton *bookButton = [[AAButton alloc] initWithWidth:200 onTap:^(UIView *_self) {
            [wSelf bookButtonTapped];
        }];
        if(_carwashComplex.isBookable) {
            [bookButton commonStyleButtonWithTitle:@"ЗАБРОНИРОВАТЬ"];
        } else {
            bookButton.hidden = YES;
        }
        
        [bookButton setTitleFont:[UIFont robotoRegular:18]];
        bookButton.centerX = self.view.centerX;
        bookButton.y = feedbacksButton.bottom + 30;
        bookButton.height = 40;
        [sv addSubview:bookButton];
        
        yPoint = bookButton.bottom;
    }

    CGSize contentSize = sv.contentSize;
    contentSize.height = yPoint + 20;
    [sv setContentSize:contentSize];
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    [self setNavigationBackButton];
    [self setNavigationTitle:self.carwash.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self removeObservers];
}

@end
