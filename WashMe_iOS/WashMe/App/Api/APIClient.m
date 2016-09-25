//
//  APIClient.m
//  Wash! Me
//
//  Created by Almas Adilbek on 10/15/12.
//
//

#import "APIClient.h"
#import "Toast.h"
#import "UIHelper.h"
#import "NSObject+Json.h"
#import "SDiPhoneVersion.h"
#import "NSString+Ext.h"
#import "NSData+Base64.h"
#import "User.h"

const NSString *kSTATUS = @"status";
const NSString *kSUCCESS = @"success";
const NSString *kMESSAGE = @"message";
const NSString *kFAULT_CODE = @"faultCode";
const NSString *kDATA = @"data";

@interface APIClient()

@end

@implementation APIClient

+(APIClient *)sharedManager {
    static dispatch_once_t once;
    static APIClient *sharedManager;
    dispatch_once(&once, ^ {
        sharedManager = [[self alloc] init];

        [sharedManager.requestSerializer setValue:kContentTypeApplicationJson forHTTPHeaderField:@"Content-Type"];
        [sharedManager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"X-Att-Deviceid"];

        NSString *userAgent = [NSString stringWithFormat:@"Washme/%@ (iOS %@; %@)", [AppUtils appVersion], [UIDevice currentDevice].systemVersion, [AppUtils deviceModel]];
        [sharedManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    });

    // Language
    [sharedManager.requestSerializer setValue:@"ru" forHTTPHeaderField:@"Accept-Language"];

    // token
    if([User isAuthorized]) {
        [sharedManager.requestSerializer setValue:[NSString stringWithFormat:@"ApiKey %@", [[User currentUser] authorizedToken]] forHTTPHeaderField:@"Authorization"];
    }

    return sharedManager;
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password
{
    [self.requestSerializer clearAuthorizationHeader];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

+(void)cancelAllRequests {
    [[[self sharedManager] operationQueue] cancelAllOperations];
}

#pragma mark -
#pragma mark GET

+(void)GET:(NSString *)path success:(success)success failure:(failure)failure {
    [self GET:path parameters:nil success:success failure:failure];
}

+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure
{
    NSLog(@"GET: %@", [self urlWithPath:path]);
    [[self sharedManager] GET:[self urlWithPath:path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processSuccessResponse:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        NSLog(@"FAULT %li", (long) statusCode);
        if (statusCode == 401) {
//            [UIHelper popToGlobalRoot];
        } else if (statusCode == 500) {
//            [UIAlertView showWithTitle:@""
//                               message:@"Внутренняя ошибка сервера, попробуйте позднее"
//                     cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
        }
        [self responseHTTPFailure:failure operation:operation error:error];
    }];
}

#pragma mark -
#pragma mark PUT

+(void)PUT:(NSString *)path success:(success)success failure:(failure)failure {
    [self PUT:path parameters:nil body:nil success:success failure:failure contentType:nil];
}

+(void)PUT:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure {
    [self PUT:path parameters:parameters body:nil success:success failure:failure contentType:nil];
}

+(void)PUT:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure {
    [self PUT:path parameters:nil body:body success:success failure:failure contentType:nil];
}

+(void)PUT:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType {
    [self PUT:path parameters:nil body:body success:success failure:failure contentType:contentType];
}

+ (void) PUT:(NSString *)path parameters:(NSDictionary *)parameters body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType
{
    [self requestWithPath:path method:@"PUT" parameters:parameters body:body success:success failure:failure contentType:contentType];
}

#pragma mark -
#pragma mark POST

+(void)POST:(NSString *)path success:(success)success failure:(failure)failure {
    [self POST:path parameters:nil body:nil success:success failure:failure contentType:nil];
}

+(void)POST:(NSString *)path parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure {
    [self POST:path parameters:parameters body:nil success:success failure:failure contentType:nil];
}

+(void)POST:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure {
    [self POST:path parameters:nil body:body success:success failure:failure contentType:nil];
}

+(void)POST:(NSString *)path body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType {
    [self POST:path parameters:nil body:body success:success failure:failure contentType:contentType];
}

+ (void)POST:(NSString *)path parameters:(NSDictionary *)parameters body:(NSString *)body success:(success)success failure:(failure)failure contentType:(NSString *)contentType {
    [self requestWithPath:path method:@"POST" parameters:parameters body:body success:success failure:failure contentType:contentType];
}

+ (void)POST:(NSString *)path uploadImage:(NSData *)imageData dataName:(NSString *)dataName parameters:(NSDictionary *)parameters success:(success)success failure:(failure)failure {
    [self requestWithPath:path uploadFile:imageData formDataName:dataName fileName:@"photo.jpg" mimeType:@"image/jpeg" parameters:parameters success:success failure:failure];
}

+ (void)requestWithPath:(NSString *)path
             uploadFile:(NSData *)uploadData
           formDataName:(NSString *)formDataName
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
             parameters:(NSDictionary *)parameters
                success:(success)success failure:(failure)failure {

    NSString *fullPath = [self urlWithPath:path];
    if(kDEBUGMODE) NSLog(@"POST: %@, %@", fullPath, parameters ? [parameters JSONRepresentation] : @"");

    [[self sharedManager] POST:[self urlWithPath:path] parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:uploadData name:formDataName fileName:fileName mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processSuccessResponse:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self responseHTTPFailure:failure operation:operation error:error];
    }];
}

#pragma mark -
#pragma mark PATCH

+ (void)PATCH:(NSString *)path success:(success)success failure:(failure)failure {
    [self PATCH:path body:nil success:success failure:failure];
}

+ (void)PATCH:(NSString *)path body:(id)body success:(success)success failure:(failure)failure {
    [self requestWithPath:path method:@"PATCH" parameters:nil body:body success:success failure:failure contentType:kContentTypeApplicationJson];
}

#pragma mark -
#pragma mark DELETE

+ (void)DELETE:(NSString *)path success:(success)success failure:(failure)failure {
    [self DELETE:path body:nil success:success failure:failure];
}

+ (void)DELETE:(NSString *)path body:(id)body success:(success)success failure:(failure)failure {
    [self requestWithPath:path method:@"DELETE" parameters:nil body:body success:success failure:failure contentType:kContentTypeApplicationJson];
}


#pragma mark -
#pragma mark Common

+ (void)requestWithPath:(NSString *)path
                 method:(NSString *)method
             parameters:(NSDictionary *)parameters
                   body:(NSString *)body
                success:(success)success failure:(failure)failure  contentType:(NSString *)contentType
{
    APIClient *sharedManager = [self sharedManager];
    if(contentType) {
        [sharedManager.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    } else {
        [sharedManager.requestSerializer setValue:kContentTypeApplicationJson forHTTPHeaderField:@"Content-Type"];
    }
    
    if(body) {
        NSLog(@"Request BODY:%@", body);
    }

    NSMutableURLRequest *request = [[sharedManager requestSerializer] requestWithMethod:method URLString:[self urlWithPath:path] parameters:nil error:nil];
    if (body) {
        [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    }

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];

    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processSuccessResponse:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self responseHTTPFailure:failure operation:operation error:error];
    }];

    [op start];
}

