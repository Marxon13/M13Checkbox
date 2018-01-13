Pod::Spec.new do |s|
  s.name         = "M13Checkbox"
  s.version      = "3.2.2"
  s.summary      = "A beautiful, customizable, extendable, animated checkbox for iOS."

  s.description  = <<-DESC
                   Create beautiful, customizable, extendable, animated checkboxes on iOS. Completely configurable through interface builder. See the demo app or playground to play with all the features.
                   DESC

  s.homepage     = "https://github.com/Marxon13/M13Checkbox"
  s.license      = {:type => 'MIT',
                    :text => <<-LICENSE
                    Copyright (c) 2016 Brandon McQuilkin
                    
                    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                    
                    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                    
                    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                    
                    LICENSE
                    }


  s.author             = { "Brandon McQuilkin" => "brandon.mcquilkin@gmail.com" }

  s.platform     = :ios, '8.0'

  s.source = { :git => "https://github.com/Marxon13/M13Checkbox.git", :tag => "#{s.version}"}

  s.source_files  = 'Sources/**/*'

  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'

  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
