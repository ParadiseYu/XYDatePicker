
Pod::Spec.new do |s|

  s.name         = "XYDatePicker"

  s.version      = "0.0.1"

  s.summary      = "A short description of XYDatePicker."

  s.homepage     = "http://EXAMPLE/XYDatePicker"

  s.license      = "MIT"

  s.author       = { "ParadiseYu" => "wxy1990926@126.com" }

  s.source       = { :git => "https://github.com/ParadiseYu/XYDatePicker.git", :commit => "cb5e7e82b005139d76f443af4b8e995e38c1934a" }

  s.source_files  = "XYDatePicker/*.{h,m}"

  s.resources = "XYDatePicker/*.xib", "XYDatePicker/**/*.xib", "XYDatePicker/Assets.xcassets"

  s.requires_arc = true

  s.dependency "YYKit", "~> 1.0.9"

  s.platform = :ios

end
