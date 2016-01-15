//
//  ViewController.m
//  TimePickerViewDemo
//
//  Created by App on 1/15/16.
//  Copyright © 2016 App. All rights reserved.
//

#import "ViewController.h"
#import "MyTimePickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)chooseTimeAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseTimeAction:(id)sender {
    [MyTimePickerView showTimePickerViewDeadLine:@"20160320" CompleteBlock:^(NSDictionary *infoDic) {
        NSString *time = infoDic[@"time_value"];
        _timeLabel.text = time;
        NSLog(@"time---%@", time);
    }];
}
@end
