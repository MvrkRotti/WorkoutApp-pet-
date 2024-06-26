//
//  TabController.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 06.02.2024.
//



import UIKit

enum Tabs: Int, CaseIterable {
    case exercises
    case notes
    case profile
}

final class TabController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        configureAppearance()
        switchTo(tab: .profile)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }

    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }

    private func configureAppearance() {
        tabBar.tintColor = ColorResources.customCoral
        tabBar.unselectedItemTintColor = ColorResources.white
        tabBar.barTintColor = ColorResources.customDarkGrey
        tabBar.layer.masksToBounds = true
        tabBar.alpha = 0.9
        
        let controllers: [UIViewController] = Tabs.allCases.map { tab in
            let controller = UINavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: TabBarResources.title(for: tab),
                                                 image: TabBarResources.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }

        setViewControllers(controllers, animated: false)
    }

    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .exercises: return HandbookAssembler.buildModule()
        case .notes: return NotesAssembler.buildModule()
        case .profile: return ProfileAssembler.buildModule()
        }
    }
}
