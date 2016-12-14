Pod::Spec.new do |s|
  s.name          = "HandLayout"
  s.version       = "0.1.0"
  s.summary       = "Auto Layout? Auto Schmayout."
  s.homepage      = "https://github.com/mxcl/HandLayout"
  s.license       = "Public Domain"
  s.author        = { "Max Howell" => "mxcl@me.com" }
  s.platform      = :ios
  s.source        = { :git => "#{s.homepage}", :tag => "#{s.version}" }
  s.source_files  = "*.swift"
  s.exclude_files = "Classes/Exclude"
  s.framework     = "UIKit"
  s.requires_arc = true
end
