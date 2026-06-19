//
//  Cita.swift
//  NutriApp
//

import Foundation

struct Recordatorio: Identifiable, Codable {
    var id          = UUID()
    var descripcion: String
    var hora:        Date
    var completado:  Bool = false
}

struct CitaModel: Identifiable, Codable {
    var id       = UUID()
    var paciente: String
    var motivo:   String
    var tipo:     String
    var fecha:    Date
    var notas:    String
}
