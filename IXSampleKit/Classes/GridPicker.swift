//
//  GridPicker.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit

public protocol GridPickerItem {
    var id :String? {get}
}
open class GridPicker: UIView ,UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    typealias BlockHandler = ((GridPickerCell,GridPickerItem,Int)->Void)
    
    open var collectionView : UICollectionView!
    
    open var flow = UICollectionViewFlowLayout()
    
    fileprivate var items = Array<GridPickerItem>()
    
    private var cellLoadHandler : BlockHandler?
    
    private var cellContrainHandler : BlockHandler?
    
    private var cellSizeForHeightHandler : ((GridPickerItem,Int)->CGSize)?
    private var cellWillSelectHandler : ((GridPickerCell,GridPickerItem,Int)->Bool)?
    
    private var completionHandler : BlockHandler?
    
    open var normalColor = UIColor.white
    
    open var selectedIndex = -1
    
    open var disbleSelection = false
    
    public var count:Int{
        return items.count
    }
    //MARK: - Alloc
    public init()  {
        super.init(frame : CGRect.zero)
        allocInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allocInit()
    }
    
    func allocInit()  {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        collectionView = UICollectionView(frame:  CGRect.zero , collectionViewLayout: flow)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.parentLayout()
        self.collectionView.register(GridPickerCell.self, forCellWithReuseIdentifier: GridPickerCell.identifier)
        collectionView.reloadData()
    }
    //MARK:- UICollectionView
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridPickerCell.identifier, for: indexPath) as! GridPickerCell
        if cell.titleLabel.frame == CGRect.zero && cell.detailsLabel.frame == CGRect.zero && cell.imageView.frame == CGRect.zero {
            cellContrainHandler?(cell,items[indexPath.row],indexPath.row)
        }
        if self.selectedIndex == indexPath.row {
            cell.backgroundColor = self.tintColor
        }else{
            cell.backgroundColor = self.normalColor
        }
        self.cellLoadHandler?(cell,items[indexPath.row],indexPath.row)
       
        return cell
    }
   
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.disbleSelection{
            return
        }
        if self.selectedIndex == indexPath.row {
            self.selectedIndex = -1
        }else{
            self.selectedIndex = indexPath.row
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? GridPickerCell {
            self.completionHandler?(cell,items[indexPath.row],indexPath.row)
        }
        collectionView.reloadData()
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let handler = self.cellSizeForHeightHandler?(items[indexPath.row],indexPath.row){
            return handler
        }
        return flow.itemSize
    }
    
    //MARK:- Public
    open func pickerItem(_ item:Array<GridPickerItem>) {
        self.items = item
        self.collectionView.reloadData()
    }
    open func addCellContrain(_ handler: ((GridPickerCell,GridPickerItem,Int)->Void)?) {
        self.cellContrainHandler = handler
    }
    open func loadCell(_ handler: ((GridPickerCell,GridPickerItem,Int)->Void)?) {
        self.cellLoadHandler = handler
    }
    open func cellWillSelectHandler(_ handler: ((GridPickerCell,GridPickerItem,Int)->Bool)?) {
        self.cellWillSelectHandler = handler
    }
    open func didSelectItem(_ handler: ((GridPickerCell,GridPickerItem,Int)->Void)?) {
        self.completionHandler = handler
    }
    open func cellSizeForHeight(_ handler: ((GridPickerItem,Int)->CGSize)?) {
        self.cellSizeForHeightHandler = handler
    }
}

open class GridPickerCell:UICollectionViewCell{
    
    public var imageView:UIImageView!
    public var titleLabel:UILabel!
    public var detailsLabel:UILabel!
    static var identifier = "GridPicker"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _allocInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _allocInit()
    }
    private func _allocInit(){
        self.imageView = UIImageView.init(frame: CGRect.zero)
        self.contentView.addSubview(self.imageView)
        
        self.titleLabel = UILabel.init(frame: CGRect.zero)
        self.contentView.addSubview(self.titleLabel)
        
        self.detailsLabel = UILabel.init(frame:CGRect.zero)
        self.contentView.addSubview(self.detailsLabel)
    }
}


