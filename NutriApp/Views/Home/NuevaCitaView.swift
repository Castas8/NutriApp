//
//  NuevaCitaView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 12/06/26.
//

import SwiftUI

struct NuevaCitaView: View {
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var paciente  = ""
    @State private var motivo    = ""
    @State private var fecha     = Date()
    @State private var tipo      = "Primera vez"
    @State private var notas     = ""
    @State private var intentado = false

    let tipos = ["Primera vez", "Seguimiento", "Control de peso", "Plan nutricional"]

    var pacienteValido: Bool   { paciente.trimmingCharacters(in: .whitespaces).count >= 3 }
    var motivoValido: Bool     { motivo.trimmingCharacters(in: .whitespaces).count >= 3 }
    var formularioValido: Bool { pacienteValido && motivoValido }

    var body: some View {
        NavigationView {
            ZStack {
                beige.ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        VStack(spacing: 12) {
                            campoValidado("Nombre del paciente", placeholder: "Ej. Juan Pérez",      text: $paciente, esValido: pacienteValido, error: "Mínimo 3 caracteres")
                            campoValidado("Motivo de la cita",   placeholder: "Ej. Control de peso", text: $motivo,   esValido: motivoValido,   error: "Mínimo 3 caracteres")

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tipo de consulta")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(verdeM)
                                Picker("Tipo", selection: $tipo) {
                                    ForEach(tipos, id: \.self) { Text($0) }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fecha y hora")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(verdeM)
                                DatePicker("", selection: $fecha, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                                    .tint(verdeO)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notas (opcional)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(verdeM)
                                ZStack(alignment: .topLeading) {
                                    if notas.isEmpty {
                                        Text("Observaciones adicionales...")
                                            .font(.system(size: 13))
                                            .foregroundColor(gris)
                                            .padding(12)
                                    }
                                    TextEditor(text: $notas)
                                        .font(.system(size: 13))
                                        .frame(height: 80)
                                        .padding(8)
                                }
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                        Button {
                            intentado = true
                            if formularioValido { dismiss() }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "calendar.badge.plus")
                                Text("Agendar cita")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(formularioValido ? verdeO : gris)
                            .cornerRadius(12)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Nueva Cita")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(gris)
                }
            }
        }
    }

    @ViewBuilder
    func campoValidado(_ label: String, placeholder: String, text: Binding<String>, esValido: Bool, error: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(verdeM)
            TextField(placeholder, text: text)
                .font(.system(size: 14))
                .padding(12)
                .background(beige)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            intentado && !text.wrappedValue.isEmpty && !esValido ? terra : menta,
                            lineWidth: intentado && !text.wrappedValue.isEmpty && !esValido ? 1.5 : 0.8
                        )
                )
            if intentado && !text.wrappedValue.isEmpty && !esValido {
                Text(error).font(.system(size: 11)).foregroundColor(terra)
            }
            if intentado && text.wrappedValue.isEmpty {
                Text("Este campo es requerido").font(.system(size: 11)).foregroundColor(terra)
            }
        }
    }
}

#Preview {
    NuevaCitaView()
}
