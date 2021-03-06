//
//  AuthenticationData.m
//  twendy
//
//  Created by Scott Larribeau on 1/21/15.
//  Copyright (c) 2015 Larribeau. All rights reserved.
//

#import "AuthenticationModel.h"

@implementation AuthenticationModel

//static const NSString *client_id = @"2sVEcZDhudTeScaMShpd3w"; //codegerms
//static const NSString *secret = @"CVqonV4B8wDxSnwzzXCC2uhak8H22R1gXhbsCSF1400"; //codegerms


static const NSString *client_id = @"3gVLXgS5yRw9L1LwuO49mT2UN"; //slarribeau
static const NSString *secret = @"cEsD1MLgWwgnkddxjyN41DkYiaaGS8Dt6jITfeb8UrW4L85MfU"; //slarribeau
static const NSString *callback = @"http://nowandzen.com/callback";


static BOOL isLoggedInBOOL = NO;
static BOOL initialized = NO;
static OAToken* accessToken = nil;
static OAToken* requestToken = nil;
static OAConsumer* consumer = nil;

+(void)initialize
{
  if(!initialized)
  {
    initialized = YES;
    //isLoggedInBOOL = NO;
    consumer = [[OAConsumer alloc] initWithKey:client_id secret:secret realm:nil];
  }
}




+(BOOL) isLoggedIn
{
  return isLoggedInBOOL;
}

+(void) setIsLoggedIn:(BOOL)status
{
  isLoggedInBOOL = status;
  if (status == NO) {
    accessToken = nil;
    requestToken = nil;
  }
}

+(OAToken*) getAccessToken
{
  return accessToken;
}

+(void) setAccessToken:(OAToken*)token
{
  accessToken = token;
}

+(OAToken*) getRequestToken
{
  return requestToken;
}

+(void) setRequestToken:(OAToken*)token
{
  requestToken = token;
}

+(OAConsumer *) getConsumer
{
  return consumer;
}

+(const NSString *) getCallback
{
  return callback;
}

@end
