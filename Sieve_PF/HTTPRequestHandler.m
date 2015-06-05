//
//  HTTPRequestHandler.m
//  Sieve_PF
//
//  Created by Jordan Sieve on 11/27/14.
//  Copyright (c) 2014 Jordan Sieve. All rights reserved.
//

#import "HTTPRequestHandler.h"
#import "SearchViewController.h"
#import "RecipeSingleton.h"

@interface HTTPRequestHandler() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *mainConnection;
@property (nonatomic, strong) NSMutableData *returnMutableData;
@property (nonatomic, copy) void(^completionCallback)(NSArray *dataArray);
@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *formattedSearchTerm;
@property (nonatomic) RecipeSingleton *sharedManager;

@end

@implementation HTTPRequestHandler

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Public HTTP Request Methods

- (void)startWebRequestWithCompletionBlock:(void(^)(NSArray *))completionBlock
{
    // Stored API key
    _apiKey = @"0f380c8113bd1259aa6feb0c5f4e1b0a";
    
    // Open up singleton
    _sharedManager = [RecipeSingleton sharedManager];
    
    // Grab search terms and format them for URL search
    _formattedSearchTerm = [_sharedManager.searchTerms stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.completionCallback = completionBlock;
    NSString *urlAsString = [NSString stringWithFormat:@"http://food2fork.com/api/search?key=%@&q=%@", _apiKey, _formattedSearchTerm];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [mutableRequest setHTTPMethod:@"GET"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.mainConnection = [[NSURLConnection alloc] initWithRequest:mutableRequest delegate:self startImmediately:NO];
    [self.mainConnection start];
}

#pragma mark - NSURLConnection DataDelegate and Delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.completionCallback(nil);
    self.completionCallback = nil;
    
    // Display error if occurs
    NSLog(@"Did fail with error: %@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"Did receive response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.returnMutableData) {
        self.returnMutableData = [[NSMutableData alloc] init];
    }
    [self.returnMutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    id returnData = [NSJSONSerialization JSONObjectWithData:self.returnMutableData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    // Grab correct piece from JSON data
    NSArray *results = [returnData valueForKey:@"recipes"];
    
    if ([results isKindOfClass:[NSArray class]]) {
        self.completionCallback(results);
    }
    else {
        self.completionCallback(nil);
    }
    
    self.completionCallback = nil;
    self.mainConnection = nil;
//    NSLog(@"Connection did finish loading");
}

@end
