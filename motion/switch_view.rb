class BSSwitchView < UIScrollView
  
  attr_accessor :delegate, :views, :wrapperView
  
  def init
    super
    
    self
  end
  
  def views=(views)
    @labels = NSMutableArray.alloc.init
    views.each_with_index do |view, index|
      @labels[index] = begin
        l = UILabel.alloc.initWithFrame [[0, 0], [50, 20]]
        l.text = "#{view[:title]}"
        l
      end
      self.addSubview @labels[index]
      if @wrapperView
        frame = @wrapperView.frame
        frame.origin = [@wrapperView.frame.size.width*index, 0]
        view[:view].frame = frame
        @wrapperView.addSubview view[:view]
      end
    end
    size = CGSizeMake(views.count * @wrapperView.frame.size.width, @wrapperView.frame.size.height)
    @wrapperView.contentSize = size
    @views = views
  end
  
  def setSelectedIndex(index, animated: animated)
    if @wrapperView
      if animated == false
        @labels.each_with_index do |label, i|
          unless [index - 1, index, index + 1].include?(i)
            frame = @labels[i].frame
            frame.origin.x = - @labels[i].frame.size.width
            @labels[i].frame = frame
          end
        end
        if index > 0
          frame = @labels[index - 1].frame
          frame.origin.x = (@wrapperView.frame.size.width - @labels[index - 1].frame.size.width) * 0
          @labels[index - 1].frame = frame
        end
        frame = @labels[index].frame
        frame.origin.x = (@wrapperView.frame.size.width - @labels[index].frame.size.width) * 0.5
        @labels[index].frame = frame
        if index < self.views.count - 1
          frame = @labels[index + 1].frame
          frame.origin.x = (@wrapperView.frame.size.width - @labels[index + 1].frame.size.width) * 1
          @labels[index + 1].frame = frame
        end
      end
      @wrapperView.setContentOffset([index * @wrapperView.frame.size.width, 0], animated: animated)
      @selectedIndex = index
    end
  end
  
  def selectedIndex
    @selectedIndex
  end
  
  def wrapperView=(view)
    @wrapperView = view
    @wrapperView.delegate = self
  end
  
  def scrollViewDidScroll(scrollView)
    if scrollView == @wrapperView
      index = ((scrollView.contentOffset.x + scrollView.frame.size.width/2) / scrollView.contentSize.width * self.views.count).floor
      
      if (@selectedIndex - index).abs == 1
        @preventPropagation = !@preventPropagation
      end
      
      if index >= 0 && index <= self.views.count - 1 && (@selectedIndex - index).abs <= 1
        @selectedIndex = index
      end
      
      progress = ((scrollView.contentOffset.x + scrollView.frame.size.width/2) % scrollView.frame.size.width) / scrollView.frame.size.width
      
      if index > 0
        frame = @labels[index - 1].frame
        frame.origin.x = (self.frame.size.width - @labels[index - 1].frame.size.width) * (0.25 - progress*0.5)
        @labels[index - 1].frame = frame
      end
      
      if index >= 0 && index <= self.views.count - 1
        frame = @labels[index].frame
        frame.origin.x = (self.frame.size.width - @labels[index].frame.size.width) * (0.75 - progress*0.5)
        @labels[index].frame = frame
      end
      
      if index < self.views.count - 1
        frame = @labels[index + 1].frame
        frame.origin.x = (self.frame.size.width - @labels[index + 1].frame.size.width) * (1.25 - progress*0.5)
        @labels[index + 1].frame = frame
      end
    end
  end
  
  def scrollViewWillBeginDragging(scrollView)
    if scrollView == @wrapperView
      @beginDragX = scrollView.contentOffset.x
      @endDragX = nil
      @preventPropagation = false
    end
  end
  
  def scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    if scrollView == @wrapperView
      @endDragX = scrollView.contentOffset.x
    end
  end
  
  def scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    if scrollView == @wrapperView
      self.setSelectedIndex(@selectedIndex, animated: true)
    end
  end
  
  def scrollViewWillBeginDecelerating(scrollView)
    if scrollView == @wrapperView
      if @endDragX < @beginDragX && @selectedIndex > 0 && !@preventPropagation
        self.setSelectedIndex(@selectedIndex - 1, animated: true)
      elsif @endDragX > @beginDragX && @selectedIndex < self.views.count - 1 && !@preventPropagation
        self.setSelectedIndex(@selectedIndex + 1, animated: true)
      else
        self.setSelectedIndex(@selectedIndex, animated: true)
      end
    end
  end
end