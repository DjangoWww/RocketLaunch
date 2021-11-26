//
//  RocketDetailVM.swift
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
public final class RocketDetailVM {
    deinit {
        printDebug("RocketDetailVM deinit")
    }

    public enum ViewState {
        case `init`
        case loading
        case success
        case failedWith(error: Error)
    }

    private let _disposeBag = DisposeBag()
    private let _serverProvider = ServerProvider()
    private let _viewStateRelay = BehaviorRelay<ViewState>(value: .`init`)
    private let _rocketDetailRelay = BehaviorRelay<ServerRocketDetailModelRes?>(value: nil)

    public let viewStateDriver: Driver<ViewState>
    public let rocketDetailDriver: Driver<ServerRocketDetailModelRes>

    public init() {
        viewStateDriver = _viewStateRelay.asDriver()
        rocketDetailDriver = _rocketDetailRelay.asDriver().compactMap { $0 }
    }
}

// MARK: - public funcs
extension RocketDetailVM {
    /// accept rocket id
    public func acceptRocket(
        with id: String
    ) {
        _getRocketDetail(with: id)
    }
}

// MARK: - private funcs
extension RocketDetailVM {
    private func _getRocketDetail(with id: String) {
        _viewStateRelay.accept(.loading)
        let modelReq = ServerRocketDetailModelReq(id: id)
        Promise<Void>(resolver: { $0.fulfill(()) })
            .map { modelReq }
            .then(_requestRocketDetail)
            .done(_handleSucceed)
            .catch(_handleFailed)
    }

    private func _requestRocketDetail(
        _ model: ServerRocketDetailModelReq
    ) -> Promise<[ServerRocketDetailModelRes]> {
        return _serverProvider
            .request(target: .getRocketDetail(model))
    }

    private func _handleSucceed(
        with res: [ServerRocketDetailModelRes]
    ) {
        _rocketDetailRelay.accept(res.first)
        _viewStateRelay.accept(.success)
    }

    private func _handleFailed(
        with error: Error
    ) {
        printDebug(error)
        _viewStateRelay.accept(.failedWith(error: error))
    }
}
