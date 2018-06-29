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


+ (void) signIn:(NSDictionary *) signInData withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) signUp:(NSDictionary *) signUpData withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) sendSMS:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) verifySMSCode:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) createList:(NSDictionary *) inputData accessToken : (NSString*)token  withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getContactList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) createEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getUserEvents:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getRequests:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) acceptEventRequest:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) rejectEventRequest:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateDeviceToken:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) getReceivedRequests:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) signOut:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) updateList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;
+ (void) deleteEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock;

@end
