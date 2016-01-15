//
//  MyTimePicker.m
//  TimePicker
//
//  Created by App on 1/13/16.
//  Copyright © 2016 App. All rights reserved.
//

#import "MyTimePickerView.h"
#import "MyTimeTool.h"

#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define HEIGHTCOUNT 0.5

#define ONEDAYARRAY @[@"今天"]
#define TWODAYARRAY @[@"今天", @"明天"]
#define THREEDAYARRAY @[@"今天", @"明天", @"后天"]
#define HOURARRAY @[@"0点", @"1点", @"2点", @"3点", @"4点", @"5点", @"6点", @"7点", @"8点", @"9点", @"10点", @"11点", @"12点", @"13点", @"14点", @"15点", @"16点", @"17点", @"18点", @"19点", @"20点", @"21点", @"22点", @"23点"]
#define MINUTEARRAY @[@"0分", @"10分", @"20分", @"30分", @"40分", @"50分"]

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]  

typedef void(^CompleteBolck) (NSDictionary *);

@interface MyTimePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


- (IBAction)sureBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;

@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, strong) NSArray *showDayArray;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;
@property (nonatomic, strong) NSArray *totalArray;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) NSInteger columnIndex;
@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, copy) CompleteBolck completeBlock;
@property (nonatomic, copy) NSString *deadLine;

@end

@implementation MyTimePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)myTimePickerViewWithDeadLine:(NSString *)deadLine{
    MyTimePickerView *timePickerView = [[[NSBundle mainBundle] loadNibNamed:@"MyTimePickerView" owner:self options:nil] objectAtIndex:0];
    timePickerView.deadLine = deadLine;
    [timePickerView initData];
    return timePickerView;
}

-(void)awakeFromNib{
    NSLog(@"awakeFromNib---");
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    NSLog(@"layout subviews---%@", NSStringFromCGSize(SCREENSIZE));
////    self.frame =
////    self.topLabel.frame = CGRectMake(0, 0.2 * 0.06 * SCREENSIZE.height, SCREENSIZE.width, 0.6 * 0.1 *SCREENSIZE.height);
////    self.pickerView.frame = CGRectMake(0, 0.1 * SCREENSIZE.height, SCREENSIZE.width, 0.3 * SCREENSIZE.height);
////    self.cancelBtn.frame = CGRectMake( 0.2 * 0.0.06 * SCREENSIZE.height, self.cancelBtn.frame.origin.y, 100, 60);
////    self.sureBtn.frame = CGRectMake(SCREENSIZE.width - 0.2 * 0.1 * SCREENSIZE.height, self.cancelBtn.frame.origin.y, 60, 60);
//    
//}

+(void)showTimePickerViewDeadLine:(NSString *)deadLine CompleteBlock:(void (^)(NSDictionary *))completeBlock{
    MyTimePickerView *timePickerView = [self myTimePickerViewWithDeadLine:deadLine];
    timePickerView.completeBlock = completeBlock;
    timePickerView.frame = CGRectMake(0, SCREENSIZE.height + HEIGHTCOUNT * SCREENSIZE.height, SCREENSIZE.width, HEIGHTCOUNT * SCREENSIZE.height);
    
    [timePickerView.maskView addSubview:timePickerView];

    [[UIApplication sharedApplication].keyWindow addSubview:timePickerView.maskView];
//    CGRect frame = CGRectMake(0, (1-HEIGHTCOUNT) * 0.5 * SCREENSIZE.height, SCREENSIZE.width, HEIGHTCOUNT * SCREENSIZE.height);
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = timePickerView.frame;
        frame.origin.y = (1-HEIGHTCOUNT) * 0.5 * SCREENSIZE.height;
        timePickerView.frame = frame;
        timePickerView.maskView.alpha = 0.8;
    } completion:^(BOOL finished) {
            }];

}

-(UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, SCREENSIZE.height)];
        _maskView.backgroundColor = COLOR(58, 59, 58, 1.0);
        _maskView.alpha = 0.0;
    }
    return _maskView;
}

