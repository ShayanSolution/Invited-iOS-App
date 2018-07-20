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
                                                         @"message": @"Something went wrong with login"});
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
                                                         @"message": @"Something went wrong with validation."});
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
                                                         @"message": @"Something went wrong with registration."});
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
                                                         @"message": @"Something went wrong with send sms."});
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
                                                         @"message": @"Something went wrong with verification."});
                                       }
//
                                       
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
                                                         @"message": @"Something went wrong with create list."});
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
                                                         @"message": @"Something went wrong with fetching contact list."});
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
                                                        @"message": @"Something went wrong with create event."});
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
                                                         @"message": @"Something went wrong with fetching list of invites sent."});
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
                                                        @"message": @"Something went wrong with fetching list of invites received."});
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
                                                        @"message": @"Something went wrong with update event."});
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
                                                         @"message": @"Something went wrong with accept invite request."});
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
                                                         @"message": @"Something went wrong with reject invite request."});
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
                                                         @"message": @"Something went wrong with update device token."});
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
                                                         @"message": @"Something went wrong with fetching list of my events."});
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
                                                        @"message": @"Something went wrong with logout."});
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
                                                        @"message": @"Something went wrong with update list."});
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
                                                         @"message": @"Something went wrong with delete list."});
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
                                                        @"message": @"Something went wrong with delete event."});
                                      }
                                      
                                      
                                      
                                  }];
}

@end
