//
//  Task.m
//  SmartTasks
//
//  Created by Aleksandar Radojicic on 22/1/16.
//  Copyright © 2016 Aleksandar Radojicic. All rights reserved.
//

#import "Task.h"

@implementation Task

-(void)deserialize:(NSDictionary*)dictionary {
    self.uid = [dictionary objectForKey:@"id"];
    self.title = [dictionary objectForKey:@"title"];
    self.targetDate = [Converter getFormatedDateFromString:[dictionary objectForKey:@"TargetDate"]];
    self.dueDate = [Converter getFormatedDateFromString:[dictionary objectForKey:@"DueDate"]];
    self.taskDescription = [dictionary objectForKey:@"Description"];
    self.priority = [[dictionary objectForKey:@"Priority"] integerValue];
    self.taskState = TaskStateUnresolved;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.uid forKey:@"id"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.targetDate forKey:@"targetDate"];
    [coder encodeObject:self.dueDate forKey:@"dueDate"];
    [coder encodeObject:self.taskDescription forKey:@"description"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.taskState forKey:@"taskState"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]){
        self.uid = [decoder decodeObjectForKey:@"id"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.targetDate = [decoder decodeObjectForKey:@"targetDate"];
        self.dueDate = [decoder decodeObjectForKey:@"dueDate"];
        self.taskDescription = [decoder decodeObjectForKey:@"description"];
        self.priority = [decoder decodeIntegerForKey:@"priority"];
        self.taskState = [decoder decodeIntegerForKey:@"taskState"];
    }
    return self;
}

@end
