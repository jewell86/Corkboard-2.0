#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "image1" asset catalog image resource.
static NSString * const ACImageNameImage1 AC_SWIFT_PRIVATE = @"image1";

#undef AC_SWIFT_PRIVATE
