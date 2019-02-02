//
//  ServerManager.h
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^TMARServiceResultBlock)(NSDictionary *result);

@interface ServerManager : NSObject

+ (void) getURL:(NSDictionary *) signInData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) signIn:(NSDictionary *) signInData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) validation:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) signUp:(NSDictionary *) signUpData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) socialSignUp:(NSDictionary *) signUpData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) sendSMS:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) verifySMSCode:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) sendSMSWithForgetPassword:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) verifyForgetPasswordCode:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updatePassword:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) createList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token  withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getContactList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) createEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getUserEvents:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getRequests:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) acceptEventRequest:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) rejectEventRequest:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateDeviceToken:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getReceivedRequests:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) signOut:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) cancelEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) sendReport:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getUserProfile:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateUserProfile:(NSDictionary *) inputData withBaseURL : (NSString*) url withImageData : (NSData *)imageData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateListImage:(NSDictionary *) inputData withBaseURL : (NSString*) url withImageData : (NSData *)imageData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteProfileImage:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteListImage:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;

@end