#pragma mark -
#pragma mark Helper

+ (NSString *)urlWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@", [path rangeOfString:@"/api"].location == NSNotFound ? kApiGateway : kApiBase, path];
}

+ (void)processSuccessResponse:(id)responseObject success:(success)success failure:(failure)failure
{
    [Toast hideHud];
    NSLog(@"ResponseObject: %@", [responseObject JSONRepresentation]);

    if(responseObject)
    {
        NSString *status = [responseObject objectForKey:kSTATUS];
        if([status isEqual:kSUCCESS])
        {
            if(success)
            {
                id message = [responseObject objectForKey:kMESSAGE];
                if(message && ![message isKindOfClass:[NSNull class]]) {
                    [UIHelper showAlertWithMessageTitle:@"" message:message];
                }
                id data = [responseObject objectForKey:kDATA];
                if(data) {
                    success(data);
                } else {
                    success(responseObject);
                }
            }
        }
        else
        {
            [self responseFailure:failure response:responseObject];
        }
    } else {
        success(nil);
    }
}

+ (void)responseFailure:(failure)failure response:(id)response
{
    NSString *message = [response objectForKey:kMESSAGE];
    NSString *faultCodeString = [response objectForKey:kFAULT_CODE];
    NSInteger faultCode = faultCodeString?[faultCodeString integerValue]:0;

    if(message) { // !!!! for testing
        [UIHelper showAlertWithMessageTitle:@"" message:message];
    }

    if(failure) failure(faultCode, message);
}

+ (void)responseHTTPFailure:(failure)failure operation:(AFHTTPRequestOperation *)operation error:(NSError *)error
{
    [Toast hideHud];

    NSDictionary *responseObject = operation.responseObject;

    if(responseObject && responseObject[@"message"])
    {
        NSString *apiMessage = @"";
        id apiMessages = responseObject[@"message"];

        if([apiMessages isKindOfClass:[NSArray class]]) {
            for(NSString *message in apiMessages) {
                apiMessage = [NSString stringWithFormat:@"- %@\n", message];
            }
        } else if([apiMessage isKindOfClass:[NSString class]]) {
            apiMessage = apiMessages;
        }

        NSLog(@"apiMessage: %@", apiMessage);
        [UIHelper showAlertWithMessage:apiMessage];

        if(failure) failure(error.code, apiMessage);
    } else {
        NSInteger faultCode = operation.response.statusCode;
        NSLog(@"%li, %@", (long)faultCode, error.localizedDescription);

        NSString *localizedError = error.localizedDescription;

        if([localizedError isEqualToString:@"The request timed out."]) {
            [UIHelper showAlertWithMessageTitle:@"Время запроса истекло" message:@"Попробуйте еще раз"];
        } else {
            [UIHelper showAlertWithMessageTitle:[NSString stringWithFormat:@"Error: %i", faultCode] message:localizedError];
        }

        if(failure) failure(faultCode, localizedError);
    }
}

@end
