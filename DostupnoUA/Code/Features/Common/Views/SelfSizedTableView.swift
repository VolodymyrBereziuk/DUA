//
//  SelfSizedTableView.swift
//  DostupnoUA
//
//  Created by admin on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  
  override func reloadData() {
    super.reloadData()
    invalidateIntrinsicContentSize()
    layoutIfNeeded()
  }
  
  override var intrinsicContentSize: CGSize {
    setNeedsLayout()
    layoutIfNeeded()
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
