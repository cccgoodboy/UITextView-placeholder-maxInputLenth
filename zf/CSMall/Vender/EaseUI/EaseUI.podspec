Pod::Spec.new do |spec|
  spec.name         = 'EaseUI'
  spec.version      = '3.3.1'
  spec.license       = { :type => 'Copyright', :text => 'EaseMob Inc. 2017' }
  spec.summary      = 'EaseMob UI Kit'
  spec.homepage     = 'https://github.com/easemob/easeui-ios-hyphenate-cocoapods'
  spec.author       = {'EaseMob Inc.' => 'admin@easemob.com'}
  spec.source       =  {:path => './' }
  spec.source_files = '**/*.{h,m,mm}'
  spec.platform     = :ios, '7.0'
  spec.vendored_libraries = ['EMUIKit/3rdparty/DeviceHelper/VoiceConvert/opencore-amrnb/libopencore-amrnb.a','EMUIKit/3rdparty/DeviceHelper/VoiceConvert/opencore-amrwb/libopencore-amrwb.a']
  spec.requires_arc = true
  spec.frameworks = 'Foundation', 'UIKit'
  spec.libraries    = 'stdc++'
  spec.resource     = 'resources/EaseUIResource.bundle'
  spec.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}
  spec.dependency 'MWPhotoBrowser', '~> 2.1.1'		
  spec.dependency 'MJRefresh', '~> 3.1.0'
  spec.dependency 'Hyphenate', '~> 3.3.0'
end
