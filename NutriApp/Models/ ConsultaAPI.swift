//
//   ConsultaAPI.swift
//  NutriApp
//
//  Created by DIEGO CASTAÑEDA on 14/06/26.
//

struct ConsultaAPI: Codable, Identifiable {
    var idConsulta:        Int?
    var idPaciente:        Int?
    var fechaConsulta:     String?
    var pesoKg:            Double?
    var tallaCm:           Int?
    var imc:               Double?
    var porcentajeMusculo: Double?
    var porcentajeGrasa:   Double?
    var grasaVisceral:     Double?
    var bodyAge:           Int?
    var circBrazoRelajado: Double?
    var circBrazoContraido:Double?
    var circCintura:       Double?
    var circCadera:        Double?
    var circPecho:         Double?
    var plicoTriceps:      Double?
    var plicoBiceps:       Double?
    var plicoAbdominal:    Double?
    var plicoSubescapular: Double?
    var notasClinicas:     String?
    var tipoConsulta:      String?

    var id: Int { idConsulta ?? 0 }

    enum CodingKeys: String, CodingKey {
        case idConsulta, idPaciente, fechaConsulta
        case pesoKg, tallaCm, imc
        case porcentajeMusculo, porcentajeGrasa, grasaVisceral, bodyAge
        case circBrazoRelajado, circBrazoContraido, circCintura, circCadera, circPecho
        case plicoTriceps, plicoBiceps, plicoAbdominal, plicoSubescapular
        case notasClinicas, tipoConsulta
    }
}
