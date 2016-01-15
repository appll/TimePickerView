//
//  TimeTool.h
//  TimePicker
//
//  Created by App on 1/14/16.
//  Copyright © 2016 App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTimeTool : NSObject

+(NSArray *)daysFromNowToDeadLine:(NSString *)deadLine;

+(int)currentDateHour;

+(int)currentDateMinute;

+(NSString *)displayedSummaryTimeUsingString:(NSString *)string;

@end
