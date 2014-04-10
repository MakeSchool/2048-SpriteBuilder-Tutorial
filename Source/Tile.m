//
//  Tile.m
//  2048Tutorial
//
//  Created by Benjamin Encz on 07/04/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tile.h"

@implementation Tile {
    CCLabelTTF *_valueLabel;
    CCNodeColor *_backgroundNode;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.value = (arc4random()%2+1)*2;
    }
    
    return self;
}

- (void)didLoadFromCCB {
    [self updateValueDisplay];
}

- (void)updateValueDisplay {
    _valueLabel.string = [NSString stringWithFormat:@"%d", self.value];
}

@end
