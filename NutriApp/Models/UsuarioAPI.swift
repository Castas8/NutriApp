//
//  UsuarioAPI.swift
//  NutriApp
//

import Foundation

struct UsuarioAPI: Codable {
    var idUsuario: Int?
    var nombre: String?
    var correo: String?
    var password: String?
    var nombreConsultorio: String?
    var telefono: String?
    var estadoCuenta: String?
    var fechaRegistro: String?
}
