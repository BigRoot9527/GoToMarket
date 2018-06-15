//
//  QuoteDataViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/6.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class QuoteDataViewController: UIViewController {

    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!

    // MARK: - Generate Input
    var basePredicateString: String = "(newAveragePrice > 0)"
    var isMainVC: Bool = false
    var isActive: Bool = false {
        didSet {
            quotesTableView.setContentOffset(quotesTableView.contentOffset, animated: false)
            if isActive {
                fetchAndReloadData()
                countAndPostNotification(withAnimation: false)
            }
        }
    }

    // MARK: - UIRefreshControl
    private let refreshControl = UIRefreshControl()

    // MARK: - Transition
    private let transition = GoToMarketAnimator()
    private var quoteContextView: UIView?

    // MARK: - CoreData
    private var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    private var isUpdated: Bool = false
    private var filterText: String?
    private var savedSortingType: [NSSortDescriptor] = GoToMarketConstant.cropBasicNSSortDecriptor
    private let manager = NoteManager()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupTrasition()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isActive {

            fetchAndReloadData()
            countAndPostNotification(withAnimation: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isMainVC && !isUpdated {

            checkAndUpdateApi()

            isUpdated = true
        }
    }

    private func setupTableView() {

        quotesTableView.dataSource = self
        quotesTableView.delegate = self

        quotesTableView.separatorStyle = .none

        //Setup UIRefreshControl
        if #available(iOS 10.0, *) {
            quotesTableView.refreshControl = refreshControl
        } else {
            quotesTableView.addSubview(refreshControl)
        }

        refreshControl.tintColor = UIColor(named: GotoMarketColors.ChartAverage)
        refreshControl.addTarget(self, action: #selector(didPullTableView(_:)), for: .valueChanged)

        let nibFile = UINib(
            nibName: "QuotesTableViewCell",
            bundle: nil)

        quotesTableView.register(
            nibFile,
            forCellReuseIdentifier: String(describing: QuotesTableViewCell.self))
    }

    private func setupTrasition() {
        transition.presentingContextViewProvider = self
    }

    private func checkAndUpdateApi() {

        if LoadingTaskKeeper.shared.getMarket(ofKey: TaskKeys.crop) == nil {

            guard let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as? MarketSettingViewController else { return }

            //TODO: Switch item type
            settingVC.itemTypeInput = .crop

            settingVC.hero.modalAnimationType = .fade

            present(settingVC, animated: true, completion: nil)

        } else {

            guard let loadingVC = UIStoryboard.loading().instantiateInitialViewController() as? LoadingViewController else { return }

            //TODO: Switch item type

            loadingVC.itemTypeInput = .crop

            loadingVC.hero.modalAnimationType = .fade

            present(loadingVC, animated: true, completion: nil)
        }
    }

    // MARK: - UIRefreshControl method
    @objc private func didPullTableView(_ sender: Any) {

        self.refreshControl.endRefreshing()
        checkAndUpdateApi()

        if let index = quotesTableView.indexPathsForVisibleRows?.first {
            quotesTableView.scrollToRow(at: index, at: .top, animated: true)
        }
    }

    // MARK: - Accessable Funcs
    func changeQuoteWeight() {

        if isActive {
            quotesTableView.reloadData()
        }
    }

    func sortQuoteData(sortDescriptor: [NSSortDescriptor]) {

        savedSortingType = sortDescriptor

        if isActive {
            fetchAndReloadData()
            let idexPath = IndexPath(row: 0, section: 0)
            quotesTableView.scrollToRow(at: idexPath, at: .top, animated: true)
        }
    }

    func scrollTableView(scrollToTop: Bool) {

        if isActive {
            let indexPath = scrollToTop ?
                IndexPath(row: 0, section: 0) :
                IndexPath(row: quotesTableView.numberOfRows(inSection: 0) - 1, section: 0)

            quotesTableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }

    func searchQuote(searchText: String) {

        quotesTableView.setContentOffset(quotesTableView.contentOffset, animated: false)

        self.filterText = searchText

        if isActive {
            fetchAndReloadData()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension QuoteDataViewController: NSFetchedResultsControllerDelegate {

    //TODO: implement back NSFetchedResultsControllerDelegate auto update tableView func
    //helper: UIApplication.shared.isNetworkActivityIndicatorVisible = true

    private func fetchAndReloadData() {

        if let context = container?.viewContext {

//            context.reset()

            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()

            request.sortDescriptors = savedSortingType

            if let filter = filterText, filter != GoToMarketConstant.emptyString {

                request.predicate = NSPredicate(format: "(cropName CONTAINS %@) AND " + basePredicateString, filter)
            } else {

                request.predicate = NSPredicate(format: basePredicateString)
            }

            fetchedResultsController = NSFetchedResultsController<CropDatas>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            quotesTableView.reloadData()
        }
    }

    private func countAndPostNotification(withAnimation bool: Bool) {

        postCartNotification(count: manager.countInCartNotFinished(), playBounceAnimation: bool)
    }
}

// MARK: - UITableViewDataSource
extension QuoteDataViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: QuotesTableViewCell.self),
                for: indexPath) as? QuotesTableViewCell,
            let crop = fetchedResultsController?.object(at: indexPath), let note = crop.note
            else { return UITableViewCell() }

        cell.itemNameLabel.text = crop.cropName

        cell.sellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: note.sellingPrice)

        if crop.newAveragePrice == 0 {
            cell.priceIndicator = 1
        } else {
            cell.priceIndicator = crop.newAveragePrice / crop.lastAveragePrice
        }
        //SwipeCellKit
        cell.delegate = self

        cell.inBuyingChart = note.isInCart

        cell.isFruit = crop.isFruit

        //TODO: add gesture when touch the cell, showing scale down animation
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let sections = fetchedResultsController?.sections, sections.count > 0 {

            noResultLabel.isHidden = sections[section].numberOfObjects > 1

            tableView.isScrollEnabled = sections[section].numberOfObjects > 1

            return sections[section].numberOfObjects

        } else {

            noResultLabel.isHidden = false

            tableView.isScrollEnabled = false

            return 0
        }
    }
}

