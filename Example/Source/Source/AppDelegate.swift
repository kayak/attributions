import UIKit
import Attributions
import Framework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let attributionController = AttributionController()
        guard let carthageFile = Bundle.main.url(forResource: "carthageAttributions", withExtension: "json") else {
            assertionFailure("File not found")
            return false
        }
        guard let customAttributionsFile = Bundle.main.url(forResource: "customAttributions", withExtension: "json") else {
            assertionFailure("File not found")
            return false
        }
        let sections = [
            AttributionSection(file: carthageFile, description: "Carthage"),
            AttributionSection(file: customAttributionsFile, description: "Other")
        ]

        do {
            try attributionController.setAttributions(from: sections)
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
        
        let navController = UINavigationController()
        navController.viewControllers = [attributionController as UIViewController]
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }

}
