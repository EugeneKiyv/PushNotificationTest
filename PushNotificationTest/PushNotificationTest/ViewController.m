//
//  ViewController.m
//  PushNotificationTest
//
//  Created by Eugene Kuropatenko on 29.10.15.
//  Copyright © 2015 Eugene Kuropatenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tokenTextView;
@property (weak, nonatomic) IBOutlet UITextView *pushTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToken) name:kReceiveTokenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kReceiveNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showToken];
}

- (void)showToken
{
    NSData *token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    if (token) {
        self.tokenTextView.text = [NSString stringWithFormat:@"%@",token];
    }
}

- (void)receiveNotification:(NSNotification *)notification
{
    NSDictionary *aps = [notification.object valueForKey:@"aps"];
    if (aps) {
        NSString *alertMessage = [aps valueForKey:@"alert"];
        if (alertMessage) {
            self.pushTextView.text = alertMessage;
        }
    }
}
@end
