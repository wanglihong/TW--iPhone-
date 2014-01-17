//
//  Document.m
//  TW+
//
//  Created by Dennis Yang on 13-7-24.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "Document.h"

#import "Attachment.h"

#import "Brand.h"

#import "NSObject+Helpers.h"


@implementation Document

@dynamic author;
@dynamic describe;
@dynamic dId;
@dynamic fileSize;
@dynamic fileType;
@dynamic fileUrl;
@dynamic name;
@dynamic createTime;
@dynamic updateTime;
@dynamic website;
@dynamic iconUrl;
@dynamic attachment;
@dynamic brand;

@dynamic convertedFileSize;
@dynamic convertedUpdateTime;

- (BOOL)exist {

    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", documentPath(), self.dId, self.fileType];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) // 附近在本地存在
        return YES;
    
    else if (self.fileUrl.length == 0) // 没有附件地址（附件为超链接）
        return YES;
    
    else 
        return NO;
    
}

- (NSString *)convertedFileSize {
    
    float size = self.fileSize.floatValue;
    
    if (size > 1024 * 1024)
    {
        return [NSString stringWithFormat:@"%.1fM", size/(1024.f*1024.f)];
    }
    else if (size > 1024)
    {
        return [NSString stringWithFormat:@"%.1fK", size/1024.f];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fB", size];
    }
}

- (NSString *)convertedUpdateTime {

    NSCalendar *gregorian = [NSCalendar currentCalendar];;
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:[NSDate dateWithTimeIntervalSince1970:self.updateTime.doubleValue]
                                                  toDate:[NSDate date]
                                                 options:0];
    
    int year = [components year];
    int month = [components month];
    int day = [components day];
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    
    
    if (year) {
        return [NSString stringWithFormat:@"%d %@", year, (year > 1 ? @"years" : @"year")];
    }
    else if (month) {
        return [NSString stringWithFormat:@"%d %@", month, (month > 1 ? @"mons" : @"mon")];
    }
    else if (day) {
        return [NSString stringWithFormat:@"%d %@", day, (day > 1 ? @"days" : @"day")];
    }
    else if (hour) {
        return [NSString stringWithFormat:@"%d %@", hour, (hour > 1 ? @"hrs" : @"hr")];
    }
    else if (minute) {
        return [NSString stringWithFormat:@"%d %@", minute, (minute > 1 ? @"mins" : @"min")];
    }
    else {
        return [NSString stringWithFormat:@"%d %@", second, (second > 1 ? @"secs" : @"sec")];
    }
}

@end
