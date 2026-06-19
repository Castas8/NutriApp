//
//  RegisterView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 02/06/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var nombre          = ""
    @State private var correo          = ""
    @State private var telefono        = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var consultorio     = ""
    @State private var intentado       = false

    var nombreValido: Bool      { nombre.trimmingCharacters(in: .whitespaces).count >= 3 }
    var correoValido: Bool {
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return correo.range(of: regex, options: .regularExpression) != nil
    }
    var telefonoValido: Bool    { telefono.filter { $0.isNumber }.count == 10 }
    var passwordValida: Bool    { password.count >= 8 }
    var confirmValida: Bool     { confirmPassword == password && !confirmPassword.isEmpty }
    var consultorioValido: Bool { consultorio.trimmingCharacters(in: .whitespaces).count >= 3 }
    var formularioValido: Bool  {
        nombreValido && correoValido && telefonoValido &&
        passwordValida && confirmValida && consultorioValido
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(verdeO)
                            .frame(width: 72, height: 72)
                            .overlay(
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 34))
                                    .foregroundColor(menta)
                            )
                            .shadow(color: verdeO.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.top, 32)

                        Text("Crear cuenta")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(verdeO)

                        Text("Ingresa tus datos para comenzar")
                            .font(.system(size: 12))
                            .foregroundColor(gris)
                    }
                    .padding(.bottom, 32)

                    sectionLabel("Datos personales")
                    campoValidado("Nombre completo",      placeholder: "Dra. Karla Martínez", text: $nombre,         esValido: nombreValido,      error: "Mínimo 3 caracteres")
                    campoValidado("Correo electrónico",   placeholder: "karla@correo.com",    text: $correo,         esValido: correoValido,      error: "Ingresa un correo válido", keyboard: .emailAddress)
                    campoValidado("Teléfono",             placeholder: "4771234567",           text: $telefono,       esValido: telefonoValido,    error: "Ingresa 10 dígitos", keyboard: .phonePad)
                    campoPasswordValidado("Contraseña",           placeholder: "Mínimo 8 caracteres",  text: $password,       esValido: passwordValida,    error: "Mínimo 8 caracteres")
                    campoPasswordValidado("Confirmar contraseña", placeholder: "Repite tu contraseña", text: $confirmPassword, esValido: confirmValida,    error: "Las contraseñas no coinciden")

                    sectionLabel("Consultorio").padding(.top, 20)
                    campoValidado("Nombre del consultorio", placeholder: "Consultorio NutriSalud", text: $consultorio, esValido: consultorioValido, error: "Mínimo 3 caracteres")

                    // Botón que solo cierra el modal — no guarda nada
                    Button {
                        dismiss()
                    } label: {
                        Text("Crear cuenta")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(beige)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(verdeO)
                            .cornerRadius(12)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                    Button { dismiss() } label: {
                        Text("¿Ya tienes cuenta? Inicia sesión")
                            .font(.system(size: 13))
                            .foregroundColor(terra)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 28)
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(terra)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)
            .kerning(0.8)
    }

    @ViewBuilder
    func campoValidado(_ label: String, placeholder: String, text: Binding<String>, esValido: Bool, error: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(verdeM)
            TextField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor(text.wrappedValue, esValido: esValido), lineWidth: borderWidth(text.wrappedValue, esValido: esValido)))
                .keyboardType(keyboard)
                .autocapitalization(.none)
            if intentado && !text.wrappedValue.isEmpty && !esValido {
                Text(error).font(.system(size: 11)).foregroundColor(terra)
            }
        }
        .padding(.bottom, 12)
    }

    @ViewBuilder
    func campoPasswordValidado(_ label: String, placeholder: String, text: Binding<String>, esValido: Bool, error: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(verdeM)
            SecureField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor(text.wrappedValue, esValido: esValido), lineWidth: borderWidth(text.wrappedValue, esValido: esValido)))
            if intentado && !text.wrappedValue.isEmpty && !esValido {
                Text(error).font(.system(size: 11)).foregroundColor(terra)
            }
        }
        .padding(.bottom, 12)
    }

    func borderColor(_ value: String, esValido: Bool) -> Color {
        if !intentado || value.isEmpty { return menta }
        return esValido ? verdeM : terra
    }

    func borderWidth(_ value: String, esValido: Bool) -> CGFloat {
        if !intentado || value.isEmpty { return 0.8 }
        return esValido ? 1.0 : 1.5
    }
}

#Preview {
    RegisterView()
}
