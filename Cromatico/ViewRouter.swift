//
//  ViewRouter.swift
//  Cromatico
//
//  Created by Pedro Muniz on 18/05/23.
//

import SwiftUI

class ViewRouter: ObservableObject {

    @Published var currentPage: String

    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "cameraView"
        }
    }

}
