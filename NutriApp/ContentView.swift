//
//  ContentView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 02/06/26.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        if showSplash {
            SplashView(showSplash: $showSplash)
        } else if isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}
