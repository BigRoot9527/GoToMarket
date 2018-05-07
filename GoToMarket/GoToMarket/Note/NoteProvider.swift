//
//  NoteProvider.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum NoteRequestProvider
{
    case getFavoriteState(ofCode: String)
    case setFavoriteState(ofCode: String, isFavorite: Bool)
    case getPredictPricePerKG(ofCode: String)
    case setMultiplerAndWeight(ofCode: String, withMutipler: Double, withWeight: Double)
}


struct NoteProvider
{
    private weak var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func getFevorite(
        toCropCode code: String,
        success: @escaping(Bool) -> Void,
        failure: @escaping(Error) -> Void )
    {
        if let context = container?.viewContext
        {
            do {
                let state = try UserNotes.getFavoriteState(
                    matching: code,
                    in: context)
                success(state)
            } catch {
                failure(error)
            }
        }
    }
    
    func setFevorite(toCropCode code: String, bool: Bool)
    {
        if let context = container?.viewContext {
            UserNotes.setFavoriteState(matching: code, toState: bool, in: context)
            try? context.save()
        }
    }
    
    func getPricePerKG(
        toCropCode code: String,
        success: @escaping (Double) -> Void,
        failure: @escaping (Error) -> Void)
    {
        if let context = container?.viewContext {
            do {
                let (price) = try UserNotes.getPredictPrice(matching: code, in: context)
                success(price)
            } catch {
                failure(error)
            }
        }
    }
    
    func setTrainModel(toCropCode code: String, mutipler: Double, weight: Double)
    {
        container?.performBackgroundTask{ context in
            UserNotes.setCropMutiplerAndWeight(matching: code, withNewMutipler: mutipler, withNewWeight: weight, in: context)
            try? context.save()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
