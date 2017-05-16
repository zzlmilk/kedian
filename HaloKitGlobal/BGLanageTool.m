//
//  BGLanageTool.m
//  HaloKitGlobal
//
//  Created by 范博 on 2017/5/2.
//  Copyright © 2017年 范博. All rights reserved.
//
#define CNS @"zh-Hans"
#define EN @"en"
#define AR @"ar"
#define CNT @"zh-Hant"

#define LANGUAGE_SET @"langeuageset"


#import "BGLanageTool.h"
#import "AppDelegate.h"

static BGLanageTool *sharedModel;

@interface BGLanageTool()
@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;
@end

@implementation BGLanageTool

+(id)sharedInstance
{
    if (!sharedModel)
    {
        sharedModel = [[BGLanageTool alloc]init];
    }
    
    return sharedModel;
}


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

-(void)initLanguage
{
    
    NSString *defaultLanuage = [self getPreferredLanguage];
    NSString *path;
    NSString * isSetting = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSetting"];
    if ([isSetting isEqualToString:@"YES"]) {
        self.language = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];

    }else{
        self.language = defaultLanuage;
    }
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    NSLog(@"tmptmptmp:%@", defaultLanuage);
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}


-(void)changeNowLanguage
{
    if ([self.language isEqualToString:EN])
    {
        [self setNewLanguage:CNS];
    }
    else
    {
        [self setNewLanguage:EN];
    }
}

-(void)setNewLanguage:(NSString *)language
{
    if ([language isEqualToString:self.language])
    {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNS] || [language isEqualToString:AR] || [language isEqualToString:CNT])
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSetting"];
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
        
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
}

-(void)resetRootViewController 
{
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *rootNav = [storyBoard instantiateViewControllerWithIdentifier:@"BGTableBarVc"];
    appDelegate.window.rootViewController = rootNav;
}

+ (NSString*)getPreferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

- (NSString*)getPreferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}



@end
