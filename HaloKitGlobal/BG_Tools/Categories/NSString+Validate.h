//
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//   佛祖保佑       永无BUG
//   Created by haytor.
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)
/**验证是否是电子邮件*/
- (BOOL)isEmail;
/**验证是否是手机号码*/
- (BOOL)isMobile;
/**验证是否是电话号码*/
- (BOOL)isTelphone;
/**验证是否是手机或电话号码*/
- (BOOL)isMobileAndTel;
/**验证是否是字符串(不带特殊符号)*/
- (BOOL)isNormalString;
/**验证是否是中文*/
- (BOOL)isCHZN;
/**验证是否是身份证*/
- (BOOL)isIdentityCard;
/**验证是否是数字*/
- (BOOL)isNumber;
/**验证是否是正数*/
- (BOOL)isNumberSign;
/**验证是否是浮点型*/
- (BOOL)isDecimal;
/**验证是否是正浮点型*/
- (BOOL)isDecimalSign;

@end
