//
//  StoreManager.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (StoreManager *)instance;
- (void)saveContext;

@end
