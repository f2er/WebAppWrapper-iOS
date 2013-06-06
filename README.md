# WebAppWrapper-iOS

An web app wrapper for iOS.

## 10 Minutes To Create Your Own App

### Clone This Repo

```
$ git clone git@github.com:AlexRezit/WebAppWrapper-iOS.git
$ open WebAppWrapper-iOS/WebAppWrapper.xcodeproj
```

### Configure Links & Other Settings

Most of the configurations you need to make is in `RootViewController.m` file.

You can change the constants directly:

```
NSString * const kWebAppStartLink = @"http://yourwebapp.com/";
NSString * const kWebAppHost = @"yourwebapp.com";
```

Or you can leave them untouched and change it in the `-configure:` method.

```
- (void)configure
{
    // Init start URL.
    
    self.startURL = [NSURL URLWithString:kWebAppStartLink];
    
    // Set web app host.
    
    self.webAppHost = kWebAppHost;
    
    // Set other internal hosts.
    
    self.otherInternalHosts = @[
                                @"about:blank",
                                @"googleads.g.doubleclick.net",
                                @"metric.gstatic.com"
                                ];
    
    // Set blocked hosts.
    
    self.blockedHosts = @[
                          ];
    
    // Set max fail refresh count.
    
    self.maxFailRefreshCount = kWebAppMaxFailRefreshCount;
    [self resetFailRefreshCount];
}
```

Here are some concepts you might want to know more about.

* Start URL - It is the first web page you want to see when you launch the app.
* Web App Host - The host of your web app. Most your web pages should be under this domain.
* Other Internal Hosts - Some other hosts you want to permit request to. For example, Google Analytics and Google AdSense. So we won't open them in an in-app browser.
* Blocked Hosts - The hosts you don't want the app to have access to. For example, you can add Google AdSense to block ads.
* Max Fail Refresh Count - When the app fails to open a web page, it will automatically retry a few times before alerting user.

### Localization

This project uses `NSLocalizedString()` to manage multi language. You can use `genstrings` command in Terminal to generate a `Localizable.strings` file and translate to the language you want on your own.

### Launch Image (Splash Screen)

You can replace these images:

* Default.png
* Default@2x.png
* Default-568h@2x.png

### Icon

You can drag your icons into `App Icons` in Summary tab of iOS Application Target.

### App Name

And of course don't forget to change the name to your app's name. You can do this by changing the build target name.

## License

This code is distributed under the terms and conditions of the [MIT license](http://opensource.org/licenses/MIT).

## Donate

You can support me in various ways: Cash donation, purchasing items on Amazon Wishlists, or just improve my code and send a pull request.

Via:
* [Alipay](https://me.alipay.com/alexrezit)
* [Amazon Wishlist](http://www.amazon.cn/wishlist/P8YMPIX8QFTN/)
