//
//  EditNoteViewController.swift
//  Notes
//
//  Created by Keerthana Reddy Ragi on 15/04/18.
//  Copyright © 2018 Keerthana Reddy Ragi. All rights reserved.
//

import AsyncDisplayKit

protocol NoteEditedDelegate: class {
    func updateNote(titleValue: String, descriptionValue: String, index: Int)
    func deleteNoteAt(index: Int)
}

class EditNoteViewController: ASViewController<ASDisplayNode>, NoteDisplayDelegate {
    
    var titleValue: String
    var descriptionValue: String
    var indexValue: Int
    weak public var delegate: NoteEditedDelegate?
    
    init(title: String = "New Title", description: String = "New Description", index: Int, new: Bool) {
        indexValue = index
        titleValue = title
        descriptionValue = description
        let noteNode = NoteDisplay(title: title, description: description, new: new)
        super.init(node: noteNode)
        noteNode.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DELETE", style: .plain, target: self, action: #selector(deleteNote))
        self.view.backgroundColor = .white
    }
    
    func saveNote(titleValue: String, descriptionValue: String) {
        self.delegate?.updateNote(titleValue: titleValue, descriptionValue: descriptionValue, index: self.indexValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteNote() {
        self.delegate?.deleteNoteAt(index: self.indexValue)
        self.navigationController?.popViewController(animated: true)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol NoteDisplayDelegate: class {
    func saveNote(titleValue: String, descriptionValue: String)
}

class NoteDisplay: ASDisplayNode {
    var titleValue: String
    var descriptionValue: String
    let titleNode = ASEditableTextNode()
    let descriptionNode = ASEditableTextNode()
    var new = false
    weak public var delegate: NoteDisplayDelegate?
    
    init(title: String, description: String, new: Bool) {
        self.titleValue = title
        self.descriptionValue = description
        self.new = new
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    @objc func saveNote() {
        self.delegate?.saveNote(titleValue: titleNode.textView.text, descriptionValue: descriptionNode.textView.text)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalSpec = ASStackLayoutSpec.vertical()
        descriptionNode.style.minHeight = ASDimensionMake(200)
        if new {
            titleNode.placeholderEnabled = true
            titleNode.typingAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black, NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 16)]
            titleNode.attributedPlaceholderText =  NSAttributedString(string: self.titleValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.black])
            descriptionNode.placeholderEnabled = true
            descriptionNode.typingAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.gray, NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 16)]
            descriptionNode.attributedPlaceholderText = NSAttributedString(string: self.descriptionValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.gray])
        } else {
            titleNode.attributedText = NSAttributedString(string: self.titleValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.black])
            descriptionNode.attributedText = NSAttributedString(string: self.descriptionValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.gray])
        }
        verticalSpec.children = [titleNode, descriptionNode]
        verticalSpec.spacing = 8
        let footerText = ASTextNode()
        footerText.borderColor = UIColor.brown.cgColor
        footerText.borderWidth = 0.5
        footerText.cornerRadius = 4
        footerText.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        footerText.addTarget(self, action: #selector(saveNote), forControlEvents: .touchUpInside)
        footerText.attributedText = NSAttributedString(string: "Save", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        verticalSpec.children?.append(footerText)
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 74, left: 16, bottom: 0, right: 16), child: verticalSpec)
    }
}
