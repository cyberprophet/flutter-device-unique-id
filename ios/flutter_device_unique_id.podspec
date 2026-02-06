#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_device_unique_id.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_device_unique_id'
  s.version          = '1.0.3'
  s.summary          = 'plugin for getting the Unique ID.'
  s.description      = <<-DESC
the flutter plugin for getting the Unique ID.
DESC
  s.homepage         = 'https://github.com/Share-Invest'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'ShareInvest Corp.' => 'prophet0915@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'KeychainAccess'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end