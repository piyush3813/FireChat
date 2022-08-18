//
//  CustonInputAccessoryView.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import UIKit
protocol CustomInputAccessorydelegate: class {
    func inputView(_ inputView:CustomInputAccessoryView, wantsToSend message: String)
}
class CustomInputAccessoryView: UIView{
    //mark:properties
    weak var delegate:CustomInputAccessorydelegate?
    
    private let messagetextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
        
    }()
    
    private lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handlesendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placehonder: UILabel = {
        let label = UILabel()
        label.text = "entering message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //mark:lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messagetextView)
        messagetextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placehonder)
        placehonder.anchor(left: leftAnchor, paddingLeft: 4)
        placehonder.centerY(inView: messagetextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handletextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    //mark:selectors
    @objc func handlesendMessage(){
        guard let message = messagetextView.text else {
            return
        }
        delegate?.inputView(self, wantsToSend: message)
    }
    
    @objc func handletextInputChange(){
        placehonder.isHidden = !self.messagetextView.text.isEmpty
    }
    
    //MARK:HELPERS
    
    func clearMessageText(){
        messagetextView.text = nil
        placehonder.isHidden = false
    }
}
