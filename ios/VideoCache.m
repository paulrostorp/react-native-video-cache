#import "VideoCache.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@implementation VideoCache

RCT_EXPORT_MODULE()

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(convert:(NSString *)url)
{
    if (!KTVHTTPCache.proxyIsRunning) {
      NSError *error;
      [KTVHTTPCache proxyStart:&error];
      if (error) {
        return url;
      }
    }
    return [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:url]].absoluteString;
}

RCT_EXPORT_METHOD(convertAsync:(NSString *)url
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  if (!KTVHTTPCache.proxyIsRunning) {
    NSError *error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
      reject(@"init.error", @"failed to start proxy server", error);
      return;
    }
  }
  resolve([KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:url]].absoluteString);
}


RCT_EXPORT_METHOD(setIgnoreUrlParams:(BOOL)shouldIgnore
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  if (!KTVHTTPCache.proxyIsRunning) {
    NSError *error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
      reject(@"init.error", @"failed to start proxy server", error);
      return;
    }
  }

  if (shouldIgnore) {
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
        urlComponents.query = nil;
        NSURL *url = urlComponents.URL;
        return url;
    }];
  }

  resolve(@"success");
}

@end
