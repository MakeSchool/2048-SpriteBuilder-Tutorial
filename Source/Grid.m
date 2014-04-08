//
//  Grid.m
//  2048Tutorial
//
//  Created by Benjamin Encz on 07/04/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"

@implementation Grid {
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
}

static const NSInteger GRID_SIZE = 4;

#pragma mark - View

- (void)didLoadFromCCB {
    [self setupBackground];
}

- (void)setupBackground
{
    // load one tile to read the dimensions
    CCNode *tile = [CCBReader load:@"Tile"];
    _columnWidth = tile.contentSize.width;
    _columnHeight = tile.contentSize.height;
    
    // calculate the margin by subtracting the tile sizes from the grid size
    _tileMarginHorizontal = (self.contentSize.width - (GRID_SIZE * _columnWidth)) / (GRID_SIZE+1);
    _tileMarginVertical = (self.contentSize.height - (GRID_SIZE * _columnWidth)) / (GRID_SIZE+1);
    
    // set up initial x and y positions
    float x = _tileMarginHorizontal;
    float y = _tileMarginVertical;
    
    for (int i = 0; i < GRID_SIZE; i++) {
        // iterate through each row
        x = _tileMarginHorizontal;
        
        for (int j = 0; j < GRID_SIZE; j++) {
            // iterate through each column in the current row
            CCNodeColor *backgroundTile = [CCNodeColor nodeWithColor:[CCColor grayColor]];
            backgroundTile.contentSize = CGSizeMake(_columnWidth, _columnHeight);
            backgroundTile.position = ccp(x, y);
            [self addChild:backgroundTile];
            
            x+= _columnWidth + _tileMarginHorizontal;
        }
        
        y += _columnHeight + _tileMarginVertical;
    }
}

@end
