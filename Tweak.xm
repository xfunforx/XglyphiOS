#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>
#import <notify.h>
UIWindow *mywindow;
UIImageView *imgview1;
UIImageView *imgview2;
UIImageView *imgview3;
UIImageView *imgview4;
UIImageView *imgview5;
UIButton *button;
UIButton *button1;
UIImage *image;
CGSize size;
int picindex;
bool big;
CFNotificationCenterRef CFNotificationCenterGetDarwinNotifyCenter(void);
void ingressXglyphShow(CFNotificationCenterRef center,
              void *observer,
              CFStringRef name,
              const void *object,
              CFDictionaryRef userInfo)
{
[mywindow setHidden:FALSE];
[mywindow makeKeyAndVisible];
}
void ingressXglyphHide(CFNotificationCenterRef center,
              void *observer,
              CFStringRef name,
              const void *object,
              CFDictionaryRef userInfo)
{
    NSLog(@"ingressXglyphHide");
[mywindow setHidden:TRUE];
}
%hook SpringBoard
%new
-(void)clearpic{
    if(picindex==1){
        if(big){
            [mywindow setFrame:CGRectMake(10,110,50,50)];
            big =FALSE;
        }else{
            [mywindow setFrame:CGRectMake(10, 110, size.width-20,50)];
            big=TRUE;
        }
    }else{
	[imgview1 setImage:nil];
    [imgview2 setImage:nil];
    [imgview3 setImage:nil];
    [imgview4 setImage:nil];
    [imgview5 setImage:nil];
        picindex=1;
    }
}
%new 
-(void)clickbutton{
UIView *view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
view.frame=[[UIScreen mainScreen]bounds];

UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
image=UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],CGRectMake(0,(size.height-size.width+400)/2,size.width*2,size.width*2));

if (picindex==6) {
    [imgview1 setImage:nil];
    [imgview2 setImage:nil];
    [imgview3 setImage:nil];
    [imgview4 setImage:nil];
    [imgview5 setImage:nil];
    picindex=1;
    }
    switch (picindex) {
    case 1:
        [imgview1 setImage:[UIImage imageWithCGImage:imageRef]];
    break;
    case 2:
        [imgview2 setImage:[UIImage imageWithCGImage:imageRef]];
    break;
    case 3:
        [imgview3 setImage:[UIImage imageWithCGImage:imageRef]];
    break;
    case 4:
        [imgview4 setImage:[UIImage imageWithCGImage:imageRef]];
    break;
    case 5:
        [imgview5 setImage:[UIImage imageWithCGImage:imageRef]];
    break;
    default:
        break;
    }
    picindex+=1;
	CGImageRelease(imageRef);
}

-(void)applicationDidFinishLaunching:(id)application {
%orig;

picindex = 1;
big = TRUE;
UIAlertView *alert = [[UIAlertView alloc]
initWithTitle:@"welcome"
message:@"hello,ingress"
delegate:nil
cancelButtonTitle:@"ok"
otherButtonTitles:nil];
[alert show];
[alert release];

size = [[UIScreen mainScreen] bounds].size;
mywindow = [[UIWindow alloc] initWithFrame:CGRectMake(10, 110, size.width-20,50)];

button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setBackgroundColor:[UIColor redColor]];
button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"C" forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(300, 0, 50, 50)];
    [button1 setBackgroundColor:[UIColor blueColor]];
[button addTarget:self action:@selector(clearpic) forControlEvents:UIControlEventTouchUpInside];
[button1 addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];

[mywindow setBackgroundColor:[UIColor blueColor]];
[mywindow addSubview:button];
[mywindow addSubview:button1];
[mywindow setWindowLevel:UIWindowLevelAlert+1];
mywindow.layer.cornerRadius = 10;
mywindow.layer.masksToBounds = YES;

imgview1 = [[UIImageView alloc] initWithFrame: CGRectMake(50, 0, 50, 50)];
imgview2 = [[UIImageView alloc] initWithFrame: CGRectMake(100, 0, 50, 50)];
imgview3 = [[UIImageView alloc] initWithFrame: CGRectMake(150, 0, 50, 50)];
imgview4 = [[UIImageView alloc] initWithFrame: CGRectMake(200, 0, 50, 50)];
imgview5 = [[UIImageView alloc] initWithFrame: CGRectMake(250, 0, 50, 50)];

[imgview1 setBackgroundColor: [UIColor darkGrayColor]];
[imgview2 setBackgroundColor: [UIColor darkGrayColor]];
[imgview3 setBackgroundColor: [UIColor darkGrayColor]];
[imgview4 setBackgroundColor: [UIColor darkGrayColor]];
[imgview5 setBackgroundColor: [UIColor darkGrayColor]];

[mywindow addSubview:imgview1];
[mywindow addSubview:imgview2];
[mywindow addSubview:imgview3];
[mywindow addSubview:imgview4];
[mywindow addSubview:imgview5];
[mywindow setHidden:TRUE];

CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            ingressXglyphHide,
            CFSTR("ingress-Xglyph-hide"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);
CFNotificationCenterAddObserver(
            CFNotificationCenterGetDarwinNotifyCenter(),
            NULL,
            ingressXglyphShow,
            CFSTR("ingress-Xglyph-show"),
            NULL,
            CFNotificationSuspensionBehaviorDeliverImmediately);

}
%end
