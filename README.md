# ViewSwitcher for RubyMotion

View Switch bar just like first Google+ iOS app or mixi iOS app

## Installation

Add in Gemfile:

```
gem 'view_switcher', :git => 'https://github.com/n-studio/ViewSwitcher.git'
```

Add in Rakefile:

```
require 'bubble-wrap'
require 'view_switcher'
```

## Usage

![ViewSwitcher screenshot][1]

```ruby
  def viewDidLoad
    super
    applicationFrame = UIScreen.mainScreen.applicationFrame
    self.view = UIView.alloc.initWithFrame [[0, 0], [applicationFrame.size.width, applicationFrame.size.height]]
    self.view.backgroundColor = UIColor.whiteColor
    
    # init SwitchView
    @switchView = BSSwitchView.alloc.initWithFrame [[0, 0], [Device.screen.width_for_orientation(:portrait), 30]]
    @switchView.backgroundColor = UIColor.redColor
    @switchView.delegate = self
    self.view.addSubview @switchView
    
    # init WrapperScrollView
    @horizontalScrollView = BSSwitchWrapperView.alloc.initWithFrame [[0, @switchView.frame.size.height], [Device.screen.width_for_orientation(:portrait), applicationFrame.size.height - @switchView.frame.size.height]]
    @horizontalScrollView.bounces = true
    self.view.addSubview @horizontalScrollView
    @switchView.wrapperView = @horizontalScrollView
    
    # init tableViews
    @tableView1 = UITableView.alloc.init
    @tableView1.dataSource = self
    @tableView1.delegate = self
    
    @tableView2 = UITableView.alloc.init
    @tableView2.dataSource = self
    @tableView2.delegate = self
    
    @tableView3 = UITableView.alloc.init
    @tableView3.dataSource = self
    @tableView3.delegate = self
    
    @switchView.views = [
      {name: "view1", title: "View1", view: @tableView1},
      {name: "view2", title: "View2", view: @tableView2},
      {name: "view3", title: "View3", view: @tableView3}
    ]
    
  end
  
  def viewWillAppear(animated)
    super
    @switchView.setSelectedIndex(0, animated: false)
  end
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    ...
  end
```

  [1]: https://github.com/n-studio/ViewSwitcher/raw/master/Screenshot.png
