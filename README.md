

All around Unread.app like pull to refresh library.

<img src="http://f.cl.ly/items/2u1f3V190J3Z1t3E3d3T/Screen%20Recording%202015-02-15%20at%2011.27%20%E5%8D%88%E5%BE%8C.gif" alt="Demo gif" width="300" />

---

Swift version of https://github.com/r-plus/AASpringRefresh

## Install
### Carthage
Add `github "newbdez33/JZSpringRefresh"` to your Cartfile.

### Manually

1. Copy `JZSpringRefresh` directory to your project.

## Usage

    import JZSpringRefresh
    ...
    let top = self.scrollView.addSpringRefresh(position: .top) { (v:JZSpringRefresh) in
        print("top")
    }
    top.text = "REFRESH"
    
### Customization
#### Property
You can customize below properties.

    springRefresh.unExpandedColor = UIColor.gray;
    springRefresh.expandedColor = UIColor.black;
    springRefresh.readyColor = UIColor.red;
    springRefresh.text = "REFRESH"; // available for position Top or Bottom.
    springRefresh.borderThickness = 6.0;
    springRefresh.affordanceMargin = 10.0; // to adjust space between scrollView edge and affordanceView.
    springRefresh.offsetMargin = 30.0; // to adjust threshold of offset.
    springRefresh.threshold = 60.0;  // default is width or height of size.
    springRefresh.size = CGSize(width:60.0, height40.0); // to adjust expanded size and each interval space.
    springRefresh.show = false; // dynamic show/hide affordanceView and add/remove KVO observer.

## TODO 
 * Cocoapods support

## LICENSE
MIT License
