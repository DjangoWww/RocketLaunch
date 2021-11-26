//
//  LaunchesListVM.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import PromiseKit

/// LaunchesListVM
public final class LaunchesListVM {
    deinit {
        printDebug("LaunchesListVM deinit")
    }

    public typealias TableSection = SectionModel<String?, ServerLaunchesListModelRes>

    public enum ViewState {
        case `init`
        case loading
        case success
        case failedWith(error: Error)
    }

    /// which year to show
    public enum YearType {
        case year_2020
        case year_2021
    }

    private let _disposeBag = DisposeBag()
    private let _serverProvider = ServerProvider()
    private let _viewStateRelay = BehaviorRelay<ViewState>(value: .`init`)
    private let _tableSectionsRelay = BehaviorRelay<[TableSection]>(value: [])
    private let _launchesListResRelay = BehaviorRelay<[ServerLaunchesListModelRes]>(value: [])

    public let viewStateDriver: Driver<ViewState>
    public let tableSectionsDriver: Driver<[TableSection]>
    public let selectedYearRelay = BehaviorRelay<YearType>(value: .year_2020)

    public init() {
        viewStateDriver = _viewStateRelay.asDriver()
        tableSectionsDriver = _tableSectionsRelay.asDriver()

        Observable
            .combineLatest(
                _launchesListResRelay.skip(1),
                selectedYearRelay.distinctUntilChanged()
            )
            .map { $0.0._filterMapRes(with: $0.1) }
            .bind(to: _tableSectionsRelay)
            .disposed(by: _disposeBag)
    }
}

// MARK: - public funcs
extension LaunchesListVM {
    /// refresh datas
    public func refreshData() {
        _getLaunchesList()
    }
}

// MARK: - private funcs
extension LaunchesListVM {
    private func _getLaunchesList() {
        _viewStateRelay.accept(.loading)
        Promise<Void>(resolver: { $0.fulfill(()) })
            .then(_requestLaunchesList)
            .done(_handleSucceed)
            .catch(_handleFailed)
    }

    private func _requestLaunchesList() -> Promise<[ServerLaunchesListModelRes]> {
        return _serverProvider
            .request(target: .getLaunchesList)
    }

    private func _handleSucceed(
        with res: [ServerLaunchesListModelRes]
    ) {
        _launchesListResRelay.accept(res)
        _viewStateRelay.accept(.success)
    }

    private func _handleFailed(
        with error: Error
    ) {
        printDebug(error)
        _viewStateRelay.accept(.failedWith(error: error))
    }
}

// MARK: - Array extension for value mapping
extension Array where Element == ServerLaunchesListModelRes {
    /// filter within specific year and map to res
    fileprivate func _filterMapRes(
        with year: LaunchesListVM.YearType
    ) -> [LaunchesListVM.TableSection] {
        return [
            LaunchesListVM.TableSection(
                model: nil,
                items: compactMap { $0._filter(with: year) }
            )
        ]
    }
}

// MARK: - ServerLaunchesListModelRes filter
extension ServerLaunchesListModelRes {
    fileprivate static let _dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    fileprivate func _filter(
        with year: LaunchesListVM.YearType          // filter within specific year
    ) -> ServerLaunchesListModelRes? {
        guard let date = ServerLaunchesListModelRes._dateFormatter.date(from: date_local) else {
            return nil                              // format a date failed
        }
        let yearToCompare: Int
        switch year {
        case .year_2020:
            yearToCompare = 2020
        case .year_2021:
            yearToCompare = 2021
        }
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: date
        )
        if dateComponents.year != yearToCompare {   // filter year
            return nil
        }
        if upcoming || (success == true) {          // filter success & upcoming
            return self
        }
        return nil                                  // failed with filter
    }
}
