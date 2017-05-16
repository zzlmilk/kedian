//
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//   佛祖保佑       永无BUG
//   Created by haytor.
//   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "UIView+Tag.h"

#pragma mark -

#undef	KEY_NAMESPACE
#define KEY_NAMESPACE	"UIView.nameSpace"

#undef	KEY_TAGSTRING
#define KEY_TAGSTRING	"UIView.tagString"

#undef	KEY_TAGCLASSES
#define KEY_TAGCLASSES	"UIView.tagClasses"

#pragma mark -

@implementation UIView(Tag)

@dynamic nameSpace;
@dynamic tagString;
@dynamic tagClasses;

- (NSString *)nameSpace
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_NAMESPACE );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

- (void)setNameSpace:(NSString *)value
{
	if ( nil == value )
		return;
	
	objc_setAssociatedObject( self, KEY_NAMESPACE, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSString *)tagString
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_TAGSTRING );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	
	return nil;
}

- (void)setTagString:(NSString *)value
{
	objc_setAssociatedObject( self, KEY_TAGSTRING, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSMutableArray *)tagClasses
{
	NSObject * obj = objc_getAssociatedObject( self, KEY_TAGCLASSES );
	if ( obj && [obj isKindOfClass:[NSMutableArray class]] )
		return (NSMutableArray *)obj;
	
	return nil;
}

- (void)setTagClasses:(NSMutableArray *)value
{
	objc_setAssociatedObject( self, KEY_TAGCLASSES, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (UIView *)viewWithTagString:(NSString *)value
{
	if ( nil == value )
		return nil;
	
	for ( UIView * subview in self.subviews )
	{
		NSString * tag = subview.tagString;
		if ( [tag isEqualToString:value] )
		{
			return subview;
		}
	}
	
	return nil;
}

- (UIView *)viewWithTagPath:(NSString *)path
{
	NSArray * array = [path componentsSeparatedByString:@"."];
	if ( 0 == [array count] )
	{
		return nil;
	}
	
	UIView * result = self;
	
	for ( NSString * subPath in array )
	{
		if ( 0 == subPath.length )
			continue;
		
		result = [result viewWithTagString:subPath];
		if ( nil == result )
			return nil;
		
		if ( [array lastObject] == subPath )
		{
			return result;
		}
		else if ( NO == [result isKindOfClass:[UIView class]] )
		{
			return nil;
		}
	}
	
	return result;
}

- (NSArray *)viewWithTagClass:(NSString *)value
{
	NSMutableArray * result = [NSMutableArray array];
	
	for ( UIView * subview in self.subviews )
	{
		NSMutableArray * classes = subview.tagClasses;
		for ( NSString * tagClass in classes )
		{
			if ( NSOrderedSame == [tagClass compare:value options:NSCaseInsensitiveSearch] )
			{
				[result addObject:subview];
				break;
			}
		}
	}
	
	return result;
}

- (NSArray *)viewWithTagClasses:(NSArray *)array
{
	NSMutableArray * result = [NSMutableArray array];
	
	for ( NSString * tagClass in array )
	{
		NSArray * subResult = [self viewWithTagClass:tagClass];
		if ( subResult && subResult.count )
		{
			[result addObjectsFromArray:subResult];
		}
	}
	
	return result;
}


@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
