//
//  PerfilNutriView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct PerfilNutriView: View {

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    // Estado del perfil — se actualiza al editar
    @State private var nombre      = "Diego Castañeda"
    @State private var consultorio = "Consultorio NutriConsulta"
    @State private var correo      = "diego.kastan@gmail.com"
    @State private var telefono    = "477 123 4567"

    let totalPacientes = 100
    let totalConsultas = 108

    @State private var irAEditar       = false
    @State private var showLogoutAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    headerSection.padding(.top, 16)
                    estadisticasSection
                    opcionesSection

                    Button { showLogoutAlert = true } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Cerrar sesión")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(terra)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(terra.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(terra.opacity(0.3), lineWidth: 1))
                    }

                    Text("NutriConsulta v1.0")
                        .font(.system(size: 11))
                        .foregroundColor(gris)
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $irAEditar) {
            EditarPerfilView(
                nombre:      $nombre,
                consultorio: $consultorio,
                correo:      $correo,
                telefono:    $telefono
            )
        }
        .alert("Cerrar sesión", isPresented: $showLogoutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                isLoggedIn = false
            }
        } message: {
            Text("¿Estás seguro que deseas cerrar sesión?")
        }
    }

    // MARK: — Header
    var headerSection: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(verdeM)
                .frame(width: 90, height: 90)
                .overlay(
                    Text(String(nombre.prefix(2)).uppercased())
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                )
                .overlay(Circle().stroke(menta, lineWidth: 3))
                .shadow(color: verdeO.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(spacing: 4) {
                Text(nombre)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(verdeO)
                HStack(spacing: 6) {
                    Image(systemName: "building.2").font(.system(size: 12)).foregroundColor(gris)
                    Text(consultorio).font(.system(size: 13)).foregroundColor(gris)
                }
                HStack(spacing: 6) {
                    Image(systemName: "envelope").font(.system(size: 12)).foregroundColor(gris)
                    Text(correo).font(.system(size: 12)).foregroundColor(gris)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    // MARK: — Estadísticas — sin Planes IA
    var estadisticasSection: some View {
        HStack(spacing: 0) {
            statItem(valor: "\(totalPacientes)", label: "Pacientes")
            Divider().frame(height: 40)
            statItem(valor: "\(totalConsultas)", label: "Consultas")
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    func statItem(valor: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(valor).font(.system(size: 24, weight: .bold)).foregroundColor(verdeO)
            Text(label).font(.system(size: 11)).foregroundColor(gris)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: — Opciones
    var opcionesSection: some View {
        VStack(spacing: 0) {
            Text("CUENTA")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(gris)
                .kerning(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                opcionRow(icono: "pencil", label: "Editar perfil", color: verdeO) {
                    irAEditar = true
                }
                Divider().padding(.horizontal, 16)
                opcionRow(icono: "lock", label: "Cambiar contraseña", color: verdeO) {}
                Divider().padding(.horizontal, 16)
                opcionRow(icono: "chart.bar.fill", label: "Mis estadísticas", color: verdeM) {}
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    func opcionRow(icono: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.12))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Image(systemName: icono).font(.system(size: 15)).foregroundColor(color)
                    )
                Text(label).font(.system(size: 14)).foregroundColor(verdeO)
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(gris)
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
    }
}

// MARK: — Editar Perfil — recibe bindings para reflejar cambios en tiempo real
struct EditarPerfilView: View {
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @Binding var nombre:      String
    @Binding var consultorio: String
    @Binding var correo:      String
    @Binding var telefono:    String

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // Avatar
                    VStack(spacing: 8) {
                        Circle()
                            .fill(verdeM)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(nombre.prefix(2)).uppercased())
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .overlay(Circle().stroke(menta, lineWidth: 2))
                        Button {} label: {
                            Text("Cambiar foto")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(terra)
                        }
                    }
                    .padding(.top, 20)

                    // Campos
                    VStack(spacing: 12) {
                        campoEditar("Nombre completo",        text: $nombre)
                        campoEditar("Nombre del consultorio", text: $consultorio)
                        campoEditar("Correo electrónico",     text: $correo,   keyboard: .emailAddress)
                        campoEditar("Teléfono",               text: $telefono, keyboard: .phonePad)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    Button { dismiss() } label: {
                        Text("Guardar cambios")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(verdeO)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { dismiss() } label: {
                    Text("Guardar").font(.system(size: 14, weight: .semibold)).foregroundColor(verdeO)
                }
            }
        }
    }

    func campoEditar(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 11, weight: .medium)).foregroundColor(verdeM)
            TextField(label, text: text)
                .font(.system(size: 14)).padding(12).background(beige).cornerRadius(10)
                .keyboardType(keyboard).autocapitalization(.none)
        }
    }
}

#Preview {
    NavigationStack { PerfilNutriView() }
}
