//
//  LeftViewController.h
//  twendy
//
//  Created by Macadamian on 1/27/15.
//  Copyright (c) 2015 Larribeau. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id delegate;
@end
