//
//  SortButtonStruct.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol SortParametersGettable {

    var representAttribute: String { get set }

    func getAcendingStyle() -> Bool?
}

struct SortButton: SortParametersGettable {

    var state: ToolButtonState
    var representAttribute: String
    var buttonImage: UIImage

    enum ToolButtonState {

        case ascending, descending, none

        mutating func next() {

            switch self {

            case .ascending:
                self = .none

            case .descending:
                self = .ascending

            case .none:
                self = .descending
            }
        }
    }

    func getTintColor() -> UIColor? {

        switch state {

        case .ascending:
            return UIColor(named: GotoMarketColors.SortAscending)

        case .descending:
            return UIColor(named: GotoMarketColors.SortDescending)

        case .none:
            return UIColor(named: GotoMarketColors.SortNone)
        }
    }

    func getAcendingStyle() -> Bool? {

        switch state {
        case .ascending:
            return true
        case .descending:
            return false
        case .none:
            return nil
        }
    }

    func getImage() -> UIImage {

        return buttonImage.withRenderingMode(.alwaysTemplate)
    }
}
