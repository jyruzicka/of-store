Pod::Spec.new do |s|
  s.name             = "JROFBridge"
  s.version          = "0.0.1"
  s.summary          = "Bridge your program and OmniFocus."
  s.description      = <<-DESC
                       JROFBridge acts as a bridge between OmniFocus and your Cocoa application. Version differences, possibly-not-running apps, differences between AppStore and refular apps, missing values, and all other problems are taken care of. All you need to do is include the library and start using it in your app! 
                       DESC
  s.homepage         = "http://1klb.com/projects/JROFBridge"
  s.license          = { type: 'MIT', file: "LICENSE" }
  s.author           = { "Jan-Yves Ruzicka" => "jan@1klb.com" }
  s.source           = { :git => "https://github.com/jyruzicka/JROFBridge.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/akchizar'

  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'Classes'

  s.dependency "FMDB", "~> 2.1"
end
