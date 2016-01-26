//
//  WebServiceManager.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "WebServiceManager.h"
#import "AFNetworking.h"
#import "URLProvider.h"
#import "Task.h"

@implementation WebServiceManager

# pragma mark - Tasks methods

+ (void)getAllTasksWithCompletion:(void(^)(BOOL success, NSArray *tasks, NSError *error))completion {
    AFHTTPRequestOperationManager *manager = [self constructHTTPRequestManager];
    NSString *requestUrl = [URLProvider getURLforTasks];
    
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *responseDictionary = [self convertJson:operation];
        NSArray *arrayReceived = [responseObject objectForKey:@"tasks "];
        if (arrayReceived == nil) {
            if (completion) {
                completion(NO, nil, nil);
            }
        } else {
            NSMutableArray *arrayTasks = [NSMutableArray new];
            for (NSDictionary *dictionary in arrayReceived) {
                Task *task = [Task new];
                [task deserialize:dictionary];
                [arrayTasks addObject:task];
            }
            if (completion) {
                completion(YES, arrayTasks, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, nil, error);
        }
    }];
}


#pragma mark - HTTP init helper methods

+ (AFHTTPRequestOperationManager*)constructHTTPRequestManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *responseSerializerUpdate = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializerUpdate];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"application/json"]]];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.requestSerializer = requestSerializer;
    return manager;
}

+ (id)convertJson:(AFHTTPRequestOperation*) operation {
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    return NULL_TO_NIL([NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil]);
}

@end
