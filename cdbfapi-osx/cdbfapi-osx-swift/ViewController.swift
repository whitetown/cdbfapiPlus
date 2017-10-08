//
//  ViewController.swift
//  cdbfapi-osx-swift
//
//  Created by Sergey Chehuta on 26/09/2017.
//  Copyright © 2017 WhiteTown. All rights reserved.
//

import Cocoa
import cdbfapi

class ViewController: NSViewController, NSTabViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableViewS: NSTableView!
    @IBOutlet weak var tableViewD: NSTableView!

    var dbf = cdbfapi()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func btnTap(_ sender: Any)
    {
        while(self.tableViewS.numberOfColumns > 0) {
            self.tableViewS.removeTableColumn(self.tableViewS.tableColumns.first!)
        }

        while(self.tableViewD.numberOfColumns > 0) {
            self.tableViewD.removeTableColumn(self.tableViewD.tableColumns.first!)
        }

        let filename = Bundle.main.resourcePath?.appending("/example.dbf")

        self.dbf = cdbfapi()

        if self.dbf.openDBFfile(filename!)
        {
            self.dbf.setDateFormat("dmy")

            let tc = NSTableColumn()
            tc.title = "Fields";
            self.tableViewS.addTableColumn(tc)

            for field in 0...self.dbf.fieldCount()-1
            {
                let tc = NSTableColumn()
                tc.title = self.dbf.fieldName(field) ?? "-"
                self.tableViewD.addTableColumn(tc)
            }
        }

        self.tableViewS.reloadData()
        self.tableViewD.reloadData()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == tableViewS {
            return self.dbf.fieldCount()
        } else {
            return self.dbf.recCount()
        }
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {

        var text = ""

        if tableView == self.tableViewS
        {
            text = String.init(format: "%@ %c(%ld.%ld)",
                                    self.dbf.fieldName(row) ?? "-",
                                    self.dbf.fieldType(row),
                                    self.dbf.fieldLength(row),
                                    self.dbf.fieldDecimal(row))
        }

        if tableView == self.tableViewD
        {
            self.dbf.getRecord(row)
            var data = [String]()
            for field in 0...self.dbf.fieldCount()-1
            {
                data.append((self.dbf.getString(field) ?? "").trimmingCharacters(in: .whitespacesAndNewlines) )
            }

            text = data.joined(separator: ", ")
        }

        let cell = NSCell(textCell: text)
        return cell;

    }

}

