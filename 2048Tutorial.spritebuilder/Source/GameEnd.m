//
//  GameEnd.m
//  2048Tutorial
//
//  Created by Benjamin Encz on 12/04/14.
//  Copyright (c) 2014 MakeGamesWithUs inc. Free to use for all purposes.
//

#import "GameEnd.h"

@implementation GameEnd {
  CCLabelTTF *_messageLabel;
  CCLabelTTF *_scoreLabel;
}

- (void)newGame {
  CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector]replaceScene:mainScene];
}

- (void)setMessage:(NSString *)message score:(NSInteger)score {
  _messageLabel.string = message;
  _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
}

@end
