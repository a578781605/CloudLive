Pod::Spec.new do |s|
  s.name         = "CloudLiveSDK"
  s.version      = "1.2.2"
  s.summary      = "A library for collection device info."
  s.homepage     = "https://github.com/a578781605/CloudLive"
  s.license      = "MIT"
  s.author             = { "moRuiQuan" => "578781605@qq.com" }
  s.source       = { :git =>    "https://github.com/a578781605/CloudLive.git", :tag => "#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = "7.0"
  s.source_files  = "CloudLiveSDK/*.{h,m}"
end