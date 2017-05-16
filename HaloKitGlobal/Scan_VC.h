

#import <UIKit/UIKit.h>

@protocol Scan_VCDelegate <NSObject>

-(void)returnValue:(NSString *)value;

@end

@interface Scan_VC : UIViewController
@property (assign ,nonatomic) id<Scan_VCDelegate> delegate;
@end

