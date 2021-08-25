import UIKit

/// Defines the global appearance for the application.
struct Appearance {
    /// Sets the global appearance for the application.
    /// Call this method early in the applicaiton's setup, i.e. in `applicationDidFinishLaunching:`
    static func setup() {
        UIButton.appearance().tintColor = R.color.ickyGreen()
        UISearchBar.appearance().tintColor = R.color.ickyGreen()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: R.color.warmGrey() ?? UIColor.black, NSAttributedString.Key.font: UIFont.p1LeftBold]

//        UINavigationBar.appearance().barTintColor = .red
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
