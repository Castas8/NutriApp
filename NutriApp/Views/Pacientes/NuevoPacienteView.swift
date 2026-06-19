//
//  NuevoPacienteView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct NuevoPacienteView: View {
    @Environment(\.dismiss) var dismiss

    var pacienteEditar: PacienteAPI? = nil
    var onGuardar: (() -> Void)? = nil

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var nombre          = ""
    @State private var fechaNacimiento = Date()
    @State private var edad            = ""
    @State private var genero          = "Femenino"
    @State private var estadoCivil     = "Soltero/a"
    @State private var ocupacion       = ""
    @State private var telefono        = ""
    @State private var motivoConsulta  = ""

    @State private var enfermedadesPatologicas = ""
    @State private var enfermedadesHeredo      = ""
    @State private var operacionesPrevias      = ""
    @State private var consumeTabaco           = false
    @State private var consumeAlcohol          = false
    @State private var otrasSustancias         = false
    @State private var otrasSustanciasDesc     = ""
    @State private var medicamentos            = ""

    @State private var registroCompleto = false
    @State private var objetivo         = "Pérdida de peso"
    @State private var nivelActividad   = "Sedentario (Poco o nada)"

    @State private var irANuevaConsulta = false
    @State private var errorMsg         = ""

    let generos          = ["Femenino", "Masculino", "Otro"]
    let estadosCivil     = ["Soltero/a", "Casado/a", "Divorciado/a", "Viudo/a", "Unión libre"]
    let objetivos        = ["Pérdida de peso", "Ganancia muscular", "Mantenimiento", "Mejora salud", "Rendimiento deportivo"]
    let nivelesActividad = ["Sedentario (Poco o nada)", "Ligeramente activo", "Moderadamente activo", "Muy activo", "Extra activo"]

    var esEdicion: Bool { pacienteEditar != nil }

    var generoAPI: String {
        switch genero {
        case "Masculino": return "M"
        case "Femenino":  return "F"
        default:          return "Otro"
        }
    }

    var formularioCompleto: Bool {
        !nombre.isEmpty &&
        !edad.isEmpty &&
        !ocupacion.isEmpty &&
        !telefono.isEmpty &&
        !motivoConsulta.isEmpty
    }

    var pacienteEnMemoria: PacienteAPI {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return PacienteAPI(
            idUsuario:                    1,
            nombreCompleto:               nombre,
            fechaNacimiento:              formatter.string(from: fechaNacimiento),
            edad:                         Int(edad) ?? 0,
            genero:                       generoAPI,
            ocupacion:                    ocupacion,
            estadoCivil:                  estadoCivil,
            telefono:                     telefono,
            motivoConsulta:               motivoConsulta,
            enfermedadesPatologicas:      enfermedadesPatologicas,
            enfermedadesHeredofamiliares: enfermedadesHeredo,
            operacionesPrevias:           operacionesPrevias,
            consumeTabaco:                consumeTabaco,
            consumeAlcohol:               consumeAlcohol,
            otrasSustancias:              otrasSustancias ? otrasSustanciasDesc : "Ninguna",
            objetivo:                     objetivo,
            nivelActividad:               nivelActividad,
            medicamentos:                 medicamentos.isEmpty ? "Ninguno" : medicamentos,
            estatus:                      "en_proceso"
        )
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    sectionLabel("Datos generales")

                    campo("Nombre completo *", placeholder: "Ej. Ana García López", text: $nombre)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fecha de nacimiento")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(verdeM)
                        DatePicker("", selection: $fechaNacimiento, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    }
                    .padding(.bottom, 12)

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Edad *").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                            TextField("00", text: $edad)
                                .font(.system(size: 14)).keyboardType(.numberPad).padding(12)
                                .background(Color.white).cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(edad.isEmpty && !errorMsg.isEmpty ? terra : menta, lineWidth: edad.isEmpty && !errorMsg.isEmpty ? 1.5 : 0.8))
                        }.frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Género").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                            Picker("Género", selection: $genero) {
                                ForEach(generos, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                            .background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                        }.frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 12)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estado civil").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                        Picker("Estado civil", selection: $estadoCivil) {
                            ForEach(estadosCivil, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                        .background(Color.white).cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    }
                    .padding(.bottom, 12)

                    campo("Ocupación *", placeholder: "Ej. Ingeniero", text: $ocupacion)
                    campo("Teléfono *", placeholder: "477 123 4567", text: $telefono, keyboard: .phonePad)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Motivo de consulta *").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                        ZStack(alignment: .topLeading) {
                            if motivoConsulta.isEmpty {
                                Text("¿Por qué consulta al nutriólogo?")
                                    .font(.system(size: 14)).foregroundColor(gris).padding(12)
                            }
                            TextEditor(text: $motivoConsulta)
                                .font(.system(size: 14)).frame(height: 80).padding(8)
                        }
                        .background(Color.white).cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(motivoConsulta.isEmpty && !errorMsg.isEmpty ? terra : menta, lineWidth: motivoConsulta.isEmpty && !errorMsg.isEmpty ? 1.5 : 0.8))
                    }
                    .padding(.bottom, 12)

                    sectionLabel("Antecedentes").padding(.top, 8)

                    campoEditor("Enfermedades patológicas",     placeholder: "Hipertensión, diabetes...",  text: $enfermedadesPatologicas)
                    campoEditor("Enfermedades heredofamiliares",placeholder: "Antecedentes familiares...", text: $enfermedadesHeredo)
                    campoEditor("Operaciones previas",          placeholder: "Listado de cirugías...",     text: $operacionesPrevias)
                    campo("Medicamentos", placeholder: "Medicamentos actuales...", text: $medicamentos)

                    VStack(spacing: 0) {
                        toggleRow("Consume tabaco",   isOn: $consumeTabaco)
                        Divider().padding(.horizontal, 16)
                        toggleRow("Consume alcohol",  isOn: $consumeAlcohol)
                        Divider().padding(.horizontal, 16)
                        toggleRow("Otras sustancias", isOn: $otrasSustancias)
                        if otrasSustancias {
                            TextField("Especifica...", text: $otrasSustanciasDesc)
                                .font(.system(size: 13)).padding(.horizontal, 16).padding(.bottom, 12)
                        }
                    }
                    .background(Color.white).cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    .padding(.bottom, 12)

                    sectionLabel("Objetivo").padding(.top, 8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Objetivo principal").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                        Picker("Objetivo", selection: $objetivo) {
                            ForEach(objetivos, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                        .background(Color.white).cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    }
                    .padding(.bottom, 12)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nivel de actividad").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                        Picker("Nivel actividad", selection: $nivelActividad) {
                            ForEach(nivelesActividad, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                        .background(Color.white).cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    }
                    .padding(.bottom, 28)

                    if !errorMsg.isEmpty {
                        Text(errorMsg)
                            .font(.system(size: 12))
                            .foregroundColor(terra)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                    }

                    // Botón — "Siguiente" si es nuevo, "Guardar cambios" si es edición
                    Button {
                        if esEdicion {
                            guardarEdicion()
                        } else {
                            if nombre.isEmpty {
                                errorMsg = "El nombre completo es requerido"
                            } else if edad.isEmpty {
                                errorMsg = "La edad es requerida"
                            } else if ocupacion.isEmpty {
                                errorMsg = "La ocupación es requerida"
                            } else if telefono.isEmpty {
                                errorMsg = "El teléfono es requerido"
                            } else if motivoConsulta.isEmpty {
                                errorMsg = "El motivo de consulta es requerido"
                            } else if enfermedadesPatologicas.isEmpty {
                                errorMsg = "Las enfermedades patológicas son requeridas (escribe 'Ninguna' si no aplica)"
                            } else if enfermedadesHeredo.isEmpty {
                                errorMsg = "Las enfermedades heredofamiliares son requeridas (escribe 'Ninguna' si no aplica)"
                            } else if operacionesPrevias.isEmpty {
                                errorMsg = "Las operaciones previas son requeridas (escribe 'Ninguna' si no aplica)"
                            } else if medicamentos.isEmpty {
                                errorMsg = "Los medicamentos son requeridos (escribe 'Ninguno' si no aplica)"
                            } else {
                                errorMsg = ""
                                irANuevaConsulta = true
                            }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: esEdicion ? "pencil.circle.fill" : "arrow.right.circle.fill")
                            Text(esEdicion ? "Guardar cambios" : "Siguiente")
                                .font(.system(size: 15, weight: .semibold))
                        }
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
        .navigationTitle(esEdicion ? "Editar Paciente" : "Nuevo Paciente")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
            if esEdicion {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { guardarEdicion() } label: {
                        Text("Guardar").font(.system(size: 14, weight: .semibold)).foregroundColor(verdeO)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $irANuevaConsulta) {
            NuevaConsultaView(
                paciente: pacienteEnMemoria,
                onGuardar: {
                    onGuardar?()
                    registroCompleto = true
                },
                esPrimerRegistro: true
            )
        }
        .onChange(of: registroCompleto) {
            if registroCompleto { dismiss() }
        }
        .onAppear { precargarDatos() }
    }

    // MARK: — Guardar edición
    func guardarEdicion() {
        errorMsg = ""
        var paciente = pacienteEnMemoria
        if let id = pacienteEditar?.idPaciente { paciente.idPaciente = id }
        paciente.estatus = pacienteEditar?.estatus ?? "en_proceso"

        guard let body = try? JSONEncoder().encode(paciente) else {
            errorMsg = "Error al preparar los datos"
            return
        }

        APIService.shared.request(
            endpoint: "pacientes/update",
            method:   "PUT",
            body:     body
        ) { (result: Result<PacienteAPI, Error>) in
            switch result {
            case .success:
                onGuardar?()
                dismiss()
            case .failure:
                errorMsg = "No se pudo guardar el paciente"
            }
        }
    }

    // MARK: — Precargar datos edición
    func precargarDatos() {
        guard let p = pacienteEditar else { return }
        nombre         = p.nombreCompleto ?? ""
        edad           = "\(p.edad ?? 0)"
        ocupacion      = p.ocupacion ?? ""
        telefono       = p.telefono ?? ""
        motivoConsulta = p.motivoConsulta ?? ""
        enfermedadesPatologicas = p.enfermedadesPatologicas ?? ""
        enfermedadesHeredo      = p.enfermedadesHeredofamiliares ?? ""
        operacionesPrevias      = p.operacionesPrevias ?? ""
        medicamentos            = p.medicamentos ?? ""
        consumeTabaco           = p.consumeTabaco ?? false
        consumeAlcohol          = p.consumeAlcohol ?? false
        otrasSustanciasDesc     = p.otrasSustancias ?? ""
        otrasSustancias         = !(p.otrasSustancias ?? "Ninguna").lowercased().contains("ninguna")
        switch p.genero {
        case "M": genero = "Masculino"
        case "F": genero = "Femenino"
        default:  genero = "Otro"
        }
        if let ec = p.estadoCivil, estadosCivil.contains(ec) { estadoCivil = ec }
        if let obj = p.objetivo, objetivos.contains(obj) { objetivo = obj }
        if let na = p.nivelActividad, nivelesActividad.contains(na) { nivelActividad = na }
        if let fn = p.fechaNacimiento {
            let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
            fechaNacimiento = f.date(from: fn) ?? Date()
        }
    }

    // MARK: — Helpers UI
    func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .semibold)).foregroundColor(terra)
            .frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 8).kerning(0.8)
    }

    @ViewBuilder
    func campo(_ label: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
            TextField(placeholder, text: text)
                .font(.system(size: 14)).padding(12).background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    text.wrappedValue.isEmpty && !errorMsg.isEmpty ? terra : menta,
                    lineWidth: text.wrappedValue.isEmpty && !errorMsg.isEmpty ? 1.5 : 0.8))
                .keyboardType(keyboard)
        }.padding(.bottom, 12)
    }

    @ViewBuilder
    func campoEditor(_ label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder).font(.system(size: 14)).foregroundColor(gris).padding(12)
                }
                TextEditor(text: text).font(.system(size: 14)).frame(height: 70).padding(8)
                    .opacity(text.wrappedValue.isEmpty ? 0.85 : 1)
            }
            .background(Color.white).cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
        }.padding(.bottom, 12)
    }

    func toggleRow(_ label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).foregroundColor(verdeO)
            Spacer()
            Toggle("", isOn: isOn).tint(verdeM)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack { NuevoPacienteView() }
}
