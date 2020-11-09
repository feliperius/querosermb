//
//  HomeCoordinatorSpecs.swift
//  QueroSerMBDesafioUITests
//
//  Created by Felipe Perius on 09/11/20.
//
import Quick

@testable import QueroSerMBDesafio

final class AssetCoordinatorSpec: BaseTest {

    var apiClient: AssetServiceMock!
    var robot: ExchangeCoordinatorRobot!
    
    func setupExchanges() {
        gateway = ExchangeGatewayMock(exchanges: ExchangesMock.exchanges!,
                                      exchangesIcon: ExchangesMock.icons!)
        robot = ExchangeCoordinatorRobotFactory.make(self).load(gateway: gateway)
    }
    
    func setupEmptyExchanges() {
        gateway = ExchangeGatewayMock(exchanges: [], exchangesIcon: [])
        robot = ExchangeCoordinatorRobotFactory.make(self).load(gateway: gateway)
    }
    
    func setupError() {
        gateway = ExchangeGatewayMock(error: NetworkError.offline)
        robot = ExchangeCoordinatorRobotFactory.make(self).load(gateway: gateway)
    }
    
    override func spec() {
        super.spec()
        
        describe("ExchangeCoordinator") {
            context("when start exchanges list coordinator") {
                beforeEach {
                    self.setupExchanges()
                }

                it("should appear the exchange list") {
                    self.robot
                    .wiat()
                    .result()
                    .checkExchangesList()
                }
            }
            
            context("when selects the cell of exchange") {
                beforeEach {
                    self.setupExchanges()
                }

                it("should appear the screen of exchange detail") {
                    self.robot
                    .wiat()
                    .tapCell()
                    .result()
                    .checkExchangeDetail()
                }
            }
        }
    }
}
