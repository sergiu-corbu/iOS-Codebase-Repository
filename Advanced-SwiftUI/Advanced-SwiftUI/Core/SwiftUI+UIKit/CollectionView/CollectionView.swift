//
//  CollectionView.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import SwiftUI
import UIKit

struct UIKitCollectionView<SectionType: Hashable,
                           ItemType: Hashable,
                           CellContent: View>: UIViewRepresentable {
  
  let dataSource: [SectionType:[ItemType]]
  let collectionViewLayout: UICollectionViewLayout
  
  @ViewBuilder var cellProvider: CellProvider
  var customizeCollectionView: ((UICollectionView) -> Void)?
  var willDisplayItem: ((ItemType?) -> Void)?
  
  typealias CellProvider = (ItemType) -> CellContent
  
  init(sectionType: SectionType.Type,
       dataSource: [SectionType : [ItemType]],
       collectionViewLayout: UICollectionViewLayout,
       @ViewBuilder cellProvider: @escaping CellProvider,
       customizeCollectionView: ((UICollectionView) -> Void)? = nil) {
    
    self.dataSource = dataSource
    self.collectionViewLayout = collectionViewLayout
    self.cellProvider = cellProvider
    self.customizeCollectionView = customizeCollectionView
  }
  
  func makeUIView(context: Context) -> UICollectionView {
    let collectionView = context.coordinator.collectionView
    collectionView.backgroundColor = .clear
    customizeCollectionView?(collectionView)
    return collectionView
  }
  
  func updateUIView(_ uiView: UICollectionView, context: Context) {
    context.coordinator.updateDataSource(dataSource)
  }
  
  func makeCoordinator() -> CollectionViewCoordinator {
    return CollectionViewCoordinator(
      collectionViewLayout: collectionViewLayout,
      cellProvider: cellProvider,
      willDisplayItem: willDisplayItem
    )
  }
  
  class CollectionViewCoordinator: NSObject, UICollectionViewDelegate {
    
    private(set) var collectionView: UICollectionView
    private let dataSource: DiffableDataSource
    let willDisplayItem: ((ItemType?) -> Void)?
    
    private typealias CellType = UIHostingViewCell<CellContent>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>
    
    init(collectionViewLayout: UICollectionViewLayout,
         cellProvider: @escaping (ItemType) -> CellContent,
         willDisplayItem: ((ItemType?) -> Void)?) {
      
      collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
      collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseIdentifier)
      dataSource = DiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType
        cell?.configure(with: cellProvider(itemIdentifier))
        return cell
      }
      self.willDisplayItem = willDisplayItem
      
      super.init()
      collectionView.dataSource = dataSource
      collectionView.delegate = self
    }
    
    func updateDataSource(_ dataSourceSections: [SectionType:[ItemType]]) {
      var snapshot = Snapshot()
      for section in dataSourceSections {
        snapshot.appendSections([section.key])
        snapshot.appendItems(section.value, toSection: section.key)
      }
      dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      willDisplayItem?(dataSource.itemIdentifier(for: indexPath))
    }
  }
}

extension UIKitCollectionView where SectionType == String {
  
  init(dataSource: [ItemType],
       collectionViewLayout: UICollectionViewLayout,
       @ViewBuilder cellProvider: @escaping CellProvider,
       customizeCollectionView: ((UICollectionView) -> Void)? = nil,
       willDisplayItem: ((ItemType?) -> Void)? = nil) {
    
    self.dataSource = ["firstSection":dataSource]
    self.collectionViewLayout = collectionViewLayout
    self.cellProvider = cellProvider
    self.customizeCollectionView = customizeCollectionView
    self.willDisplayItem = willDisplayItem
  }
}

