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

class ViewController_sample: UIViewController {
    
    enum MyModel {
        case textEntry(String)
        case imageEntry(UIImage)
    }
    
    //本来ならViewModelに追加すべき
    //ダミーMyModelタイプの値
    let observableItems: Observable<[MyModel]> = Observable.of([.textEntry("Paris"),
                                                           .imageEntry(#imageLiteral(resourceName: "p1")),
                                                           .textEntry("London"),
                                                           .imageEntry(#imageLiteral(resourceName: "l1"))])
    
    let bag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        bindTableView()
    }
    
    func registerCells() {
        
        //titleセル登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        //imageセル登録
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "imageCell")
    }
    
    func bindTableView() {
        
        //MyModelタイプのItemsを -> tableView.rx.itemとバインド
        observableItems
            .bind(to: tableView.rx.items) { tableView, index, element in
            
            let indexPath = IndexPath(item: index, section: 0)
            
            // ここで 渡ってきた値のタイプによってセル表示を出し分ける
            switch element {
            case .textEntry(let title):
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
                cell.textLabel?.text = title
                return cell
            case .imageEntry(let image):
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
                cell.imageView?.image = image
                return cell
            }
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

