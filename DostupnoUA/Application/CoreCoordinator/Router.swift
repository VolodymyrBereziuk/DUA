//
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class Router: NSObject, Routable {
  
  private var rootController: NavigationController?
  private var completions: [UIViewController : () -> Void]
  
  init(rootController: NavigationController) {
    self.rootController = rootController
    completions = [:]
  }
  
  func toPresent() -> UIViewController? {
    return rootController
  }
  
  func present(_ module: Presentable?) {
    present(module, animated: true)
  }
  
  func present(_ module: Presentable?, animated: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.present(controller, animated: animated, completion: nil)
  }
  
  func dismissModule() {
    dismissModule(animated: true, completion: nil)
  }
  
  func dismissModule(animated: Bool, completion: (() -> Void)?) {
    rootController?.dismiss(animated: animated, completion: completion)
  }
  
  func push(_ module: Presentable?) {
    push(module, animated: true)
  }
    
  func push(_ module: Presentable?, hideBottomBar: Bool) {
    push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
  }
  
  func push(_ module: Presentable?, animated: Bool) {
    push(module, animated: animated, completion: nil)
  }
  
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
    push(module, animated: animated, hideBottomBar: false, completion: completion)
  }

  func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
    guard
      let controller = module?.toPresent(),
      (controller is NavigationController == false)
      else { assertionFailure("Deprecated push NavigationController."); return }
    
    if let completion = completion {
      completions[controller] = completion
    }
    controller.hidesBottomBarWhenPushed = hideBottomBar
    rootController?.pushViewController(controller, animated: animated)
  }
  
  func popModule() {
    popModule(animated: true)
  }
  
  func popModule(animated: Bool) {
    if let controller = rootController?.popViewController(animated: animated) {
      runCompletion(for: controller)
    }
  }
  
  func setRootModule(_ module: Presentable?) {
    setRootModule(module, hideBar: false)
  }
  
  func setRootModule(_ module: Presentable?, hideBar: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.setViewControllers([controller], animated: false)
    rootController?.isNavigationBarHidden = hideBar
  }
  
  func popToRootModule(animated: Bool) {
    if let controllers = rootController?.popToRootViewController(animated: animated) {
      controllers.forEach { controller in
        runCompletion(for: controller)
      }
    }
  }
  
  private func runCompletion(for controller: UIViewController) {
    guard let completion = completions[controller] else { return }
    completion()
    completions.removeValue(forKey: controller)
  }
}

extension Router {
    
    func topmostPresented() -> UIViewController {
        //It is impossible to get nil from toPresent() in theory
        let viewController = toPresent() ?? UIViewController()
        return topViewController(with: viewController)
    }
    
    private func topViewController(with rootViewController: UIViewController) -> UIViewController {
        if let tabBarController = rootViewController as? UITabBarController, let viewController = tabBarController.selectedViewController {
            return topViewController(with: viewController)
        }
        if let viewController = rootViewController as? UINavigationController, let visibleVC = viewController.visibleViewController {
            return topViewController(with: visibleVC)
        }
        if let viewController = rootViewController.presentedViewController {
            return topViewController(with: viewController)
        }
        return rootViewController
    }

//    - (UIViewController*)topViewController {
//        return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    }
//
//    - (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
//        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
//            UITabBarController* tabBarController = (UITabBarController*)rootViewController;
//            return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
//        } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//            UINavigationController* navigationController = (UINavigationController*)rootViewController;
//            return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
//        } else if (rootViewController.presentedViewController) {
//            UIViewController* presentedViewController = rootViewController.presentedViewController;
//            return [self topViewControllerWithRootViewController:presentedViewController];
//        } else {
//            return rootViewController;
//        }
//    }

}
