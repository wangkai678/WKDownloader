#
# Be sure to run `pod lib lint WKDownloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WKDownloader'
  s.version          = '0.0.3'
  s.summary          = 'WKDownloader.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WKDownloader.一个下载工具
                       DESC

  s.homepage         = 'https://github.com/wangkai678/WKDownloader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangkai' => 'wangkai_678@163.com' }
  s.source           = { :git => 'https://github.com/wangkai678/WKDownloader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

 s.source_files = 'WKDownloader/Classes/**/*'

#s.subspec 'Dog' do |b|
#       b.source_files = 'WKDownloader/Classes/Dog/*'
        # b.dependency 'AFNetworking', '~> 2.3'

#   end
#   s.subspec 'Person' do |p|
#       p.source_files = 'WKDownloader/Classes/Person/*'
#   end

  # s.resource_bundles = {
  #   'WKDownloader' => ['WKDownloader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
