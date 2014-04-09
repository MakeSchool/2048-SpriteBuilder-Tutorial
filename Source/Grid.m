//
//  Grid.m
//  2048Tutorial
//
//  Created by Benjamin Encz on 07/04/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"

@implementation Grid {
    CGFloat _columnWidth;
    CGFloat _columnHeight;
    CGFloat _tileMarginVertical;
    CGFloat _tileMarginHorizontal;
    NSMutableArray *_gridArray;
    NSNull *_noTile;
}

static const NSInteger GRID_SIZE = 4;
static const NSInteger START_TILES = 2;

#pragma mark - View

- (void)didLoadFromCCB {
    [self setupBackground];

    // a value that will represent an empty slot in the grid
    _noTile = [NSNull null];
    
    // initialize the grid with empty slots
    _gridArray = [NSMutableArray array];
    for (int i = 0; i < GRID_SIZE; i++) {
        _gridArray[i] = [NSMutableArray array];
        for (int j = 0; j < GRID_SIZE; j++) {
            _gridArray[i][j] = _noTile;
        }
    }
    // spawn start titles
    [self spawnStartTiles];
    
    // add gesture recognizers to detect swipes
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
}

#pragma mark - Touch Handling

- (void)swipeLeft {
    [self move:ccp(-1, 0)];
}

- (void)swipeRight {
    [self move:ccp(1, 0)];
}

- (void)swipeDown {
    [self move:ccp(0, -1)];
}

- (void)swipeUp {
    [self move:ccp(0, 1)];
}

#pragma mark - Movement

- (void)move:(CGPoint)direction {
    // apply negative vector until reaching boundary, this way we get the tile that is the furthest away
    
    //bottom left corner
    NSInteger currentX = 0;
    NSInteger currentY = 0;
    
    //1) Move to relevant edge by applying direction until reaching border
    while ([self indexValid:currentX y:currentY]) {
        CGFloat newX = currentX + direction.x;
        CGFloat newY = currentY + direction.y;
        
        if ([self indexValid:newX y:newY]) {
            currentX = newX;
            currentY = newY;
        } else {
            break;
        }
    }
    
    // store initial row value to reset after completing each column
    NSInteger initialY = currentY;
    
    // define changing of x and y value (moving left, up, down or right?)
    NSInteger xChange = -direction.x;
    NSInteger yChange = -direction.y;
    
    if (xChange == 0) {
        xChange = 1;
    }
    
    if (yChange == 0) {
        yChange = 1;
    }
    
    // visit column for column
    while ([self indexValid:currentX y:currentY]) {
        while ([self indexValid:currentX y:currentY]) {
            
            // get tile at current index
            Tile *tile = _gridArray[currentX][currentY];
            
            if ([tile isEqual:_noTile]) {
                // if there is no tile at this index -> skip
                currentY += yChange;
                continue;
            }
            
            // store index in temp variables to change them and store new location of this tile
            NSInteger newX = currentX;
            NSInteger newY = currentY;
            
            /* find the farthest position by iterating in direction of the vector until we reach border of grid or an occupied cell*/
            while ([self indexValid:newX+direction.x y:newY+direction.y]) {
                newX += direction.x;
                newY += direction.y;
            }
            if (newX != currentX || newY !=currentY) {
                [self moveTile:tile fromIndex:currentX oldY:currentY newX:newX newY:newY];
            }
            // move further in this column
            currentY += yChange;
        }
        
        // move to the next column, start at the inital row
        currentX += xChange;
        currentY = initialY;
    }
}

- (void)moveTile:(Tile *)tile fromIndex:(NSInteger)oldX oldY:(NSInteger)oldY newX:(NSInteger)newX newY:(NSInteger)newY {
    _gridArray[newX][newY] = _gridArray[oldX][oldY];
    _gridArray[oldX][oldY] = _noTile;
    
    CGPoint newPosition = [self positionForColumn:newX row:newY];
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:0.2f position:newPosition];
    [tile runAction:moveTo];
}

#pragma mark - Index Utils

- (BOOL)indexValid:(NSInteger)x y:(NSInteger)y {
    BOOL indexValid = TRUE;
    indexValid &= x >= 0;
    indexValid &= y >= 0;
    
    if (indexValid) {
        indexValid &= x < (int) [_gridArray count];
        if (indexValid) {
            indexValid &= y < (int) [(NSMutableArray*) _gridArray[x] count];
        }
    }
    return indexValid;
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

#pragma mark - Tile Utils

- (void)spawnStartTiles {
    for (int i = 0; i < START_TILES; i++) {
        [self spawnRandomTile];
    }
}

- (void)spawnRandomTile {
    BOOL spawned = FALSE;
    
    while (!spawned) {
        NSInteger randomRow = arc4random() % GRID_SIZE;
        NSInteger randomColumn = arc4random() % GRID_SIZE;
        
        BOOL positionFree = (_gridArray[randomColumn][randomRow] == _noTile);
        
        if (positionFree) {
            [self addTileAtColumn:randomColumn row:randomRow];
            spawned = TRUE;
        }
    }
}

- (void)addTileAtColumn:(NSInteger)column row:(NSInteger)row {
    Tile *tile = (Tile*) [CCBReader load:@"Tile"];
    _gridArray[column][row] = tile;
    tile.scale = 0.f;
    [self addChild:tile];
    tile.position = [self positionForColumn:column row:row];
    CCActionDelay *delay = [CCActionDelay actionWithDuration:0.3f];
    CCActionScaleTo *scaleUp = [CCActionScaleTo actionWithDuration:0.2f scale:1.f];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[delay, scaleUp]];
    [tile runAction:sequence];
}

- (CGPoint)positionForColumn:(NSInteger)column row:(NSInteger)row {
    NSInteger x = _tileMarginHorizontal + column * (_tileMarginHorizontal + _columnWidth);
    NSInteger y = _tileMarginVertical + row * (_tileMarginVertical + _columnHeight);
    
    return CGPointMake(x,y);
}

@end
