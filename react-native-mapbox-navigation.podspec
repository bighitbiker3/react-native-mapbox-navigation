# frozen_string_literal: true

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'react-native-mapbox-navigation'
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = <<-DESC
                  Smart Mapbox turn-by-turn routing based on real-time traffic for React Native.
  DESC
  s.homepage = 'https://github.com/emin93/react-native-mapbox-navigation'
  s.license = { type: 'Apache-2.0', file: 'LICENSE' }
  s.authors      = { 'Emin Khateeb' => 'emin@emin.ch' }
  s.platforms    = { ios: '10.0' }
  s.source       = { git: 'https://github.com/emin93/react-native-mapbox-navigation.git', tag: s.version.to_s }

  s.source_files = 'ios/**/*.{h,m,swift}'
  s.requires_arc = true
  s.dependency 'React'
  s.dependency 'MapboxNavigation', '~> 0.40.0'

  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift-$(SWIFT_VERSION)/$(PLATFORM_NAME) $(inherited)'
  }
end
