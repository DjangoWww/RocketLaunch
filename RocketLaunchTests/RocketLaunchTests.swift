//
//  RocketLaunchTests.swift
//  RocketLaunchTests
//
//  Created by Django on 2021/11/26.
//

import XCTest
@testable import RocketLaunch
import RxSwift
import RxCocoa
import RxRelay
import RxTest
import RxBlocking
import PromiseKit

// MARK: - _TestError to throw
fileprivate enum _TestError: Error {
    case _testError(reason: String)
}

// MARK: - LaunchesListVMTests
public final class LaunchesListVMTests: XCTestCase {
    private var _disposeBag: DisposeBag!
    private var _viewModel: LaunchesListVM!
    private var _scheduler: ConcurrentDispatchQueueScheduler!
    private var _testScheduler: TestScheduler!
    
    public override func setUpWithError() throws {
        _disposeBag = DisposeBag()
        _viewModel = LaunchesListVM()
        _scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        _testScheduler = TestScheduler(initialClock: 0)
    }

    public override func tearDownWithError() throws {
        _disposeBag = nil
        _viewModel = nil
        _scheduler = nil
        _testScheduler = nil
    }

    /// to test if initialState is all correct
    func testInitialState() throws {
        let viewStateObs = _testScheduler.createObserver(LaunchesListVM.ViewState.self)
        let selectedYearObs = _testScheduler.createObserver(LaunchesListVM.YearType.self)
        let tableSectionsObs = _testScheduler.createObserver([LaunchesListVM.TableSection].self)

        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        _viewModel.selectedYearRelay.asDriver().drive(selectedYearObs).disposed(by: _disposeBag)
        _viewModel.tableSectionsDriver.drive(tableSectionsObs).disposed(by: _disposeBag)

        XCTAssertRecordedElements(viewStateObs.events, [.`init`])
        XCTAssertRecordedElements(selectedYearObs.events, [.year_2020])
        XCTAssertRecordedElements(tableSectionsObs.events, [[]])
    }
    
    /// to test if you can get a correct result of the request
    func testReqLaunchesList() throws {
        _viewModel.refreshData()
        let viewStateObs = _testScheduler.createObserver(LaunchesListVM.ViewState.self)
        _viewModel.viewStateDriver.drive(viewStateObs).disposed(by: _disposeBag)
        let tableSectionsRes = try _viewModel.tableSectionsDriver.skip(1).toBlocking().first()
        XCTAssert(tableSectionsRes != [], "error req")      // req succeed
        XCTAssertRecordedElements(
            viewStateObs.events,
            [.loading, .success]
        )
    }
    
    /// to test if the year switch is working
    func testYearSwitch() throws {
        let yearToTest: LaunchesListVM.YearType = .year_2021
        let yearNumToVerify = yearToTest._getYearNum()

        _viewModel.refreshData()
        let tableSectionsRes = try _viewModel.tableSectionsDriver.skip(1).toBlocking().first()
        XCTAssert(tableSectionsRes != [], "error req")      // req succeed
        
        _viewModel.selectedYearRelay.accept(yearToTest)     // switch year
        let resWithinYear = try _viewModel.tableSectionsDriver.toBlocking().first()
        guard let items = resWithinYear?.first?.items else {
            throw _TestError._testError(reason: "switch failed")       // switch failed
        }
        
        for item in items {
            XCTAssert(                                      // show only successful and upcoming
                item.upcoming || (item.success == true),
                "show only successful and upcoming launches "
            )
            let year = try item.date_local._getYearValue()
            XCTAssert(                                      // check if succeed with year filter
                year == yearNumToVerify,
                "check if succeed with year filter "
            )
        }
    }
}

// MARK: - ServerProviderTests
public final class ServerProviderTests: XCTestCase {
    private var _serverProvider: ServerProvider!

    public override func setUpWithError() throws {
        _serverProvider = ServerProvider()
    }

    public override func tearDownWithError() throws {
        _serverProvider = nil
    }

    /// to test if the provider can make a request
    func testReqLaunchesList() throws {
        let expectation = expectation(description: "expectation for launchesList result")
        let promise: Promise<[ServerLaunchesListModelRes]> = _serverProvider
            .request(target: .getLaunchesList)
        promise
            .done { _ in expectation.fulfill() }
            .catch { XCTFail($0.errorDescription) }
        let waiter = XCTWaiter()
        waiter.wait(for: [expectation], timeout: 30)
    }
}

// MARK: - extension for XCTest
// MARK: LaunchesListVM.ViewState: Equatable
extension LaunchesListVM.ViewState: Equatable {
    public static func == (
        lhs: LaunchesListVM.ViewState,
        rhs: LaunchesListVM.ViewState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.`init`, .`init`):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.failedWith, .failedWith):
            return true
        default:
            return false
        }
    }
}
// MARK: RocketDetailVM.ViewState: Equatable
extension RocketDetailVM.ViewState: Equatable {
    public static func == (
        lhs: RocketDetailVM.ViewState,
        rhs: RocketDetailVM.ViewState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.`init`, .`init`):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.failedWith, .failedWith):
            return true
        default:
            return false
        }
    }
}
// MARK: ServerLaunchesListModelRes: Equatable
extension ServerLaunchesListModelRes: Equatable {
    public static func == (
        lhs: ServerLaunchesListModelRes,
        rhs: ServerLaunchesListModelRes
    ) -> Bool {
        return lhs.name == rhs.name
        && lhs.id == rhs.id
        && lhs.rocket == rhs.rocket
    }
}
// MARK: extensions for LaunchesListVM.YearType
extension LaunchesListVM.YearType {
    fileprivate func _getYearNum() -> Int {
        switch self {
        case .year_2020:
            return 2020
        case .year_2021:
            return 2021
        }
    }
}
// MARK: extensions for string
extension String {
    fileprivate func _getYearValue() throws -> Int {
        guard let date = ServerLaunchesListModelRes.dateFormatter.date(from: self),
              let year = Calendar.current.dateComponents([.year, .month, .day], from: date).year
        else {
            throw _TestError._testError(reason: "failed in mapping date")
        }
        return year
    }
}
