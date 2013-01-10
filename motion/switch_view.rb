class BSSwitchView < UIScrollView
  
  attr_accessor :delegate, :pages, :wrapperView, :labels
  
  def initWithFrame(frame)
    super
    self.scrollsToTop = false
    self
  end
  
  def pages=(pages)
    @labels = NSMutableArray.alloc.init
    pages.each_with_index do |page, index|
      @labels[index] = begin
        l = UILabel.alloc.initWithFrame [[0, 0], [50, 20]]
        l.text = "#{page[:title]}"
        l
      end
      self.addSubview @labels[index]
      if @wrapperView
        frame = @wrapperView.frame
        frame.origin = [@wrapperView.frame.size.width*index, 0]
        page[:view].frame = frame
        page[:view].scrollsToTop = false if page[:view].respond_to?(:scrollsToTop=)
        @wrapperView.addSubview page[:view]
      end
    end
    size = CGSizeMake(pages.count * @wrapperView.frame.size.width, @wrapperView.frame.size.height)
    @wrapperView.contentSize = size
    @pages = pages
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
        if index < self.pages.count - 1
          frame = @labels[index + 1].frame
          frame.origin.x = (@wrapperView.frame.size.width - @labels[index + 1].frame.size.width) * 1
          @labels[index + 1].frame = frame
        end
      end
      if !@isDragged && @indexBeforeDrag != index
        self.pages[@indexBeforeDrag].scrollsToTop = false if @indexBeforeDrag && self.pages[@indexBeforeDrag].respond_to?(:scrollsToTop=)
        self.pages[index][:view].scrollsToTop = true if self.pages[index][:view].respond_to?(:scrollsToTop=)
        @delegate.pageDidChange(index) if @delegate.respond_to?(:pageDidChange)
      end
      @selectedIndex = index
      @wrapperView.setContentOffset([index * @wrapperView.frame.size.width, 0], animated: animated)
      return index
    end
  end
  
  def selectedIndex
    @selectedIndex
  end
  
  def visiblePage
    self.pages[@selectedIndex]
  end
  
  def visibleView
    self.pages[@selectedIndex][:view]
  end
  
  def visibleTitle
    self.pages[@selectedIndex][:title]
  end
  
  def wrapperView=(view)
    @wrapperView = view
    @wrapperView.delegate = self
  end
  
  def scrollViewDidScroll(scrollView)
    if scrollView == @wrapperView
      index = ((scrollView.contentOffset.x + 1 + scrollView.frame.size.width/2) / scrollView.contentSize.width * self.pages.count).floor
      
      if (@selectedIndex - index).abs == 1
        @preventPropagation = !@preventPropagation
      end
      
      if index >= 0 && index <= self.pages.count - 1 && (@selectedIndex - index).abs <= 1
        @selectedIndex = index
      end
      
      progress = ((scrollView.contentOffset.x + scrollView.frame.size.width/2) % scrollView.frame.size.width) / scrollView.frame.size.width
      
      if index > 0
        frame = @labels[index - 1].frame
        frame.origin.x = (self.frame.size.width - @labels[index - 1].frame.size.width) * (0.25 - progress*0.5)
        @labels[index - 1].frame = frame
      end
      
      if index >= 0 && index <= self.pages.count - 1
        frame = @labels[index].frame
        frame.origin.x = (self.frame.size.width - @labels[index].frame.size.width) * (0.75 - progress*0.5)
        @labels[index].frame = frame
      end
      
      if index < self.pages.count - 1
        frame = @labels[index + 1].frame
        frame.origin.x = (self.frame.size.width - @labels[index + 1].frame.size.width) * (1.25 - progress*0.5)
        @labels[index + 1].frame = frame
      end
    end
  end
  
  def scrollViewWillBeginDragging(scrollView)
    if scrollView == @wrapperView
      @indexBeforeDrag = @selectedIndex
      @isDragged = true
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
      @isDragged = false
      self.setSelectedIndex(@selectedIndex, animated: true)
    end
  end
  
  def scrollViewWillBeginDecelerating(scrollView)
    if scrollView == @wrapperView
      if @endDragX < @beginDragX && @selectedIndex > 0 && !@preventPropagation
        self.setSelectedIndex(@selectedIndex - 1, animated: true)
      elsif @endDragX > @beginDragX && @selectedIndex < self.pages.count - 1 && !@preventPropagation
        self.setSelectedIndex(@selectedIndex + 1, animated: true)
      else
        self.setSelectedIndex(@selectedIndex, animated: true)
      end
    end
  end
end