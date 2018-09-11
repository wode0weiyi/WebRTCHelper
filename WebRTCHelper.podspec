Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.name         = "WebRTCHelper"
s.version      = "1.0.0"
s.summary      = "WebRTCHelper."
s.description  = <<-DESC
this is WebRTCHelper
DESC
s.homepage     = "https://github.com/wode0weiyi/WebRTCHelper"
s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
s.author             = { "huzhihui" => "wonderfulhzh@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/wode0weiyi/WebRTCHelper.git", :tag => s.version.to_s }
s.source_files  = "WebRTCHelper/*.{h,m}"
s.requires_arc = true
end
