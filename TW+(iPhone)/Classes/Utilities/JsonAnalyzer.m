//
//  JsonAnalyzer.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "JsonAnalyzer.h"

#import "StoreManager.h"

#import "AppAPIClient.h"




@implementation JsonAnalyzer

+ (void)analyzeAccessInfo:(id)json {

    if ([json isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *oa = [json valueForKeyPath:@"OAuth"];
        if (oa && [oa isKindOfClass:[NSDictionary class]])
        {
            NSString *accessToken = [oa valueForKey:@"access_token"];
            NSString *expiresOn = [oa valueForKey:@"expires_on"];
            NSLog(@"--------%@", accessToken);
            [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setValue:expiresOn forKey:@"expires_on"];
            
            [[AppAPIClient sharedClient] setDefaultHeader:@"Authorization"
                                                    value:accessToken];
        }
    }
}

+ (void)analyzeBrand:(id)json {
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        NSArray *data = [json valueForKeyPath:@"data"];
        
        
        // remote category ids
        NSMutableArray *rcIds = [NSMutableArray arrayWithCapacity:0];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [rcIds addObject:[obj valueForKey:@"category_id"]];
        }];
        
        // remote brands
        NSManagedObjectContext *addingManagedObjectContext = [StoreManager instance].managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Brand"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cId in %@", rcIds];
        NSArray *brands = [addingManagedObjectContext executeFetchRequest:fetchRequest error:NULL];
        
        // local category ids
        NSMutableArray *lcIds = [NSMutableArray arrayWithCapacity:0];
        [brands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [lcIds addObject:((Brand *)obj).cId];
        }];
        
        // local brands
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:brands forKeys:lcIds];
        
        
        for (NSDictionary *item in data) {
            
            NSString *itemId = [item valueForKey:@"category_id"];
            NSManagedObject *brand = nil;
            
            if ([dic objectForKey:itemId])
            {
                brand = [dic objectForKey:itemId];
            }
            else
            {
                brand = [NSEntityDescription insertNewObjectForEntityForName:@"Brand" inManagedObjectContext:addingManagedObjectContext];
                ((Brand *)brand).hasUpdate = YES;
            }
            
            [brand setValue:[item valueForKey:@"category_id"] forKey:@"cId"];
            [brand setValue:[item valueForKey:@"name"] forKey:@"name"];
            [brand setValue:[item valueForKey:@"icon"] forKey:@"iconUrl"];
            [brand setValue:safeString([item valueForKey:@"document_time"]) forKey:@"lastUpdate"];
            [brand setValue:safeString([item valueForKey:@"new_document_total"]) forKey:@"numsUpdate"];
        }
        
        NSError *error;
        if (![addingManagedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

+ (void)analyzeDocument:(id)json inBrand:(Brand *)brand {
    NSLog(@"%@", json);
    if ([json isKindOfClass:[NSDictionary class]])
    {
        NSArray *data = [json valueForKeyPath:@"data"];
        
        // remote document ids
        NSMutableArray *rdIds = [NSMutableArray arrayWithCapacity:0];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [rdIds addObject:[obj valueForKey:@"document_id"]];
        }];
        
        // remote documents
        NSManagedObjectContext *addingManagedObjectContext = [StoreManager instance].managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Document"];
        NSArray *documents = [addingManagedObjectContext executeFetchRequest:fetchRequest error:NULL];
        
        // local document ids
        NSMutableArray *ldIds = [NSMutableArray arrayWithCapacity:0];
        [documents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [ldIds addObject:((Document *)obj).dId];
        }];
        
        // local documents
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:documents forKeys:ldIds];
        
        
        for (NSDictionary *item in data) {
            
            NSString *itemId = [item valueForKey:@"document_id"];
            NSManagedObject *document = nil;
            
            if ([ldIds containsObject:itemId])
            {
                document = [dic objectForKey:itemId];
            }
            else
            {
                document = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:addingManagedObjectContext];
            }
            
            [document setValue:[item valueForKey:@"document_id"]    forKey:@"dId"];
            [document setValue:[item valueForKey:@"name"]           forKey:@"name"];
            [document setValue:[item valueForKey:@"icon"]           forKey:@"iconUrl"];
            [document setValue:[item valueForKey:@"author"]         forKey:@"author"];
            [document setValue:[item valueForKey:@"description"]    forKey:@"describe"];
            [document setValue:[item valueForKey:@"website"]        forKey:@"website"];
            [document setValue:[item valueForKey:@"source_url"]     forKey:@"fileUrl"];
            [document setValue:[item valueForKey:@"source_size"]    forKey:@"fileSize"];
            [document setValue:[item valueForKey:@"create_time"]    forKey:@"createTime"];
            [document setValue:[item valueForKey:@"update_time"]    forKey:@"updateTime"];
            [document setValue:brand                                forKey:@"brand"];
            
            if (!((Document *)document).fileType) {
                [document setValue:[item valueForKey:@"format"]     forKey:@"fileType"];
            }
            
            if (brand == nil) {
                
                NSManagedObject *brand = ((Document *)document).brand;
                NSDictionary *category = [item valueForKey:@"categories"];
                [brand setValue:[category valueForKey:@"category_id"] forKey:@"cId"];
                [brand setValue:[category valueForKey:@"name"] forKey:@"name"];
                [brand setValue:[category valueForKey:@"icon"] forKey:@"iconUrl"];
            }
        }
        
        if (brand == nil) {
            
            [brand setHasUpdate:NO];
            [brand setNumsUpdate:@"0"];
        }
        
        NSError *error;
        if (![addingManagedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

NSString * safeString(id string) {
    return [NSString stringWithFormat:@"%@", string];
}

@end
