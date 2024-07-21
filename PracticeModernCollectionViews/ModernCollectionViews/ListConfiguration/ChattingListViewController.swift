//
//  ChattingListViewController.swift
//  PracticeModernCollectionViews
//
//  Created by 하연주 on 7/21/24.
//

import UIKit

final class ChattingListViewController : UIViewController {
    // MARK: - UI
    lazy var chatListCollectionView = {
        //⭐️ Layout
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        cv.backgroundColor = .cyan
        return cv
    }()
    
    // MARK: - Properties

    private var dataSource : UICollectionViewDiffableDataSource<Int, ChatRoom>!
    
    // MARK: - Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureView()
        
        
        configureDataSource()
        updateSnapshot()
    }
    
    
    // MARK: - ConfigureView
    
    private func configureView() {
        view.addSubview(chatListCollectionView)
        
        chatListCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    // MARK: - CollectionView Layout
    
    //⭐️ Layout
    private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .clear
        //        configuration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
        
    }
    
    func configureDataSource(){
        //⭐️ Presentation
        let cellRegistration = makeCellRegistration()
        
        
        //⭐️ Data
        //✅Cell✅
        dataSource = UICollectionViewDiffableDataSource(collectionView: chatListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    //⭐️ Presentation
    //✅Cell Registration✅
    private func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, ChatRoom?> {
        //각 셀에 들어갈 데이터가 itemIdentifier 파라미터로 들어온다
        let cellRegistration : UICollectionView.CellRegistration<UICollectionViewCell, ChatRoom?>  = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            //⭐️ Presentation
            //Configuration types - ContentConfiguration (📍14+)
            var content = UIListContentConfiguration.sidebarCell() //시스템셀 지원(📍14+)
            content.text = itemIdentifier?.chatroomName
            content.textProperties.font = .systemFont(ofSize: 15)
            content.textProperties.color = .black
            
            content.image = UIImage(named: itemIdentifier?.chatroomImage.first ?? "")
            content.imageProperties.tintColor = .red
            content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            content.imageProperties.cornerRadius = 20
            
            content.secondaryText = itemIdentifier?.chatList.first?.message
            content.secondaryTextProperties.font = .systemFont(ofSize: 13)
            content.secondaryTextProperties.color = .lightGray
            
            //Configuration types - BackgroundConfiguration (📍14+)
            var backgroundCongfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundCongfig.backgroundColor = .clear
            
            
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundCongfig
        }
        
        return cellRegistration
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatRoom>()
        snapshot.appendSections([0])
        snapshot.appendItems(mockChatList)
        
        dataSource.apply(snapshot){
            print("⭐️⭐️snapshot - datasource apply - completion ")
        }
    }
    
    
    
}


