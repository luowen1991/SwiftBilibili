#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SVGA.h"
#import "SVGAAudioEntity.h"
#import "SVGAAudioLayer.h"
#import "SVGABezierPath.h"
#import "SVGABitmapLayer.h"
#import "SVGAContentLayer.h"
#import "SVGAExporter.h"
#import "SVGAImageView.h"
#import "SVGAParser.h"
#import "SVGAPlayer.h"
#import "SVGAVectorLayer.h"
#import "SVGAVideoEntity.h"
#import "SVGAVideoSpriteEntity.h"
#import "SVGAVideoSpriteFrameEntity.h"
#import "Svga.pbobjc.h"

FOUNDATION_EXPORT double SVGAPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char SVGAPlayerVersionString[];

