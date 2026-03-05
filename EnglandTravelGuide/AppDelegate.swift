
import SwiftUI
import FirebaseCore
import FirebaseInstallations
import FirebaseRemoteConfigInternal
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    weak var initialVC: ViewController?
    static var orientationLock = UIInterfaceOrientationMask.all
    private var remoteConfig: RemoteConfig?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfig()
        
        let viewController = ViewController()
        initialVC = viewController
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        start(viewController: viewController)

        return true
    }
    
    func requestApp() {
       if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
           SKStoreReviewController.requestReview(in: scene)
       }
   }

    func setupRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    
    func start(viewController: ViewController) {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "alwaysOpenApp") == true {
            DispatchQueue.main.async {
                viewController.yegfeyw()
            }
            return
        }
        
        remoteConfig?.fetch { [weak self] status, error in
            guard let self = self else { return }
            
            if let _ = error {
                defaults.set(true, forKey: "alwaysOpenApp")
                DispatchQueue.main.async {
                    viewController.yegfeyw()
                }
                return
            }
            
            if status == .success {
                self.remoteConfig?.activate { _, error in
                    DispatchQueue.main.async {
                        
                        if error != nil {
                            defaults.set(true, forKey: "alwaysOpenApp")
                            viewController.yegfeyw()
                            return
                        }
                        
                        guard let stringFire = self.remoteConfig?.configValue(forKey: "england").stringValue,
                              !stringFire.isEmpty else {
                            defaults.set(true, forKey: "alwaysOpenApp")
                            viewController.yegfeyw()
                            return
                        }
                        
                        if let finalURL = defaults.string(forKey: "value") {
                            viewController.fksdjhsdf(tewytr: finalURL)
                            return
                        }
                        
                        let stringURL = viewController.uygsdfysd(vzcxghvxz: stringFire)
                        
                        guard let url = URL(string: stringURL) else {
                            defaults.set(true, forKey: "alwaysOpenApp")
                            viewController.yegfeyw()
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(url) {
                            viewController.fksdjhsdf(tewytr: stringURL)
                        } else {
                            defaults.set(true, forKey: "alwaysOpenApp")
                            viewController.yegfeyw()
                        }
                    }
                }
                
            } else {
                defaults.set(true, forKey: "alwaysOpenApp")
                DispatchQueue.main.async {
                    viewController.yegfeyw()
                }
            }
        }
    }
}

