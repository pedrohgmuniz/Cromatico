//
//  MotherView.swift
//  Cromatico
//
//  Created by Pedro Muniz on 18/05/23.
//

import SwiftUI

struct MotherView: View {

    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                OnBoardingView()
            } else if viewRouter.currentPage == "cameraView" {
                CameraView()
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
