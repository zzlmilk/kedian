//
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//   佛祖保佑       永无BUG
//   Created by haytor.
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//

#import <UIKit/UIKit.h>

@interface UIViewController (KeyBoardNotification)

@property (assign,nonatomic) BOOL isKeyBackground;

- (void)addObserverForKeyBoard;
- (void)unaddObserverForKeyBoard;

- (void)KeyBoardWillShowHandle:(NSNotification *)notify;
- (void)KeyBoardDidShowHandle:(NSNotification *)notify;
- (void)KeyBoardWillHideHandle:(NSNotification *)notify;
- (void)KeyBoardDidHideHandle:(NSNotification *)notify;
- (void)KeyBoardWillChangeHandle:(NSNotification *)notify;

@end
