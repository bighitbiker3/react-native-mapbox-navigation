import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

class MapboxNavigationView: UIView, NavigationViewControllerDelegate {
  var voiceController: CustomVoiceController?
  
  @objc var origin: NSArray = [] {
    didSet { startNavigation() }
  }
  
  @objc var destination: NSArray = [] {
    didSet { startNavigation() }
  }
  
  @objc var shouldSimulateRoute: Bool = false
  
  @objc var isMuted: Bool = false {
    didSet {
      guard voiceController != nil else { return }
      voiceController?.isMuted = isMuted
    }
  }
  
  @objc var onProgressChange: RCTDirectEventBlock?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startNavigation() {
    guard origin.count == 2 && destination.count == 2 else { return }
    
    let originWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: origin[1] as! CLLocationDegrees, longitude: origin[0] as! CLLocationDegrees))
    let destinationWaypoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destination[1] as! CLLocationDegrees, longitude: destination[0] as! CLLocationDegrees))
    
    let options = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint])
    
    Directions.shared.calculate(options) { [weak self] (session, result) in
        switch result {
            case .failure(let error):
            print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
     
                // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
                let navigationService = MapboxNavigationService(route: route, routeOptions: options, simulating: .never)
                let navigationOptions = NavigationOptions(navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: route, routeOptions: options, navigationOptions: navigationOptions)
//                navigationViewController.modalPresentationStyle = .fullScreen
//                Directions.shared.calculate(options) { _, routes in
//                  guard let route = routes?.first else { return }
//
//                  let navigationService = MapboxNavigationService(route: route, simulating: self.shouldSimulateRoute ? .always : .onPoorGPS)
//
//                  self.voiceController = CustomVoiceController(navigationService: navigationService)
//                  self.voiceController?.isMuted = self.isMuted
//
//                  let navigationOptions = NavigationOptions(navigationService: navigationService, voiceController: self.voiceController)
//                  let navigationViewController = NavigationViewController(for: route, options: navigationOptions)
//                  navigationViewController.delegate = self
//
//                  let view = navigationViewController.view!
//                  view.frame = self.frame
//                  view.bounds = self.bounds
//
//                  self.addSubview(view)
//                }
             
                navigationViewController.delegate = strongSelf
        
              let view = navigationViewController.view!
              view.frame = strongSelf.frame
              view.bounds = strongSelf.bounds

              strongSelf.addSubview(view)
            }
      }
  }
  
  func navigationViewController(_ navigationViewController: NavigationViewController, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
    onProgressChange!(["longitude": location.coordinate.longitude, "latitude": location.coordinate.latitude])
  }
}

class CustomVoiceController: MapboxVoiceController {
  var isMuted = false
  
  override func didPassSpokenInstructionPoint(notification: NSNotification) {
    if isMuted == false {
      super.didPassSpokenInstructionPoint(notification: notification)
    }
  }
}
