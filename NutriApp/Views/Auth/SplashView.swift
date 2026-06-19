//
//  SplashView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 02/06/26.
//

import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    // Animación de flotación
    @State private var float1 = false
    @State private var float2 = false
    @State private var float3 = false
    @State private var pulse  = false

    let beige    = Color(hex: "FAF6EE")
    let verdeO   = Color(hex: "2D5016")
    let verdeM   = Color(hex: "4A7C2F")
    let menta    = Color(hex: "A8C97F")
    let arena    = Color(hex: "E8D5B0")

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                // Iconos flotantes + logo central
                ZStack {
                    // Iconos esquinas y lados
                    iconBox("apple.logo",   color: verdeM, bg: arena, offset: CGSize(width: -70, height: -60), anim: float1)
                    iconBox("carrot",       color: verdeM, bg: arena, offset: CGSize(width:  70, height: -60), anim: float2)
                    iconBox("fish",         color: verdeM, bg: arena, offset: CGSize(width: -80, height:   0), anim: float3)
                    iconBox("flame",        color: Color(hex: "C4693A"), bg: arena, offset: CGSize(width:  80, height:   0), anim: float1)
                    iconBox("leaf.circle",  color: verdeM, bg: arena, offset: CGSize(width: -50, height:  60), anim: float2)
                    iconBox("drop",         color: verdeM, bg: arena, offset: CGSize(width:  50, height:  60), anim: float3)

                    // Logo central
                    Image("AppIcon_Balance")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(18)
                        .scaleEffect(pulse ? 1.05 : 1.0)
                }
                .frame(width: 200, height: 160)

                // Nombre de la app
                Text("Balance")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(verdeO)

                // Tagline
                Text("Para nutricionistas profesionales")
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "9E9681"))

                Spacer()

            }
        }
        .onAppear {
            // Animaciones
            withAnimation(.easeInOut(duration: 1.4).repeatForever()) { float1 = true }
            withAnimation(.easeInOut(duration: 1.8).repeatForever()) { float2 = true }
            withAnimation(.easeInOut(duration: 1.6).repeatForever()) { float3 = true }
            withAnimation(.easeInOut(duration: 1.2).repeatForever()) { pulse  = true }

            // Ir a siguiente pantalla después de 2 seg
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation { showSplash = false }
            }
        }
    }

    // Helper para iconos flotantes
    func iconBox(_ icon: String, color: Color, bg: Color, offset: CGSize, anim: Bool) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(bg)
            .frame(width: 36, height: 36)
            .overlay(Image(systemName: icon).font(.system(size: 16)).foregroundColor(color))
            .offset(offset)
            .offset(y: anim ? -5 : 5)
            .animation(.easeInOut(duration: 1.5).repeatForever(), value: anim)
    }
}

#Preview {
    SplashView(showSplash: .constant(true))
}
