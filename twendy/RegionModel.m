//
//  RegionModel.m
//  twendy
//
//  Created by Macadamian on 1/22/15.
//  Copyright (c) 2015 Larribeau. All rights reserved.
//

#import "RegionModel.h"
#import "TwitterFetch.h"
#import "OAuthConsumer.h"
#import "Notifications.h"


@implementation RegionModel
static BOOL initialized = NO;
static BOOL isSearching = NO;

static NSMutableArray* regionDB;
static NSMutableArray* regionDBSearch;


+(void)initialize
{
  if(!initialized)
  {
    initialized = YES;
    regionDB = [[NSMutableArray alloc] init ];
    regionDBSearch = [[NSMutableArray alloc] init ];

  }
}

-(id)init
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:LoginSucceed object:nil];
  return self;
}


- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(NSMutableArray*)getDBBasedOnSearchMode:(BOOL)search
{
  if (search == NO) {
    return regionDB;
  } else {
    return regionDBSearch;
  }
}
+(NSInteger)count
{
  return [self getDBBasedOnSearchMode:isSearching].count;
}

+(Region*)get:(NSUInteger)index
{
  NSMutableArray* currentDB = [self getDBBasedOnSearchMode:isSearching];
  
  if (index >= currentDB.count || currentDB.count ==0) {
    return nil;
  } else {
    return currentDB[index];
  }
}
+(void)reset
{
  //Clear out DB
  regionDB = [[NSMutableArray alloc] init ];
  regionDBSearch = [[NSMutableArray alloc] init ];
}

-(void)reload:(NSNotification *)notification
{
  if (regionDB.count == 0) {
    [TwitterFetch fetch:self url:@"https://api.twitter.com/1.1/trends/available.json" didFinishSelector:@selector(didReceiveRegion:data:) didFailSelector:@selector(didNotReceiveUserData:error:)];

  }
}

- (void)didNotReceiveUserData:(OAServiceTicket*)ticket error:(NSError*)error {
  NSLog(@"Failed User Data Fetch %@", error);
}

- (void)didReceiveRegion:(OAServiceTicket*)ticket data:(NSData*)data {
  //NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  //NSLog(@"didReceiveRegion%@", httpBody);
  id tmp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"configRegion"] mutableCopy];
  NSMutableDictionary* configRegionDict;
  if (tmp == nil) {
    configRegionDict = [[NSMutableDictionary alloc]init];
  }else {
    configRegionDict = tmp;
  }
  
  NSArray *twitterRegions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers       error:nil];
  
  for (NSDictionary *region in twitterRegions) {
    Region *regionObj = [[Region alloc] init];
    
    regionObj.city = [region objectForKey:@"name"];
    regionObj.country = [region objectForKey:@"country"];
    regionObj.woeid = [[region objectForKey:@"woeid"] intValue];
    
    NSInteger woeid = [[configRegionDict objectForKey:regionObj.city] intValue];
    
    if (woeid == regionObj.woeid) {
      regionObj.selected = YES;
    }
    
    [regionDB addObject:regionObj];
  }
  
  //Sort
  [RegionModel sortCountryDescend];
  
}

+(void)startSearch:(NSString*)searchString
{
  NSLog(@"searchString = %@", searchString);
  isSearching = YES;
  [self resetSearch];
  NSMutableArray *toRemove = [[NSMutableArray alloc] init];

  for (Region *region in regionDBSearch)
  {
    if ([region.city rangeOfString:searchString
                           options:NSCaseInsensitiveSearch].location == NSNotFound) {
      if ([region.country rangeOfString:searchString
                             options:NSCaseInsensitiveSearch].location == NSNotFound) {

      [toRemove addObject:region];
      }
    }
      
  }
  [regionDBSearch removeObjectsInArray:toRemove];
}

+(void)resetSearch
{
  //Shallow copy
  regionDBSearch = [[NSMutableArray alloc] initWithArray:regionDB];
  //Deep copy
  //regionDBSearch = [[NSMutableArray alloc] initWithArray:regionDB copyItems:YES] ;
}
+(void)endSearch
{
  isSearching = NO;
}
+(void)sortCountryAscend
{
  [RegionModel sort:@"country" ascending:YES];
}
+(void)sortCountryDescend
{
  [RegionModel sort:@"country" ascending:NO];
}

+(void)sortCityAscend
{
  [RegionModel sort:@"city" ascending:YES];
}
+(void)sortCityDescend
{
  [RegionModel sort:@"city" ascending:NO];
}

+(void)sortSelectedAscend
{
  //UI more intuitive if this is reversed
  [RegionModel sort:@"selected" ascending:NO];
}
+(void)sortSelectedDescend
{
  //UI more intuitive if this is reversed
  [RegionModel sort:@"selected" ascending:YES];
}

+(void)sort:(NSString*)key ascending:(BOOL)ascending
{
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                               ascending:ascending];
  
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  [regionDB sortUsingDescriptors:sortDescriptors];
}

@end
