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
        static let placeholder = UnsafeRawPointer.init(bitPattern: "PLACEHOLDEL".hashValue)
        static let limitLength = UnsafeRawPointer.init(bitPattern: "LIMITLENGTH".hashValue)
        static let limitLines = UnsafeRawPointer.init(bitPattern: "LIMITLINES".hashValue)
        static let placeholderLabel = UnsafeRawPointer.init(bitPattern: "PLACEHOLDELABEL".hashValue)
        static let wordCountLabel = UnsafeRawPointer.init(bitPattern: "WORDCOUNTLABEL".hashValue)
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
            NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: .UITextViewTextDidChange, object: self)
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
    /*
     *  占位符
     */
    fileprivate func initPlaceholder(_ placeholder: String) {

        NotificationCenter.default.addObserver(self, selector: #selector(textChange(_:)), name: .UITextViewTextDidChange, object: self)
        let font = UIFont.systemFont(ofSize: 13)
        self.placeholderLabel = UILabel()
        placeholderLabel?.font = font
        placeholderLabel?.text = placeholder
        placeholderLabel?.numberOfLines = 0
        placeholderLabel?.lineBreakMode = .byWordWrapping
        placeholderLabel?.textColor = .lightGray
        let rect = placeholder.boundingRect(with: CGSize(width: self.frame.size.width - 14, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil)
        placeholderLabel?.frame = CGRect(x: 7, y: 7, width: rect.size.width, height: rect.size.height)
        addSubview(self.placeholderLabel!)
        placeholderLabel?.isHidden = self.text.characters.count > 0 ? true : false
    }
    
    /*
     *  字数限制
     */
    fileprivate func initWordCountLabel(_ limitLength : NSNumber) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(limitLengthEvent), name: .UITextViewTextDidChange, object: self)
         if wordCountLabel != nil {
            wordCountLabel?.removeFromSuperview()
        }
        wordCountLabel = UILabel(frame: CGRect(x: self.frame.size.width - 65, y: self.frame.size.height - 20, width: 60, height: 20))
        let font = UIFont.systemFont(ofSize: 13)
        wordCountLabel?.textAlignment = .right
        wordCountLabel?.textColor = .lightGray
        wordCountLabel?.font = font
        if self.text.characters.count > limitLength.intValue {
            self.text = (self.text as NSString).substring(to: limitLength.intValue)
        }
        wordCountLabel?.text = "\(self.text.characters.count)/\(limitLength)"
        addSubview(wordCountLabel!)
    }
    
    
    /*
     *  动态监听
     */
    @objc fileprivate func textChange(_ notification : Notification) {

        if placeholder != nil {
            placeholderLabel?.isHidden = true
            if self.text.characters.count ==  0 {
                self.placeholderLabel?.isHidden = false
            }
        }
        if limitLength != nil {
            var wordCount = self.text.characters.count
            if wordCount > (limitLength?.intValue)! {
                wordCount = (limitLength?.intValue)!
            }
            let limit = limitLength!.stringValue
            wordCountLabel?.text = "\(wordCount)/\(limit)"
        }
        
    }

    @objc fileprivate func limitLengthEvent() {
        if limitLength != nil {
            if self.text.characters.count > (limitLength?.intValue)! && limitLength != nil {
                self.text = (self.text as NSString).substring(to: (limitLength?.intValue)!)
                print("Maximum number of words");
            }
        }else {
            if (limitLines != nil) {//行数限制
                let size = getStringPlaceSize(self.text, textFont: self.font!)
                let height = self.font!.lineHeight * CGFloat(limitLines!.floatValue)
                if (size.height > height) {
                    self.text = (self.text as NSString).substring(to: self.text.characters.count - 1)
                    print("Maximum number of lines");
                }
            }
        }
    }
    
    @objc fileprivate func getStringPlaceSize(_ string : String, textFont : UIFont) -> CGSize {
        ///计算文本高度
        let attribute = [NSFontAttributeName : textFont];
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = string.boundingRect(with: CGSize(width: self.contentSize.width-10, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attribute, context: nil).size
        return size
    }
    //MARK: 不支持   fuck!
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: self)
//
//    }
//    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if limitLength != nil && wordCountLabel != nil {
            /*
             *  避免外部使用了约束 这里再次更新frame
             */
            wordCountLabel!.frame = CGRect(x: frame.width - 65, y: frame.height - 20, width: 60, height: 20)
        }
    }

}






