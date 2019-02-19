//
//  ServerManager.m
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

#import "ServerManager.h"




//#define kBaseURL @"http://invited2.shayansolutions.com/"
//#define kBaseURL @"http://dev.invited.shayansolutions.com/"

//#if DEBUG
//#define kBaseURL @"http://dev.invited.shayansolutions.com/"
//#else
//#define kBaseURL @""
//#endif


@implementation ServerManager

//+ (AFHTTPRequestOperationManager *) sharedWebService {
//    static dispatch_once_t once;
//    static AFHTTPRequestOperationManager * sharedInstance;
//    dispatch_once(&once, ^{
//        if (sharedInstance == nil) {
//
//            sharedInstance = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
//            [sharedInstance setResponseSerializer:[AFJSONResponseSerializer serializer]];
//            [sharedInstance setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//            [sharedInstance.requestSerializer setTimeoutInterval:300];
//            [sharedInstance.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
//
//        }
//
//    });
//    return sharedInstance;
//}

//+ (AFHTTPRequestOperationManager *) sharedWebService: (NSString *)baseURL
//{
//    //static dispatch_once_t once;
//    AFHTTPRequestOperationManager * sharedInstance;
//    //dispatch_once(&once, ^{
////    if (sharedInstance == nil)
////        {
//
//            sharedInstance = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
//            [sharedInstance setResponseSerializer:[AFJSONResponseSerializer serializer]];
//            [sharedInstance setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//            [sharedInstance.requestSerializer setTimeoutInterval:300];
//            [sharedInstance.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
//
////        }
//
//
//
//
//    //});
//    return sharedInstance;
//}

+ (AFHTTPRequestOperationManager *) sharedWebServiceWithBaseURL: (NSString *)baseURL
{
    static AFHTTPRequestOperationManager * shared;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
    if (shared == nil || ![shared.baseURL.absoluteString isEqual: baseURL])
    {
    
        shared = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        [shared setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [shared setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [shared.requestSerializer setTimeoutInterval:300];
        [shared.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
//    if (![token  isEqual: @""])
//    {
//        [shared.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//
//    }
//        [sharedInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
    }
//    else
//    {
//        shared = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
//        [shared setResponseSerializer:[AFJSONResponseSerializer serializer]];
//        [shared setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//        [shared.requestSerializer setTimeoutInterval:300];
//        [shared.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
//    }
    
    
    
//    });
    return shared;
}

+ (void) getURL:(NSDictionary *) signInData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"config.json" parameters:signInData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            if (operation.responseObject)
                                            {
                                                resultBlock((NSDictionary*)operation.responseObject);
                                            }
                                            else
                                            {
                                                resultBlock(@{
                                                              @"error": @"1",
                                                              @"message": @"Something went wrong"});
                                            }
                                            
                                            
                                            
                                            
                                        }];
    
    
}
+ (void) signIn:(NSDictionary *) signInData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"login" parameters:signInData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) validation:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"register/validation" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }

                                       
                                       
                                   }];
    
    
}

+ (void) signUp:(NSDictionary *) signUpData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"register-user" parameters:signUpData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) socialSignUp:(NSDictionary *) signUpData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"social-signup-user" parameters:signUpData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) sendSMS:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"sms" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) verifySMSCode:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"phone/verification?" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
//
                                       
                                   }];
    
    
}
+ (void) sendSMSWithForgetPassword:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"forget-password/send-code" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) verifyForgetPasswordCode:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"forget-password/verify-code" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) updatePassword:(NSDictionary *) inputData withBaseURL : (NSString*) url withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"forget-password/update-password" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}

+ (void) createList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token  withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"create-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) getContactList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"get-contact-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                   }];
}
+ (void) createEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"create-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                  }];
}
+ (void) getUserEvents:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"get-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
           
                                   }];
}
+ (void) getRequests:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"get-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                  }];
}
+ (void) updateEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"update-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) acceptEventRequest:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"accept-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) rejectEventRequest:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"reject-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) updateDeviceToken:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"update-device-token" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                   }];
}

+ (void) getReceivedRequests:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"received-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) signOut:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"logout" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) updateList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"update-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) deleteList:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"delete-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) deleteEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"delete-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) cancelEvent:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebServiceWithBaseURL:url] GET:@"cancel-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                      if (operation.responseObject)
                                      {
                                          resultBlock((NSDictionary*)operation.responseObject);
                                      }
                                      else
                                      {
                                          resultBlock(@{
                                                        @"error": @"1",
                                                        @"message": @"Something went wrong"});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) sendReport:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"send-report" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) getUserProfile:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"get-user" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) updateUserProfile:(NSDictionary *) inputData withBaseURL : (NSString*) url accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebServiceWithBaseURL: url].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
//    [[ServerManager sharedWebService: url].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[ServerManager sharedWebServiceWithBaseURL:url] POST:@"update-user" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        resultBlock((NSDictionary*)responseObject );
    }
     
     
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.responseObject)
                                       {
                                           resultBlock((NSDictionary*)operation.responseObject);
                                       }
                                       else
                                       {
                                           resultBlock(@{
                                                         @"error": @"1",
                                                         @"message": @"Something went wrong"});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}

@end
