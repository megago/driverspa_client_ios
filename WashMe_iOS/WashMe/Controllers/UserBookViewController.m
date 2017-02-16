//
//  UserBookViewController.m
//  WashMe
//
//  Created by Almas Adilbek on 11/8/14.
//  Copyright (c) 2014 Almas Adilbek. All rights reserved.
//

#import "UserBookViewController.h"
#import "CarwashBook.h"
#import "UIViewController+Ext.h"
#import "UserApi.h"
#import "CarwashApi.h"
#import "Carwash.h"
#import "CarwashMapView.h"
#import "UIScrollView+Ext.h"
#import "TitleValueView.h"
#import "CarwashComplex.h"
#import "CarwashRefs.h"
#import "Cache.h"
#import "AAButton+Styles.h"
#import "UIAlertView+Blocks.h"
#import "CarwashMapViewController.h"
#import "Toast.h"
#import "BookSetCarViewController.h"
#import "NSString+Ext.h"
#import "BookObject.h"
#import "CarwashVisits.h"
#import "UIAlertView+Blocks.h"

#import "User.h"
#import "CenterTitle.h"
#import "IconTitleView.h"
#import "UIViewController+NavigationBar.h"

@interface UserBookViewController ()
@end

@implementation UserBookViewController {
    CarwashComplex *carwash;
    CarwashMapView *carwashMapView;
    CarwashRefs *_carwashRefs;
    CarwashVisits *visits;
    
    NSTimer *timer;
    NSDate *waitingDate;
    CenterTitle *timerLabel;
    
    CenterTitle *secondBlockTitle;
    CenterTitle *nameLabel;
    CenterTitle *carLabel;
    CenterTitle *serviceLabel;
    CenterTitle *dateLabel;
    UIView *line2;
    CenterTitle *carwashLabel;
    CenterTitle *addressLabel;
    AAButton *phoneButton;
    IconTitleView *commentLabel;
    CenterTitle *visitsCountLabel;
    CenterTitle *lastVisitDateLavel;
    UIView *line3;
    
    CGFloat yPosition;
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
    self.tabBarController.tabBar.hidden = YES;
    [self configUI];
    
    if (_afterNotification) {
        [self loadBook:_bookId];
    } else {
        [self showBook];
    }
}

- (void)configAction
{
    // Carwash map tap
    UITapGestureRecognizer *mapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped)];
    [carwashMapView addGestureRecognizer:mapGes];
}

- (void)showBook {
    [Cache carwashRefs:^(id obj) {
        _carwashRefs = obj;
        [Toast showHudLoading];
        NSString *url = [self.book.carwash stringByReplacingOccurrencesOfString:@"/api/v1/" withString:@""];
        [CarwashApi getCarwashWithResource:url success:^(id response) {
            carwash = response;
            [self loadVisitsInfo];
        } failure:^(NSInteger code, NSString *message) {
            
        }];
    }];
}

- (void)loadBook: (NSString *)bookId {
    [UserApi bookDetails:bookId success:^(id response) {
        _book = response;
        [self showBook];
    } failure:^(NSInteger code, NSString *message) {
        
    }];
}

- (void)loadVisitsInfo {
    [UserApi visitInfoByCarwash:carwash.carwashId success:^(id response) {
        visits = response;
        [self buildUI];
        [self configAction];
    } failure:^(NSInteger code, NSString *message) {
        [self buildUI];
        [self configAction];
    }];
}

#pragma mark -
#pragma mark Actions

- (void)mapTapped {
    CarwashMapViewController *v = [[CarwashMapViewController alloc] init];
    v.carwashes = @[carwash];
    v.annotationsEnabled = NO;
    v.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:v animated:YES completion:nil];
}

- (void)cancelTapped {
    [UIAlertView showWithTitle:@"Отменить бронирование?" message:@"" cancelButtonTitle:@"Нет" otherButtonTitles:@[@"Да"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex != alertView.cancelButtonIndex) {
            [Toast showHudLoading];
            [UserApi cancelBooking:self.book.carwashBookId success:^(id response) {
//                [Toast showSuccessToastWithMessage:@"Бронь отменена!"];
//                if([self.delegate respondsToSelector:@selector(clientBookViewControllerBookCanceled:)]) {
//                    [self.delegate clientBookViewControllerBookCanceled:self.book.carwashBookId];
//                }
//                [self.navigationController popViewControllerAnimated:YES];
                
                [self checkUpdatedStatusResponse:response withStatus:kBookStatusCancelled withSuccessTitle:@"Бронь отменена!" actionBlock:nil];
            } failure:^(NSInteger code, NSString *message) {
                [UIHelper showAlertTryAgain];
            }];
        }
    }];
}

