//
//  PlanNutricionalView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

// MARK: — Modelos de datos IA

struct PlatilloIA: Identifiable, Codable {
    let id        = UUID()
    let nombre:    String
    let calorias:  Int
    let proteina:  Double
    let hdc:       Double
    let lipidos:   Double
    let emoji:     String
    let receta:    RecetaIA

    enum CodingKeys: String, CodingKey {
        case nombre, calorias, proteina, hdc, lipidos, emoji, receta
    }
}

struct RecetaIA: Codable {
    let ingredientes: [String]
    let pasos:        [String]
    let tiempo:       String   // "25 min"
    let porcion:      String   // "1 plato"
}

struct TiempoComidaIA: Identifiable, Codable {
    let id       = UUID()
    let tiempo:   String       // "Desayuno", "Colación AM", etc.
    let emoji:    String
    let platillos: [PlatilloIA]

    enum CodingKeys: String, CodingKey {
        case tiempo, emoji, platillos
    }
}

struct RespuestaIA: Codable {
    let tiempos: [TiempoComidaIA]
}

// MARK: — Vista principal

struct PlanNutricionalView: View {
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    var nombrePaciente:   String
    var caloriasObjetivo: Int
    var getVal:           Double
    var gramosHDC:        Double
    var gramosLip:        Double
    var gramosProt:       Double

    // Contexto adicional opcional (se pasa desde NuevaConsultaView)
    var sexo:             String = "No especificado"
    var edad:             Int    = 0
    var diagnostico:      String = ""
    var restricciones:    String = ""

    @State private var tabSeleccionado  = 0
    @State private var generando        = false
    @State private var planGenerado     = false
    @State private var errorMensaje:    String? = nil
    @State private var tiemposComida:   [TiempoComidaIA] = []

    // Modal receta
    @State private var platilloSeleccionado: PlatilloIA? = nil
    @State private var mostrarReceta = false

    var tiempoActual: TiempoComidaIA? {
        guard tabSeleccionado < tiemposComida.count else { return nil }
        return tiemposComida[tabSeleccionado]
    }

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    headerSection
                    macrosSection

                    if let error = errorMensaje {
                        errorSection(mensaje: error)
                    } else if !planGenerado {
                        generarSection
                    } else {
                        tabsIASection
                        if let tiempo = tiempoActual {
                            ForEach(tiempo.platillos) { platillo in
                                platilloCardIA(platillo: platillo)
                            }
                        }
                    }

