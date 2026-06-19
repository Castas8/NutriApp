//
//  PerfilPacienteView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct PerfilPacienteView: View {
    @Environment(\.dismiss) var dismiss

    let paciente: PacienteAPI

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var pacienteActual: PacienteAPI
    @State private var historial: [ConsultaAPI] = []
    @State private var cargandoHistorial        = false
    @State private var irANuevaConsulta         = false
    @State private var irAEditar                = false
    @State private var mostrarConfirmar         = false
    @State private var eliminando               = false
    @State private var errorEliminar            = ""

    init(paciente: PacienteAPI) {
        self.paciente = paciente
        self._pacienteActual = State(initialValue: paciente)
    }

    var nombre: String   { pacienteActual.nombreCompleto ?? "Sin nombre" }
    var estatus: String  { pacienteActual.estatus ?? "en_proceso" }
    var objetivo: String { pacienteActual.objetivo ?? "No especificado" }
    var genero: String   { pacienteActual.genero ?? "F" }
    var edad: Int        { pacienteActual.edad ?? 0 }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    headerSection
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    resumenSection
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    infoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    historialSection
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    Button {
                        irANuevaConsulta = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "stethoscope")
                            Text("Nueva consulta")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(verdeO)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    Button {
                        mostrarConfirmar = true
                    } label: {
                        HStack(spacing: 8) {
                            if eliminando { ProgressView().tint(terra).scaleEffect(0.8) }
                            else { Image(systemName: "trash") }
                            Text(eliminando ? "Eliminando..." : "Eliminar paciente")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(terra)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(terra.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(terra.opacity(0.3), lineWidth: 1))
                    }
                    .disabled(eliminando)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    if !errorEliminar.isEmpty {
                        Text(errorEliminar)
                            .font(.system(size: 12)).foregroundColor(terra)
                            .padding(.horizontal, 20).padding(.top, 8)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationTitle(nombre)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear { cargarHistorial() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { irAEditar = true } label: {
                    Image(systemName: "pencil").foregroundColor(verdeO)
                }
            }
        }
        .confirmationDialog(
            "¿Eliminar a \(nombre)?",
            isPresented: $mostrarConfirmar,
            titleVisibility: .visible
        ) {
            Button("Eliminar", role: .destructive) { eliminarPaciente() }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Esta acción no se puede deshacer. Se eliminarán todos sus datos y consultas.")
        }
        .navigationDestination(isPresented: $irANuevaConsulta) {
            NuevaConsultaView(paciente: pacienteActual)
        }
        .navigationDestination(isPresented: $irAEditar) {
            NuevoPacienteView(
                pacienteEditar: pacienteActual,
                onGuardar: {
                    guard let id = pacienteActual.idPaciente else { return }
                    APIService.shared.request(
                        endpoint: "pacientes/getById/\(id)"
                    ) { (result: Result<PacienteAPI, Error>) in
                        if case .success(let actualizado) = result {
                            pacienteActual = actualizado
                        }
                    }
                }
            )
        }
    }

    // MARK: — Cargar historial
    func cargarHistorial() {
        guard let id = pacienteActual.idPaciente else { return }
        cargandoHistorial = true
        APIService.shared.request(
            endpoint: "consultas/getByPaciente/\(id)"
        ) { (result: Result<[ConsultaAPI], Error>) in
            cargandoHistorial = false
            if case .success(let lista) = result {
                historial = lista.sorted {
                    ($0.fechaConsulta ?? "") > ($1.fechaConsulta ?? "")
                }
            }
        }
    }

    // MARK: — Eliminar paciente
    func eliminarPaciente() {
        guard let id = pacienteActual.idPaciente else { return }
        eliminando = true
        errorEliminar = ""
        APIService.shared.delete(endpoint: "pacientes/delete/\(id)") { exito in
            eliminando = false
            if exito { dismiss() }
            else { errorEliminar = "No se pudo eliminar el paciente" }
        }
    }

    // MARK: — Header
    var headerSection: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(colorEstatus(estatus).opacity(0.15))
                .frame(width: 64, height: 64)
                .overlay(
                    Text(String(nombre.prefix(2)).uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(colorEstatus(estatus))
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(nombre).font(.system(size: 20, weight: .bold)).foregroundColor(verdeO)
                Text(objetivo).font(.system(size: 12)).foregroundColor(gris)
                estatusBadge(estatus)
            }
            Spacer()
        }
        .padding(16).background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: — Resumen rápido
    var resumenSection: some View {
        HStack(spacing: 12) {
            resumenCard(valor: "\(edad)", label: "Edad", icono: "person.fill", color: verdeO)
            resumenCard(valor: genero == "M" ? "Masc." : "Fem.", label: "Género", icono: "figure.stand", color: verdeM)
            resumenCard(valor: pacienteActual.nivelActividad?.components(separatedBy: " ").first ?? "—", label: "Actividad", icono: "figure.walk", color: terra)
            resumenCard(valor: pacienteActual.consumeTabaco == true ? "Sí" : "No", label: "Tabaco", icono: "nosign", color: Color(hex: "E8A020"))
        }
    }

    func resumenCard(valor: String, label: String, icono: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icono).font(.system(size: 14)).foregroundColor(color)
            Text(valor).font(.system(size: 13, weight: .bold)).foregroundColor(verdeO)
            Text(label).font(.system(size: 9)).foregroundColor(gris).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12).background(Color.white).cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: — Info clínica
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("INFORMACIÓN CLÍNICA").font(.system(size: 10, weight: .semibold)).foregroundColor(gris).kerning(0.8)
            VStack(spacing: 0) {
                infoRow(label: "Ocupación",    valor: pacienteActual.ocupacion ?? "—")
                Divider().padding(.horizontal, 16)
                infoRow(label: "Estado civil", valor: pacienteActual.estadoCivil ?? "—")
                Divider().padding(.horizontal, 16)
                infoRow(label: "Teléfono",     valor: pacienteActual.telefono ?? "—")
                Divider().padding(.horizontal, 16)
                infoRow(label: "Motivo",       valor: pacienteActual.motivoConsulta ?? "—")
                Divider().padding(.horizontal, 16)
                infoRow(label: "Medicamentos", valor: pacienteActual.medicamentos ?? "—")
            }
            .background(Color.white).cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    func infoRow(label: String, valor: String) -> some View {
        HStack(alignment: .top) {
            Text(label).font(.system(size: 12)).foregroundColor(gris).frame(width: 100, alignment: .leading)
            Text(valor).font(.system(size: 13, weight: .medium)).foregroundColor(verdeO).fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }

    // MARK: — Historial
    var historialSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("HISTORIAL DE CONSULTAS").font(.system(size: 10, weight: .semibold)).foregroundColor(gris).kerning(0.8)

            if cargandoHistorial {
                ProgressView().tint(verdeO).frame(maxWidth: .infinity)
            } else if historial.isEmpty {
                Text("No hay consultas registradas")
                    .font(.system(size: 13)).foregroundColor(gris)
                    .padding(16).frame(maxWidth: .infinity)
                    .background(Color.white).cornerRadius(16)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(historial.enumerated()), id: \.offset) { index, consulta in
                        historialRow(consulta: consulta)
                        if index < historial.count - 1 {
                            Divider().padding(.horizontal, 16)
                        }
                    }
                }
                .background(Color.white).cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
            }
        }
    }

    func historialRow(consulta: ConsultaAPI) -> some View {
        NavigationLink(destination: DetalleConsultaView(consulta: ConsultaAPI2(
            idConsulta:     consulta.idConsulta,
            idPaciente:     consulta.idPaciente,
            nombrePaciente: pacienteActual.nombreCompleto,
            fechaConsulta:  consulta.fechaConsulta,
            pesoKg:         consulta.pesoKg,
            imc:            consulta.imc,
            tipoConsulta:   consulta.tipoConsulta
        ))) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(fechaFormateada(consulta.fechaConsulta ?? ""))
                        .font(.system(size: 13, weight: .medium)).foregroundColor(verdeO)
                    HStack(spacing: 12) {
                        if let peso = consulta.pesoKg {
                            Label("\(String(format: "%.1f", peso)) kg", systemImage: "scalemass.fill")
                                .font(.system(size: 11)).foregroundColor(gris)
                        }
                        if let imc = consulta.imc {
                            Label("IMC \(String(format: "%.1f", imc))", systemImage: "heart.text.square.fill")
                                .font(.system(size: 11)).foregroundColor(verdeM)
                        }
                        if let tipo = consulta.tipoConsulta {
                            Text(tipo)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(tipo == "Primera vez" ? terra : verdeM)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background((tipo == "Primera vez" ? terra : verdeM).opacity(0.12))
                                .cornerRadius(6)
                        }
                    }
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(gris)
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }

    func fechaFormateada(_ fecha: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "es_MX")
        if let date = formatter.date(from: fecha) {
            let out = DateFormatter()
            out.dateFormat = "d 'de' MMMM, yyyy"
            out.locale = Locale(identifier: "es_MX")
            return out.string(from: date)
        }
        return fecha
    }

    func estatusBadge(_ estatus: String) -> some View {
        let (label, color): (String, Color) = {
            switch estatus {
            case "en_meta":  return ("En meta", verdeM)
            case "atencion": return ("Atención", terra)
            default:         return ("En proceso", Color(hex: "E8A020"))
            }
        }()
        return Text(label)
            .font(.system(size: 10, weight: .semibold)).foregroundColor(color)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.12)).cornerRadius(8)
    }

    func colorEstatus(_ estatus: String) -> Color {
        switch estatus {
        case "en_meta":  return verdeM
        case "atencion": return terra
        default:         return Color(hex: "E8A020")
        }
    }
}

struct ConsultaResumen: Identifiable {
    let id    = UUID()
    let fecha: String
    let peso:  Double
}

#Preview {
    NavigationStack {
        PerfilPacienteView(paciente: PacienteAPI(
            idPaciente: 1, idUsuario: 1,
            nombreCompleto: "Ana García López",
            edad: 26, genero: "F",
            objetivo: "Bajar grasa corporal",
            estatus: "en_proceso"
        ))
    }
}
