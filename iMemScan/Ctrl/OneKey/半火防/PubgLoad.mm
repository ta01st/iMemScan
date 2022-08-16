

#import "PubgLoad.h"
#import <UIKit/UIKit.h>
#import "JHPP.h"
#import "JHDragView.h"
#import "SCLAlertView.h"

@interface wum()
@end

@implementation wum

static wum *extraInfo;
static BOOL MenDeal;

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
        extraInfo =  [wum new];
        [extraInfo initTapGes];
        [extraInfo tapIconView];
    });
}

-(void)initTapGes
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 3;//点击次数
    tap.numberOfTouchesRequired = 3;//手指数
    [[JHPP currentViewController].view addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(tapIconView)];
}


-(void)tapIconView
{
 JHDragView *view = [[JHPP currentViewController].view viewWithTag:100];
 if (!view) {
     view = [[JHDragView alloc] init];
     view.tag = 100;
     [[JHPP currentViewController].view addSubview:view];
     
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConsoleButtonTapped)];
     tap.numberOfTapsRequired = 1;
     [view addGestureRecognizer:tap];
 }
 
 if (!MenDeal) {
     view.hidden = NO;
 } else {
     view.hidden = YES;
 }
 
 MenDeal = !MenDeal;
}

NSString *requestStr = @"http://47.104.183.134:88/ss.html";

NSString *htmlStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestStr] encoding:NSUTF8StringEncoding error:nil];
-(void)onConsoleButtonTapped//:(id)sender
{

      //解析服务器版本
          NSError *error;
          NSString *txturl = [NSString stringWithFormat:@"http://47.104.183.134:88/e.json"];
     
          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:txturl]];
          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
          //主标题
          
          NSString *zhutitle = [json objectForKey:@"biaoti"];
          NSString *fubiaoti = [json objectForKey:@"fubiaoti"];
          NSString *zicaidan = [json objectForKey:@"zicaidan"];
          NSString *bb = [json objectForKey:@"bb"];
          
          NSString *gongneng1 = [json objectForKey:@"gongneng1"];
          NSString *gongneng2 = [json objectForKey:@"gongneng2"];
          NSString *gongneng3 = [json objectForKey:@"gongneng3"];
          NSString *gongneng4 = [json objectForKey:@"gongneng4"];
          NSString *gongneng5 = [json objectForKey:@"gongneng5"];
      //    总菜单开始=============
          SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
          [alert addTimerToButtonIndex:0 reverse:YES];
            
               [alert addButton:@"开启绘制" actionBlock:^{
           
           }];

          [alert showSuccess:zhutitle subTitle:fubiaoti closeButtonTitle:@"取消" duration:0];

    
}

@end
