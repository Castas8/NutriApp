//
//  NuevaConsultaView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct NuevaConsultaView: View {
    @Environment(\.dismiss) var dismiss

    var paciente: PacienteAPI? = nil
    var onGuardar: (() -> Void)? = nil
    var esPrimerRegistro: Bool = false

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    var pacienteEdad: Double   { Double(paciente?.edad ?? 28) }
    var pacienteGenero: String { paciente?.genero ?? "F" }
    var nombreCorto: String    { paciente?.nombreCompleto?.components(separatedBy: " ").first ?? "" }

    @State private var peso: String  = ""
    @State private var talla: String = ""
    @State private var pctMusculo:    String = ""
    @State private var pctGrasa:      String = ""
    @State private var grasaVisceral: String = ""
    @State private var bodyAge:       String = ""
    @State private var circBrazoRel:  String = ""
    @State private var circBrazoCon:  String = ""
    @State private var circCintura:   String = ""
    @State private var circCadera:    String = ""
    @State private var circPecho:     String = ""
    @State private var plicoTriceps:  String = ""
    @State private var plicoBiceps:   String = ""
    @State private var plicoAbdominal:String = ""
    @State private var plicoSubescap: String = ""
    @State private var plicoCrestaIl: String = ""
    @State private var tabR24 = 0
    @State private var desayuno       = ""
    @State private var colacionManana = ""
    @State private var comida         = ""
    @State private var colacionTarde  = ""
    @State private var cena           = ""
    @State private var horaDesayunoDate  = Calendar.current.date(bySettingHour: 8,  minute: 0,  second: 0, of: Date())!
    @State private var horaColMananaDate = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date())!
    @State private var horaComidaDate    = Calendar.current.date(bySettingHour: 14, minute: 0,  second: 0, of: Date())!
    @State private var horaColTardeDate  = Calendar.current.date(bySettingHour: 17, minute: 0,  second: 0, of: Date())!
    @State private var horaCenaDate      = Calendar.current.date(bySettingHour: 20, minute: 0,  second: 0, of: Date())!
    @State private var af: Double      = 1.2
    @State private var pctHDC: Double  = 50
    @State private var pctLip: Double  = 25
    @State private var pctProt: Double = 25
    @State private var notasClinicas = ""
    @State private var expandDatos  = true
    @State private var expandOmron  = true
    @State private var expandPlico  = true
    @State private var expandR24    = true
    @State private var expandMacros = true
    @State private var expandNotas  = true
    @State private var irAPlan   = false
    @State private var guardando = false
    @State private var errorMsg  = ""

    let nivelesAF: [(String, Double)] = [
        ("Sedentario", 1.2), ("Ligeramente activo", 1.375),
        ("Moderadamente activo", 1.55), ("Muy activo", 1.725), ("Extra activo", 1.9),
    ]
    let tabsR24 = ["DES", "COL AM", "COM", "COL PM", "CEN"]

    var pesoD:  Double { Double(peso)  ?? 0 }
    var tallaD: Double { Double(talla) ?? 0 }
    var tallaM: Double { tallaD / 100 }
    var imc: Double {
        guard tallaM > 0 else { return 0 }
        return pesoD / (tallaM * tallaM)
    }
    var geb: Double {
        guard pesoD > 0, tallaD > 0 else { return 0 }
        return pacienteGenero == "M"
            ? 66.5 + (13.75 * pesoD) + (5.003 * tallaD) - (6.775 * pacienteEdad)
            : 655.1 + (9.563 * pesoD) + (1.850 * tallaD) - (4.676 * pacienteEdad)
    }
    var eta: Double { geb * 0.10 }
    var get: Double { (geb * af) + eta }
    var kcalHDC:  Double { return get * (pctHDC  / 100) }
    var kcalLip:  Double { return get * (pctLip  / 100) }
    var kcalProt: Double { return get * (pctProt / 100) }
    var gramosHDC:  Double { kcalHDC / 4 }
    var gramosLip:  Double { kcalLip / 9 }
    var gramosProt: Double { kcalProt / 4 }
    var totalPct: Double { pctHDC + pctLip + pctProt }
    var equilibrado: Bool { abs(totalPct - 100) < 0.1 }

    // MARK: — Validación completa
    func validarFormulario() -> String? {
        if peso.isEmpty  { return "El peso es requerido" }
        if talla.isEmpty { return "La talla es requerida" }
        if pctMusculo.isEmpty    { return "El % de músculo es requerido" }
        if pctGrasa.isEmpty      { return "El % de grasa es requerido" }
        if grasaVisceral.isEmpty { return "La grasa visceral es requerida" }
        if bodyAge.isEmpty       { return "El body age es requerido" }
        if circBrazoRel.isEmpty  { return "La circunferencia de brazo relajado es requerida" }
        if circBrazoCon.isEmpty  { return "La circunferencia de brazo contraído es requerida" }
        if circCintura.isEmpty   { return "La circunferencia de cintura es requerida" }
        if circCadera.isEmpty    { return "La circunferencia de cadera es requerida" }
        if circPecho.isEmpty     { return "La circunferencia de pecho es requerida" }
        if plicoTriceps.isEmpty   { return "La plicometría de tríceps es requerida" }
        if plicoBiceps.isEmpty    { return "La plicometría de bíceps es requerida" }
        if plicoAbdominal.isEmpty { return "La plicometría abdominal es requerida" }
        if plicoSubescap.isEmpty  { return "La plicometría subescapular es requerida" }
        if plicoCrestaIl.isEmpty  { return "La plicometría de cresta ilíaca es requerida" }
        if desayuno.isEmpty       { return "El recordatorio de desayuno es requerido" }
        if colacionManana.isEmpty { return "El recordatorio de colación AM es requerido" }
        if comida.isEmpty         { return "El recordatorio de comida es requerido" }
        if colacionTarde.isEmpty  { return "El recordatorio de colación PM es requerido" }
        if cena.isEmpty           { return "El recordatorio de cena es requerido" }
        if notasClinicas.isEmpty  { return "Las notas clínicas son requeridas" }
        return nil
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    // Card paciente
                    if let p = paciente {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(verdeM.opacity(0.15))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String((p.nombreCompleto ?? "?").prefix(1)))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(verdeM)
                                )
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.nombreCompleto ?? "Paciente")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(verdeO)
                                Text("\(p.edad ?? 0) años · \(p.genero == "M" ? "Masculino" : "Femenino")")
                                    .font(.system(size: 12)).foregroundColor(gris)
                            }
                            Spacer()
                        }
                        .padding(12).background(Color.white).cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }

                    cardSection(titulo: "DATOS BÁSICOS", expandido: $expandDatos) {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                campoNumerico("Peso (kg)", placeholder: "70.0", text: $peso)
                                campoNumerico("Talla (cm)", placeholder: "175", text: $talla)
                            }
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("IMC").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                                    Text(imc > 0 ? String(format: "%.1f", imc) : "—")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(imc > 0 ? verdeO : gris)
                                        .frame(maxWidth: .infinity).padding(12)
                                        .background(imc > 0 ? menta.opacity(0.25) : Color.white).cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                                }.frame(maxWidth: .infinity)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Clasificación").font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
                                    Text(clasificacionIMC(imc))
                                        .font(.system(size: 13, weight: .medium)).foregroundColor(colorIMC(imc))
                                        .frame(maxWidth: .infinity).padding(12)
                                        .background(Color.white).cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }

                    cardSection(titulo: "MEDIDAS OMRON", expandido: $expandOmron) {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                campoNumerico("% Músculo", placeholder: "32.5", text: $pctMusculo)
                                campoNumerico("% Grasa",   placeholder: "18.2", text: $pctGrasa)
                            }
                            HStack(spacing: 12) {
                                campoNumerico("Grasa Visceral", placeholder: "4",  text: $grasaVisceral)
                                campoNumerico("Body Age",       placeholder: "28", text: $bodyAge)
                            }
                            Text("Circunferencias (cm)").font(.system(size: 11, weight: .semibold)).foregroundColor(gris).frame(maxWidth: .infinity, alignment: .leading)
                            filaCirc("Brazo relajado",  text: $circBrazoRel)
                            filaCirc("Brazo contraído", text: $circBrazoCon)
                            filaCirc("Cintura",         text: $circCintura)
                            filaCirc("Cadera",          text: $circCadera)
                            filaCirc("Pecho",           text: $circPecho)
                        }
                    }

                    cardSection(titulo: "PLICOMETRÍA", expandido: $expandPlico) {
                        VStack(spacing: 12) {
                            HStack(spacing: 10) {
                                campoPlico("TRÍCEPS",    text: $plicoTriceps)
                                campoPlico("BÍCEPS",     text: $plicoBiceps)
                                campoPlico("ABDOMINAL",  text: $plicoAbdominal)
                            }
                            HStack(spacing: 10) {
                                campoPlico("SUBESCAP.",  text: $plicoSubescap)
                                campoPlico("CRESTA IL.", text: $plicoCrestaIl)
                                Spacer().frame(maxWidth: .infinity)
                            }
                        }
                    }

                    cardSection(titulo: "RECORDATORIO 24HRS", expandido: $expandR24) {
                        VStack(spacing: 12) {
                            HStack(spacing: 6) {
                                ForEach(Array(tabsR24.enumerated()), id: \.offset) { i, tab in
                                    Button { tabR24 = i } label: {
                                        Text(tab).font(.system(size: 11, weight: .medium))
                                            .foregroundColor(tabR24 == i ? verdeO : gris)
                                            .padding(.horizontal, 10).padding(.vertical, 6)
                                            .background(tabR24 == i ? Color.white : Color.clear).cornerRadius(8)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(tabR24 == i ? menta : Color.clear, lineWidth: 1))
                                    }
                                }
                            }
                            .padding(4).background(arena.opacity(0.5)).cornerRadius(10)

                            HStack(spacing: 10) {
                                Image(systemName: "clock").foregroundColor(gris)
                                DatePicker("", selection: bindingHoraTab(tabR24), displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.compact).labelsHidden().tint(verdeO)
                                Spacer()
                            }
                            .padding(12).background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))

                            ZStack(alignment: .topLeading) {
                                let binding = bindingR24(tabR24)
                                if binding.wrappedValue.isEmpty {
                                    Text("Describe los alimentos consumidos, porciones y método de preparación...")
                                        .font(.system(size: 13)).foregroundColor(gris).padding(12)
                                }
                                TextEditor(text: binding).font(.system(size: 13)).frame(height: 100).padding(8)
                            }
                            .background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                        }
                    }

                    cardSection(titulo: "DISTRIBUCIÓN MACROS", expandido: $expandMacros) {
                        VStack(spacing: 14) {
                            HStack(spacing: 8) {
                                macroChip("GEB",  valor: geb > 0 ? "\(Int(geb))"      : "—", destacado: false)
                                macroChip("AF",   valor: String(format: "%.3g", af),           destacado: false)
                                macroChip("ETA",  valor: geb > 0 ? "\(Int(eta)) kcal" : "—", destacado: false)
                                macroChip("GET",  valor: get > 0 ? "\(Int(get))"      : "—", destacado: true)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Factor de actividad").font(.system(size: 11, weight: .medium)).foregroundColor(gris)
                                Picker("AF", selection: $af) {
                                    ForEach(nivelesAF, id: \.1) { Text($0.0).tag($0.1) }
                                }
                                .pickerStyle(.menu).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                                .background(Color.white).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(menta, lineWidth: 0.8))
                            }
                            VStack(spacing: 0) {
                                HStack {
                                    Text("MACRO").frame(maxWidth: .infinity, alignment: .leading)
                                    Text("%").frame(width: 60, alignment: .center)
                                    Text("KCAL").frame(width: 60, alignment: .center)
                                    Text("G").frame(width: 50, alignment: .center)
                                }
                                .font(.system(size: 10, weight: .semibold)).foregroundColor(gris)
                                .padding(.horizontal, 12).padding(.vertical, 8).background(arena.opacity(0.4)).cornerRadius(8)
                                macroFila("HDC",      pct: $pctHDC,  kcal: kcalHDC,  gramos: gramosHDC)
                                Divider().padding(.horizontal, 8)
                                macroFila("Lípidos",  pct: $pctLip,  kcal: kcalLip,  gramos: gramosLip)
                                Divider().padding(.horizontal, 8)
                                macroFila("Proteína", pct: $pctProt, kcal: kcalProt, gramos: gramosProt)
                            }
                            .background(Color.white).cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                            HStack {
                                Text("Total \(Int(totalPct))%").font(.system(size: 12, weight: .semibold)).foregroundColor(equilibrado ? verdeO : terra)
                                Spacer()
                                Text(equilibrado ? "Equilibrado" : "Ajustar %").font(.system(size: 12, weight: .medium)).foregroundColor(equilibrado ? verdeM : terra)
                            }
                            GeometryReader { geo in
                                HStack(spacing: 0) {
                                    Rectangle().fill(verdeO).frame(width: geo.size.width * CGFloat(pctHDC / 100))
                                    Rectangle().fill(verdeM).frame(width: geo.size.width * CGFloat(pctLip / 100))
                                    Rectangle().fill(terra).frame(width: geo.size.width * CGFloat(pctProt / 100))
                                }
                                .frame(height: 8).cornerRadius(4)
                            }
                            .frame(height: 8)
                        }
                    }

                    cardSection(titulo: "NOTAS CLÍNICAS", expandido: $expandNotas) {
                        ZStack(alignment: .topLeading) {
                            if notasClinicas.isEmpty {
                                Text("Observaciones generales, antecedentes, síntomas reportados...")
                                    .font(.system(size: 13)).foregroundColor(gris).padding(12)
                            }
                            TextEditor(text: $notasClinicas).font(.system(size: 13)).frame(height: 100).padding(8)
                        }
                        .background(Color.white).cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
                    }

                    if !errorMsg.isEmpty {
                        Text(errorMsg)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(terra)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }

                    VStack(spacing: 10) {
                        Button {
                            if let error = validarFormulario() {
                                errorMsg = error
                                return
                            }
                            guardarYGenerarPlan()
                        } label: {
                            HStack(spacing: 8) {
                                if guardando { ProgressView().tint(.white).scaleEffect(0.8) }
                                Image(systemName: "sparkles")
                                Text(guardando ? "Guardando..." : "Generar Plan con IA")
                                    .font(.system(size: 15, weight: .semibold))
                                Image(systemName: "sparkles")
                            }
                            .foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(terra).cornerRadius(12)
                        }
                        .disabled(guardando)

                        Button {
                            if let error = validarFormulario() {
                                errorMsg = error
                                return
                            }
                            if esPrimerRegistro {
                                guardarPacienteYConsulta()
                            } else {
                                guardarConsulta { dismiss() }
                            }
                        } label: {
                            Text(guardando ? "Guardando..." : (esPrimerRegistro ? "Guardar y Registrar" : "Guardar Consulta"))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(verdeO)
                                .cornerRadius(12)
                        }
                        .disabled(guardando)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 16).padding(.top, 12)
            }
        }
        .navigationTitle(paciente != nil ? "Consulta · \(nombreCorto)" : "Nueva Consulta")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
        }
        .navigationDestination(isPresented: $irAPlan) {
            let nombre = paciente?.nombreCompleto ?? "Paciente"
            let cals   = Int(get)
            PlanNutricionalView(
                nombrePaciente:   nombre,
                caloriasObjetivo: cals,
                getVal:           get,
                gramosHDC:        gramosHDC,
                gramosLip:        gramosLip,
                gramosProt:       gramosProt
            )
        }
    }

    // MARK: — Guardar consulta (seguimiento)
    func guardarConsulta(completion: @escaping () -> Void) {
        guardando = true
        errorMsg  = ""

        let consulta = ConsultaAPI(
            idPaciente:         paciente?.idPaciente ?? 1,
            pesoKg:             pesoD,
            tallaCm:            Int(tallaD),
            imc:                imc,
            porcentajeMusculo:  Double(pctMusculo),
            porcentajeGrasa:    Double(pctGrasa),
            grasaVisceral:      Double(grasaVisceral),
            bodyAge:            Int(bodyAge),
            circBrazoRelajado:  Double(circBrazoRel),
            circBrazoContraido: Double(circBrazoCon),
            circCintura:        Double(circCintura),
            circCadera:         Double(circCadera),
            circPecho:          Double(circPecho),
            plicoTriceps:       Double(plicoTriceps),
            plicoBiceps:        Double(plicoBiceps),
            plicoAbdominal:     Double(plicoAbdominal),
            plicoSubescapular:  Double(plicoSubescap),
            notasClinicas:      notasClinicas,
            tipoConsulta:       "Seguimiento"
        )

        guard let body = try? JSONEncoder().encode(consulta) else {
            guardando = false
            errorMsg  = "Error al preparar los datos"
            return
        }

        APIService.shared.request(
            endpoint: "consultas/insert",
            method:   "POST",
            body:     body
        ) { (result: Result<ConsultaAPI, Error>) in
            guardando = false
            switch result {
            case .success:
                onGuardar?()
                completion()
            case .failure:
                errorMsg = "No se pudo guardar la consulta"
            }
        }
    }

    // MARK: — Guardar paciente + consulta (primer registro)
    func guardarPacienteYConsulta() {
        guard let p = paciente else { return }
        guardando = true
        errorMsg = ""

        guard let bodyPaciente = try? JSONEncoder().encode(p) else {
            guardando = false
            errorMsg = "Error al preparar los datos"
            return
        }

        APIService.shared.request(
            endpoint: "pacientes/insert",
            method: "POST",
            body: bodyPaciente
        ) { (result: Result<PacienteAPI, Error>) in
            switch result {
            case .success(let pacienteGuardado):
                let consultaFinal = ConsultaAPI(
                    idPaciente: pacienteGuardado.idPaciente ?? 1,
                    pesoKg: self.pesoD, tallaCm: Int(self.tallaD),
                    imc: self.imc, porcentajeMusculo: Double(self.pctMusculo),
                    porcentajeGrasa: Double(self.pctGrasa),
                    grasaVisceral: Double(self.grasaVisceral),
                    bodyAge: Int(self.bodyAge),
                    circBrazoRelajado: Double(self.circBrazoRel),
                    circBrazoContraido: Double(self.circBrazoCon),
                    circCintura: Double(self.circCintura),
                    circCadera: Double(self.circCadera),
                    circPecho: Double(self.circPecho),
                    plicoTriceps: Double(self.plicoTriceps),
                    plicoBiceps: Double(self.plicoBiceps),
                    plicoAbdominal: Double(self.plicoAbdominal),
                    plicoSubescapular: Double(self.plicoSubescap),
                    notasClinicas: self.notasClinicas,
                    tipoConsulta: "Primera vez"
                )
                guard let bodyConsulta = try? JSONEncoder().encode(consultaFinal) else {
                    self.guardando = false
                    self.errorMsg = "Error al preparar consulta"
                    return
                }
                APIService.shared.request(
                    endpoint: "consultas/insert",
                    method: "POST",
                    body: bodyConsulta
                ) { (r: Result<ConsultaAPI, Error>) in
                    self.guardando = false
                    switch r {
                    case .success:
                        self.onGuardar?()
                        NotificationCenter.default.post(name: NSNotification.Name("irAHome"), object: nil)
                        self.dismiss()
                    case .failure:
                        self.errorMsg = "Paciente guardado pero falló la consulta"
                    }
                }
            case .failure:
                self.guardando = false
                self.errorMsg = "No se pudo guardar el paciente"
            }
        }
    }

    func guardarYGenerarPlan() {
        irAPlan = true
    }

    func cardSection<Content: View>(titulo: String, expandido: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { expandido.wrappedValue.toggle() }
            } label: {
                HStack {
                    Text(titulo).font(.system(size: 11, weight: .semibold)).foregroundColor(verdeO).kerning(0.6)
                    Spacer()
                    Image(systemName: expandido.wrappedValue ? "chevron.up" : "chevron.down").font(.system(size: 12)).foregroundColor(gris)
                }
                .padding(.horizontal, 16).padding(.vertical, 14)
            }
            if expandido.wrappedValue {
                Divider().padding(.horizontal, 16)
                content().padding(16)
            }
        }
        .background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    func campoNumerico(_ label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12, weight: .medium)).foregroundColor(verdeM)
            TextField(placeholder, text: text)
                .font(.system(size: 14)).keyboardType(.decimalPad).padding(12)
                .background(Color.white).cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(menta, lineWidth: 0.8))
        }.frame(maxWidth: .infinity)
    }

    func filaCirc(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label).font(.system(size: 13)).foregroundColor(verdeO)
            Spacer()
            TextField("0", text: text).font(.system(size: 13, weight: .semibold)).foregroundColor(verdeO)
                .keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 60)
            Text("cm").font(.system(size: 12)).foregroundColor(gris)
        }
    }

    func campoPlico(_ label: String, text: Binding<String>) -> some View {
        VStack(spacing: 6) {
            Text(label).font(.system(size: 9, weight: .semibold)).foregroundColor(gris).kerning(0.3)
            TextField("0", text: text).font(.system(size: 16, weight: .semibold)).foregroundColor(verdeO)
                .keyboardType(.decimalPad).multilineTextAlignment(.center).padding(10)
                .background(Color.white).cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(menta, lineWidth: 0.8))
        }.frame(maxWidth: .infinity)
    }

    func macroChip(_ label: String, valor: String, destacado: Bool) -> some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 10, weight: .medium)).foregroundColor(destacado ? .white : gris)
            Text(valor).font(.system(size: 15, weight: .bold)).foregroundColor(destacado ? .white : verdeO)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10)
        .background(destacado ? verdeM : arena.opacity(0.5)).cornerRadius(10)
    }

    func macroFila(_ nombre: String, pct: Binding<Double>, kcal: Double, gramos: Double) -> some View {
        HStack {
            Text(nombre).font(.system(size: 13, weight: .medium)).foregroundColor(verdeO).frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 4) {
                Text("\(Int(pct.wrappedValue))").font(.system(size: 13, weight: .semibold)).foregroundColor(verdeO).frame(width: 30, alignment: .trailing)
                VStack(spacing: 1) {
                    Button { if pct.wrappedValue < 100 { pct.wrappedValue += 1 } } label: {
                        Image(systemName: "chevron.up").font(.system(size: 8, weight: .bold)).foregroundColor(verdeM)
                    }
                    Button { if pct.wrappedValue > 0 { pct.wrappedValue -= 1 } } label: {
                        Image(systemName: "chevron.down").font(.system(size: 8, weight: .bold)).foregroundColor(verdeM)
                    }
                }
            }.frame(width: 60, alignment: .center)
            Text(get > 0 ? "\(Int(kcal))" : "—").font(.system(size: 13)).foregroundColor(gris).frame(width: 60, alignment: .center)
            Text(get > 0 ? "\(Int(gramos))" : "—").font(.system(size: 13)).foregroundColor(gris).frame(width: 50, alignment: .center)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
    }

    func clasificacionIMC(_ imc: Double) -> String {
        if imc == 0 { return "—" }
        if imc < 18.5 { return "Bajo peso" }
        if imc < 25.0 { return "Normal" }
        if imc < 30.0 { return "Sobrepeso" }
        return "Obesidad"
    }

    func colorIMC(_ imc: Double) -> Color {
        if imc == 0   { return gris }
        if imc < 18.5 { return Color(hex: "E8A020") }
        if imc < 25   { return verdeM }
        if imc < 30   { return Color(hex: "E8A020") }
        return terra
    }

    func bindingR24(_ tab: Int) -> Binding<String> {
        switch tab {
        case 0: return $desayuno; case 1: return $colacionManana
        case 2: return $comida;   case 3: return $colacionTarde
        default: return $cena
        }
    }

    func bindingHoraTab(_ tab: Int) -> Binding<Date> {
        switch tab {
        case 0: return $horaDesayunoDate; case 1: return $horaColMananaDate
        case 2: return $horaComidaDate;   case 3: return $horaColTardeDate
        default: return $horaCenaDate
        }
    }
}

#Preview {
    NavigationStack { NuevaConsultaView() }
}
