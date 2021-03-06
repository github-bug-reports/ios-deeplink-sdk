#import "Specta.h"
#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"

NSURL *URLWithPath(NSString *path) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"dpl://dpl.com%@", path]];
}

SpecBegin(DPLRouteMatcher)

describe(@"Matching Routes", ^{
    
    it(@"returns a deep link when a URL matches a route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"returns a deep link when a URL matches a parameterized route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when the URL and route dont match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });

    it(@"does NOT return a deep link when the URL and parameterized route dont match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when the URL path does not match the route path", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/ride/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters).to.equal(@{ @"id": @"abc123", @"time": @"1418931000" });
    });
});

SpecEnd
