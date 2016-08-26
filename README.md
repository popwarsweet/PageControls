# PageControls

[![CI Status](http://img.shields.io/travis/popwarsweet/PageControls.svg?style=flat)](https://travis-ci.org/popwarsweet/PageControls)
[![Version](https://img.shields.io/cocoapods/v/PageControls.svg?style=flat)](http://cocoapods.org/pods/PageControls)
[![License](https://img.shields.io/cocoapods/l/PageControls.svg?style=flat)](http://cocoapods.org/pods/PageControls)
[![Platform](https://img.shields.io/cocoapods/p/PageControls.svg?style=flat)](http://cocoapods.org/pods/PageControls)

This is a selection of custom page controls to replace UIPageControl, inspired by a dribbble found [here]( https://dribbble.com/shots/2578447-Page-Control-Indicator-Transitions-Collection). The appearance (color, size, # of pages) of each control can be customized using Interface Builder.

## Demo
<img src="https://github.com/popwarsweet/PageControls/blob/master/demo.gif" width="600">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

**__NOTE:__** __IBDesignable is currently not rendering when using cocoapods (version 1.0.1).__ [Open Issue](https://github.com/CocoaPods/CocoaPods/issues/5334)

PageControls is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PageControls"
```

## Installation (individual controls)

Each page control can be installed individually using cocoapods subspecs with one of the following lines:

```ruby
pod "PageControls/SnakePageControl"
pod "PageControls/FilledPageControl"
pod "PageControls/PillPageControl"
pod "PageControls/ScrollingPageControl"
```

## Manual Installation

Each page control file is standalone and can be installed individually by copy/pasting the respective file into your project.

## Author

Kyle Zaragoza, popwarsweet@gmail.com
Twitter: [@KyleZaragoza](https://twitter.com/kylezaragoza)

## License

PageControls is available under the MIT license. See the LICENSE file for more info.
