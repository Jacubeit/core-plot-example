class BarGraphController < CPTGraphHostingView
  attr_accessor :selectedTheme, :dataForPlot, :dummyDataHighestValue

  def setupGraph
    self.configureHost
    self.configureGraph
    self
  end

  def configureHost
    self.allowPinchScaling = false
      a = Array.new
      (0..23).each_with_index do |c, i|
        hs = { x: (i), y: rand(20000) }
        a << hs
      end
      self.dataForPlot = a
      max = self.dataForPlot.map{|x| x[:y]}.max
      self.dummyDataHighestValue = max
  end
   
  def configureGraph    
    self.hostedGraph = CPTXYGraph.alloc.initWithFrame(self.frame)
    self.selectedTheme = CPTTheme.themeNamed(KCPTPlainWhiteTheme)    
    self.hostedGraph.applyTheme(self.selectedTheme)

    self.hostedGraph.paddingLeft   = 0.0
    self.hostedGraph.paddingTop    = 0.0
    self.hostedGraph.paddingRight  = 0.0
    self.hostedGraph.paddingBottom = 0.0

    self.hostedGraph.plotAreaFrame.paddingRight = 0.0
    self.hostedGraph.plotAreaFrame.paddingLeft = 0.0
    self.hostedGraph.plotAreaFrame.paddingBottom = 20.0

    self.hostedGraph.plotAreaFrame.masksToBorder = true

    plot = CPTBarPlot.alloc.initWithFrame self.frame
    plot.dataSource = self
    plot.delegate = self

    plot.barCornerRadius = 5.0
    borderLineStyle = CPTMutableLineStyle.lineStyle
    borderLineStyle.lineColor = CPTColor.clearColor
    plot.lineStyle = nil
    plot.identifier = "com.barplot-example"
    plot.labelRotation =  Math::PI/2
    self.hostedGraph.addPlot(plot)


    ### Dummy Plot for workaround
    dummyPlot = CPTBarPlot.alloc.init
    dummyPlot.dataSource = self
    dummyPlot.delegate = self
    dummyPlot.identifier = "dummyPlot"

    axisSet = self.hostedGraph.axisSet
    x       = axisSet.xAxis
    y       = axisSet.yAxis

    [x,y].each do |z|
      z.labelingPolicy  = CPTAxisLabelingPolicyNone
      z.axisLineStyle   = nil
    end

    ## usually its not DRY to initialize each lable seperately but to play around...
    label_1 = CPTAxisLabel.alloc.initWithText("foo", textStyle: x.labelTextStyle)
    label_1.tickLocation = CPTDecimalFromFloat(0.0)
    label_1.offset = 5.0

    label_2 = CPTAxisLabel.alloc.initWithText("bar", textStyle: x.labelTextStyle)
    label_2.tickLocation = NSDecimalNumber.decimalNumberWithString("10").decimalValue
    label_2.offset = 5.0

    ## Does not work ???? Why???
    # label_3 = CPTAxisLabel.alloc.initWithText("foobar", textStyle: x.labelTextStyle)
    # label_3.tickLocation = NSDecimalNumber.decimalNumberWithString("15").decimalValue
    # label_3.offset = 5.0

    x.axisLabels = NSSet.setWithArray([label_1, label_2])

    plotSpace = self.hostedGraph.defaultPlotSpace
    plotSpace.scaleToFitPlots [dummyPlot]

    ## This does not work ... seems that 'lenght' is the problem
    # plotRange = CPTPlotRange.plotRangeWithLocation(CPTDecimalFromFloat(0.1), length:CPTDecimalFromFloat(3.0))
    # plotSpace.xRange =  plotRange

    plotSpace.allowsUserInteraction = true
    true
  end

  def numberForPlot plot, field: fieldEnum, recordIndex: index 
    if fieldEnum == CPTBarPlotFieldBarLocation
      key = :x
    elsif fieldEnum == CPTBarPlotFieldBarTip
      key = :y
    end
    num = self.dataForPlot[index][key]

    # Hack for failing plot range length
    if plot.identifier == "dummyPlot" 
      if num == self.dummyDataHighestValue
        spacing_percent = (num/100)*20
        num = num + spacing_percent  
      elsif key == :x
        if index == self.dataForPlot.count-1
          num = num + 1
        elsif index == 0
          num = num - 1
        end
      end
    end
    num
  end

  def numberOfRecordsForPlot plot
    self.dataForPlot.count
  end

  def dataLabelForPlot plot, recordIndex: index
    number = self.dataForPlot[index][:y]
    label = CPTTextLayer.alloc.initWithText(NSString.stringWithString(number.to_s))
    label
  end
end