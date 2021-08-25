import UIKit

class AppCoordinator: Coordinator {
    
    private var storageManager: StorageManagerProtocol
    private var coordinatorFactory: CoordinatorFactoryProtocol
        
    init(router: Router, coordinatorFactory: CoordinatorFactory, storageManager: StorageManagerProtocol) {
        self.coordinatorFactory = coordinatorFactory
        self.storageManager = storageManager
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        //start with deepLink
        if let option = option {
            switch option {
            case .somethingElse:
                //run flow
                break
            default:
                childCoordinators.forEach { $0.start(with: option) }
            }
            // default start
        } else {
            runStartupFlow()
        }
        ReachabilityListener.shared.startListening()
    }
    
    //    override func start(with option: DeepLinkOption?) {
    //      //start with deepLink
    //      if let option = option {
    //        switch option {
    //        case .onboarding: runOnboardingFlow()
    //        case .signUp: runAuthFlow()
    //        default: childCoordinators.forEach { coordinator in
    //          coordinator.start(with: option)
    //          }
    //        }
    //      // default start
    //      } else {
    //        switch instructor {
    //        case .onboarding: runOnboardingFlow()
    //        case .auth: runAuthFlow()
    //        case .main: runMainFlow()
    //        }
    //      }
    //    }
    
    //    init(coordinatorFactory: CoordinatorFactoryProtocol, storageManager: StorageManagerProtocol) {
    //        self.coordinatorFactory = coordinatorFactory
    //        self.storageManager = storageManager
    //        let tabBarCoordinator = coordinatorFactory.makeMainTabBarCoordinator(storageManager: storageManager)
    //        let viewController = tabBarCoordinator.start() ?? UIViewController()
    //        super.init(rootViewController: viewController)
    //        addChild(tabBarCoordinator)
    //    }
    //
    //    override func start() -> Presentable? {
    //        runMainTabBarFlow(with: nil)
    //        return rootViewController
    //    }
    //
    //    override func start(with option: DeepLinkOption?) {
    //        runMainTabBarFlow(with: option)
    //    }
    //
    
    func runStartupFlow() {
        var coordinator = coordinatorFactory.makeStartupCoordinator(router: router)
        coordinator.didFinish = { [weak self] coordinator, showLoginScreen in
            self?.removeDependency(coordinator)
            self?.router.popModule()
            self?.runMainTabBarFlow(showLoginScreen: showLoginScreen)
            
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    func runMainTabBarFlow(showLoginScreen: Bool) {
        let coordinator = coordinatorFactory.makeMainTabBarCoordinator(router: router,
                                                                       storageManager: storageManager,
                                                                       coordinatorFactory: coordinatorFactory, showLoginScreen: showLoginScreen)
        addDependency(coordinator)
        coordinator.start()
    }
}
