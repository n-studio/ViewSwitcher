class BSSwitchWrapperView < UIScrollView
  
  def initWithFrame(frame)
    super
    self.scrollEnabled = true
    self.userInteractionEnabled = true
    self.bounces = false
    self.showsHorizontalScrollIndicator = false
    self
  end
end