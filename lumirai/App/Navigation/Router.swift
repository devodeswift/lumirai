//
//  Router.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/01/26.
//

import Foundation
import SwiftUI
import Combine

final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func setRoot(_ route: AppRoute) {
        path = NavigationPath([route])
    }
}
