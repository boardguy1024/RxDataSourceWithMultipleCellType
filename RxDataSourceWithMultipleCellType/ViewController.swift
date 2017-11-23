//
//  ViewController.swift
//  RxDataSourceWithMultipleCellType
//
//  Created by PIVOT on 2017/11/23.
//  Copyright © 2017年 PIVOT. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
    }
    
    func bindTableView() {
        let cities = Observable.of(["Lisbon","Seoul","London","Tokyo"])
        
        cities
            .bind(to: tableView.rx.items) { tableView, index, element in
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { model in
                print("\(model) was selected!")
            })
            .disposed(by: bag)
        
        tableView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: {
                print("willDisplayCell : \($0)")
            })
            .disposed(by: bag)
        
        tableView.rx.didEndDisplayingCell.asObservable()
            .subscribe(onNext: {
                print("didEndDisplayCell :\($0)")
            })
            .disposed(by: bag)
    }

}

