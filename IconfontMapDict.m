
#import "IconfontMapDict.h"

@implementation IconfontMapDict

+ (NSDictionary *)getIconfontMapDict {
    static NSDictionary *mapDict = nil;
    if (mapDict == nil) {
        mapDict = @{
                    // 所有的图标映射
                    @"chat_list" : @"\U0000e815"
                    
                    };
    }
    return mapDict;
}
@end
