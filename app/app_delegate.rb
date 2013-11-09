class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @plot_controller = PlotController.alloc.init
    @window.rootViewController = @plot_controller
    @window.makeKeyAndVisible
    true
  end
end