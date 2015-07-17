//
//  ViewController.swift
//  swiftTableViewApp
//
//  Created by 鬼塚峰行 on 2015/05/23.
//  Copyright (c) 2015年 onizuka. All rights reserved.
//

import UIKit

class dataObj: RLMObject{
    dynamic var id = ""
    dynamic var date = ""
    
    override class func primaryKey() -> String{
        return "id"
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate {
    var tableView: UITableView?
    let listArray: NSMutableArray = NSMutableArray()
    let WIN_SIZE: CGSize = UIScreen.mainScreen().bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ToDo"
        
        var addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "pressAddButton:")
        
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.rightBarButtonItem = addButton
        
        tableView = UITableView(frame: CGRectMake(0, 0, WIN_SIZE.width, WIN_SIZE.height),style: UITableViewStyle.Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
    }
    //追加ボタンをおした時の処理
    func pressAddButton(button:UIButton){
        println("add")
        
        var date: NSDate = NSDate()
        var formatter: NSDateFormatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        var now = formatter.stringFromDate(date)
        var row = -1
        let allData = dataObj.allObjects()
        row = Int(allData.count)
        
        //Realmオブジェクトを生成してセットする
        let d = dataObj()
        d.id = String(row)
        d.date = now
        
        var indexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
        tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        //Realmトランザクション
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock({ () -> Void in
            realm.addObject(d)
        })
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セルの数を返す
        let allData = dataObj.allObjects()
        return Int(allData.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = dataObj(forPrimaryKey: String(indexPath.row))
        //指定されたIndexPathのCellを作成する
        let cellIdentifier = "Cell"
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        
        cell.textLabel!.text = data.date
        
        return cell
    }
    
    //セルが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //配列から要素を削除
            listArray.removeObjectAtIndex(indexPath.row)
            //テーブルから行を削除
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //行の並び替えを可能にする
        return true
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "削除"
    }

}

