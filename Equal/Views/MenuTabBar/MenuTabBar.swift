//
//  MenuTabBar.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

public protocol MenuTabBarDelegate {
    
    func didSelectItemAt(Index index: Int)
    
}

class MenuTabBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private struct keys {
        static let cellID = "cellID"
        static let titleNames = ["Overview", "Balance"]
    }
    
    var delegate: MenuTabBarDelegate?
    
    private var layout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    private lazy var horizontalBar : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 187/255, green: 193/255, blue: 206/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.registerClass()
        self.setupCollectionView()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UICollectionView config Related
extension MenuTabBar {
    
    private func registerClass() {
        self.collectionView.register(MenuTabBarCell.self, forCellWithReuseIdentifier: keys.cellID)
    }
    
    private func setupCollectionView() {
        self.layout.scrollDirection = .horizontal
        self.collectionView.bounces = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.selectFirst()
    }
    
    private func selectFirst() {
        self.selectItemAt(Index: IndexPath(item: 0, section: 0), animated: false)
    }
    
    public func selectItemAt(Index index: IndexPath, animated: Bool = true) {
        self.collectionView.selectItem(at: index, animated: animated, scrollPosition: .left)
    }
    
}

// UICollectionView Related
extension MenuTabBar {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.titleNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? MenuTabBarCell else { fatalError("MenuTabBarCell must exist") }
        cell.titleLabel.text = keys.titleNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAt(Index: indexPath.item)
    }
    
}

// UICollectionView Flow layout Related
extension MenuTabBar {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2.0, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// UI Related
extension MenuTabBar {
    
    private func setupView() {
        self.setupCollectionViewAnchors()
        self.setupHorinzontalBar()
    }
    
    private func setupHorinzontalBar() {
        self.addSubview(self.horizontalBar)
        self.horizontalBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.horizontalBarLeftAnchorConstraint = self.horizontalBar.leftAnchor.constraint(equalTo: leftAnchor)
        self.horizontalBarLeftAnchorConstraint?.isActive = true
        self.horizontalBar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        self.horizontalBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupCollectionViewAnchors() {
        self.addSubview(self.collectionView)
        self.collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    public func updateScroll(value: CGFloat) {
        self.horizontalBarLeftAnchorConstraint?.constant = value / CGFloat(keys.titleNames.count)
    }
    
}
