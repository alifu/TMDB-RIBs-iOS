//
//  SceneDelegate.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 18/09/25.
//

import netfox
import RIBs
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var launchRouter: LaunchRouting?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        NFX.sharedInstance().start()
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let rootBuilder = RootBuilder(dependency: AppComponent())
        let launchRouter = rootBuilder.build()
        self.launchRouter = launchRouter
        
        if #available(iOS 26.0, *) {
            let appearance = UITabBarAppearance()
            appearance.shadowColor = .clear
            appearance.stackedLayoutAppearance.normal.iconColor = ColorUtils.mediumGrey
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: ColorUtils.mediumGrey
            ]
            appearance.stackedLayoutAppearance.selected.iconColor = ColorUtils.blue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: ColorUtils.blue
            ]
            
            let tabBar = UITabBar.appearance()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ColorUtils.darkBlue
            
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: ColorUtils.mediumGrey
            ]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: ColorUtils.blue
            ]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            appearance.shadowColor = ColorUtils.blue
            appearance.stackedLayoutAppearance.normal.iconColor = ColorUtils.mediumGrey
            appearance.stackedLayoutAppearance.selected.iconColor = ColorUtils.blue
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        launchRouter.launch(from: window)
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

