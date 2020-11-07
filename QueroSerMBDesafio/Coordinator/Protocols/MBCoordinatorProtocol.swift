import UIKit

protocol MBCoordinatorProtocol {
    func start() -> BaseViewController
    func start(with controller: BaseViewController) -> BaseViewController
}