                    Button {
                        NotificationCenter.default.post(
                            name: NSNotification.Name("irAHome"), object: nil
                        )
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
                    } label: {
                        Text("Guardar Plan")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(verdeO)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Plan Nutricional")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundColor(verdeO)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {} label: {
                    Image(systemName: "square.and.arrow.up").foregroundColor(verdeO)
                }
            }
        }
        .sheet(isPresented: $mostrarReceta) {
            if let platillo = platilloSeleccionado {
                RecetaModalView(platillo: platillo)
            }
        }
    }

    // MARK: — Header
    var headerSection: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(verdeM.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(nombrePaciente.prefix(2)).uppercased())
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(verdeM)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(nombrePaciente)
                    .font(.system(size: 16, weight: .bold)).foregroundColor(verdeO)
                Text("Plan generado • \(fechaHoy())")
                    .font(.system(size: 12)).foregroundColor(gris)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(caloriasObjetivo)")
                    .font(.system(size: 20, weight: .bold)).foregroundColor(verdeO)
                Text("kcal objetivo")
                    .font(.system(size: 10)).foregroundColor(gris)
            }
        }
        .padding(16).background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: — Macros
    var macrosSection: some View {
        HStack(spacing: 10) {
            macroChip("HDC",      gramos: gramosHDC,  color: verdeO)
            macroChip("Lípidos",  gramos: gramosLip,  color: verdeM)
            macroChip("Proteína", gramos: gramosProt, color: terra)
        }
    }

    func macroChip(_ label: String, gramos: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(Int(gramos))g")
                .font(.system(size: 18, weight: .bold)).foregroundColor(color)
            Text(label)
                .font(.system(size: 11)).foregroundColor(gris)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 14)
        .background(Color.white).cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: — Sección generar
    var generarSection: some View {
        VStack(spacing: 14) {
            Image(systemName: "sparkles").font(.system(size: 32)).foregroundColor(terra)
            Text("Generar recomendación")
                .font(.system(size: 15, weight: .semibold)).foregroundColor(verdeO)
            Text("La IA analizará los datos de la consulta, preferencias alimentarias y objetivos de \(nombrePaciente) para generar 2 opciones por tiempo de comida con receta completa.")
                .font(.system(size: 12)).foregroundColor(gris).multilineTextAlignment(.center)
            Button { Task { await generarPlanIA() } } label: {
                HStack(spacing: 8) {
                    if generando {
                        ProgressView().tint(.white).scaleEffect(0.8)
                    } else {
                        Image(systemName: "sparkles")
                    }
                    Text(generando ? "Generando plan..." : "Generar recomendación ")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(terra).cornerRadius(12)
            }
            .disabled(generando)
        }
        .padding(20).background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: — Error
    func errorSection(mensaje: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle").font(.system(size: 28)).foregroundColor(terra)
            Text("No se pudo generar el plan")
                .font(.system(size: 14, weight: .semibold)).foregroundColor(verdeO)
            Text(mensaje)
                .font(.system(size: 12)).foregroundColor(gris).multilineTextAlignment(.center)
            Button { errorMensaje = nil; Task { await generarPlanIA() } } label: {
                Text("Reintentar")
                    .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(terra).cornerRadius(10)
            }
        }
        .padding(20).background(Color.white).cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: — Tabs IA
    var tabsIASection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles").font(.system(size: 12)).foregroundColor(terra)
                Text("PLAN GENERADO CON IA")
                    .font(.system(size: 10, weight: .semibold)).foregroundColor(gris).kerning(0.8)
                Spacer()
                Button {
                    planGenerado = false
                    tiemposComida = []
                    errorMensaje = nil
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 13)).foregroundColor(gris)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(tiemposComida.enumerated()), id: \.offset) { i, tiempo in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { tabSeleccionado = i }
                        } label: {
                            HStack(spacing: 4) {
                                Text(tiempo.emoji)
                                Text(tiempo.tiempo)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundColor(tabSeleccionado == i ? .white : gris)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(tabSeleccionado == i ? verdeO : Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
                        }
                    }
                }
            }
        }
    }

    // MARK: — Card platillo IA
    func platilloCardIA(platillo: PlatilloIA) -> some View {
        Button {
            platilloSeleccionado = platillo
            mostrarReceta = true
        } label: {
            HStack(spacing: 14) {
                Text(platillo.emoji)
                    .font(.system(size: 34))
                    .frame(width: 62, height: 62)
                    .background(arena.opacity(0.6))
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 6) {
                    Text(platillo.nombre)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(verdeO)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 8) {
                        Label("\(platillo.calorias) kcal", systemImage: "flame.fill")
                            .font(.system(size: 11)).foregroundColor(terra)
                        Label("\(Int(platillo.proteina))g prot", systemImage: "bolt.fill")
                            .font(.system(size: 11)).foregroundColor(verdeM)
                    }
                    HStack(spacing: 8) {
                        Text("HDC \(Int(platillo.hdc))g")
                            .font(.system(size: 10)).foregroundColor(gris)
                        Text("·").foregroundColor(gris)
                        Text("Lip \(Int(platillo.lipidos))g")
                            .font(.system(size: 10)).foregroundColor(gris)
                    }
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(gris)
                    Text("Receta")
                        .font(.system(size: 10))
                        .foregroundColor(gris)
                }
            }
            .padding(14).background(Color.white).cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: — Helpers
    func fechaHoy() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "d MMM yyyy"
        return f.string(from: Date())
    }

    // MARK: — Llamada real a Claude API
    func generarPlanIA() async {
        await MainActor.run {
            generando = true
            errorMensaje = nil
        }

        let apiKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"] ?? ""

        let prompt = """
        Eres un experto en nutrición clínica. Genera un plan de alimentación personalizado para el siguiente paciente.

        DATOS DEL PACIENTE:
        - Nombre: \(nombrePaciente)
        - Sexo: \(sexo)
        - Edad: \(edad > 0 ? "\(edad) años" : "No especificada")
        - GET (Gasto Energético Total): \(Int(getVal)) kcal/día
        - Calorías objetivo: \(caloriasObjetivo) kcal/día
        - Macronutrientes objetivo:
          * Carbohidratos: \(Int(gramosHDC))g
          * Lípidos: \(Int(gramosLip))g
          * Proteína: \(Int(gramosProt))g
        \(diagnostico.isEmpty ? "" : "- Diagnóstico/condición: \(diagnostico)")
        \(restricciones.isEmpty ? "" : "- Restricciones o preferencias: \(restricciones)")

        INSTRUCCIONES:
        - Genera exactamente 5 tiempos de comida: Desayuno, Colación AM, Comida, Colación PM, Cena
        - Para cada tiempo genera exactamente 2 opciones de platillos
        - Cada platillo debe ser práctico para México
        - Las calorías de cada platillo deben ser proporcionales: Desayuno ~25%, Colación AM ~10%, Comida ~30%, Colación PM ~10%, Cena ~25% del total diario
        - Cada receta debe tener ingredientes concretos con cantidades, pasos breves y tiempo de preparación

        Responde ÚNICAMENTE con un JSON válido, sin texto adicional, sin markdown, sin backticks. El formato debe ser exactamente:

        {
          "tiempos": [
            {
              "tiempo": "Desayuno",
              "emoji": "🌅",
              "platillos": [
                {
                  "nombre": "Nombre del platillo",
                  "calorias": 350,
                  "proteina": 20.5,
                  "hdc": 45.0,
                  "lipidos": 12.0,
                  "emoji": "🥚",
                  "receta": {
                    "ingredientes": ["2 huevos", "1/2 taza espinacas", "1 tortilla integral"],
                    "pasos": ["Bate los huevos.", "Saltea las espinacas 2 min.", "Haz el omelette a fuego medio 3 min."],
                    "tiempo": "10 min",
                    "porcion": "1 plato"
                  }
                }
              ]
            }
          ]
        }

        Emojis sugeridos por tiempo: Desayuno=🌅, Colación AM=🍎, Comida=🍽️, Colación PM=🥜, Cena=🌙
        """

        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            await MainActor.run {
                errorMensaje = "URL inválida"
                generando = false
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json",      forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey,                  forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01",            forHTTPHeaderField: "anthropic-version")
        request.timeoutInterval = 120

        let body: [String: Any] = [
            "model": "claude-sonnet-4-6",
            "max_tokens": 8192,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            await MainActor.run {
                errorMensaje = "Error al preparar la solicitud"
                generando = false
            }
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    errorMensaje = "Respuesta inválida del servidor"
                    generando = false
                }
                return
            }

            guard httpResponse.statusCode == 200 else {
                let errorBody = String(data: data, encoding: .utf8) ?? "Sin detalle"
                await MainActor.run {
                    errorMensaje = "Error del servidor (\(httpResponse.statusCode)). Verifica tu API key."
                    generando = false
                }
                print("❌ Claude API error \(httpResponse.statusCode): \(errorBody)")
                return
            }

            // Parsear respuesta de Anthropic
            guard
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let content = json["content"] as? [[String: Any]],
                let firstBlock = content.first,
                let textoJSON = firstBlock["text"] as? String
            else {
                await MainActor.run {
                    errorMensaje = "No se pudo leer la respuesta de la IA"
                    generando = false
                }
                return
            }

            // Limpiar posible markdown residual
            let jsonLimpio = textoJSON
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```",     with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            print("🤖 Respuesta Claude: \(jsonLimpio)")
            
            guard let jsonData = jsonLimpio.data(using: .utf8) else {
                await MainActor.run {
                    errorMensaje = "Error al procesar la respuesta"
                    generando = false
                }
                return
            }

            let respuesta = try JSONDecoder().decode(RespuestaIA.self, from: jsonData)

            await MainActor.run {
                tiemposComida = respuesta.tiempos
                tabSeleccionado = 0
                planGenerado = true
                generando = false
            }

        } catch let decodingError as DecodingError {
            await MainActor.run {
                errorMensaje = "Error al interpretar el plan generado. Intenta de nuevo."
                generando = false
            }
            print("❌ Decoding error: \(decodingError)")
        } catch {
            await MainActor.run {
                errorMensaje = "Sin conexión o tiempo de espera agotado. Verifica tu internet."
                generando = false
            }
            print("❌ Network error: \(error)")
        }
    }
}

// MARK: — Modal Receta

struct RecetaModalView: View {
    let platillo: PlatilloIA
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let terra  = Color(hex: "C4693A")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let gris   = Color(hex: "9E9681")
    let menta  = Color(hex: "A8C97F")

    var body: some View {
        NavigationStack {
            ZStack {
                beige.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        // Emoji grande + nombre
                        VStack(spacing: 10) {
                            Text(platillo.emoji)
                                .font(.system(size: 72))
                                .frame(width: 120, height: 120)
                                .background(arena.opacity(0.6))
                                .cornerRadius(24)

                            Text(platillo.nombre)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(verdeO)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 6) {
                                Text(platillo.receta.tiempo)
                                Text("·")
                                Text(platillo.receta.porcion)
                            }
                            .font(.system(size: 13))
                            .foregroundColor(gris)
                        }
                        .padding(.top, 8)

                        // Macros
                        HStack(spacing: 0) {
                            macroItem("\(platillo.calorias)", "kcal",  terra)
                            Divider().frame(height: 40)
                            macroItem("\(Int(platillo.proteina))g", "prot", verdeM)
                            Divider().frame(height: 40)
                            macroItem("\(Int(platillo.hdc))g",    "HDC",  verdeO)
                            Divider().frame(height: 40)
                            macroItem("\(Int(platillo.lipidos))g","lip",  gris)
                        }
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)

                        // Ingredientes
                        cardSeccion(titulo: "Ingredientes", icono: "cart.fill") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(platillo.receta.ingredientes.enumerated()), id: \.offset) { _, ing in
                                    HStack(alignment: .top, spacing: 10) {
                                        Circle()
                                            .fill(menta)
                                            .frame(width: 7, height: 7)
                                            .padding(.top, 5)
                                        Text(ing)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "3A3A3A"))
                                    }
                                }
                            }
                        }

                        // Preparación
                        cardSeccion(titulo: "Preparación", icono: "flame.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(platillo.receta.pasos.enumerated()), id: \.offset) { i, paso in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(i + 1)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                            .background(verdeO)
                                            .clipShape(Circle())
                                        Text(paso)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "3A3A3A"))
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Receta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(gris)
                            .font(.system(size: 22))
                    }
                }
            }
        }
    }

    func macroItem(_ valor: String, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(valor).font(.system(size: 16, weight: .bold)).foregroundColor(color)
            Text(label).font(.system(size: 11)).foregroundColor(gris)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    func cardSeccion<Content: View>(titulo: String, icono: String, @ViewBuilder contenido: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: icono).font(.system(size: 13)).foregroundColor(terra)
                Text(titulo).font(.system(size: 14, weight: .semibold)).foregroundColor(verdeO)
            }
            contenido()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

// MARK: — Preview

#Preview {
    NavigationStack {
        PlanNutricionalView(
            nombrePaciente:   "Ana López",
            caloriasObjetivo: 1914,
            getVal:           1914,
            gramosHDC:        239,
            gramosLip:        53,
            gramosProt:       119,
            sexo:             "Femenino",
            edad:             28,
            diagnostico:      "Sobrepeso grado I",
            restricciones:    "No consume cerdo"
        )
    }
}
