//
//  CameraView.swift
//  Cromatico
//
//  Created by Pedro Muniz on 15/05/23.
//

import SwiftUI

struct CameraView: View {

    var body: some View {
        ZStack {
            HostedViewController()
                .navigationBarHidden(true)
            VStack {
                NavigationLink(destination: OnBoardingView().navigationBarBackButtonHidden(true)) {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("customLightGray"))
                        .padding(.all)
                        .position(x: 360, y: 30)
                }
                Spacer()
                PenColorResultView(penColorResult: "Cor da caneta")
            }
        }
    }
}

struct PenColorResultView: View {

    var penColorResult: String

    var body: some View {
        Text(penColorResult)
            .font(.system(size: 24, weight: .bold))
            .frame(width: 260, height: 50)
            .foregroundColor(.black)
            .background(Color("customLightGray").opacity(0.5))
            .padding(.bottom)
    }
}
