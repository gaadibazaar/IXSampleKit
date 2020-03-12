//
//  IXTextField.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit


/// <#Description#>
///
/// - none: <#none description#>
/// - basic: <#basic description#>
/// - advance: <#advance description#>
public enum IXTextFieldInputAccessory{
    case none
    case basic
    case advance
}

///
open class IXTextField: UITextField {

    /// didchange text listener
    private var _textLintener : ((IXTextField,String)->Bool)?
    
    /// return action next IXTextField and previous IXTextField
    fileprivate var _returnActionLintener : ((IXTextField)->Bool)?
    
    /// did change validation listener
    private var _validationShouldTextChangeHandler : ((IXTextField,IXTextFieldValidator)->Void)?
    
    /// <#Description#>
    private var _validationTextEndEditingHandler : ((IXTextField,IXTextFieldValidator)->Void)?

    /// create actual delete to the corresponded class
    private var _delegate :UITextFieldDelegate?
    
    /// when
    private var _nextTextField :UIControl?
    
    ///
    private var _previousTextField :UIControl?

    private var doneBarbuttonPressed = false

    private var _text:String{
        return (self.text ?? "")
    }
    /// <#Description#>
    private lazy var _textChangevalidations:[IXTextFieldValidator]={ return Array<IXTextFieldValidator>()}()
    /// <#Description#>
    private lazy var _textEndEditingvalidations:[IXTextFieldValidator]={ return Array<IXTextFieldValidator>()}()

    
    //defalut is none
    open var inputAccessoryType = IXTextFieldInputAccessory.basic

    ///for text reference, it can any type, usecase, if you want to set text on textFld at the same time you need to the object, you can use this ref
    public var ref :Any?
    