- (IBAction)sureBtnAction:(id)sender {
    if(self.completeBlock){
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        NSInteger firstIndex = [_pickerView selectedRowInComponent:0];
        NSInteger secodnIndex = [_pickerView selectedRowInComponent:1];
        NSInteger thirdIndex = [_pickerView selectedRowInComponent:2];
        NSMutableString *dateValue = [[NSMutableString alloc] initWithString:_dayArray[firstIndex]];
        [dateValue appendString:[self formatOriArray:_hourArray][secodnIndex]];
        [dateValue appendString:[self formatOriArray:_minuteArray][thirdIndex]];
        infoDic[@"time_value"] = dateValue;
        self.completeBlock(infoDic);
    }
    [self.maskView removeFromSuperview];
}

-(NSArray *)formatOriArray:(NSArray *)oriArray{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *hourStr in oriArray) {
        NSString *tmpStr = [self removeLastChareacter:hourStr];
        [newArray addObject: [self append0IfNeed:tmpStr]];
    }
    return newArray;
}

-(NSString *)removeLastChareacter:(NSString *)oriString{
    return [oriString substringToIndex:oriString.length -1];
}

-(NSString *)append0IfNeed:(NSString *)oriString{
    if(oriString.length <2) return [NSString stringWithFormat:@"0%@", oriString];
    return oriString;
}

- (IBAction)cancelBtnAction:(id)sender {
    [self.maskView removeFromSuperview];
}

#pragma mark - pickerview data and delegate
-(void)initData{
    _dayArray = [MyTimeTool daysFromNowToDeadLine:self.deadLine];
    _showDayArray = [self genShowDayArrayByDayArray:_dayArray];
    _hourArray = [self validHourArray];
    _minuteArray = [self validMinuteArray];
}

-(NSArray *)genShowDayArrayByDayArray:(NSArray *)dayArray{
    int arrayCount = dayArray.count;
    if(arrayCount == 1) return ONEDAYARRAY;
    if(arrayCount == 2) return TWODAYARRAY;
    if(arrayCount == 3) return THREEDAYARRAY;
    NSMutableArray *showDayArray = [NSMutableArray arrayWithArray:THREEDAYARRAY];
    NSArray *tmpArray = [dayArray subarrayWithRange:NSMakeRange(3, arrayCount - 3)];
    for (int i = 0; i< tmpArray.count; i++) {
        [showDayArray addObject:[MyTimeTool displayedSummaryTimeUsingString:tmpArray[i]]];
    }
    return showDayArray;
}

-(NSArray *)validHourArray{
    int startIndex = [MyTimeTool currentDateHour];
    if ([MyTimeTool currentDateMinute] >= 50) startIndex++;
    return [HOURARRAY subarrayWithRange:NSMakeRange(startIndex, HOURARRAY.count - startIndex)];
}

-(NSArray *)validMinuteArray{
    int startIndex = [MyTimeTool currentDateMinute] / 10 +1;
    if ([MyTimeTool currentDateMinute] >= 50) startIndex = 0;
    return [MINUTEARRAY subarrayWithRange:NSMakeRange(startIndex, MINUTEARRAY.count - startIndex)];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.showDayArray.count;
        case 1:
            return self.hourArray.count;
        case 2:
            return self.minuteArray.count;
        default:
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int firstComponentSelectedRow = [self.pickerView selectedRowInComponent:0];
    if (firstComponentSelectedRow == 0) {
        _hourArray = [self validHourArray];
        _minuteArray = [self validMinuteArray];
        int secondComponentSelectedRow = [self.pickerView selectedRowInComponent:1];
        if (secondComponentSelectedRow == 0 || component ==0) {
            _minuteArray = [self validMinuteArray];
//            if(component == 1) [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }else{
            _minuteArray = MINUTEARRAY;
        }
    }else{
        _hourArray = HOURARRAY;
        _minuteArray = MINUTEARRAY;
    }
    [self.pickerView reloadAllComponents];
    
    //当第一列滑到第一个位置时，第二，三列滚回到0位置
    if(component == 0){
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label;
    if (view) {
        label = (UILabel *)view;
    }else{
        label = [[UILabel alloc] init];
    }
    label.textAlignment = NSTextAlignmentCenter;
    switch (component) {
        case 0:
            label.text = self.showDayArray[row];
            //            [label setBackgroundColor:[UIColor redColor]];
            break;
        case 1:
            label.text = self.hourArray[row];
            //            [label setBackgroundColor:[UIColor greenColor]];
            break;
        case 2:
            label.text = self.minuteArray[row];
            //            [label setBackgroundColor:[UIColor lightGrayColor]];
            break;
        default:
            break;
    }
    
    return label;
}

//view的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 3.0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}


@end
