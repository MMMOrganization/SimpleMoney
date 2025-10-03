//
//  SceneDelegate.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 12/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator : AppCoordinator?

    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        registerContainer()
        let factories = makeFactories()
        
        appCoordinator = AppCoordinator(navigationController: navigationController, factories: factories)
        appCoordinator?.start()

        setupNavigationBarAppearance()
        
        window?.makeKeyAndVisible()
    }
    
    private func registerContainer() {
        do {
            registerRepository()
            try registerViewModel()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func registerRepository() {
        DIContainer.shared.register(key: DataRepository.self, value: DataRepository())
        DIContainer.shared.register(key: MockDataRepository.self, value: MockDataRepository())
    }
    
    private func registerViewModel() throws {
        let repository = try DIContainer.shared.resolve(key: DataRepository.self)
        let mockRepository = try DIContainer.shared.resolve(key: MockDataRepository.self)
        
        DIContainer.shared.register(key: GraphViewModelFactory.self, value: GraphViewModelFactory(repository: repository))
        DIContainer.shared.register(key: DetailViewModelFactory.self, value: DetailViewModelFactory(repository: repository))
        DIContainer.shared.register(key: CreateViewModelFactory.self, value: CreateViewModelFactory(repository: repository))
        DIContainer.shared.register(key: CalendarViewModelFactory.self, value: CalendarViewModelFactory(repository: repository))
    }
    
    private func makeFactories() -> Factories {
        do {
            let graphFactory = try DIContainer.shared.resolve(key: GraphViewModelFactory.self)
            let detailFactory = try DIContainer.shared.resolve(key: DetailViewModelFactory.self)
            let createFactory = try DIContainer.shared.resolve(key: CreateViewModelFactory.self)
            let calendarFactory = try DIContainer.shared.resolve(key: CalendarViewModelFactory.self)
            
            return Factories(graph: graphFactory, detail: detailFactory, create: createFactory, calendar: calendarFactory)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

