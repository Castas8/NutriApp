//
//  ConsultasListView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

// MARK: — Modelo API
struct ConsultaAPI2: Identifiable, Codable, Hashable {
    var id: Int? { idConsulta }
    var idConsulta:     Int?
    var idPaciente:     Int?
    var nombrePaciente: String?
    var fechaConsulta:  String?
    var pesoKg:         Double?
    var imc:            Double?
    var tipoConsulta:   String?

    enum CodingKeys: String, CodingKey {
        case idConsulta     = "idConsulta"
        case idPaciente     = "idPaciente"
        case nombrePaciente = "nombreCompleto"
        case fechaConsulta  = "fechaConsulta"
        case pesoKg         = "pesoKg"
        case imc            = "imc"
        case tipoConsulta   = "tipoConsulta"
    }
}

// MARK: — Vista principal
struct ConsultasListView: View {

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    @State private var busqueda   = ""
    @State private var filtroTipo = "Todos"
    @State private var consultas: [ConsultaAPI2] = []
    @State private var cargando   = true
    @State private var error      = false
    @State private var consultaSeleccionada: ConsultaAPI2? = nil

    let filtros = ["Todos", "Seguimiento", "Primera vez"]

    var consultasFiltradas: [ConsultaAPI2] {
        consultas.filter { c in
            let coincideBusqueda = busqueda.isEmpty ||
                (c.nombrePaciente ?? "").localizedCaseInsensitiveContains(busqueda)
            let coincideTipo = filtroTipo == "Todos" ||
                (c.tipoConsulta ?? "") == filtroTipo
            return coincideBusqueda && coincideTipo
        }
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            VStack(spacing: 0) {
                // Buscador
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass").font(.system(size: 15)).foregroundColor(gris)
                    TextField("Buscar por paciente...", text: $busqueda)
                        .font(.system(size: 14)).autocapitalization(.none)
                }
                .padding(12).background(Color.white).cornerRadius(12)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 20).padding(.top, 12)

                // Filtros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(filtros, id: \.self) { filtro in
                            Button { filtroTipo = filtro } label: {
                                Text(filtro)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(filtroTipo == filtro ? .white : gris)
                                    .padding(.horizontal, 14).padding(.vertical, 7)
                                    .background(filtroTipo == filtro ? verdeO : Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10).padding(.bottom, 4)

                if cargando {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView().tint(verdeO).scaleEffect(1.2)
                        Text("Cargando consultas...").font(.system(size: 13)).foregroundColor(gris)
                    }
                    Spacer()
                } else if error {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.slash").font(.system(size: 36)).foregroundColor(arena)
                        Text("No se pudieron cargar las consultas").font(.system(size: 14)).foregroundColor(gris)
                        Button { Task { await cargarConsultas() } } label: {
                            Text("Reintentar")
                                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(verdeO).cornerRadius(10)
                        }
                    }
                    Spacer()
                } else if consultasFiltradas.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "calendar.badge.minus").font(.system(size: 36)).foregroundColor(arena)
                        Text("No se encontraron consultas").font(.system(size: 14)).foregroundColor(gris)
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 10) {
                            ForEach(consultasFiltradas) { consulta in
                                Button { consultaSeleccionada = consulta } label: {
                                    consultaCard(consulta: consulta)
                                }
                            }
                        }
                        .padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 32)
                    }
                }
            }
        }
        .navigationTitle("Consultas")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(item: $consultaSeleccionada) { consulta in
            DetalleConsultaView(consulta: consulta)
        }
        .task { await cargarConsultas() }
    }

    // MARK: — Cargar desde Railway
    func cargarConsultas() async {
        await MainActor.run { cargando = true; error = false }

        let urlString = "https://nutriapp-production-fee6.up.railway.app/api/consultas/getAll"
        guard let url = URL(string: urlString) else {
            await MainActor.run { error = true; cargando = false }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode([ConsultaAPI2].self, from: data)
            await MainActor.run {
                consultas = resultado.sorted { ($0.idConsulta ?? 0) > ($1.idConsulta ?? 0) }
                cargando = false
            }
        } catch {
            print("❌ Error consultas: \(error)")
            await MainActor.run { self.error = true; cargando = false }
        }
    }

    // MARK: — Card
    func consultaCard(consulta: ConsultaAPI2) -> some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(diaDeConsulta(consulta.fechaConsulta ?? ""))
                    .font(.system(size: 22, weight: .bold)).foregroundColor(.white)
                Text(mesDeConsulta(consulta.fechaConsulta ?? ""))
                    .font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.85))
            }
            .frame(width: 52, height: 58).background(verdeO).cornerRadius(14)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(consulta.nombrePaciente ?? "Paciente")
                        .font(.system(size: 15, weight: .semibold)).foregroundColor(verdeO)
                    Spacer()
                    tipoBadge(consulta.tipoConsulta ?? "")
                }
                HStack(spacing: 12) {
                    Label("\(String(format: "%.1f", consulta.pesoKg ?? 0)) kg", systemImage: "scalemass.fill")
                        .font(.system(size: 12)).foregroundColor(gris)
                    Label("IMC \(String(format: "%.1f", consulta.imc ?? 0))", systemImage: "heart.text.square.fill")
                        .font(.system(size: 12)).foregroundColor(colorIMC(consulta.imc ?? 0))
                }
            }
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundColor(gris)
        }
        .padding(14).background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    func tipoBadge(_ tipo: String) -> some View {
        Text(tipo.isEmpty ? "—" : tipo)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(tipo == "Primera vez" ? terra : verdeM)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background((tipo == "Primera vez" ? terra : verdeM).opacity(0.12))
            .cornerRadius(8)
    }

    func colorIMC(_ imc: Double) -> Color {
        if imc < 18.5 { return Color(hex: "E8A020") }
        if imc < 25   { return verdeM }
        if imc < 30   { return Color(hex: "E8A020") }
        return terra
    }

    func diaDeConsulta(_ fecha: String) -> String {
        let partes = fecha.split(separator: "T")
        let date = String(partes.first ?? "")
        let componentes = date.split(separator: "-")
        return componentes.count >= 3 ? String(componentes[2]) : "—"
    }

    func mesDeConsulta(_ fecha: String) -> String {
        let partes = fecha.split(separator: "T")
        let date = String(partes.first ?? "")
        let componentes = date.split(separator: "-")
        guard componentes.count >= 2, let mes = Int(String(componentes[1])) else { return "—" }
        let meses = ["","ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC"]
        return mes < meses.count ? meses[mes] : "—"
    }
}

