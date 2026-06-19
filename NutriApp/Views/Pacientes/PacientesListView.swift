//
//  PacientesListView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct PacientesListView: View {

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var busqueda              = ""
    @State private var filtroEstatus         = "Todos"
    @State private var irANuevoPaciente      = false
    @State private var pacienteSeleccionado: PacienteAPI? = nil
    @State private var pacientes: [PacienteAPI] = []
    @State private var cargando              = false
    @State private var errorMsg              = ""

    let filtros = ["Todos", "En proceso", "En meta", "Atención"]

    var pacientesFiltrados: [PacienteAPI] {
        pacientes.filter { p in
            let coincideBusqueda = busqueda.isEmpty ||
                (p.nombreCompleto ?? "").localizedCaseInsensitiveContains(busqueda)
            let coincideFiltro: Bool
            switch filtroEstatus {
            case "En proceso": coincideFiltro = p.estatus == "en_proceso"
            case "En meta":    coincideFiltro = p.estatus == "en_meta"
            case "Atención":   coincideFiltro = p.estatus == "atencion"
            default:           coincideFiltro = true
            }
            return coincideBusqueda && coincideFiltro
        }
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 0) {

                // Buscador
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundColor(gris)
                    TextField("Buscar paciente...", text: $busqueda)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Filtros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filtros, id: \.self) { filtro in
                            Button { filtroEstatus = filtro } label: {
                                Text(filtro)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(filtroEstatus == filtro ? .white : gris)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .background(filtroEstatus == filtro ? verdeO : Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                .padding(.bottom, 4)

                // Estados
                if cargando {
                    Spacer()
                    ProgressView("Cargando pacientes...")
                        .tint(verdeO)
                    Spacer()
                } else if !errorMsg.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 36))
                            .foregroundColor(arena)
                        Text(errorMsg)
                            .font(.system(size: 14))
                            .foregroundColor(gris)
                        Button { cargarPacientes() } label: {
                            Text("Reintentar")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(verdeO)
                        }
                    }
                    Spacer()
                } else if pacientesFiltrados.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "person.slash")
                            .font(.system(size: 36))
                            .foregroundColor(arena)
                        Text("No se encontraron pacientes")
                            .font(.system(size: 14))
                            .foregroundColor(gris)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(pacientesFiltrados) { paciente in
                                Button {
                                    pacienteSeleccionado = paciente
                                } label: {
                                    pacienteCard(paciente: paciente)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }

            // FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button { irANuevoPaciente = true } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                            Text("Nuevo paciente")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(verdeO)
                        .cornerRadius(30)
                        .shadow(color: verdeO.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationTitle("Pacientes")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { cargarPacientes() }
        
        .navigationDestination(isPresented: $irANuevoPaciente) {
            NuevoPacienteView(onGuardar: { cargarPacientes() })
        }
        .navigationDestination(item: $pacienteSeleccionado) { paciente in
            PerfilPacienteView(paciente: paciente)
        }
    }

    // MARK: — Cargar pacientes del backend
    func cargarPacientes() {
        cargando = true
        errorMsg = ""
        APIService.shared.request(
            endpoint: "pacientes/getByUsuario/1"
        ) { (result: Result<[PacienteAPI], Error>) in
            cargando = false
            switch result {
            case .success(let lista):
                pacientes = lista
            case .failure:
                errorMsg = "No se pudo conectar al servidor"
            }
        }
    }

    // MARK: — Card
    func pacienteCard(paciente: PacienteAPI) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(colorEstatus(paciente.estatus ?? "").opacity(0.15))
                .frame(width: 46, height: 46)
                .overlay(
                    Text(String((paciente.nombreCompleto ?? "?").prefix(1)))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(colorEstatus(paciente.estatus ?? ""))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(paciente.nombreCompleto ?? "Sin nombre")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(verdeO)
                Text("\(paciente.edad ?? 0) años · \(paciente.genero == "M" ? "Masculino" : "Femenino")")
                    .font(.system(size: 12))
                    .foregroundColor(gris)
                Text("Objetivo: \(paciente.objetivo ?? "No especificado")")
                    .font(.system(size: 11))
                    .foregroundColor(gris)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                estatusBadge(paciente.estatus ?? "")
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(gris)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
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
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.12))
            .cornerRadius(8)
    }

    func colorEstatus(_ estatus: String) -> Color {
        switch estatus {
        case "en_meta":  return verdeM
        case "atencion": return terra
        default:         return Color(hex: "E8A020")
        }
    }
}

#Preview {
    NavigationStack {
        PacientesListView()
    }
}
