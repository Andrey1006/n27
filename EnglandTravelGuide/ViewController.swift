

import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let onbScreen = SplashView()
        let hostContr = UIHostingController(rootView: onbScreen)
        
        addChild(hostContr)
        view.addSubview(hostContr.view)
        hostContr.didMove(toParent: self)
        
        hostContr.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostContr.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostContr.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostContr.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostContr.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func fksdjhsdf(tewytr: String) {
        DispatchQueue.main.async {
            let vc = SecondView(targetUrl: URL(string: tewytr) ?? .applicationDirectory)
            let hostingController = UIHostingController(rootView: vc)
            self.bdhvsbsd(hostingController)
        }
    }

    func uygsdfysd(vzcxghvxz: String) -> (String) {
        return vzcxghvxz
    }
    
    func yegfeyw() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let onboardingScreen = RootView()
            let hostingController = UIHostingController(rootView: onboardingScreen)
            self.bdhvsbsd(hostingController)
        }
    }
    
    func bdhvsbsd(_ viewController: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = viewController
        }
    }
}
