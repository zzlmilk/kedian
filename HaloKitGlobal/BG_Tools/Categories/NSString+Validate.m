//
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//   佛祖保佑       永无BUG
//   Created by haytor.
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

- (BOOL)isEmail
{
    //w 英文字母或数字的字符串，和 [a-zA-Z0-9] 语法一样
    NSString *tmpRegex = @"^[\\w-]+@[\\w-]+\\.(com|net|org|edu|mil|tv|biz|info)$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

- (BOOL)isMobile
{
    NSString *tmpRegex = @"^(0?1[3-9]\\d{9})?$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

- (BOOL)isTelphone
{
    NSString *tmpRegex = @"^[0-9]+[-]?[0-9]+[-]?[0-9]$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isMobileAndTel
{
    NSString *tmpRegex = @"^(((01\\d|02\\d|0[3-9]\\d{2})[ -]?[2-9]\\d{6,7})|(0?1[3-9]\\d{9}))?$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

- (BOOL)isNormalString
{   NSString *tmpRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isCHZN
{
    NSString *tmpRegex = @"[\u4e00-\u9fa5]";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isIdentityCard
{
    NSString *tmpRegex = @"^(\\d{17}[\\dXx]|\\d{15}|\\d{7})?$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *tmpRegex = @"^[0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isNumberSign
{
    NSString *tmpRegex = @"^[+-]?[0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isDecimal
{
    NSString *tmpRegex = @"^[0-9]+[.]?[0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}
- (BOOL)isDecimalSign
{
    NSString *tmpRegex = @"^[+-]?[0-9]+[.]?[0-9]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:self];
}

@end
