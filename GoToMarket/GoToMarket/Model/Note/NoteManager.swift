//
//  NoteManager.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation

protocol NoteManagerFevoriteDelegate: class {
    func manager(_ manager: NoteManager, didGet favorite: Bool) -> Void
    func manager(_ manager: NoteManager, didFailWith error: Error) -> Void
}

protocol NoteManagerPriceDelegate: class {
    func manager(_ manager: NoteManager, didGet priceAndWeight: Double) -> Void
    func manager(_ manager: NoteManager, didFailWith error: Error) -> Void
}

struct NoteManager {
    
    private let provider = NoteProvider()
    weak var priceDelegate: NoteManagerPriceDelegate?
    weak var favoriteDelegate: NoteManagerFevoriteDelegate?
    
    func accessNote(task: NoteRequestProvider) {
        
        switch task {
            
        case .setFavoriteState(ofCode: let code, isFavorite: let bool):
            
            self.provider.setFavorite(toCropCode: code, bool: bool)
            
        case .setMultiplerAndWeight(ofCode: let code, actualPricePerKG: let price):
            
            self.provider.setTrainModel(toCropCode: code, actualPricePerKG: price)
            
        case .getFavoriteState(ofCode: let code):
            
            self.provider.getFevorite(
                toCropCode: code,
                success: { self.favoriteDelegate?.manager(self, didGet: $0)},
                failure: { self.favoriteDelegate?.manager(self, didFailWith: $0)})
            
        case .getPredictPricePerKG(ofCode: let code):
            
            self.provider.getPricePerKG(
                toCropCode: code,
                success: { self.priceDelegate?.manager(self, didGet:$0)},
                failure: { self.priceDelegate?.manager(self, didFailWith: $0)})
        }
    }
}
