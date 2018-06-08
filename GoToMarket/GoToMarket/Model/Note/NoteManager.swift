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

struct NoteManager {
    
    private weak var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func countInCartNotFinished() -> Int {
        
        if let context = container?.viewContext {
            
            return UserNotes.countCartNotes(in: context)
        }
        return 0
    }
    
    func getCurrentMultipler(
        fromItemCode code: String,
        success: (String, Bool) -> Void,
        failure: (Error) -> Void) {
        
        if let context = container?.viewContext {
            
            guard let note = UserNotes.fetchNote(matching: code, in: context) else {
                
                failure(GoToMarketError.FetchError)
                return
            }
            
            let multiplerString = String(format: "%.2f", note.customMutipler)
            let isDefault = note.muliplerWeight == NoteConstant.initailMultiplerWeight
            
            success(multiplerString, isDefault)
        }
    }
    
    func resetModel(
        toItemCode code: String,
        success: @escaping (UserNotes) -> Void,
        failure: @escaping (Error) -> Void ) {
        
        if let context = container?.viewContext {
            
            do {
                let newnote = try UserNotes.resetMultipler(toItemCode: code, in: context)
                
                success(newnote)
                
            } catch {
                
                failure(error)
            }
        }
    }
    
    func setTrainModel(
        toItemCode code: String,
        actualPricePerKG price: Double,
        success: (UserNotes) -> Void,
        failure: (Error) -> Void) {
        
        if let context = container?.viewContext {
            
            do {
                let newnote = try UserNotes.trainModelWithActualPrice(
                    matching: code,
                    actualPricePerKG: price,
                    in: context)
                
                success(newnote)
                
            } catch {
                
                failure(error)
            }
        }
    }
}
