//
//  CalculateViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/27.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

private enum CalculateWeightType {

    case kilogram

    case gram

    case taigram

    func getActualPricePerKG(
        fromCost cost: Double,
        fromWeight weight: Double
        ) -> Double {

        var constant: Double

        switch self {
        case .kilogram:
            constant = 1.0
        case .gram:
            constant = 1000
        case .taigram:
            constant = (1 / 0.6)
        }

        return (cost / weight) * constant
    }
}

class CalculateViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var currentMultiplerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var actualCostTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backGroundView: UIView!

    //TODO: make info labels to fadeIn chainly

    //Input
    var itemCodeInput: String = ""
    var dismissCallBack: (() -> Void)?

    private var isDefaulMultipler: Bool = true {

        didSet {
            setResetButton()
        }
    }
    private var weightType: CalculateWeightType = .kilogram

    private let manager = NoteManager()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        loadMultiplerData()
    }

    private func setupUI() {

        backGroundView.roundedCorner(cornerRadius: 10.0)
        enterButton.roundedCorner()
        closeButton.roundedCorner()
        actualCostTextField.keyboardType = UIKeyboardType.numberPad
        actualCostTextField.delegate = self
        weightTextField.keyboardType = UIKeyboardType.decimalPad
        weightTextField.delegate = self
    }

    private func loadMultiplerData() {

        manager.getCurrentMultipler(
            fromItemCode: itemCodeInput,
            success: { [weak self] (multiplerString, isDefault) in

                self?.currentMultiplerLabel.text = multiplerString

                self?.isDefaulMultipler = isDefault

        }, failure: { (error) in

            print("ErrorFrom \(#file, #line): \(error)")
        })
    }

    private func setResetButton() {

        resetButton.isEnabled = !isDefaulMultipler
    }

    private func checkIput(ofTextField textField: UITextField) -> Double? {

        if
            let costString = textField.text,
            let costDouble = Double(costString),
            costDouble > 0 {

            return costDouble

        } else {

            textField.backgroundColor = UIColor.init(named: GotoMarketColors.TextFieldError)
            textField.textColor = UIColor.red
            textField.text = GoToMarketConstant.calculateCostTextFieldError

            return nil
        }
    }

    // MARK: - IBActions
    @IBAction func didTapEnterButton(_ sender: UIButton) {

        let cost = checkIput(ofTextField: actualCostTextField)
        let weight = checkIput(ofTextField: weightTextField)

        guard let costDouble = cost, let weightDouble = weight else { return }

        manager.setTrainModel(
            toItemCode: itemCodeInput,
            actualPricePerKG: weightType.getActualPricePerKG(fromCost: costDouble, fromWeight: weightDouble),
            success: { [weak self] (newNote) in

                self?.currentMultiplerLabel.text = String(format: "%.2f", newNote.customMutipler)
                self?.resetButton.isEnabled = true
        }, failure: { (error) in

            print("Error from \(#file) \(#line): \(error)")
        })
    }

    @IBAction func didTapCloseButton(_ sender: UIButton) {

        if let callBack = dismissCallBack {

            dismiss(animated: true, completion: callBack)

        } else {

            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func didChangeWeightTypeSegment(_ sender: UISegmentedControl) {

        let segmentArray: [CalculateWeightType] = [.kilogram, .taigram, .gram]

        weightType = segmentArray[sender.selectedSegmentIndex]
    }

    @IBAction func didTapResetButton(_ sender: UIButton) {

        manager.resetModel(toItemCode: itemCodeInput, success: { [weak self] (originNote) in
            self?.currentMultiplerLabel.text = String(format: "%.2f", originNote.customMutipler)
            self?.resetButton.isEnabled = false
        }, failure: { (error) in
            print("Error from \(#file) \(#line): \(error)")
        })
    }
}

// MARK: - TextFieldDelegate
extension CalculateViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
        ) -> Bool {

        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

        if newText.isEmpty { return true }

        if Double(newText) != nil { return true }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        textField.backgroundColor = UIColor.white
        textField.text = nil
        textField.textColor = UIColor.black
    }

}
