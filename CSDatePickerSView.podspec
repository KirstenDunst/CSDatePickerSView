Pod::Spec.new do |s| 
s.name = "CSDatePickerSView"
s.version = '0.0.1'
s.summary = "时间选择器，可以自定义年月日时分秒显示模式，最详细到秒"
s.description = "年月日，年月日时，年月日时分，年月日时分秒，时分秒。多个模式可选。带时间范围选择"
s.homepage = "https://github.com/KirstenDunst/CSDatePickerSView" 
s.license= { :type => "MIT", :file => "LICENSE" }
s.author = { "艾鑫文学社" => "1778223463@163.com" } 
s.platform = :ios, "8.0" 
s.source = { :git => "https://github.com/KirstenDunst/CSDatePickerSView.git", :tag => s.version} 
s.source_files = 'CSDatePickerSView/Code/*/.{h,m}' 
s.requires_arc = true 
s.framework = "UIKit" 
end