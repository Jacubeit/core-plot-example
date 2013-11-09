module TableModule
  def init
    super
    #Fancy Stuff each Table has
    self
  end

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    @graphHeight = 300

  end

  def tableView(tableView, numberOfRowsInSection:section)
    4
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    if indexPath.row == 0
      50
    elsif indexPath.row == 1
      @graphHeight
    elsif indexPath.row == 2 or 3
      (self.view.bounds.size.height - @graphHeight - 50 - 110) / 2
    else
      30
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
     # NSLog "TableView"
     @reuseIdentifier ||= "CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:@reuseIdentifier)
      cell.setAccessoryType(UITableViewCellAccessoryNone)
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if indexPath.row == 1
      cell.contentView.addSubview @graphController
    else
      # NSLog "#{@data}"
      cell.textLabel.text = @data[indexPath.row]
    end
    cell
  end
end