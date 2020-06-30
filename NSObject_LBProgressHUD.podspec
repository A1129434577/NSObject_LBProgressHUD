Pod::Spec.new do |spec|
  spec.name         = "NSObject_LBProgressHUD"
  spec.version      = "1.0.2"
  spec.summary      = "对MBProgressHUD二次封装，使其使用起来更方便。"
  spec.description  = "对MBProgressHUD二次封装，使其使用起来更方便。"
  spec.homepage     = "https://github.com/A1129434577/NSObject_LBProgressHUD"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/NSObject_LBProgressHUD.git', :tag => spec.version.to_s }
  spec.dependency     "MBProgressHUD"
  spec.dependency     "LBCommonComponents/Macros"
  spec.source_files = "NSObject+ProgressHUD/**/*.{h,m}"
  spec.resource     = "NSObject+ProgressHUD/**/*.bundle"
  spec.requires_arc = true
end
#--use-libraries
