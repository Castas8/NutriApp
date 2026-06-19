//
//  MainTabView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct MainTabView: View {

    let verdeO = Color(hex: "2D5016")

    @State var tabSeleccionado = 0

    var body: some View {
        TabView(selection: $tabSeleccionado) {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: tabSeleccionado == 0 ? "house.fill" : "house")
                Text("Inicio")
            }
            .tag(0)

            NavigationStack {
                PacientesListView()
            }
            .tabItem {
                Image(systemName: tabSeleccionado == 1 ? "person.2.fill" : "person.2")
                Text("Pacientes")
            }
            .tag(1)

            NavigationStack {
                ConsultasListView()
            }
            .tabItem {
                Image(systemName: tabSeleccionado == 2 ? "calendar" : "calendar")
                Text("Consultas")
            }
            .tag(2)

            NavigationStack {
                PerfilNutriView()
            }
            .tabItem {
                Image(systemName: tabSeleccionado == 3 ? "person.fill" : "person")
                Text("Perfil")
            }
            .tag(3)
        }
        // Escucha notificación para ir a Home
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("irAHome"))) { _ in
            tabSeleccionado = 0
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(hex: "2D5016"))

            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "A8C97F"))
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color(hex: "A8C97F"))
            ]

            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
