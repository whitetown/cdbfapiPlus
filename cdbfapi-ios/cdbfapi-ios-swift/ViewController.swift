//
//  ViewController.swift
//  cdbfapi-ios-swift
//
//  Created by Sergey Chehuta on 26/09/2017.
//  Copyright © 2017 WhiteTown. All rights reserved.
//

import UIKit
import cdbfapi

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewS: UITableView!
    @IBOutlet weak var tableViewD: UITableView!

    var dbf = cdbfapi()

    let cellID = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableViewS.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.tableViewD.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    @IBAction func btnTap(_ sender: Any)
    {
        let filename = Bundle.main.resourcePath?.appending("/example.dbf")

        self.dbf = cdbfapi()
        self.dbf.openDBFfile(filename!)

        self.dbf.setDateFormat("dmy")

        self.tableViewS.reloadData()
        self.tableViewD.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewS {
            return self.dbf.fieldCount()
        } else {
            return self.dbf.recCount()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)

        if tableView == tableViewS {
            cell?.textLabel?.text = String.init(format: "%@ %c(%ld.%ld)",
                                    self.dbf.fieldName(indexPath.row) ?? "-",
                                    self.dbf.fieldType(indexPath.row),
                                    self.dbf.fieldLength(indexPath.row),
                                    self.dbf.fieldDecimal(indexPath.row));

        } else {
            self.dbf.getRecord(indexPath.row)
            var data = [String]()
            for field in 0...self.dbf.fieldCount()-1
            {
                data.append((self.dbf.getString(field) ?? "").trimmingCharacters(in: .whitespacesAndNewlines) )
            }

            cell?.textLabel?.text = data.joined(separator: ", ")
        }

        return cell!
    }


}

