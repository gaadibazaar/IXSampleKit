//
//  PaginationTableViewType.swift
//  IXSampleKit
//
//  Created by CIFCL on 12/03/20.
//

import UIKit

public enum PaginationTableViewType {
    case index
    case content
}

public protocol PaginationTableViewDelegate{
    func tableView(_ tableView: UITableView, nextPage page: UInt)
}
open class PaginationTableView: UITableView {
    
    open var type = PaginationTableViewType.content
    
    /// create actual delete to the corresponded class
    open var paginationDelegate :PaginationTableViewDelegate?
    
    /// create actual delete to the corresponded class
    private var _delegate :UITableViewDelegate?
    private var _dataSource :UITableViewDataSource?
    
    
    /// pagination
    private var _lastContentHeight : CGFloat = 0
    private var _visitedIndexPath :  IndexPath?
    private  var _page:UInt = 1
    
    var activity = UIActivityIndicatorView()
    
    open  var pageSize:UInt = 20
    
    public var currentPage:UInt{
        return _page
    }
    var totalCount : Int = 0

    open var loadingPagination: Bool = false{
        didSet{
            if loadingPagination{
                self.setFooterLoading()
            }else{
                activity.stopAnimating()
                super.tableFooterView = nil
            }
        }
    }
    //KVO
    var context = 0
    
    //MARK:- Override
    /// forwarding delegate to internal and external class
    override open var delegate: UITableViewDelegate?{
        set{
            _delegate = newValue
            super.delegate = self
        }
        get{
            return _delegate
        }
    }
    /// forwarding delegate to internal and external class
    override open var dataSource: UITableViewDataSource?{
        set{
            _dataSource = newValue
            super.dataSource = self
        }
        get{
            return _dataSource
        }
    }
    
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        intialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        intialize()
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &self.context{
            if let content = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                //                 didChangeOffset(content.y)
            }
        }
    }
    //MARK:- private
    private func intialize(){
        super.delegate = self
        super.dataSource = self
        
        self.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.prior], context: &context)
    }
    // method forwading to corresponded class(_delegate)
    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        /// comportable to UITextFieldDelegate delegate class
        if let realDelegate = _delegate, realDelegate.responds(to: aSelector) {
            return realDelegate
        } else {
            //forwarding to super class
            return super.forwardingTarget(for: aSelector)
        }
    }
    
    //  this will allow to validate _delegate responds to the correponded class
    override open func responds(to aSelector: Selector!) -> Bool {
        if let realDelegate = _delegate, realDelegate.responds(to: aSelector) {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    open func reset(){
        _visitedIndexPath = nil
        _lastContentHeight = 0
        _page = 1
        totalCount = 0
    }
    
    private func setFooterLoading(){
        activity = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activity.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 33, height: 33))
        activity.startAnimating()
        //        activity.color = self.tintColor
        super.tableFooterView = activity
//        super.tableFooterView?.backgroundColor = UIColor.red
        super.tableFooterView?.isHidden = false
//        super.sectionFooterHeight = 50
    }
}


extension PaginationTableView:UITableViewDataSource,UITableViewDelegate{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self._dataSource?.numberOfSections!(in:tableView) ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._dataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self._dataSource?.tableView(self,cellForRowAt:indexPath){
            let listCount = self.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
            
            if indexPath.row == listCount - 1 && listCount != totalCount {
                    totalCount = listCount
                    print("last row called")
                    _page += 1
                    self.loadingPagination = true
                    paginationDelegate?.tableView(self, nextPage: _page)
            }else{
                self.loadingPagination = false
            }
            return cell
        }
        assert((_delegate != nil), "cellForRowAt:indexPath")
        return UITableViewCell()
    }
    
    /*private func didChangeOffset(_ y:CGFloat) {
     if type == .index {
     if let indexPath = super.indexPathForRow(at: CGPoint.init(x: 0, y: (y + self.frame.height))){
     //                let rows = numberOfRows(inSection: indexPath.section)
     let last = Int(pageSize * currentPage)
     if  indexPath.row == last-1 {
     if let idx = _visitedIndexPath, indexPath == idx{
     return
     }
     _visitedIndexPath = indexPath
     _page = (UInt(indexPath.row+1)/pageSize) + 1
     self.paginationDelegate?.tableView(self, nextPage: _page)
     }
     }
     }else{
     let visitedbottom = y + self.frame.height
     let totalSize  = contentSize.height //+ (contentInset.top + contentInset.bottom + (self.tableFooterView?.frame.height ?? 0))
     if  visitedbottom >= totalSize  && _lastContentHeight  < totalSize && self.isDragging{
     _lastContentHeight = totalSize//visitedbottom
     _page += 1
     self.loadingPagination = true
     paginationDelegate?.tableView(self, nextPage: _page)
     }
     }
     }*/
}
extension PaginationTableView : UIScrollViewDelegate{
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self._delegate?.scrollViewDidScroll?(scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}

