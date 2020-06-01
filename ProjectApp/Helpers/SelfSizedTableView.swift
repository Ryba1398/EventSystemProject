//
//  SelfSizedTableView.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 02.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
      self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
      let height = max(contentSize.height, 0)
      return CGSize(width: contentSize.width, height: height)
    }
}
