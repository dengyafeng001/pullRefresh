
Pod::Spec.new do |s|
  s.name         = "pullRefresh"
  s.version      = "1.0.7"
  s.summary      = "扩展UITableView使其具体下拉刷新和上拉获取更多的功能"
  s.description  = "扩展UITableView使其具体下拉刷新和上拉获取更多的功能,仅需几行代码就能实现TableView的下拉刷新和上拉获取更多"
  s.homepage     = "https://github.com/dengyafeng001/pullRefresh"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "MIT", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "dengyafeng001 group" => "https://github.com/dengyafeng001" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "7.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/dengyafeng001/pullRefresh.git", :tag => "1.0.7" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "RefreshControl/*.{h,m}"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
