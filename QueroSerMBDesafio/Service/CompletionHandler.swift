//
//  CompletionHandler.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//
typealias CompletionHandler<T, E: Error> = ((Result<T, E>) -> Void)