// MARK: - UITableViewDelegate
extension QuoteDataViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoToMarketConstant.quotesRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard
            let crop = fetchedResultsController?.object(at: indexPath),
            let cell = quotesTableView.cellForRow(at: indexPath) as? QuotesTableViewCell,
            let detailVC = UIStoryboard.detail().instantiateInitialViewController() as? DetailViewController else { return }

        detailVC.itemCodeInput = crop.cropCode

        detailVC.didTapBuyingCallBack = { [weak self] bool -> Void in

            crop.note?.isInCart = bool

            try? crop.note?.setInCart(isInCart: bool, inContext: self?.container?.viewContext)

            cell.inBuyingChart = bool
        }

        detailVC.dismissedCallBack = { updatedPrice -> Void in

            cell.sellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: updatedPrice)
        }

        self.quoteContextView = cell.quoteBackgroundView

        transition.presentedContextViewProvider = detailVC

        detailVC.transitioningDelegate = self

        detailVC.modalPresentationStyle = .overFullScreen

        present(detailVC, animated: true, completion: nil)
    }
}

// MARK: - SwipeCellKit
extension QuoteDataViewController: SwipeTableViewCellDelegate {
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
        ) -> [SwipeAction]? {

        guard orientation == .right else { return nil }

        guard
            orientation == .right,
            let crop = fetchedResultsController?.object(at: indexPath) ,
            let note = crop.note,
            let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as? QuotesTableViewCell
            else { return nil }

        let selectAction = SwipeAction(style: .default, title: nil) { [weak self] _, _ in

            note.isInCart = !note.isInCart

            selectedCell.inBuyingChart = note.isInCart

            try? note.setInCart(isInCart: note.isInCart, inContext: self?.container?.viewContext)

            self?.showingCartAnimation(
                isInChart: note.isInCart,
                fromCellFrame: selectedCell.frame,
                cellTableView: self?.quotesTableView,
                completion: {

                    guard self?.viewIfLoaded?.window != nil else { return }

                    self?.countAndPostNotification(withAnimation: true)
            })
        }

        selectAction.image = !selectedCell.inBuyingChart ?
            #imageLiteral(resourceName: "add_icon").resizeImage(newWidth: 35) :
            #imageLiteral(resourceName: "minus_icon").resizeImage(newWidth: 35)

        selectAction.backgroundColor = UIColor.clear

        return [selectAction]
    }

    func tableView(
        _ tableView: UITableView,
        editActionsOptionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation) -> SwipeTableOptions {

        var options = SwipeTableOptions()

        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        options.buttonVerticalAlignment = .center
        options.backgroundColor = UIColor.clear

        return options
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension QuoteDataViewController: ContextViewProvider {

    func contextView(for animator: GoToMarketAnimator) -> UIView? {

        return self.quoteContextView
    }
}

extension QuoteDataViewController: UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {

        transition.isPresentation = true

        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.isPresentation = false

        return transition
    }

}
