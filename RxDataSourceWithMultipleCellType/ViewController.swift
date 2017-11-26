//
//  ViewController.swift
//  RxDataSourceWithMultipleCellType
//
//  Created by PIVOT on 2017/11/26.
//  Copyright © 2017年 PIVOT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


enum CellType {
    case textEntry(String)
    case imageEntry(UIImage)
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let bag = DisposeBag()
    
    let observableItems: Observable<[CellType]> = Observable.of([
        .textEntry("hello"),
        .imageEntry(#imageLiteral(resourceName: "p1")),
        .textEntry("hello again"),
        .imageEntry(#imageLiteral(resourceName: "l1"))])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
        tableViewBind()
    }
    
    func registCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
        
    }
    func tableViewBind() {
        
        observableItems
            .bind(to: tableView.rx.items) { tableView , index, element in
                
                let indexpath = IndexPath(item: index, section: 0)
                
                switch element {
                case .textEntry(let text):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexpath)
                    cell.textLabel?.text = text
                    return cell
                case .imageEntry(let image):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexpath)
                    cell.imageView?.image = image
                    return cell
                }
            }
            .disposed(by: bag)
        
    }

}






