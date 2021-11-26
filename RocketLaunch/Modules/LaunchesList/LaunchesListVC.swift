//
//  LaunchesListVC.swift
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
import MJRefresh

/// LaunchesListVC
public final class LaunchesListVC: UIViewController {
    deinit {
        printDebug("LaunchesListVC deinit")
    }

    @IBOutlet private weak var _showYearsLabel: UILabel!
    @IBOutlet private weak var _selectYearsSwitch: UISwitch!
    @IBOutlet private weak var _tableView: UITableView!

    private let _viewModel = LaunchesListVM()
    private let _disposeBag = DisposeBag()
}

// MARK: - Life cycle
extension LaunchesListVC {
    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "LaunchesListVC"
        _setUpSubviews()
        _bindViewModel()
        _viewModel.refreshData()
    }
}

// MARK: - private funcs
extension LaunchesListVC {
    private func _setUpSubviews() {
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let nibId = UINib(
            nibName: ._launchesListTableViewCell,
            bundle: Bundle.main
        )
        _tableView.register(
            nibId,
            forCellReuseIdentifier: ._launchesListTableViewCell
        )
        _tableView.mj_header = MJRefreshNormalHeader(
            refreshingBlock: { [weak self] in self?._viewModel.refreshData() }
        )
    }

    private func _bindViewModel() {
        _selectYearsSwitch.rx.isOn                      // Two-way binding
            .map { $0._getYearType() }
            .bind(to: _viewModel.selectedYearRelay)
            .disposed(by: _disposeBag)
        _viewModel.selectedYearRelay.asDriver()         // Two-way binding
            .map { $0._getIsOnValueForSwitch() }
            .drive(_selectYearsSwitch.rx.isOn)
            .disposed(by: _disposeBag)
        _viewModel.selectedYearRelay.asDriver()         // One-way binding
            .map { $0._getName() }
            .drive(_showYearsLabel.rx.text)
            .disposed(by: _disposeBag)
        _viewModel.viewStateDriver                      // Handle viewState change
            .drive { [weak self] in self?._handleViewState($0) }
            .disposed(by: _disposeBag)
        let dataSource = RxTableViewSectionedReloadDataSource<LaunchesListVM.TableSection> { dataS, tableV, indexP, model in
            guard let cell = tableV.dequeueReusableCell(
                withIdentifier: ._launchesListTableViewCell,
                for: indexP
            ) as? LaunchesListTableViewCell else {
                let assertMsg = "you should register cell be4 use"
                printDebug(assertMsg, assertMessage: assertMsg)
                return UITableViewCell()
            }
            cell.model = model
            cell.isEven = indexP.row % 2 == 0
            return cell
        }
        _viewModel.tableSectionsDriver                  // Set tableView dataSource
            .drive(_tableView.rx.items(dataSource: dataSource))
            .disposed(by: _disposeBag)
        _tableView.rx                                   // Handle tableView select
            .modelSelected(ServerLaunchesListModelRes.self)
            .asDriver()
            .drive { [weak self] in self?._handleModelSelect(with: $0) }
            .disposed(by: _disposeBag)
    }

    /// handle viewState
    private func _handleViewState(
        _ viewState: LaunchesListVM.ViewState
    ) {
        switch viewState {
        case .`init`:
            break
        case .loading:
            _tableView.makeActivity()
        case .success:
            _tableView.mj_header?.endRefreshing()
            _tableView.hideToast()
            view.hideToast()
        case .failedWith(let err):
            _tableView.mj_header?.endRefreshing()
            _tableView.hideToast()
            view.makeToast(err.errorDescription)
        }
    }

    /// handle modelSelect
    private func _handleModelSelect(
        with model: ServerLaunchesListModelRes
    ) {
        guard model.upcoming == true else {
            let detailVc = RocketDetailVC().then {
                $0.acceptRocket(with: model.rocket)
            }
            navigationController?.pushViewController(detailVc, animated: true)
            return
        }
        let cancelAction = AlertActionType(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        let sureAction = AlertActionType(
            title: "Have a see",
            style: .destructive,
            handler: { [weak self] _ in
                let detailVc = RocketDetailVC().then {
                    $0.acceptRocket(with: model.rocket)
                }
                self?.navigationController?.pushViewController(detailVc, animated: true)
            }
        )
        showAlertVcWith(
            title: "Alert",
            message: "This launch is upcoming, plz wait for a while",
            preferredStyle: .alert,
            actions: [sureAction, cancelAction]
        )
    }
}

// MARK: - AlertAble extensions for LaunchesListVC
extension LaunchesListVC: AlertAble { }

// MARK: - String extensions for tableView cell reuse
extension String {
    fileprivate static let _launchesListTableViewCell = "LaunchesListTableViewCell"
}

// MARK: - Bool extensions
extension Bool {
    fileprivate func _getYearType() -> LaunchesListVM.YearType {
        return self
        ? .year_2021
        : .year_2020
    }
}

// MARK: - LaunchesListVM.YearType extensions
extension LaunchesListVM.YearType {
    fileprivate func _getName() -> String {
        switch self {
        case .year_2020:
            return "Current selected year: 2020"
        case .year_2021:
            return "Current selected year: 2021"
        }
    }
    fileprivate func _getIsOnValueForSwitch() -> Bool {
        switch self {
        case .year_2020:
            return false
        case .year_2021:
            return true
        }
    }
}
