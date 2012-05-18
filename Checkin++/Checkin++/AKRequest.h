//
//  AKRequest.h
//  Checkin++
//
//  Created by Albert Sun on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKRequestDelegate;

enum {
  kAKRequestStateReady,
  kAKRequestStateLoading,
  kAKRequestStateComplete,
  kAKRequestStateError
};
typedef NSUInteger AKRequestState;

/**
 * Do not use this interface directly, instead, use method in Facebook.h
 */
@interface AKRequest : NSObject {
  id<AKRequestDelegate> _delegate;
  NSString*             _url;
  NSString*             _httpMethod;
  NSMutableDictionary*  _params;
  NSURLConnection*      _connection;
  NSMutableData*        _responseText;
  AKRequestState        _state;
  NSError*              _error;
  BOOL                  _sessionDidExpire;
}


@property(nonatomic,assign) id<AKRequestDelegate> delegate;

/**
 * The URL which will be contacted to execute the request.
 */
@property(nonatomic,copy) NSString* url;

/**
 * The API method which will be called.
 */
@property(nonatomic,copy) NSString* httpMethod;

/**
 * The dictionary of parameters to pass to the method.
 *
 * These values in the dictionary will be converted to strings using the
 * standard Objective-C object-to-string conversion facilities.
 */
@property(nonatomic,retain) NSMutableDictionary* params;
@property(nonatomic,retain) NSURLConnection*  connection;
@property(nonatomic,retain) NSMutableData* responseText;
@property(nonatomic,readonly) AKRequestState state;
@property(nonatomic,readonly) BOOL sessionDidExpire;

/**
 * Error returned by the server in case of request's failure (or nil otherwise).
 */
@property(nonatomic,retain) NSError* error;


+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;

+ (NSString*)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;

+ (AKRequest*)getRequestWithParams:(NSMutableDictionary *) params
                        httpMethod:(NSString *) httpMethod
                          delegate:(id<AKRequestDelegate>)delegate
                        requestURL:(NSString *) url;
- (BOOL)loading;

- (void)connect;

@end


@protocol AKRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(AKRequest *)request;

/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(AKRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(AKRequest *)request didFailWithError:(NSError *)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(AKRequest *)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */
- (void)request:(AKRequest *)request didLoadRawResponse:(NSData *)data;

@end