- (void)editTapped
{
    BookObject *bookObject = [[BookObject alloc] init];
    bookObject.carType = (CarType) [_book.cartype integerValue];
    bookObject.price = _book.price;
    bookObject.services = [CarwashRefs serviceObjectsWithServiceIds:_book.services];
    bookObject.bookDate = [_book bookDate];
    bookObject.bookTime = [_book bookTime];
    bookObject.bookId = [_book carwashBookId];

    BookSetCarViewController *v = [[BookSetCarViewController alloc] init];
    v.editMode = YES;
    v.carwash = carwash;
    v.bookObject = bookObject;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)telTapped
{
    NSString *tel = [carwash contactsMobilePhone];
    if(tel) {
        [UIActionSheet showInView:self.view withTitle:@"Позвонить?" cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@[tel] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            if(buttonIndex != actionSheet.cancelButtonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [tel phoneNumberValidForCall]]]];
            }
        }];
    }
}

- (void)checkUpdatedStatusResponse:(id)response withStatus:(NSString *)bookStatus withSuccessTitle:(NSString *)toastTitle actionBlock:(void(^)(void))actionBlock
{
    NSString *status = response[@"status"];
    if([status isEqual:bookStatus])
    {
        [Toast showSuccessToastWithMessage:toastTitle];
        
        // Update the book status
        _book.status = status;
        [self updateBookStatusView];
        
        // Send delegate
        if([self.delegate respondsToSelector:@selector(clientBookViewControllerBookCanceled:)]) {
            [self.delegate clientBookViewControllerBookCanceled:_book.carwashBookId];
        }
        //[self.navigationController popViewControllerAnimated:YES];
        
        if(actionBlock) {
            actionBlock();
        }
        
    } else {
        [UIHelper showAlertTryAgain];
    }
}

- (void)userTappedOnGroups:(UIGestureRecognizer*)gestureRecognizer {
    [UIAlertView showWithTitle:[_book groupsTitlesArCarwash:carwash] message:[_book goupServicesTitles] cancelButtonTitle:@"ОК" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {}];
}

#pragma mark -

- (void)updateBookStatusView {
    
    for (UIView *i in self.view.subviews){
        if([i isKindOfClass:[UILabel class]]){
            UILabel *newLbl = (UILabel *)i;
            if(newLbl.tag == 1000){
                [newLbl removeFromSuperview];
            }
        }
    }
    
    for (UIView *view in sv.subviews){
        [view removeFromSuperview];
    }
    [self buildUI];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval - 6*60*60;
    if (ti < 0){
        NSInteger seconds = abs(ti)  % 60;
        NSInteger minutes = (abs(ti) / 60) % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
    [self endTimer];
    return @"00:00";
}

- (void)updateValueTimerLabel {
    NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:waitingDate];
    timerLabel.text = [self stringFromTimeInterval:diff];
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateValueTimerLabel)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)endTimer {
    [timer invalidate];
    timer = nil;
}

