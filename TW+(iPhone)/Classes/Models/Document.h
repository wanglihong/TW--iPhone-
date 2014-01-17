//
//  Document.h
//  TW+
//
//  Created by Dennis Yang on 13-7-24.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, Brand;

@interface Document : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSString * dId;
@property (nonatomic, retain) NSString * fileSize;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSString * fileUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * createTime;
@property (nonatomic, retain) NSNumber * updateTime;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) Attachment *attachment;
@property (nonatomic, retain) Brand *brand;

@property (nonatomic, retain) NSString * convertedFileSize;
@property (nonatomic, retain) NSString * convertedUpdateTime;

- (BOOL)exist;

@end
