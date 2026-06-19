//
//  PacienteAPI.swift
//  NutriApp
//

import Foundation

struct PacienteAPI: Codable, Identifiable, Hashable {
    var idPaciente:                  Int?
    var idUsuario:                   Int?
    var nombreCompleto:              String?
    var fechaNacimiento:             String?
    var edad:                        Int?
    var genero:                      String?
    var ocupacion:                   String?
    var estadoCivil:                 String?
    var telefono:                    String?
    var motivoConsulta:              String?
    var enfermedadesPatologicas:     String?
    var enfermedadesHeredofamiliares:String?
    var operacionesPrevias:          String?
    var consumeTabaco:               Bool?
    var consumeAlcohol:              Bool?
    var otrasSustancias:             String?
    var objetivo:                    String?
    var nivelActividad:              String?
    var medicamentos:                String?
    var estatus:                     String?
    var fechaRegistro:               String?

    // Identifiable — usa idPaciente o UUID como fallback
    var id: Int { idPaciente ?? 0 }

    // Hashable manual para evitar conflicto con Codable
    func hash(into hasher: inout Hasher) {
        hasher.combine(idPaciente)
    }

    static func == (lhs: PacienteAPI, rhs: PacienteAPI) -> Bool {
        lhs.idPaciente == rhs.idPaciente
    }

    // CodingKeys para excluir 'id' del JSON
    enum CodingKeys: String, CodingKey {
        case idPaciente, idUsuario, nombreCompleto, fechaNacimiento
        case edad, genero, ocupacion, estadoCivil, telefono
        case motivoConsulta, enfermedadesPatologicas, enfermedadesHeredofamiliares
        case operacionesPrevias, consumeTabaco, consumeAlcohol
        case otrasSustancias, objetivo, nivelActividad, medicamentos
        case estatus, fechaRegistro
    }
}