- (void)buildUI
{
    if([_book isPending]) {
        [self setNavigationTitle:@"Бронь отправлена"]; //@"Ожидает";
    } else if([_book isRejected]) {
        [self setNavigationTitle:@"Бронь отменена администратором"]; //@"Отклонен";
    } else if([_book isFinished]) {
        [self setNavigationTitle:@"Бронь завершена"]; //@"Завершен";
    } else if([_book isApproved]) {
        [self setNavigationTitle:@"Бронь подтверждена"]; //@"Услуга принята";
    } else if([_book isStarted]) {
        [self setNavigationTitle:@"Бронь в процессе"]; //@"В процессе";
    } else if([_book isNoCome]) {
        [self setNavigationTitle:@"Клиент не явился"]; //@"Клиент не явился";
    } else if([_book isCancelled]) {
        [self setNavigationTitle:@"Бронь отменена клиентом"]; //@"Отменен";
    }
    
    // Infos
    CGFloat rowsSpacing = 10;
    CGFloat rowWidth = [ASize screenWidth] - 2*rowsSpacing;
    yPosition = rowsSpacing;
    
    if ([_book isPending]){
        CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:@"Администратор автомойки в течении 15 минут обработает вашу бронь, а вам прийдет push-уведомление" width:rowWidth];
        [subtitleLabel sizeToFit];
        subtitleLabel.centerX = sv.centerX;
        subtitleLabel.y = yPosition;
        [sv addSubview:subtitleLabel];
        yPosition = subtitleLabel.bottom;
        
        waitingDate = [[_book tsDate] dateByAddingTimeInterval:15*60];
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:waitingDate];
        timerLabel = [[CenterTitle alloc] initWithTitle:[self stringFromTimeInterval:diff] width:rowWidth];
        timerLabel.font = [UIFont robotoRegular:18];
        [timerLabel sizeToFit];
        timerLabel.centerX = sv.centerX;
        timerLabel.y = yPosition + rowsSpacing;
        [sv addSubview:timerLabel];
        yPosition = timerLabel.bottom;
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, yPosition + rowsSpacing, rowWidth, 0.5)];
        [line1 setBackgroundColor:[UIColor whiteColor]];
        line1.alpha = 0.2;
        line1.centerX = sv.centerX;
        [sv addSubview:line1];
        
        yPosition = line1.bottom;
    }
    
    
    [self buildInfoBlockAfter:yPosition + rowsSpacing rowWidth:rowWidth rowsSpacing:rowsSpacing];
    
    
    if ([_book isApproved]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"БРОНЬ ПОДТВЕРЖДЕНА" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor greenColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + rowsSpacing;
        [sv addSubview:statusLabel];
        
        yPosition = statusLabel.bottom;
    }

    
    if ([_book isCancelled]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"БРОНЬ ОТМЕНЕНА КЛИЕНТОМ" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor redColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + rowsSpacing;
        [sv addSubview:statusLabel];
        
        yPosition = statusLabel.bottom;
    }
    
    if ([_book isRejected]){
        CenterTitle *statusLabel = [[CenterTitle alloc] initWithTitle:@"БРОНЬ ОТМЕНЕНА АДМИНИСТРАТОРОМ" width:rowWidth];
        statusLabel.font = [UIFont robotoRegular:14];
        statusLabel.textColor = [UIColor redColor];
        [statusLabel sizeToFit];
        statusLabel.centerX = sv.centerX;
        statusLabel.y = yPosition + rowsSpacing;
        [sv addSubview:statusLabel];
        yPosition = statusLabel.bottom;
        
        CenterTitle *subtitleLabel = [[CenterTitle alloc] initWithTitle:@"Извините, бронь не была подтверждена администратором в течении 15 минут и была автоматически отменена." width:rowWidth];
        [subtitleLabel sizeToFit];
        subtitleLabel.centerX = sv.centerX;
        subtitleLabel.y = yPosition + rowsSpacing;
        [sv addSubview:subtitleLabel];
        
        yPosition = subtitleLabel.bottom;
    }
    
    
    if ([_book isPending] || [_book isApproved]){
        __weak UserBookViewController *wSelf = self;
        AAButton *cancelButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
            [wSelf cancelTapped];
        }];
        [cancelButton commonStyleButtonWithTitle:@"ОТМЕНИТЬ БРОНЬ"];
        [cancelButton setTitleFont:[UIFont robotoRegular:18]];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancelButton.centerX = self.view.centerX;
        cancelButton.y = yPosition + rowsSpacing;
        cancelButton.height = 40;
        [sv addSubview:cancelButton];
        
        yPosition = cancelButton.bottom;
    }
    [sv setContentSizeHeight:yPosition + 20];
    
    if ([_book isPending]){
        [self startTimer];
    }
}

- (void)buildInfoBlockAfter : (CGFloat)after rowWidth:(CGFloat)rowWidth rowsSpacing:(CGFloat)rowsSpacing {
    secondBlockTitle = [[CenterTitle alloc] initWithTitle:@"Бронь на имя" width:rowWidth];
    secondBlockTitle.font = [UIFont robotoRegular:18.f];
    [secondBlockTitle sizeToFit];
    secondBlockTitle.centerX = sv.centerX;
    secondBlockTitle.y = after + rowsSpacing;
    [sv addSubview:secondBlockTitle];
    
    nameLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [[User currentUser] fio], [User currentUser].mobile] width:rowWidth];
    [nameLabel sizeToFit];
    nameLabel.centerX = sv.centerX;
    nameLabel.y = secondBlockTitle.bottom + 2*rowsSpacing;
    [sv addSubview:nameLabel];
    
    carLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@", [_book carTypeTitle], [_book localizedCarNumber]] width:rowWidth];
    [carLabel sizeToFit];
    carLabel.centerX = sv.centerX;
    carLabel.y = nameLabel.bottom;
    [sv addSubview:carLabel];
    

    serviceLabel = [[CenterTitle alloc] initWithTitle:@"" width:rowWidth];
    NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] init];
    
    if (_book.groupServices.count > 0){
        [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[_book groupsTitlesArCarwash:carwash] attributes:@{
                                                                                                                   NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                   NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)
                                                                                                                   }]];
    }
    
    if (_book.groupServices.count > 0 && _book.services.count > 0){
        [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" + "
                                                                          attributes:@{                                                                                       NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                       }]];
    }
    
    [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:[_book servicesTitles]
                                                                  attributes:@{
                                                                                                                                                   NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                                                                                   }]];
    
    NSString *str = [NSString new];
    if (_book.discount.intValue > 0){
        str = [NSString stringWithFormat:@" за %@\nсо скидкой %i %%", [_book localizedPrice], _book.discount.intValue];
    } else {
        str = [NSString stringWithFormat:@" за %@", [_book localizedPrice]];
    }
    [titleAttr appendAttributedString:[[NSAttributedString alloc] initWithString:str
                                                                      attributes:@{
                                                                                   NSFontAttributeName : [UIFont robotoRegular:14],NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                   }]];
    
    serviceLabel.attributedText = titleAttr;
    [serviceLabel sizeToFit];
    serviceLabel.centerX = sv.centerX;
    serviceLabel.y = carLabel.bottom;
    [sv addSubview:serviceLabel];
    
