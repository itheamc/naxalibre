#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint naxalibre.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'naxalibre'
  s.version          = '0.0.2'
  s.summary          = 'This is Naxalibre, a custom MapLibre plugin proudly developed by @itheamc, to enhance mapping capabilities and streamline geospatial workflows.'
  s.description      = <<-DESC
This is Naxalibre, a custom MapLibre plugin proudly developed by @itheamc, to enhance mapping capabilities and streamline geospatial workflows.
                       DESC
  s.homepage         = 'https://github.com/itheamc/naxalibre'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Amit Chaudhary' => 'itheamc@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MapLibre', '6.11.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'naxalibre_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
