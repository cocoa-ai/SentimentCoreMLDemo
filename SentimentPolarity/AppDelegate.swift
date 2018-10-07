import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private lazy var controller: UIViewController = ViewController()
  private lazy var navigationController: UINavigationController = .init(rootViewController: self.controller)

  // MARK: - Application lifecycle

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}
