//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Grid.h"

@implementation MainScene {
    Grid *_grid;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
}

- (void)dealloc {
    [_grid removeObserver:self forKeyPath:@"score"];
}

- (void)didLoadFromCCB {
    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _grid.score];
    }
}

@end