    //MARK:- Override
    /// forwarding delegate to internal and external class
    override open var delegate: UITextFieldDelegate?{
        set{
            _delegate = newValue
            super.delegate = self
        }
        get{
            return _delegate
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.delegate = self
    }
    deinit {
        _previousTextField = nil
        _nextTextField = nil
    }
    // method forwading to corresponded class(_delegate)
    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        /// comportable to UITextFieldDelegate delegate class
        if let realDelegate = _delegate, realDelegate.responds(to: aSelector) {
            return realDelegate
        } else {
            //forwarding to super class
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    //  this will allow to validate _delegate responds to the correponded class
    override open func responds(to aSelector: Selector!) -> Bool {
        if let realDelegate = _delegate, realDelegate.responds(to: aSelector) {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }
    public func clear(){
        self.text = nil
        self.ref = nil
    }
}
//MARK:- Delegate
extension IXTextField :UITextFieldDelegate{
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       _setToolBar()
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        func _nextTextFieldBecome(_ allow:Bool){
            if allow {
                _ = _returnActionLintener?(self)
                if doneBarbuttonPressed{
                    _nextTextField?.perform(#selector(becomeFirstResponder), with: _nextTextField, afterDelay: 0.25)
                    doneBarbuttonPressed = false
                }
            }
        }
        if _textEndEditingvalidations.count>0 {
            let validationResult = _textEndEditingvalidations._isValid(_text)
            if !validationResult.valid {
                _validationTextEndEditingHandler?(self,validationResult.validator!)
            }
            //tmp fix, need to optimaize logic
            if validationResult.validator == nil && validationResult.valid{
                _nextTextFieldBecome(true)
                return true
            }
            if validationResult.validator!.optinal && !validationResult.valid && _text.count ==  0 {
                _nextTextFieldBecome(true)
                return true
            }
            _nextTextFieldBecome(validationResult.valid)
//            if let regex = validationResult.validator, regex.optinal{
//                return true
//            }
//            return validationResult.valid
            return true
        }
        if let allow = _returnActionLintener?(self){ _nextTextFieldBecome(allow);  return allow  }
        if let allow = _delegate?.textFieldShouldEndEditing?(textField){ _nextTextFieldBecome(allow);  return allow  }
        return true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var finalString = _text
        //get range from the original text
        if let text = textField.text,let txtRange = Range.init(range, in: text) {
            //replace text with range, adding text or delete text
            finalString = text.replacingCharacters(in: txtRange, with: string)
        }
        if _textChangevalidations.count>0 {
            _ = _textLintener?(self,finalString)
            let validationResult = _textChangevalidations._isValid(finalString)
            if !validationResult.valid{
                _validationShouldTextChangeHandler?(self,validationResult.validator!)
            }
            return validationResult.valid
        }
        if let allow = _textLintener?(self,finalString){ return allow  }
        if let allow = _delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) {
            return allow
        }
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let allow = _delegate?.textFieldShouldReturn?(textField) {
            return allow
        }
        return  true
    }
    public func willChangeText(_ handler:((IXTextField,String)->Bool)?){
        _textLintener = handler
    }
    public func willDismissKeyboard(_ handler:((IXTextField)->Bool)?){
        _returnActionLintener = handler
    }
}

//MARK:- Utilities
public extension IXTextField{
    var isEmpty:Bool{
        var txt = self.text?.replacingOccurrences(of: " ", with: "")
        txt = self.text?.replacingOccurrences(of: "\n", with: "")
        return txt == nil || txt == ""
    }
    func setPrevious(_ text1:UIControl?,_ text2:UIControl?){
        self._previousTextField = text1
        self._nextTextField = text2
    }
}


//MARK:- Validation
public extension IXTextField{
    
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    public func textShouldTextChangeError(_ handler:((IXTextField,IXTextFieldValidator)->Void)?){
        _validationShouldTextChangeHandler = handler
    }
    
    /// <#Description#>
    ///
    /// - Parameter handler: <#handler description#>
    public func textEndEditingError(_ handler:((IXTextField,IXTextFieldValidator)->Void)?){
        _validationTextEndEditingHandler = handler
    }
    
    /// <#Description#>
    ///
    /// - Parameter validation: <#validation description#>
    public func addValidationShouldTextChange( _ validation:IXTextFieldValidator){
        _textChangevalidations.append(validation)
    }
    
    /// <#Description#>
    ///
    /// - Parameter validation: <#validation description#>
    public func addValidationTextEndEditing( _ validation:IXTextFieldValidator){
        _textEndEditingvalidations.append(validation)
    }
    
    /// <#Description#>
    ///
    /// - Parameter validation: <#validation description#>
    public func addValidation( _ validation:IXTextFieldValidator){
       _textChangevalidations.append(validation)
       _textEndEditingvalidations.append( validation)
    }
    
    /// <#Description#>
    public func clearValidation(){
        _textChangevalidations.removeAll()
        _textEndEditingvalidations.removeAll()
    }
    
    /// <#Description#>
    public var  isValid: Bool{
        return _textEndEditingvalidations._isValid((self.text ?? "")).valid
    }
    
    
}

// MARK: - Evaluvate Array Validation
private extension Array where Element:IXTextFieldValidator{
    
     /// <#Description#>
     ///
     /// - Parameter validation_text: <#validation_text description#>
     /// - Returns: <#return value description#>
     func _isValid(_ validation_text:String)->(valid:Bool,validator:IXTextFieldValidator?){
       
        for _validation in self{
            let valid  = NSRegularExpression.evaluate(text: validation_text, regex:_validation.rule.rawValue)
            if !valid{
                return (valid:false,validator:_validation)
            }
        }
        return (valid:true,validator:nil)
    }
}

//MARK:- Toolbar InputAccessory
private extension IXTextField {
    
    /// <#Description#>
    func _setToolBar(){
        if self.inputAccessoryType == .none {
            return
        }
        let toolbar = UIToolbar.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.frame.width, height: 44)))
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        let space = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action:nil)
        space.width = 15
        let done = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneBarButtonAction))
        var items = [space]
        
        var arrow = UIImage.arrow(size: CGSize.init(width: 15, height: 25))
        if #available(iOS 10, * ){
            arrow = arrow.withHorizontallyFlippedOrientation()
        }else{
            assert(false, "withHorizontallyFlippedOrientation not allowed 10.* please add flip function")
        }
        items.append(UIBarButtonItem.init(image: arrow, style: .plain, target: self, action: #selector(previousBarButtonAction)))
        items.append(space)
        items.append(UIBarButtonItem.init(image: UIImage.arrow(size: CGSize.init(width: 15, height: 25)), style: .plain, target: self, action: #selector(nextBarButtonAction)))
        if _previousTextField == nil {
            //index 1 means previous bar button
            items[1].isEnabled = false
        }
        if _nextTextField == nil {
            //index 3 means next bar button
            items[3].isEnabled = false
        }else{
            self.returnKeyType = .next
        }
        if self.inputAccessoryType == .advance {
            items.insert(flex, at: items.count-1)
            
        }else{
            items.append(flex)
            items.append(done)
        }
        toolbar.items = items
        super.inputAccessoryView = toolbar
        
    }
    @objc func previousBarButtonAction(){
        doneBarbuttonPressed = true
        self._previousTextField?.becomeFirstResponder()
    }
    @objc func nextBarButtonAction(){
        doneBarbuttonPressed = true
        self._nextTextField?.becomeFirstResponder()
    }
    @objc func doneBarButtonAction(){
        self.endEditing(true)
    }
    
}

//MARK:- Animation
public extension IXTextField{
    public func shakeAnimation( _ color:UIColor=UIColor.red){
        let animation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        animation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)]
        animation.duration = 0.15
        animation.repeatCount = 2
        animation.values = [-20,-10,0,10,20]
        //        layer.add(animation, forKey: "shake")
        let errorLayer = CALayer.init()
        errorLayer.frame = bounds
        errorLayer.borderColor = color.cgColor
        errorLayer.borderWidth = 1
        errorLayer.add(animation, forKey: "shake")
        layer.addSublayer(errorLayer)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            errorLayer.removeFromSuperlayer()
        }
    }
}
// MARK: - Draw arrow icon
fileprivate extension UIImage{
    class func arrow(size:CGSize)->UIImage {
        let draw_image = UIImage.init()
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return UIImage()
        }
        draw_image.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        context.move(to: CGPoint.zero)
        context.addLine(to: CGPoint.init(x: size.width, y: size.height/2))
        context.addLine(to: CGPoint.init(x: 0, y: size.height))
        context.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()// ?? UIImage();
        UIGraphicsEndImageContext()
        return image!
    }
}

