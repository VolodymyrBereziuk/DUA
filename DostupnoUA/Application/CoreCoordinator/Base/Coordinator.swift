import UIKit

// MARK: - Coordinator

class Coordinator: NSObject, Coordinatable {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
      start(with: nil)
    }
    
    func start(with option: DeepLinkOption?) { }
    
    // add only unique object
    func addDependency(_ coordinator: Coordinator) {
      guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
      childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
      guard
        childCoordinators.isEmpty == false,
        let coordinator = coordinator
        else { return }
      
      // Clear child-coordinators recursively
      if coordinator.childCoordinators.isEmpty == false {
          coordinator.childCoordinators
              .filter({ $0 !== coordinator })
              .forEach({ coordinator.removeDependency($0) })
      }
      for (index, element) in childCoordinators.enumerated() where element === coordinator {
          childCoordinators.remove(at: index)
          break
      }
    }
}
