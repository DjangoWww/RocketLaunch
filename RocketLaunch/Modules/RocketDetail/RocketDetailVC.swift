//
//  RocketDetailVC.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import PromiseKit
import Kingfisher

/// RocketDetailVC
public final class RocketDetailVC: UIViewController {
    deinit {
        printDebug("RocketDetailVC deinit")
    }

    @IBOutlet private weak var _refreshButton: UIButton!
    @IBOutlet private weak var _imageV: UIImageView!
    @IBOutlet private weak var _nameLabel: UILabel!
    @IBOutlet private weak var _descriptionLabel: UILabel!
    @IBOutlet private weak var _wikiTextView: UITextView!

    private let _viewModel = RocketDetailVM()
    private let _disposeBag = DisposeBag()

    /// save for refresh
    private var _rocketID: String? = nil
}

// MARK: - Life cycle
extension RocketDetailVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "RocketDetailVC"
        _setUpSubviews()
        _bindViewModel()
    }
}

// MARK: - public funcs
extension RocketDetailVC {
    /// accept rocket id
    public func acceptRocket(
        with id: String
    ) {
        _rocketID = id
        _viewModel.acceptRocket(with: id)
    }
}

// MARK: - private funcs
extension RocketDetailVC {
    private func _setUpSubviews() {
        _refreshButton.rx.tap.asDriver()
            .throttle(.seconds(1))
            .drive { [weak self] _ in
                guard let id = self?._rocketID else { return }
                self?._viewModel.acceptRocket(with: id)
            }
            .disposed(by: _disposeBag)
    }

    private func _bindViewModel() {
        _viewModel.viewStateDriver                  // Handle viewState change
            .drive { [weak self] in self?._handleViewState($0) }
            .disposed(by: _disposeBag)
        _viewModel.rocketDetailDriver
            .map { $0.flickr_images.first }         // just choose the first image
            .drive(_imageV.rx._kfUrlString())
            .disposed(by: _disposeBag)
        _viewModel.rocketDetailDriver
            .map { $0.name }
            .drive(_nameLabel.rx.text)
            .disposed(by: _disposeBag)
        _viewModel.rocketDetailDriver
            .map { $0.description }
            .drive(_descriptionLabel.rx.text)
            .disposed(by: _disposeBag)
        _viewModel.rocketDetailDriver
            .map { $0.wikipedia }
            .drive(_wikiTextView.rx.text)
            .disposed(by: _disposeBag)
    }

    /// handle viewState
    private func _handleViewState(
        _ viewState: RocketDetailVM.ViewState
    ) {
        switch viewState {
        case .`init`:
            break
        case .loading:
            view.makeActivity()
        case .success:
            view.hideToast()
        case .failedWith(let err):
            view.hideToast()
            view.makeToast(err.errorDescription)
        }
    }
}

// MARK: - Rx extension for UIImageView
extension Reactive where Base: UIImageView {
    fileprivate func _kfUrlString(
        _ placeholder: Placeholder? = nil,
        _ options: KingfisherOptionsInfo? = nil
    ) -> Binder<String?> {
        return Binder(base) { imageV, urlString -> Void in
            imageV.kf.setImage(
                with: urlString?.urlValue,
                placeholder: placeholder,
                options: options
            ) { _ in }
        }
    }
}
