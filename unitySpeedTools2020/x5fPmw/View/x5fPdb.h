//
//  XXDraggableButton.h
//  HBDraggableButton
//
//  Created by Hubert on 14-2-18.
//  Copyright (c) 2014年 Hubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface x5fPdb : UIButton  //XXDraggableButton
{
    BOOL _isDragging;
    BOOL _singleTapBeenCanceled;
    CGPoint _beginLocation;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
}

@property (nonatomic) BOOL draggable;
@property (nonatomic) BOOL autoDocking;

@property (nonatomic) CGPoint dockPoint;
@property (nonatomic) CGFloat limitedDistance;

@property (nonatomic, copy) void(^longPressBlock)(x5fPdb *button);
@property (nonatomic, copy) void(^tapBlock)(x5fPdb *button);
@property (nonatomic, copy) void(^doubleTapBlock)(x5fPdb *button);

@property (nonatomic, copy) void(^draggingBlock)(x5fPdb *button);
@property (nonatomic, copy) void(^dragDoneBlock)(x5fPdb *button);

@property (nonatomic, copy) void(^autoDockingBlock)(x5fPdb *button);
@property (nonatomic, copy) void(^autoDockingDoneBlock)(x5fPdb *button);

- (id)initInView:(id)view WithFrame:(CGRect)frame;

- (BOOL)isDragging;

+ (NSArray *)itemsInView:(id)view;
- (BOOL)isInView:(id)view;


@end
