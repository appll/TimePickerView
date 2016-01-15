//
//  MyTimePicker.h
//  TimePicker
//
//  Created by App on 1/13/16.
//  Copyright © 2016 App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTimePickerView : UIView

+(void)showTimePickerViewDeadLine:(NSString *)deadLine CompleteBlock:(void (^)(NSDictionary *infoDic))completeBlock;

@end
