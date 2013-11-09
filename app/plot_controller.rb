class PlotController < UITableViewController
  include TableModule
  
  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    self.tableView = UITableView.alloc.initWithFrame(view.bounds, style: UITableViewStylePlain)
    @table = self.tableView
    @table.scrollEnabled = false
    @table.dataSource = self

    @data = Array.new
    @graphController = BarGraphController.alloc.initWithFrame(CGRectMake(0.0, 0.0, self.view.bounds.size.width, 300.0))
    @graphController.setupGraph
    self.tableView.reloadData
    self
  end
end