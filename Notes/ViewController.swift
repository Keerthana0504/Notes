//
//  ViewController.swift
//  Notes
//
//  Created by Keerthana Reddy Ragi on 31/03/18.
//  Copyright © 2018 Keerthana Reddy Ragi. All rights reserved.
//

import UIKit
import AsyncDisplayKit

struct Note {
    let title: String
    let description: String
}

class ViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {
    
    var notes = [Note]()
    private var tableView = ASTableNode()
    override func viewDidLoad() {
        self.title = "Notes"
        drawTable()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let note = notes[indexPath.row]
        let node = DisplayData(title: note.title, description: note.description)
        node.style.preferredSize.height = CGFloat(60)
        node.borderWidth = 0.5
        node.borderColor = UIColor.gray.cgColor
        node.automaticallyManagesSubnodes = true
        return node
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let footerText = ASTextNode()
        footerText.borderColor = UIColor.brown.cgColor
        footerText.borderWidth = 0.5
        footerText.cornerRadius = 4
        footerText.textContainerInset = UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        footerText.attributedText = NSAttributedString(string: "Add Note", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        footerView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: 20, width: 100, height: 40)
        footerText.frame = footerView.frame
        footerText.addTarget(self, action: #selector(addNote), forControlEvents: .touchUpInside)
        footerView.addSubnode(footerText)
        return footerView
    }
    
    @objc func addNote() {
        let editScreen = EditNoteViewController(index: notes.count, new: true)
        editScreen.title = "Add Note"
        editScreen.delegate = self
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let editScreen = EditNoteViewController(title: note.title, description: note.description, index: indexPath.row, new: false)
        editScreen.title = "Edit Note"
        editScreen.delegate = self
        self.navigationController?.pushViewController(editScreen, animated: true)
        tableView.view.deselectRow(at: indexPath, animated: true)
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func drawTable() {
        notes.append(Note(title: "Hello", description: "Data"))
        notes.append(Note(title: "Book a Movie Experience Near You With BookMyShow!", description: "Life has never been so convenient for a movie buff in Bengaluru! Remember the time when you had to stand in a long queue outside the theatre to book movie tickets? That time is gone now! With the emergence of BookMyShow, India's biggest online ticketing portal, booking movie tickets has become a cake walk. Now enjoy movies playing near you with just a click! BookMyShow is Movies on the go – Jahan Mood Kiya Wahan Book Kiya! Just take out your phone, launch the app, choose your movie, theatre & showtime near you, and book tickets online, right away! So simple. Isn't it! We give you some more amazingly cool reasons why you should book your movie tickets here like our Offers & Discounts!"))
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: UIScreen.main.bounds.height - 44)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.view.separatorStyle = .none
        self.view.addSubnode(tableView)
    }
}

extension ViewController: NoteEditedDelegate {
    func deleteNoteAt(index: Int) {
        if index < notes.count {
            self.notes.remove(at: index)
            tableView.view.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else {
            let alert = UIAlertController(title: "Error", message: "Unable to delete note", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateNote(titleValue: String, descriptionValue: String, index: Int) {
        if(index >= notes.count) {
            let newNote = Note(title: titleValue, description: descriptionValue)
            notes.append(newNote)
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else {
            let updatedNote = Note(title: titleValue, description: descriptionValue)
            notes[index] = updatedNote
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
        
    }
}

class DisplayData: ASCellNode {
    var titleValue: String
    var descriptionValue: String
    
    init(title: String, description: String) {
        self.titleValue = title
        self.descriptionValue = description
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalSpec = ASStackLayoutSpec.vertical()
        let textNode = ASTextNode()
        textNode.maximumNumberOfLines = 1
        textNode.truncationMode = .byTruncatingTail
        textNode.style.spacingBefore = 8
        textNode.attributedText = NSAttributedString(string: titleValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.darkText])
        verticalSpec.children?.append(textNode)
        let descriptionNode = ASTextNode()
        textNode.style.spacingAfter = 8
        descriptionNode.maximumNumberOfLines = 1
        descriptionNode.truncationMode = .byTruncatingTail
        descriptionNode.attributedText = NSAttributedString(string: descriptionValue, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),                                                                                                    NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        verticalSpec.children?.append(descriptionNode)
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16), child: verticalSpec)
    }
}
