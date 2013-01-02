class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = TestViewController.alloc.init
    # @window.rootViewController = RefreshViewController.alloc.init
    # @window.rootViewController = OtherTestViewController.alloc.init
    # @window.rootViewController = SearchbarViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
