//
//  ErrorResult.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//
import Foundation

public struct ErrorResult: Codable {
    public var codigo: Int?
    public var mensagem: String
    public var statusCode: Int?
    public var erros: [ErroItem]?

    static var unknown = ErrorResult(codigo: nil, mensagem: "Não foi possível processar sua solicitação", statusCode: 0)
}

public struct ErrorMensagem: Codable {
    public var mensagem: String
}

public struct ErroItem: Codable {
    public var field: String?
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case field = "campo"
        case message = "mensagem"
    }
}
