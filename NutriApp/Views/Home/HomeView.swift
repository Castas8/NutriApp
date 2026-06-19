//
//  HomeView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct HomeView: View {
    
    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    let nombreNutri = "Karla"

    @State private var selectedDate      = Date()
    @State private var weekOffset        = 0
    @State private var showNotis         = false
    @State private var showTodasCitas    = false
    @State private var showAgregarRec    = false
    @State private var showNuevaCita     = false
    @State private var irANuevoPaciente  = false

    // Recordatorios con modelo
    @State private var recordatorios: [Recordatorio] = [
        Recordatorio(descripcion: "Enviar plan de alimentación a Roberto", hora: Calendar.current.date(bySettingHour: 9,  minute: 0, second: 0, of: Date())!),
        Recordatorio(descripcion: "Confirmar asistencia curso keto",       hora: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!),
        Recordatorio(descripcion: "Revisar stock de suplementos",          hora: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!),
    ]

    @State private var nuevoDescripcion  = ""
    @State private var nuevoHora         = Date()

    let citasHoy: [CitaHome] = [
        CitaHome(hora: "10:00 AM", nombre: "Juan Pérez",    motivo: "Control de peso",  tipo: "Primera consulta", estado: .ahora),
        CitaHome(hora: "11:30 AM", nombre: "Laura Gómez",   motivo: "Plan nutricional", tipo: "Seguimiento",      estado: .siguiente),
        CitaHome(hora: "2:00 PM",  nombre: "Celia Garrido", motivo: "Consulta inicial", tipo: "Primera vez",      estado: .pendiente),
    ]

    let notificaciones: [String] = [
        "Laura Gómez tiene cita mañana a las 9am",
        "Plan de Carlos Ruiz vence esta semana",
        "3 pacientes sin consulta en el último mes",
    ]

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    headerSection
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    accesoSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    citasSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    recordatoriosSection
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    Spacer().frame(height: 40)
                }
            }
        }
        .sheet(isPresented: $showNotis)      { notisModal }
        .sheet(isPresented: $showTodasCitas) { todasCitasModal }
        .sheet(isPresented: $showAgregarRec) { agregarRecModal }
        .sheet(isPresented: $showNuevaCita)  { NuevaCitaView() }
        .navigationDestination(isPresented: $irANuevoPaciente) { NuevoPacienteView() }
    }

    // MARK: — Header
    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hola, Dr. 👋")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(verdeO)
                Text(fechaHoy())
                    .font(.system(size: 13))
                    .foregroundColor(gris)
            }
            Spacer()
            Button { showNotis = true } label: {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "bell")
                                .font(.system(size: 18))
                                .foregroundColor(verdeO)
                        )
                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                    Circle()
                        .fill(terra)
                        .frame(width: 10, height: 10)
                        .offset(x: 3, y: -3)
                }
            }
        }
    }

    // MARK: — Accesos rápidos
    var accesoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                accesoBtn(icon: "person.badge.plus.fill", label: "Nuevo\nPaciente", color: verdeO) { irANuevoPaciente = true }
                accesoBtn(icon: "calendar.badge.plus",    label: "Nueva\nCita",     color: terra)  { showNuevaCita   = true }
            }
        }
    }

    func accesoBtn(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 46, height: 46)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    )
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(verdeO)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    // MARK: — Citas de hoy
    var citasSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("CITAS DE HOY")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(gris)
                    .kerning(0.8)
                Spacer()
                Button { showTodasCitas = true } label: {
                    Text("Ver todas")
                        .font(.system(size: 12))
                        .foregroundColor(terra)
                }
            }

            VStack(spacing: 0) {
                ForEach(Array(citasHoy.enumerated()), id: \.offset) { index, cita in
                    citaRow(cita: cita)
                    if index < citasHoy.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    func citaRow(cita: CitaHome) -> some View {
        HStack(spacing: 14) {
            Text(cita.hora)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(gris)
                .frame(width: 65, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(cita.motivo)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(verdeO)
                Text("(\(cita.tipo))")
                    .font(.system(size: 11))
                    .foregroundColor(gris)
                if cita.estado == .pendiente {
                    Text(cita.nombre)
                        .font(.system(size: 12))
                        .foregroundColor(gris)
                }
            }

            Spacer()

            switch cita.estado {
            case .ahora:
                badgeLabel("AHORA", color: terra)
            case .siguiente:
                badgeLabel("SIGUIENTE", color: verdeM)
            case .pendiente:
                EmptyView()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    func badgeLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .cornerRadius(20)
    }

    // MARK: — Recordatorios
    var recordatoriosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECORDATORIOS")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(gris)
                .kerning(0.8)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(recordatorios.enumerated()), id: \.offset) { index, rec in
                    HStack(spacing: 12) {
                        // Checkbox
                        Button {
                            recordatorios[index].completado.toggle()
                        } label: {
                            Image(systemName: recordatorios[index].completado ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundColor(recordatorios[index].completado ? verdeM : gris.opacity(0.5))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(rec.descripcion)
                                .font(.system(size: 13))
                                .foregroundColor(rec.completado ? gris : verdeO)
                                .strikethrough(rec.completado, color: gris)
                            Text(horaFormateada(rec.hora))
                                .font(.system(size: 11))
                                .foregroundColor(terra)
                        }

                        Spacer()

                        Button {
                            recordatorios.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(gris.opacity(0.4))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    if index < recordatorios.count - 1 {
                        Divider().padding(.horizontal, 16)
                    }
                }

                Divider().padding(.horizontal, 16)

                HStack {
                    Spacer()
                    Button { showAgregarRec = true } label: {
                        Circle()
                            .fill(terra)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.vertical, 12)
                    Spacer()
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
    }

    // MARK: — Modal notificaciones
    var notisModal: some View {
        NavigationView {
            ZStack {
                beige.ignoresSafeArea()
                VStack(spacing: 0) {
                    ForEach(Array(notificaciones.enumerated()), id: \.offset) { index, noti in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(verdeM.opacity(0.15))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(verdeM)
                                )
                            Text(noti)
                                .font(.system(size: 14))
                                .foregroundColor(verdeO)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        if index < notificaciones.count - 1 {
                            Divider().padding(.horizontal, 20)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
            .navigationTitle("Notificaciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") { showNotis = false }
                        .foregroundColor(verdeO)
                }
            }
        }
    }

    // MARK: — Modal todas las citas
    var todasCitasModal: some View {
        NavigationView {
            ZStack {
                beige.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(citasHoy.enumerated()), id: \.offset) { index, cita in
                            citaRow(cita: cita)
                            if index < citasHoy.count - 1 {
                                Divider().padding(.horizontal, 16)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                    .padding(20)
                }
            }
            .navigationTitle("Citas de hoy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") { showTodasCitas = false }
                        .foregroundColor(verdeO)
                }
            }
        }
    }

    // MARK: — Modal agregar recordatorio
    var agregarRecModal: some View {
        NavigationView {
            ZStack {
                beige.ignoresSafeArea()
                VStack(spacing: 20) {
                    TextField("Ej. Llamar a paciente Ana...", text: $nuevoDescripcion)
                        .font(.system(size: 14))
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                        .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hora del recordatorio")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(verdeM)
                            .padding(.horizontal, 20)
                        DatePicker("", selection: $nuevoHora, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .tint(verdeO)
                            .padding(.horizontal, 20)
                    }

                    Button {
                        let trimmed = nuevoDescripcion.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            recordatorios.append(Recordatorio(descripcion: trimmed, hora: nuevoHora))
                            nuevoDescripcion = ""
                            nuevoHora = Date()
                        }
                        showAgregarRec = false
                    } label: {
                        Text("Agregar recordatorio")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(nuevoDescripcion.isEmpty ? gris : verdeO)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Nuevo recordatorio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        nuevoDescripcion = ""
                        showAgregarRec = false
                    }
                    .foregroundColor(gris)
                }
            }
        }
    }

    // MARK: — Helpers
    func fechaHoy() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "EEEE, d 'de' MMMM"
        return f.string(from: Date()).capitalized
    }

    func mesAnio() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "MMMM yyyy"
        let base = Calendar.current.date(byAdding: .weekOfYear, value: weekOffset, to: Date()) ?? Date()
        return f.string(from: base).capitalized
    }

    func diasSemana() -> [Date] {
        let cal = Calendar.current
        let hoy = cal.date(byAdding: .weekOfYear, value: weekOffset, to: Date()) ?? Date()
        let inicioSemana = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: hoy))!
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: inicioSemana) }
    }

    func horaFormateada(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "h:mm a"
        return f.string(from: date)
    }
}

// MARK: — Modelos locales
enum EstadoCita { case ahora, siguiente, pendiente }

struct CitaHome: Identifiable {
    let id    = UUID()
    let hora:   String
    let nombre: String
    let motivo: String
    let tipo:   String
    let estado: EstadoCita
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