//    if (_book.groupServices.count > 0){
//        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnGroups:)];
//        [serviceLabel setUserInteractionEnabled:YES];
//        [serviceLabel addGestureRecognizer:gesture];
//    }
    
    dateLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"%@ (%@) в %@", [_book localizedDaysAgo], [_book localizedBookDate], [_book localBookTime]] width:rowWidth];
    [dateLabel sizeToFit];
    dateLabel.centerX = sv.centerX;
    dateLabel.y = serviceLabel.bottom + 2*rowsSpacing;
    [sv addSubview:dateLabel];
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom + rowsSpacing, rowWidth, 0.5)];
    [line2 setBackgroundColor:[UIColor whiteColor]];
    line2.alpha = 0.2;
    line2.centerX = sv.centerX;
    [sv addSubview:line2];
    
    carwashLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"Автомойка %@", _book.carwashName] width:rowWidth];
    carwashLabel.font = [UIFont robotoRegular:18.f];
    [carwashLabel sizeToFit];
    carwashLabel.centerX = sv.centerX;
    carwashLabel.y = line2.bottom + rowsSpacing;
    [sv addSubview:carwashLabel];
    
    addressLabel = [[CenterTitle alloc] initWithTitle:carwash.address width:rowWidth];
    [addressLabel sizeToFit];
    addressLabel.centerX = sv.centerX;
    addressLabel.y = carwashLabel.bottom + 2*rowsSpacing;
    [sv addSubview:addressLabel];
    
    __weak UserBookViewController *wSelf = self;
    phoneButton = [[AAButton alloc] initWithWidth:250 onTap:^(UIView *_self) {
        [wSelf telTapped];
    }];
    [phoneButton noBorderStyleButtonWithTitle:[carwash contactsMobilePhone]];
    [phoneButton setTitleFont:[UIFont robotoRegular:14]];
    [phoneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    phoneButton.centerX = self.view.centerX;
    phoneButton.y = addressLabel.bottom;
    phoneButton.height = 40;
    [sv addSubview:phoneButton];
    
    float nextY = phoneButton.bottom + rowsSpacing;
    if (![_book.comment isEqualToString:@""]) {
        commentLabel = [[IconTitleView alloc] initWithIcon:@"ic_comment_book" title:_book.comment];
        commentLabel.x = [ASize screenWidth]/2 - commentLabel.frame.size.width/2;
        commentLabel.y = nextY;
        [commentLabel.titleLabel  sizeToFit];
        commentLabel.width = commentLabel.titleLabel.right;
        commentLabel.centerX = sv.centerX;
        [sv addSubview:commentLabel];
        nextY = commentLabel.bottom + rowsSpacing;
    }
    
    if (visits && visits.finishedBooksCount.intValue > 0){
        visitsCountLabel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"обслужили %i раз(а)", visits.finishedBooksCount.intValue] width:rowWidth];
        [visitsCountLabel sizeToFit];
        visitsCountLabel.centerX = sv.centerX;
        visitsCountLabel.y = nextY;
        [sv addSubview:visitsCountLabel];
        nextY = visitsCountLabel.bottom;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
        lastVisitDateLavel = [[CenterTitle alloc] initWithTitle:[NSString stringWithFormat:@"Последняя мойка %@", [formatter stringFromDate:visits.lastFinishedBookDate]] width:rowWidth];
        [lastVisitDateLavel sizeToFit];
        lastVisitDateLavel.centerX = sv.centerX;
        lastVisitDateLavel.y = nextY;
        [sv addSubview:lastVisitDateLavel];
        nextY = lastVisitDateLavel.bottom + rowsSpacing;
    }
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(0, nextY, rowWidth, 0.5)];
    [line3 setBackgroundColor:[UIColor whiteColor]];
    line3.alpha = 0.2;
    line3.centerX = sv.centerX;
    [sv addSubview:line3];
    
    yPosition = line3.bottom;
}

-(void)configUI
{
    [super configUI];
    [self setBlueBackground];
    if (_afterNotification) {
        [self setNavigationBarTransparent];
        [self showMenuButton];
        //[sv setFrame:CGRectMake(0, 64, [ASize screenWidth], [ASize screenHeightWithoutStatusBarAndNavigationBar])];
    } else {
        [self setBackButtonInNavigation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self endTimer];
}

@end
