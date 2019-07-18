//
//  UITextView-Extension.swift
//  4 Day
//
//  Created by 张雨露 on 2017/6/9.
//  Copyright © 2017年 张雨露. All rights reserved.
//

import UIKit

//MARK: 如果你想对textView.text直接赋值。请在设置属性之前进行，否则影响计算。

extension UITextView {

    fileprivate struct RuntimeKey {
        static let placeholder : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "PLACEHOLDEL".hashValue)
        static let limitLength : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LIMITLENGTH".hashValue)
        static let limitLines : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LIMITLINES".hashValue)
        static let placeholderLabel : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "PLACEHOLDELABEL".hashValue)
        static let wordCountLabel  : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "WORDCOUNTLABEL".hashValue)
        static let placeholdFont  : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "PLACEHOLDFONT".hashValue)
        static let placeholdColor : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "PLACEHOLDCOLOR".hashValue)
        static let limitLabelFont : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LIMITLABELFONT".hashValue)
        static let limitLabelColor : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LIMITLABLECOLOR".hashValue)
        static let autoHeight  : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "AUTOHEIGHT".hashValue)
        static let oldFrame  : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "LODFRAME".hashValue)

        // ...其他Key声明
    }
    /*
     *  使用runtime添加属性
     */

    var placeholder: String? {//占位符
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholder, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initPlaceholder(placeholder!)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholder) as? String
        }
    }
    var limitLength: NSNumber? {//限制的字数
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLength, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            initWordCountLabel(limitLength!)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLength) as? NSNumber
        }
    }
    var limitLines: NSNumber? {//限制的行数
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLines, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)
        
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLines) as? NSNumber
        }
    }
    var placeholderLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholderLabel) as? UILabel
        }
    }
    var wordCountLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.wordCountLabel) as? UILabel
        }
    }
    
    var placeholdFont: UIFont? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.font = placeholdFont
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont == nil ? UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdFont) as? UIFont
        }
    }
    
    var limitLabelFont: UIFont? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.wordCountLabel != nil {
                self.wordCountLabel?.font = limitLabelFont
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont) as? UIFont == nil ? UIFont.systemFont(ofSize: 13) : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelFont) as? UIFont
        }
    }
    var placeholdColor: UIColor? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.placeholdColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.placeholderLabel != nil {
                self.placeholderLabel?.textColor = placeholdColor
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.placeholdColor) as? UIColor
        }
    }
    var limitLabelColor: UIColor? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.wordCountLabel != nil {
                self.wordCountLabel?.textColor = limitLabelColor
            }
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor) as? UIColor == nil ? UIColor.lightGray : objc_getAssociatedObject(self, UITextView.RuntimeKey.limitLabelColor) as? UIColor
        }
    }
    var oldFrame: CGRect? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.oldFrame, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.oldFrame) as? CGRect
        }
    }
    var autoHeight: Bool? {
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.autoHeight, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UITextView.RuntimeKey.autoHeight) as? Bool
        }
    }
    /*
     *  占位符
     */
    fileprivate func initPlaceholder(_ placeholder: String) {

        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        self.placeholderLabel = UILabel()
        placeholderLabel?.font = self.placeholdFont
        placeholderLabel?.text = placeholder
        placeholderLabel?.numberOfLines = 0
        placeholderLabel?.lineBreakMode = .byWordWrapping
        placeholderLabel?.textColor = self.placeholdColor
        let rect = placeholder.boundingRect(with: CGSize(width: self.frame.size.width - 14, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.placeholdFont!], context: nil)
        placeholderLabel?.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
        addSubview(self.placeholderLabel!)
        placeholderLabel?.isHidden = self.text.count > 0 ? true : false
    }
    
    /*
     *  字数限制
     */
    fileprivate func initWordCountLabel(_ limitLength : NSNumber) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: UITextView.textDidChangeNotification, object: self)
         if wordCountLabel != nil {
            wordCountLabel?.removeFromSuperview()
        }
        wordCountLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width - 10, height: 20))
        wordCountLabel?.textAlignment = .right
        wordCountLabel?.textColor = self.limitLabelColor
        wordCountLabel?.font = self.limitLabelFont
        if self.text.count > limitLength.intValue {
            self.text = (self.text as NSString).substring(to: limitLength.intValue)
        }
        wordCountLabel?.text = "\(self.text.count)/\(limitLength)"
        addSubview(wordCountLabel!)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

    }
    
    
    /*
     *  动态监听
     */
    @objc fileprivate func textChange(_ notification : Notification) {

        if placeholder != nil {
            placeholderLabel?.isHidden = true
            if self.text.count ==  0 {
                self.placeholderLabel?.isHidden = false
            }
        }
        if limitLength != nil {
            var wordCount = self.text.count
            if wordCount > (limitLength?.intValue)! {
                wordCount = (limitLength?.intValue)!
            }
            let limit = limitLength!.stringValue
            wordCountLabel?.text = "\(wordCount)/\(limit)"
        }
        if autoHeight == true && self.oldFrame != nil {
            let size = getStringPlaceSize(self.text, textFont: self.font!)
            UIView.animate(withDuration: 0.15) {
                self.frame = CGRect.init(x: (self.oldFrame?.origin.x)!, y: (self.oldFrame?.origin.y)!, width: (self.oldFrame?.size.width)!, height: size.height + 25 <= (self.oldFrame?.size.height)! ? (self.oldFrame?.size.height)! : size.height + 25)
            }
        }
        
    }

    @objc fileprivate func limitLengthEvent() {
        if limitLength != nil {
            if self.text.count > (limitLength?.intValue)! && limitLength != nil {
                self.text = (self.text as NSString).substring(to: (limitLength?.intValue)!)
                print("Maximum number of words");
            }
        }else {
            if (limitLines != nil) {//行数限制
                let size = getStringPlaceSize(self.text, textFont: self.font!)
                let height = self.font!.lineHeight * CGFloat(limitLines!.floatValue)
                if (size.height > height) {
                    self.text = (self.text as NSString).substring(to: self.text.count - 1)
                    print("Maximum number of lines");
                }
            }
        }
    }
    
    @objc fileprivate func getStringPlaceSize(_ string : String, textFont : UIFont) -> CGSize {
        ///计算文本高度
        let attribute = [NSAttributedString.Key.font : textFont];
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: self.contentSize.width-10, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if limitLength != nil && wordCountLabel != nil {
            /*
             *  避免外部使用了约束 这里再次更新frame
             */
            wordCountLabel!.frame = CGRect(x: 0, y: frame.height - 20 + contentOffset.y, width: frame.width - 10, height: 20)
        }
        if placeholder != nil && placeholderLabel != nil {
            let rect: CGRect = placeholder!.boundingRect(with: CGSize(width: frame.width - 7, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)], context: nil)
            placeholderLabel!.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
        }
        if autoHeight == true {
            self.oldFrame = self.frame
            self.isScrollEnabled = false
        }else {
            self.isScrollEnabled = true
        }
    }

}
