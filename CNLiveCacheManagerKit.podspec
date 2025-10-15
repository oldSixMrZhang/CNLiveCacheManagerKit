#
# Be sure to run `pod lib lint CNLiveCacheKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CNLiveCacheManagerKit'
  s.version          = '0.1.7'
  s.summary          = 'CNLiveCacheManagerKit-中投视讯缓存框架'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://bj.gitlab.cnlive.com/ios-team/CNLiveCacheManagerKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'woshiliushiyu' => '1010530278@qq.com' }
  s.source           = { :git => 'http://bj.gitlab.cnlive.com/ios-team/CNLiveCacheManagerKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CNLiveCacheManagerKit/Classes/**/*'

  # s.resource_bundles = {
  #   'CNLiveCacheKit' => ['CNLiveCacheKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CNLiveUserManagement'
end
