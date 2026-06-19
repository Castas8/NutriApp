//
//  LoginView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 02/06/26.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showRegister = false
    @State private var correo       = ""
    @State private var password     = ""
    @State private var errorMsg     = ""
    @State private var intentado    = false
    @State private var cargando     = false

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    var correoValido: Bool {
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return correo.range(of: regex, options: .regularExpression) != nil
    }
    var passwordValida: Bool { password.count >= 8 }
    var formularioValido: Bool { correoValido && passwordValida }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image("AppIcon_Balance")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(22)
                    .shadow(color: verdeO.opacity(0.3), radius: 12, x: 0, y: 6)
                    .padding(.bottom, 48)

                campoValidado(
                    label: "Correo electrónico",
                    placeholder: "ejemplo@gmail.com",
                    text: $correo,
                    esValido: correoValido,
                    mensajeError: "Ingresa un correo válido",
                    keyboard: .emailAddress
                )
                .padding(.bottom, 14)

                campoPasswordValidado(
                    label: "Contraseña",
                    placeholder: "Mínimo 8 caracteres",
                    text: $password,
                    esValido: passwordValida,
                    mensajeError: "La contraseña debe tener al menos 8 caracteres"
                )
                .padding(.bottom, 20)

                if !errorMsg.isEmpty {
                    Text(errorMsg)
                        .font(.system(size: 12))
                        .foregroundColor(terra)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)
                }

                // Botón con conexión al backend
                Button {
                    intentado = true
                    errorMsg = ""
                    if formularioValido {
                        cargando = true
                        let loginData = UsuarioAPI(correo: correo, password: password)
                        guard let body = try? JSONEncoder().encode(loginData) else { return }

                        APIService.shared.request(
                            endpoint: "usuarios/login",
                            method: "POST",
                            body: body
                        ) { (result: Result<UsuarioAPI, Error>) in
                            cargando = false
                            switch result {
                            case .success(let usuario):
                                if usuario.idUsuario != nil {
                                    isLoggedIn = true
                                } else {
                                    errorMsg = "Credenciales incorrectas"
                                }
                            case .failure:
                                errorMsg = "Correo o contraseña incorrectos"
                            }
                        }
                    } else {
                        errorMsg = "Revisa los campos antes de continuar"
                    }
                } label: {
                    HStack(spacing: 8) {
                        if cargando {
                            ProgressView()
                                .tint(beige)
                                .scaleEffect(0.8)
                        }
                        Text(cargando ? "Entrando..." : "Iniciar sesión")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(beige)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(formularioValido ? verdeO : gris)
                    .cornerRadius(12)
                }
                .disabled(cargando)
                .padding(.bottom, 28)

                HStack(spacing: 4) {
                    Text("¿No tienes cuenta?")
                        .font(.system(size: 12))
                        .foregroundColor(gris)
                    Button { showRegister = true } label: {
                        Text("Regístrate")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(terra)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
    }

    @ViewBuilder
    func campoValidado(
        label: String,
        placeholder: String,
        text: Binding<String>,
        esValido: Bool,
        mensajeError: String,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(verdeM)
            TextField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            intentado && !text.wrappedValue.isEmpty && !esValido ? terra : menta,
                            lineWidth: intentado && !text.wrappedValue.isEmpty && !esValido ? 1.5 : 0.8
                        )
                )
                .keyboardType(keyboard)
                .autocapitalization(.none)
            if intentado && !text.wrappedValue.isEmpty && !esValido {
                Text(mensajeError)
                    .font(.system(size: 11))
                    .foregroundColor(terra)
            }
        }
    }

    @ViewBuilder
    func campoPasswordValidado(
        label: String,
        placeholder: String,
        text: Binding<String>,
        esValido: Bool,
        mensajeError: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(verdeM)
            SecureField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            intentado && !text.wrappedValue.isEmpty && !esValido ? terra : menta,
                            lineWidth: intentado && !text.wrappedValue.isEmpty && !esValido ? 1.5 : 0.8
                        )
                )
            if intentado && !text.wrappedValue.isEmpty && !esValido {
                Text(mensajeError)
                    .font(.system(size: 11))
                    .foregroundColor(terra)
            }
        }
    }
}

#Preview {
    LoginView()
}
