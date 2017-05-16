//
//  BGLighterVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/7.
//  Copyright © 2017年 范博. All rights reserved.
//

#import "BGLighterVc.h"
#import "JSONKit.h"
#import "lighterViewCell.h"
#import "BGLanageTool.h"

@interface BGLighterVc ()<NSStreamDelegate>

@end

@implementation BGLighterVc
{
    NSInputStream  * inputStream;
    NSOutputStream * outputStream;
    BOOL isWirte;
    BOOL isRed;
    BOOL isBlue;
    BOOL isGreen;
    BOOL isCyan;
    BOOL isYellow;
    BOOL ispurple;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = BGGetStringWithKeyFromTable(@"lightSetting", @"BGLanguageSetting");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"lighterViewCell" bundle:nil] forCellReuseIdentifier:@"lighterCell"];
  
    BOOL isOpen = [[NSUserDefaults standardUserDefaults]boolForKey:@"isOpen"];
    if (isOpen) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isWirte"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isRed"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isBlue"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isGreen"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isCyan"] ||[[NSUserDefaults standardUserDefaults] boolForKey:@"isYellow"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"ispurple"]) {
            isWirte = [[NSUserDefaults standardUserDefaults] boolForKey:@"isWirte"];
            isRed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRed"];
            isBlue = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBlue"];
            isGreen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isGreen"];
            isCyan = [[NSUserDefaults standardUserDefaults] boolForKey:@"isCyan"];
            isYellow = [[NSUserDefaults standardUserDefaults] boolForKey:@"isYellow"];
            ispurple = [[NSUserDefaults standardUserDefaults] boolForKey:@"ispurple"];
        }else{
        
            isWirte = YES;
            isRed = NO;
            isBlue = NO;
            isGreen = NO;
            isCyan = NO;
            isYellow = NO;

        }
       
    }else{
        isWirte = NO;
        isRed = NO;
        isBlue = NO;
        isGreen = NO;
        isCyan = NO;
        isYellow = NO;
        ispurple = NO;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    lighterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lighterCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"lighterViewCell" owner:nil options:nil].lastObject;
    }
    
    if (indexPath.row == 0) {
        cell.yanse.image = [UIImage imageNamed:@"wirte"];
        cell.yanseTitle.text = BGGetStringWithKeyFromTable(@"White", @"BGLanguageSetting");
        if (isWirte) {
            cell.isOpen.hidden = NO;

        }else{
            cell.isOpen.hidden = YES;
        }
        
    }else if (indexPath.row == 1){
        cell.yanse.image = [UIImage imageNamed:@"red"];
        cell.yanseTitle.text =  BGGetStringWithKeyFromTable(@"Red", @"BGLanguageSetting");
        if (isRed) {
            cell.isOpen.hidden = NO;
        }else{
            cell.isOpen.hidden = YES;
        }
        
    }else if (indexPath.row == 2){
        cell.yanse.image = [UIImage imageNamed:@"blue"];
        cell.yanseTitle.text =BGGetStringWithKeyFromTable(@"Blue", @"BGLanguageSetting");
        if (isBlue) {
            cell.isOpen.hidden = NO;
            
        }else{
            cell.isOpen.hidden = YES;
        }
        
    }else if (indexPath.row == 3){
        cell.yanse.image = [UIImage imageNamed:@"green"];
        cell.yanseTitle.text = BGGetStringWithKeyFromTable(@"Green", @"BGLanguageSetting");
        if (isGreen) {
            cell.isOpen.hidden = NO;
        }else{
            cell.isOpen.hidden = YES;
        }
        
        
    }else if (indexPath.row == 4){
        cell.yanse.image = [UIImage imageNamed:@"cyan"];
        cell.yanseTitle.text = BGGetStringWithKeyFromTable(@"Cyan", @"BGLanguageSetting");
        if (isCyan) {
            cell.isOpen.hidden = NO;
            
        }else{
            cell.isOpen.hidden = YES;
            
        }
    }else if (indexPath.row == 5){
        cell.yanse.image = [UIImage imageNamed:@"yellow"];
        cell.yanseTitle.text = BGGetStringWithKeyFromTable(@"Yellow", @"BGLanguageSetting");
        if (isYellow) {
            cell.isOpen.hidden = NO;//Yellow
            
        }else{
            cell.isOpen.hidden = YES;
            
        }
    }else if (indexPath.row == 6){
        cell.yanse.image = [UIImage imageNamed:@"ziseicon"];
        cell.yanseTitle.text = BGGetStringWithKeyFromTable(@"Purple", @"BGLanguageSetting");

        if (ispurple) {
            cell.isOpen.hidden = NO;
        }else{
            cell.isOpen.hidden = YES;
            
        }

    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpen"];
    switch (indexPath.row) {
        case 0:
            [self lighterSeting:@"7"];
            isWirte = YES;
            isRed = NO;

            isBlue = NO;

            isGreen = NO;

            isCyan = NO;

            isYellow = NO;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isWirte"];

           
            break;
        case 1:
            [self lighterSeting:@"1"];
            isWirte = NO;
            isRed = YES;
            isBlue = NO;
            isGreen = NO;
            isCyan = NO;
            isYellow = NO;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];


            break;
        case 2:
            [self lighterSeting:@"4"];
            isWirte = NO;
            isRed = NO;
            isBlue = YES;
            isGreen = NO;
            isCyan = NO;
            isYellow = NO;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];


            break;
        case 3:
            [self lighterSeting:@"2"];
            isWirte = NO;
            isRed = NO;
            isBlue = NO;
            isGreen = YES;
            isCyan = NO;
            isYellow = NO;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];

            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];

            break;
        case 4:
            [self lighterSeting:@"6"];
            isWirte = NO;
            isRed = NO;
            isBlue = NO;
            isGreen = NO;
            isCyan = YES;
            isYellow = NO;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];

            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];
            

            break;
            
       
        case 5:
            [self lighterSeting:@"3"];
            
            isWirte = NO;
            isRed = NO;
            isBlue = NO;
            isGreen = NO;
            isCyan = NO;
            isYellow = YES;
            ispurple = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ispurple"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];

            
            break;


        default:
            [self lighterSeting:@"5"];
            
            isWirte = NO;
            isRed = NO;
            isBlue = NO;
            isGreen = NO;
            isCyan = NO;
            isYellow = NO;
            ispurple = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ispurple"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isYellow"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isCyan"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isGreen"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBlue"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isRed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWirte"];
            break;
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

//向服务器请求位置
-(void)lighterSeting:(NSString *)lighter
{
    [self initNetworkCommunication];
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];

    NSDictionary *dict = @{@"deviceid":[userD objectForKey:@"deviceId"],@"func":@"06",@"content":lighter, @"language":@"en"};
    NSString * response = [dict JSONString];
    NSData * data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:(Byte *)[data bytes] maxLength:[data length]];

}


-(void)close

{
    [outputStream close];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [outputStream setDelegate:nil];
    [inputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
}

//初始化socket
- (void)initNetworkCommunication {
    if (inputStream != nil || outputStream != nil){
        [self close];
    }
    
    uint portNo = 40738;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"16u7471l09.imwork.net", portNo, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened now");
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"has bytes");
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            NSLog(@"Unknown event %lu", (unsigned long)streamEvent);
    }
}


@end
