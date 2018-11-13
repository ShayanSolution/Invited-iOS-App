//
//  ServerManager.m
//  Invited
//
//  Created by ShayanSolutions on 5/23/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

#import "ServerManager.h"

#define kBaseURL @"http://invited.shayansolutions.com/"

@implementation ServerManager

+ (AFHTTPRequestOperationManager *) sharedWebService {
    static dispatch_once_t once;
    static AFHTTPRequestOperationManager * sharedInstance;
    dispatch_once(&once, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
            [sharedInstance setResponseSerializer:[AFJSONResponseSerializer serializer]];
            [sharedInstance setRequestSerializer:[AFHTTPRequestSerializer serializer]];
            [sharedInstance.requestSerializer setTimeoutInterval:300];
            [sharedInstance.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
            
        }
        
    });
    return sharedInstance;
}

+ (void) signIn:(NSDictionary *) signInData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService] POST:@"login" parameters:signInData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) validation:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"register/validation" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }

                                       
                                       
                                   }];
    
    
}

+ (void) signUp:(NSDictionary *) signUpData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"register-user" parameters:signUpData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) sendSMS:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"sms" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) verifySMSCode:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"phone/verification?" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
//
                                       
                                   }];
    
    
}
+ (void) sendSMSWithForgetPassword:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"forget-password/send-code" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) verifyForgetPasswordCode:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"forget-password/verify-code" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) updatePassword:(NSDictionary *) inputData withResulBlock: (TMARServiceResultBlock) resultBlock
{
    
    
    [[ServerManager sharedWebService] POST:@"forget-password/update-password" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}

+ (void) createList:(NSDictionary *) inputData accessToken : (NSString*)token  withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] POST:@"create-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}
+ (void) getContactList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"get-contact-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                   }];
}
+ (void) createEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] POST:@"create-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                  }];
}
+ (void) getUserEvents:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"get-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
           
                                   }];
}
+ (void) getRequests:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"get-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                  }];
}
+ (void) updateEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] POST:@"update-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) acceptEventRequest:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"accept-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) rejectEventRequest:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"reject-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) updateDeviceToken:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] POST:@"update-device-token" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                   }];
}

+ (void) getReceivedRequests:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"received-request" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) signOut:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"logout" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) updateList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] POST:@"update-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) deleteList:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"delete-list" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                   }];
}
+ (void) deleteEvent:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[ServerManager sharedWebService] GET:@"delete-event" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                        @"message": error.localizedDescription});
                                      }
                                      
                                      
                                      
                                  }];
}
+ (void) sendReport:(NSDictionary *) inputData accessToken : (NSString*)token withResulBlock: (TMARServiceResultBlock) resultBlock
{
    [[ServerManager sharedWebService].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [[ServerManager sharedWebService].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [[ServerManager sharedWebService] POST:@"send-report" parameters:inputData success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                         @"message": error.localizedDescription});
                                       }
                                       
                                       
                                       
                                       
                                   }];
    
    
}

@end
