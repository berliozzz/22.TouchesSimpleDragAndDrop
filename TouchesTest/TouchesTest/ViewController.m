//
//  ViewController.m
//  TouchesTest
//
//  Created by Nikolay Berlioz on 04.11.15.
//  Copyright © 2015 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) UIView *draggingView;

@property (assign, nonatomic) CGPoint touchOffset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (int i = 0; i < 8; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 + 110 * i, 100, 100, 100)];
        view.backgroundColor = [self randomColor];
        
        [self.view addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
//-----------   This method show coordinates touches   -------------
- (void) logTouches:(NSSet*)touches withMethod:(NSString*)methodName
{
    NSMutableString *mString = [NSMutableString stringWithString:methodName];
    
    for (UITouch* touch in touches)
    {
        CGPoint point = [touch locationInView:self.view];
        [mString appendFormat:@" %@", NSStringFromCGPoint(point)];
    }
    NSLog(@"%@", mString);
    
    //self.view.multipleTouchEnabled = YES;
}

- (UIColor*) randomColor
{
    CGFloat red = (float)(arc4random() % 256) / 255;
    CGFloat green = (float)(arc4random() % 256) / 255;
    CGFloat blue = (float)(arc4random() % 256) / 255;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}

- (void) onTouchesEnded
{
    [UIView animateWithDuration:0.2 //анимация при отпускании вьюхи
                     animations:^{
                         self.draggingView.transform = CGAffineTransformIdentity; //в исходное значение
                         self.draggingView.alpha = 1.f;
                     }];
    self.draggingView = nil;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self logTouches:touches withMethod:@"touchesBegan"];
    
    UITouch *touch = [touches anyObject]; // присваивает переменной touch касание, вытаскивая его из массива touches
    
    CGPoint pointOnMainView = [touch locationInView:self.view]; //точка где был сделан тач
    
    UIView *view = [self.view hitTest:pointOnMainView withEvent:event];//та вьюха, которая глубже всех в месте касания
    
    if (![view isEqual:self.view])// !(если касание произошло не на главной вьюхе)
    {
        
        
        self.draggingView = view;//тогда присваиваем значение свойству
        
        [self.view bringSubviewToFront:self.draggingView];
        
        CGPoint touchPoint = [touch locationInView:self.draggingView];//точка в самой уже этой вьюхе где произошло касание
        
        self.touchOffset = CGPointMake(CGRectGetMidX(self.draggingView.bounds) - touchPoint.x,//разница в координатах, чтовы вьюха не слезала к центру
                                       CGRectGetMidY(self.draggingView.bounds) - touchPoint.y);
        
        [UIView animateWithDuration:0.2f  //анимация при захвате вьюхи
                         animations:^{
                             self.draggingView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                             self.draggingView.alpha = 0.7f;
                         }];
    }
    else
    {
        self.draggingView = nil;
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self logTouches:touches withMethod:@"touchesMoved"];
    
    if (self.draggingView)//если это захваченая вьюха
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint pointOnMainView = [touch locationInView:self.view];
        
        CGPoint correction = CGPointMake(pointOnMainView.x + self.touchOffset.x,//это чтобы вьюха при захвате не падала в центр
                                         pointOnMainView.y + self.touchOffset.y);
        
        self.draggingView.center = correction;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self logTouches:touches withMethod:@"touchesEnded"];
    
    [self onTouchesEnded];
}

- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self logTouches:touches withMethod:@"touchesCancelled"];
    
    [self onTouchesEnded];
}





@end
