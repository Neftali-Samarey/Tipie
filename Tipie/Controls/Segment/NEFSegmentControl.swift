//
//  NefSegmentControl.swift
//  Tipie
//
//  Created by Neftali Samarey on 9/20/20.
//  Copyright © 2020 Neftali Samarey. All rights reserved.
//

import UIKit

protocol NefSegmentControlDelegate: class {
    func selectedIndex(with index: Int)
}

class NefSegmentControl: UIView {

    private let segmentBackgroundColor: UIColor = .clear
    private var indexCount = 0

    var horizontalSegmentIndexStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        return stack
    }()

    let segmentViewElement: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.backgroundColor = .red

        return view
    }()

    lazy var labelText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private var segmentViews = [UIView]()
    private var segmentGesture = [UITapGestureRecognizer]()
    private var segmentIndex = 0


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = segmentBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action Methods
    @objc func segmentIndexSelection(identifier: Int) {
        print("Selected")
    }

    // MARK: - Setup UI Methods

    /// Use this to setup gesture recognizers
    private func setupGestureRecognizers() {

    }

    /// This internally sets the label needed for the segment's label text.
    private func setupSegmentViewItem(with text: String)-> UIView {

        let element = UIView()
        let label = UILabel()
        let tap = UITapGestureRecognizer()
        let segmentIdentifier = [segmentIndex: tap]

        label.translatesAutoresizingMaskIntoConstraints = false
        element.translatesAutoresizingMaskIntoConstraints = false

        element.layer.backgroundColor = UIColor.TipiePink().cgColor

        label.text = text
        label.stylizeTipie()

        element.addSubview(label)
        label.centerYAnchor.constraint(equalTo: element.centerYAnchor, constant: 0).isActive = true
        label.centerXAnchor.constraint(equalTo: element.centerXAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 17).isActive = true
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true

        segmentIndex = segmentIndex + 1


        return element
    }

    public func setSegmentIndexes(with index: [String]) {

        for (index, title) in index.enumerated() {
            let view = setupSegmentViewItem(with: title)
            segmentViews.insert(view, at: index)
        }

        for segment in segmentViews {
            horizontalSegmentIndexStack.addArrangedSubview(segment)
        }

        addSubview(horizontalSegmentIndexStack)

        horizontalSegmentIndexStack.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        horizontalSegmentIndexStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        horizontalSegmentIndexStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        horizontalSegmentIndexStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }

}
