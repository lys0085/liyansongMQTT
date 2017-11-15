

Pod::Spec.new do |s|

  s.name         = "liyansongMQTT"
  s.version      = "1.0.1"
  s.summary      = "mqtt管理类"
  s.description  = <<-DESC
                   "mqtt管理"
                    DESC
  s.homepage     = "https://github.com/lys0085/liyansongMQTT"
  s.framework = "UIKit","CocoaMQTT"
  s.license      = "MIT"
  s.author             = { "李严松" => "lxs0085@sina.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/lys0085/liyansongMQTT.git", :tag => v#{s.version} }
  s.source_files  = "MQTTManager.swift"
  s.requires_arc = true

end
