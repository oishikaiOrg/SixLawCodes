# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'SixLawCodes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SixLawCodes
  pod "SwiftyXMLParser", :git => 'https://github.com/yahoojapan/SwiftyXMLParser.git'
  pod 'ReachabilitySwift'
  pod 'SVProgressHUD', :git => 'https://github.com/mmdock/SVProgressHUD.git', :branch => 'patch-1'

  post_install do |installer|
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-SixLawCodes/Pods-SixLawCodes-acknowledgements.plist', 'SixLawCodes/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  end

end
