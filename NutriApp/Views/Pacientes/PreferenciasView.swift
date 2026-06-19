//
//  PreferenciasView.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 09/06/26.
//

import SwiftUI

struct PreferenciasView: View {
    @Environment(\.dismiss) var dismiss

    let verdeO = Color(hex: "2D5016")
    let verdeM = Color(hex: "4A7C2F")
    let menta  = Color(hex: "A8C97F")
    let beige  = Color(hex: "F5EDD6")
    let arena  = Color(hex: "E8D5B0")
    let terra  = Color(hex: "C4693A")
    let gris   = Color(hex: "9E9681")

    // Le gusta
    @State private var tagsgusta: [String]    = ["Frutas", "Pollo", "Arroz", "Nueces"]
    @State private var nuevoGusta             = ""

    // No le gusta
    @State private var tagsNoGusta: [String]  = ["Cebolla", "Pescado", "Lácteos"]
    @State private var nuevoNoGusta           = ""

    // Restricciones
    @State private var restriccion            = "Ninguna"
    let restricciones = ["Ninguna", "Vegetariano", "Vegano", "Sin gluten", "Sin lactosa", "Cetogénica"]

    // Frecuencia de comidas
    @State private var frecuenciaComidas: Int = 5

    // Frecuencia grupos alimenticios
    @State private var frecProteina   = "Diario"
    @State private var frecLegumbres  = "Semanal"
    @State private var frecCereales   = "Diario"
    @State private var frecFrutas     = "Diario"

    let frecOpciones = ["Diario", "Semanal", "Ocasional", "Nunca"]

    var body: some View {
        ZStack {
            beige.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // ── Le gusta / No le gusta ───────────
                    HStack(alignment: .top, spacing: 12) {
                        // Le gusta
                        tagsCard(
                            titulo: "LE GUSTA",
                            icono: "heart.fill",
                            color: verdeM,
                            tags: $tagsgusta,
                            nuevo: $nuevoGusta
                        )

                        // No le gusta
                        tagsCard(
                            titulo: "NO LE GUSTA",
                            icono: "heart.slash.fill",
                            color: terra,
                            tags: $tagsNoGusta,
                            nuevo: $nuevoNoGusta
                        )
                    }

                    // ── Restricciones ────────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("RESTRICCIONES ESPECIALES")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(gris)
                            .kerning(0.8)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(restricciones, id: \.self) { opcion in
                                Button {
                                    restriccion = opcion
                                } label: {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(restriccion == opcion ? verdeO : Color.clear)
                                            .frame(width: 10, height: 10)
                                            .overlay(
                                                Circle().stroke(restriccion == opcion ? verdeO : gris, lineWidth: 1.5)
                                            )
                                        Text(opcion)
                                            .font(.system(size: 13))
                                            .foregroundColor(restriccion == opcion ? verdeO : gris)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(restriccion == opcion ? menta.opacity(0.2) : Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(restriccion == opcion ? menta : Color.clear, lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // ── Frecuencia de comidas ────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FRECUENCIA DE COMIDAS")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(gris)
                            .kerning(0.8)

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Frecuencia de comidas")
                                    .font(.system(size: 14))
                                    .foregroundColor(verdeO)
                                Text("Veces que consume al día")
                                    .font(.system(size: 11))
                                    .foregroundColor(gris)
                            }
                            Spacer()
                            HStack(spacing: 16) {
                                Button {
                                    if frecuenciaComidas > 1 { frecuenciaComidas -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(verdeO)
                                        .frame(width: 32, height: 32)
                                        .background(arena)
                                        .cornerRadius(8)
                                }
                                Text("\(frecuenciaComidas)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(verdeO)
                                    .frame(width: 24)
                                Button {
                                    if frecuenciaComidas < 10 { frecuenciaComidas += 1 }
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 32, height: 32)
                                        .background(verdeO)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // ── Frecuencia grupos ────────────────
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FRECUENCIA DE ALIMENTOS")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(gris)
                            .kerning(0.8)

                        frecuenciaFila("Proteína animal",     frec: $frecProteina)
                        Divider()
                        frecuenciaFila("Leguminosas",         frec: $frecLegumbres)
                        Divider()
                        frecuenciaFila("Cereales",            frec: $frecCereales)
                        Divider()
                        frecuenciaFila("Frutas y Verduras",   frec: $frecFrutas)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)

                    // ── Info IA ──────────────────────────
                    HStack(spacing: 10) {
                        Image(systemName: "info.circle")
                            .foregroundColor(verdeM)
                        Text("Estas preferencias serán utilizadas por la IA para generar tu plan nutricional personalizado.")
                            .font(.system(size: 12))
                            .foregroundColor(gris)
                    }
                    .padding(14)
                    .background(menta.opacity(0.15))
                    .cornerRadius(12)

                    // ── Botón guardar ────────────────────
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Guardar Preferencias")
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
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
        }
        .navigationTitle("Preferencias")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(verdeO)
                }
            }
        }
    }

    // MARK: — Card de tags
    func tagsCard(titulo: String, icono: String, color: Color, tags: Binding<[String]>, nuevo: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icono)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                Text(titulo)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                    .kerning(0.5)
            }

            // Tags existentes
            FlowLayout(spacing: 6) {
                ForEach(tags.wrappedValue, id: \.self) { tag in
                    HStack(spacing: 4) {
                        Text(tag)
                            .font(.system(size: 12))
                            .foregroundColor(color)
                        Button {
                            tags.wrappedValue.removeAll { $0 == tag }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(color.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(color.opacity(0.12))
                    .cornerRadius(20)
                }
            }

            // Agregar tag
            HStack(spacing: 6) {
                TextField("Agregar...", text: nuevo)
                    .font(.system(size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(beige)
                    .cornerRadius(8)
                Button {
                    let trimmed = nuevo.wrappedValue.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        tags.wrappedValue.append(trimmed)
                        nuevo.wrappedValue = ""
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: — Fila frecuencia
    func frecuenciaFila(_ label: String, frec: Binding<String>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(verdeO)
            Spacer()
            Picker("", selection: frec) {
                ForEach(frecOpciones, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .foregroundColor(verdeM)
        }
    }
}

// MARK: — FlowLayout para tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            height = y + rowHeight
        }
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        PreferenciasView()
    }
}
