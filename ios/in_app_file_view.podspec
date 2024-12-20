#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_live_class.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'in_app_file_view'
  s.version          = '0.0.1'
  s.summary          = 'A file viewer plugin for Flutter, supporting local files and network links on Android and iOS.'
  s.description      = <<-DESC
A file viewer plugin for Flutter, supporting local files and network links on Android and iOS.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files      = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