// MARK: — Detalle Consulta
struct DetalleConsultaView: View {
    @Environment(\.dismiss) var dismiss
    let consulta: ConsultaAPI2

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let beige  = Color(hex: "F5EDD6")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    VStack(spacing: 8) {
                        Circle().fill(verdeM.opacity(0.15)).frame(width: 64, height: 64)
                            .overlay(
                                Text(String((consulta.nombrePaciente ?? "?").prefix(1)))
                                    .font(.system(size: 26, weight: .bold)).foregroundColor(verdeM)
                            )
                        Text(consulta.nombrePaciente ?? "Paciente")
                            .font(.system(size: 20, weight: .bold)).foregroundColor(verdeO)
                        Text(fechaFormateada(consulta.fechaConsulta ?? ""))
                            .font(.system(size: 13)).foregroundColor(gris)
                    }
                    .frame(maxWidth: .infinity).padding(20).background(Color.white).cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    HStack(spacing: 12) {
                        metricaCard(valor: String(format: "%.1f", consulta.pesoKg ?? 0), unidad: "kg", label: "Peso", color: verdeO)
                        metricaCard(valor: String(format: "%.1f", consulta.imc ?? 0),    unidad: "",   label: "IMC",  color: colorIMC(consulta.imc ?? 0))
                        metricaCard(valor: consulta.tipoConsulta ?? "—", unidad: "", label: "Tipo", color: terra)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("DATOS DE LA CONSULTA")
                            .font(.system(size: 10, weight: .semibold)).foregroundColor(gris).kerning(0.8)
                        infoRow(label: "Fecha",   valor: fechaFormateada(consulta.fechaConsulta ?? ""))
                        Divider()
                        infoRow(label: "Peso",    valor: "\(String(format: "%.1f", consulta.pesoKg ?? 0)) kg")
                        Divider()
                        infoRow(label: "IMC",     valor: String(format: "%.2f", consulta.imc ?? 0))
                        Divider()
                        infoRow(label: "Tipo",    valor: consulta.tipoConsulta ?? "—")
                    }
                    .padding(16).background(Color.white).cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    NavigationLink(destination: PlanNutricionalView(
                        nombrePaciente:   consulta.nombrePaciente ?? "Paciente",
                        caloriasObjetivo: 1914,
                        getVal:           1914,
                        gramosHDC:        239,
                        gramosLip:        53,
                        gramosProt:       119
                    )) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                            Text("Generar Plan Nutricional").font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(terra).cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20).padding(.top, 16)
            }
        }
        .navigationTitle("Detalle Consulta")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
        }
    }

    func metricaCard(valor: String, unidad: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(valor)\(unidad.isEmpty ? "" : " \(unidad)")")
                .font(.system(size: 16, weight: .bold)).foregroundColor(color).multilineTextAlignment(.center)
            Text(label).font(.system(size: 11)).foregroundColor(gris)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14).background(Color.white).cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    func infoRow(label: String, valor: String) -> some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(gris)
            Spacer()
            Text(valor).font(.system(size: 13, weight: .medium)).foregroundColor(verdeO)
        }
    }

    func colorIMC(_ imc: Double) -> Color {
        if imc < 18.5 { return Color(hex: "E8A020") }
        if imc < 25   { return verdeM }
        if imc < 30   { return Color(hex: "E8A020") }
        return terra
    }

    func fechaFormateada(_ fecha: String) -> String {
        let partes = fecha.split(separator: "T")
        let date = String(partes.first ?? Substring(fecha))
        let comp = date.split(separator: "-")
        guard comp.count == 3 else { return fecha }
        let meses = ["","Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"]
        let mes = Int(String(comp[1])) ?? 0
        return "\(String(comp[2])) \(mes < meses.count ? meses[mes] : "") \(String(comp[0]))"
    }
}

struct ConsultaLocal: Identifiable, Hashable {
    let id = UUID(); let paciente: String; let fecha: String; let peso: Double; let imc: Double; let tipo: String
}

#Preview {
    NavigationStack { ConsultasListView() }
}
