
#import "IconFont.h"
#import <CoreText/CoreText.h>
#import "IconfontMapDict.h"

static CGFontRef globalFontRef = nil;

#define kDefaultFontColor     [UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]


@implementation IconFont
#pragma mark - Public  Method
+ (UIFont*)iconFontWithSize:(NSInteger)fontSize {
    UIFont *iconfont = nil;
    if (fontSize > 0 ) {
        iconfont = [UIFont fontWithName:@"iconfont" size: fontSize];
    }
    
    if (iconfont == nil) {
        //其他业务bundle的mainclient 还是自动加载吧。
        //        if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.xxx.xxx"]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"iconfont" ofType:@"ttf"];
            [IconFont loadFontAtPath:path];
        });
        iconfont = [UIFont fontWithName:@"iconfont" size: fontSize];
        //        }
    }
    return iconfont;
}


+ (UIButton*)iconFontButtonWithType:(UIButtonType)type fontSize:(NSInteger)fontSize text:(NSString*)text {
    text = [[IconfontMapDict getIconfontMapDict] objectForKey:text] ? [[IconfontMapDict getIconfontMapDict] objectForKey:text] : text;
    UIButton *button = [UIButton buttonWithType:type];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateNormal];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[IconFont iconFontWithSize:fontSize]];
    [button setTitle:text forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    return button;
}

+ (UILabel*)iconFontLabelWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize text:(NSString*)text {
    text = [[IconfontMapDict getIconfontMapDict] objectForKey:text] ? [[IconfontMapDict getIconfontMapDict] objectForKey:text] : text;
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [IconFont iconFontWithSize:fontSize];
    label.textColor = kDefaultFontColor;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (NSString*)iconFontUnicodeWithName:(NSString*)name{
    NSString *result = nil;
    if ([name length] >0) {
        result =  [[IconfontMapDict getIconfontMapDict] objectForKey:name];
    }
    result = result ? result : name;
    return result;
}

#pragma mark - Private Method
//////////////////////////////////////////////////////////////////////////////////
+ (void )loadFontAtPath:(NSString*)path {
    if ([path length] == 0) {
        return;
    }
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if(data == nil)
    {
#ifdef DEBUG
        NSLog(@"Failed to load font. Data at path is null path = %@", path);
#endif //ifdef Debug
        return;
    }
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if(!CTFontManagerRegisterGraphicsFont(font, &error)) {
#ifdef DEBUG
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        return ;
#endif //ifdef Debug
    }
    //    CFStringRef fontName = CGFontCopyFullName(font);
    //    DLog(@"Loaded: %@", fontName);
    //
    //    CFRelease(fontName);
    if (font) {
        globalFontRef = font;
    }
    CFRelease(provider);
}

+ (void)unloadFont {
    CFErrorRef error;
    if(globalFontRef) {
        CTFontManagerUnregisterGraphicsFont(globalFontRef, &error);
        CFRelease(globalFontRef);
        globalFontRef = nil;
    }else {
        NSLog(@"WARNING: Font cannot be unloaded");
    }
}



@end
