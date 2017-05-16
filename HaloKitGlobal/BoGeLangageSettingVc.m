//
//  BoGeLangageSettingVc.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/2.
//  Copyright © 2017年 范博. All rights reserved.
#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"langeuageset"


#import "BoGeLangageSettingVc.h"
#import "BGLanageTool.h"
@interface BoGeLangageSettingVc ()

@end

@implementation BoGeLangageSettingVc
{
    NSArray  *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    array = [NSArray arrayWithObjects:@"English", @"简体中文", @"繁体中文", @"阿拉伯文", nil];
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0 :
            [[BGLanageTool sharedInstance] setNewLanguage: EN];
            break;
        case 1 :
            [[BGLanageTool sharedInstance] setNewLanguage: CNS];

            break;
        case 2 :
            [[BGLanageTool sharedInstance] setNewLanguage: EN];

            break;
        default:
            [[BGLanageTool sharedInstance] setNewLanguage: EN];

            break;
    }

}



@end
