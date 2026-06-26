//
//  APIClient.h
//  Myth
//
//  Created by Almas Adilbek on 10/15/12.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

//#define kApiGateway @"http://api.washme.kz/v1/"
//#define kApiBase @"http://api.washme.kz/"

#define kApiGateway @"https://api.driverspa.kz/api/v1/"
#define kApiBase @"https://api.driverspa.kz/"


//#define kApiGateway @"http://balhash.washme.kz:5000/api/v1/"
//#define kApiBase @"http://balhash.washme.kz:5000"

typedef void (^success)(id response);
typedef void (^successWithMessage)(id response, NSString *message);
typedef void (^cacheSuccess)(id response);
typedef void (^failure)(NSInteger code, NSString *message);

#define kContentTypeApplicationJson @"application/json"

// Наследует от библиотеки AFNetworking класса AFHTTPRequestOperationManager
@interface APIClient : AFHTTPRequestOperationManager

// Singleton значение
+(APIClient *)sharedManager;

// Basic authorization
- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

// Отменяет все незавершенные HTTP запросы
+(void)cancelAllRequests;


+ (void)GET:(NSString *)path success:(success)success failure:(failure)failure;
+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure;

+ (void)PUT:(NSString *)path success:(success)success failure:(failure)failure;
+ (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure;
+ (void)PUT:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure;
+ (void)PUT:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType;
+ (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType;

+ (void)POST:(NSString *)path success:(success)success failure:(failure)failure;
+ (void)POST:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure;
+ (void)POST:(NSString *)path body:(id)body success:(success)success failure:(failure)failure;
+ (void)POST:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType;
+ (void)POST:(NSString *)path parameters:(NSDictionary *)parameters body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType;
+ (void)POST:(NSString *)path uploadImage:(NSData *)imageData dataName:(NSString *)dataName parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure;

+ (void)PATCH:(NSString *)path success:(success)success failure:(failure)failure;
+ (void)PATCH:(NSString *)path body:(id)body success:(success)success failure:(failure)failure;

+ (void)DELETE:(NSString *)path success:(success)success failure:(failure)failure;
+ (void)DELETE:(NSString *)path body:(id)body success:(success)success failure:(failure)failure;

@end
