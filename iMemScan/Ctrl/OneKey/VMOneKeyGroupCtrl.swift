//
//  VMOneKeyGroupCtrl.swift
//  iMemScan
//
//  Created by HaoCold on 2021/8/20.
//

import UIKit

class VMOneKeyGroupCtrl: UIViewController {

    var dataArray: [VMOneKeyGroupModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "分组"
        setupViews()
    }

    // MARK: - 视图
    
    func setupViews() {
        
        dataArray = []
        VMOneKeyTool.setup()
        let arr = VMOneKeyTool.allRecords(.group)
        for model in arr {
            dataArray.append(model as! VMOneKeyGroupModel)
        }
                
        let titles = ["添加"]
        var items: [AnyHashable]? = []
        for i in 0..<titles.count {
            let button = UIButton(type: .system)
            button.frame = .init(x: 0, y: 0, width: 50, height: 25)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitle(titles[i], for: .normal)
            button.setTitle(titles[i], for: .highlighted)
            button.tag = i
            button.layer.cornerRadius = 12.5
            button.backgroundColor = .secondarySystemBackground
            button.tintColor = UIColor.dynamicColor(.gray, darkColor: UIColor.white)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)

            let item = UIBarButtonItem(customView: button)
            items?.append(item)
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItems = items as? [UIBarButtonItem]
        
        view.addSubview(tableView)
        tableView.rowHeight = 44
        tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:))))
    }
    
    // MARK: - 排序
    
    @objc func buttonAction(_ button: UIBarButtonItem?) {
        if button?.tag == 0 {
            addAction()
        }
    }
    
    // MARK: - 添加
    @objc func addAction() {
        UIAlertController.showAlert("添加组", message: nil, holder: "名称", buttonTitle: "确定", handler: { [self] text in
            let model = VMOneKeyGroupModel()
            model.name = text!
            
            self.dataArray.append(model)
            self.tableView.reloadData()
            
            VMOneKeyTool.saveGroup(model)
            VMOneKeyTool.save(.group)
        })
    }
    
    // MARK: - 长按重复名
    @objc func longPressAction(_ gesture: UIGestureRecognizer?) {
        let indexPath = tableView.indexPathForRow(at: gesture?.location(in: gesture?.view) ?? CGPoint.zero)
        if indexPath == nil {
            return
        }
        
        let model = self.dataArray[indexPath!.row]

        let title = "修改(\(model.name))名称"
        UIAlertController.showAlert_holder(title, message: "重新为分组命名", holder: model.name, buttonTitle: "修改", handler: { [self] text in
            model.name = text!
            
            self.tableView.reloadData()
            VMOneKeyTool.save(.record)
            
        })
    }
    
    // MARK: - 懒加载
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 45
        tableView.sectionHeaderHeight = 30
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = true
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 增加顶部距离
        tableView.tableHeaderView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = UIColor.clear
            return view
        }()
        
        return tableView
    }()
}

extension VMOneKeyGroupCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if view == nil {
            view = UITableViewHeaderFooterView(reuseIdentifier: "header")
        }
        
        if section == 0 {
            if dataArray.count > 0 {
                view?.textLabel?.text = "前往脚本"
            }
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "resueID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "resueID")
        }
        
        let model = dataArray[indexPath.row]
        cell?.textLabel?.text = model.name
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = dataArray[indexPath.row]
        
        let ctrl = VMOneKeyCtrl()
        ctrl.gid = model.gid
        ctrl.name = model.name
        
        navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            UIAlertController.showAlert5("提示", message: "确定删除该组?", buttonTitle: "删除", isdefault: false) {
                let model = self.dataArray[indexPath.row]
                
                self.dataArray.remove(at: indexPath.row)
                tableView.reloadData()
                
                VMOneKeyTool.deleteGroup(model)
                VMOneKeyTool.saveAll()
            }
        }
    }
}
