//
//  EditPosterViewController.swift
//  City Prints
//
//  Created by Terence Williams on 5/25/21.
//

import UIKit

class EditPosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var sections: [PosterSection] = []
    var titleString: String = ""
    var subtitleString: String = ""
    var descriptionString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()

        table.delegate = self
        table.dataSource = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setupData() {
        let editPosterTableViewCell = UINib(nibName: "EditPosterTableViewCell", bundle: nil)
        table.register(editPosterTableViewCell, forCellReuseIdentifier: "EditPosterTableViewCell")
        
        sections = [.title, .subtitle, .description]
    }
    
    //MARK: - Actions
    @IBAction func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
        let titleCell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPosterTableViewCell
        let subtitleCell = table.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditPosterTableViewCell
        let descriptionCell = table.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditPosterTableViewCell
                
        let posterDataDict:[String: String?] = ["title": titleCell?.textview.text, "subtitle": subtitleCell?.textview.text, "description": descriptionCell?.textview.text]
        
        NotificationCenter.default.post(name: .didUpdateLabels,
                                        object: nil,
                                        userInfo: posterDataDict as [AnyHashable : Any])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "EditPosterTableViewCell", for: indexPath) as? EditPosterTableViewCell
        
        let section = sections[indexPath.row]
        cell?.titleLabel.text = title(_forSection: section)
        cell?.textview.text = data(_forSection: section)
        return cell!
    }
    
    //MARK: Helpers
    func title(_forSection section: PosterSection) -> String {
        switch section {
        case .title:
            return "Title"
        case .subtitle:
            return "Subtitle"
        case .description:
            return "Description"
        }
    }
    
    func data(_forSection section: PosterSection) -> String {
        switch section {
        case .title:
            return titleString
        case .subtitle:
            return subtitleString
        case .description:
            return descriptionString
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            table.contentInset = .zero
        } else {
            table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 50, right: 0)
        }

        table.scrollIndicatorInsets = table.contentInset
    }
}

enum PosterSection {
    case title
    case subtitle
    case description
}
