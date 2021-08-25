//
//  CreationProgressView.swift
//  DostupnoUA
//
//  Created by admin on 10.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class CreationProgressView: UIView {
    
    enum ProgressState {
        case start
        case halfFilled
        case requiredFilled
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var progressTableView: SelfSizedTableView!
    private var content = [CreationProcessStepViewModel]()
    
    var state: ProgressState = .start {
        didSet {
            updateContent(with: state)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        xibSetup()
        
        titleLabel.font = UIFont.p2LeftRegular
        titleLabel.textColor = R.color.warmGrey()
        titleLabel.text = R.string.localizable.locationCreationProgressDescription.localized()
        progressTableView.register(CreationProcessStepCell.self)
        progressTableView.dataSource = self
        makeContent()
    }
}

extension CreationProgressView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CreationProcessStepCell.self, for: indexPath)
        let viewModel = content[indexPath.row]
        if let cell = cell as? CreationProcessStepCell {
            cell.adjust(to: viewModel)
            cell.setProcessImage(isHidden: state == .start)
        }
        return cell
    }
}

extension CreationProgressView {
    
    private func updateContent(with state: ProgressState) {
        let doneStepsCount: Int
        switch state {
        case .start:
            break
        case .halfFilled:
            doneStepsCount = content.count / 2
            for index in 0 ..< doneStepsCount {
                content[index].isDone = true
            }
        case .requiredFilled:
            content.forEach({ $0.isDone = true })
        }
        progressTableView.reloadData()
    }
    
    private func makeContent() {
        let addressText = R.string.localizable.locationCreationProgressAddressTitle.localized()
        let nameText = R.string.localizable.locationCreationProgressNameTitle.localized()
        let typeText = R.string.localizable.locationCreationProgressTypeTitle.localized()
        let entranceText = R.string.localizable.locationCreationProgressEntranceTitle.localized()
        let bathroomText = R.string.localizable.locationCreationProgressBathroomTitle.localized()
        let comfortText = R.string.localizable.locationCreationProgressComfortTitle.localized()
        
        let address = CreationProcessStepViewModel(leftImage: R.image.location(), title: addressText, isDone: false)
        let name = CreationProcessStepViewModel(leftImage: R.image.rename(), title: nameText, isDone: false)
        let type = CreationProcessStepViewModel(leftImage: R.image.locationType(), title: typeText, isDone: false)
        let entrance = CreationProcessStepViewModel(leftImage: R.image.enter(), title: entranceText, isDone: false)
        let bathroom = CreationProcessStepViewModel(leftImage: R.image.toilet(), title: bathroomText, isDone: false)
        let comform = CreationProcessStepViewModel(leftImage: R.image.comfort(), title: comfortText, isDone: false)
        
        content = [address, name, type, entrance, bathroom, comform]
    }
}
