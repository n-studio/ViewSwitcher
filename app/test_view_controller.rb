class TestViewController < UITableViewController
  
  include UITableViewDelegateMixin
  include UITableViewDataSourceMixin
  
  CELLID = 'CellIdentifier'
  
  def viewDidLoad
    super
    applicationFrame = UIScreen.mainScreen.applicationFrame
    self.view = UIView.alloc.initWithFrame [[0, 0], [applicationFrame.size.width, applicationFrame.size.height]]
    self.view.backgroundColor = "#ffffff".to_color
    
    # init SwitchView
    @switchView = BSSwitchView.alloc.initWithFrame [[0, 0], [Device.screen.width_for_orientation(:portrait), 30]]
    @switchView.backgroundColor = "#ff3333".to_color
    @switchView.delegate = self
    self.view.addSubview @switchView
    
    # init scrollView
    @horizontalScrollView = BSSwitchWrapperView.alloc.initWithFrame [[0, @switchView.frame.size.height], [Device.screen.width_for_orientation(:portrait), applicationFrame.size.height - @switchView.frame.size.height]]
    @horizontalScrollView.backgroundColor = "#ffff00".to_color
    if UIDevice.currentDevice.systemVersion.floatValue >= 6.0
      @horizontalScrollView.bounces = true
    else
      @horizontalScrollView.bounces = false # bounce behaviour is weird with iOS < 6.0
    end
    self.view.addSubview @horizontalScrollView
    @switchView.wrapperView = @horizontalScrollView
    
    # init tableViews
    @tableView1 = UITableView.alloc.init
    @tableView2 = UITableView.alloc.init
    @tableView3 = UITableView.alloc.init
    
    setupTableView
    
    @switchView.pages = [
      {name: "view1", title: "View1", view: @tableView1},
      {name: "view2", title: "View2", view: @tableView2},
      {name: "view3", title: "View3", view: @tableView3}
    ]
    
    @switchView.labels.each do |label|
      label.backgroundColor = UIColor.clearColor
      label.textAlignment = UITextAlignmentCenter
      label.font = UIFont.boldSystemFontOfSize(14)
      label.textColor = "#666666".to_color
      label.sizeToFit
      label.width += 10
      label.height += 10
    end
    
    @swapButton = begin
      b = UIButton.buttonWithType UIButtonTypeRoundedRect
      b.frame = [[0, 300], [50, 30]]
      b.setTitle("swap", forState: UIControlStateNormal)
      b
    end
    self.view.addSubview @swapButton
    @swapButton.when_tapped do
      @switchView.setSelectedIndex((@switchView.selectedIndex+1) % @switchView.pages.count, animated: true)
    end
    
  end
  
  def setupTableView
    @tableView1.dataSource = self
    @tableView1.delegate = self
    
    @tableView2.dataSource = self
    @tableView2.delegate = self
    
    @tableView3.dataSource = self
    @tableView3.delegate = self
    
    @tableView1.data = [
      [{text: "section1", detailText: "detail1"}, {text: "section1", detailText: "detail2"}],
      [{text: "section2", detailText: "detail1"}, {text: "section2", detailText: "detail2"}, {text: "section2", detailText: "detail3"}]
    ]
    
    @tableView2.data = [
      [{text: "section3", detailText: "detail1"}, {text: "section3", detailText: "detail2"}],
      [{text: "section4", detailText: "detail1"}, {text: "section4", detailText: "detail2"}, {text: "section4", detailText: "detail3"}]
    ]
    
    @tableView3.data = [
      [{text: "section5", detailText: "detail1"}, {text: "section5", detailText: "detail2"}],
      [{text: "section6", detailText: "detail1"}, {text: "section6", detailText: "detail2"}, {text: "section6", detailText: "detail3"}]
    ]
    
    @tableView1.cell do |tableView, indexPath|
      if tableView == @tableView1
        cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
          c = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: CELLID)
          c.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
          c
        end
      
        cell.textLabel.text = tableView.data[indexPath.section][indexPath.row][:text]
        cell.detailTextLabel.text = tableView.data[indexPath.section][indexPath.row][:detailText]
        cell
      elsif tableView == @tableView2
        cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
          c = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: CELLID)
          c.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
          c
        end
      
        cell.textLabel.text = tableView.data[indexPath.section][indexPath.row][:text]
        cell.detailTextLabel.text = tableView.data[indexPath.section][indexPath.row][:detailText]
        cell
      elsif tableView == @tableView3
        cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
          c = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: CELLID)
          c.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
          c
        end
      
        cell.textLabel.text = tableView.data[indexPath.section][indexPath.row][:text]
        cell.detailTextLabel.text = tableView.data[indexPath.section][indexPath.row][:detailText]
        cell
      end
    end
  end
  
  def viewWillAppear(animated)
    super
    @switchView.setSelectedIndex(0, animated: false)
  end
  
  def pageDidChange(index)
    BW.p "Index #{index} did change!"
  end
end