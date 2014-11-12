class BSSwitchWrapperView < UIScrollView
  
  def initWithFrame(frame)
    super
    self.scrollEnabled = true
    self.userInteractionEnabled = true
    self.bounces = false
    self.showsHorizontalScrollIndicator = false
    self.scrollsToTop = false
    self.alwaysBounceVertical = false
    self
  end
  
  def setHeight(height)
    for view in self.subviews
      if view.frame.size.height == self.frame.size.height
        frame = view.frame
        frame.size.height = height
        view.frame = frame
      end
    end
    frame = self.frame
    frame.size.height = height
    self.frame = frame
    size = self.contentSize
    size.height = height
    self.contentSize = size
  end
  alias_method :height=, :setHeight
end