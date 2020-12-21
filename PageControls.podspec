#
# Be sure to run `pod lib lint PageControls.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PageControls'
  s.version          = '1.1.1'
  s.summary          = 'A selection of custom PageControls.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a selection of custom page controls to replace UIPageControl, inspired by a dribbble found here: https://dribbble.com/shots/2578447-Page-Control-Indicator-Transitions-Collection
                       DESC

  s.homepage         = 'https://github.com/popwarsweet/PageControls'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kyle Zaragoza' => 'popwarsweet@gmail.com' }
  s.source           = { :git => 'https://github.com/popwarsweet/PageControls.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'PageControls/Classes/**/*'

  s.subspec 'FilledPageControl' do |filledPageControl|
    filledPageControl.source_files = 'PageControls/Classes/FilledPageControl.*'
  end

  s.subspec 'PillPageControl' do |pillPageControl|
    pillPageControl.source_files = 'PageControls/Classes/PillPageControl.*'
  end

  s.subspec 'ScrollingPageControl' do |scrollingPageControl|
    scrollingPageControl.source_files = 'PageControls/Classes/ScrollingPageControl.*'
  end

  s.subspec 'SnakePageControl' do |snakePageControl|
    snakePageControl.source_files = 'PageControls/Classes/SnakePageControl.*'
  end

  # s.resource_bundles = {
  #   'PageControls' => ['PageControls/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
