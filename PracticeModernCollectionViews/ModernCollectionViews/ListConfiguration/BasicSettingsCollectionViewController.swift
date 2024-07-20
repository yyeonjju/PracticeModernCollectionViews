//
//  BasicSettingsCollectionViewController.swift
//  PracticeModernCollectionViews
//
//  Created by 하연주 on 7/20/24.
//

import UIKit
import SnapKit

enum SettingsSection : String, CaseIterable {
    case basic = "전체 설정"
    case individual = "개인 설정"
    case etc = "기타"
    
    
    var items : [String]{
        switch self {
        case .basic:
            return ["공지사항", "실험실", "버전정보"]
        case .individual:
            return ["개인/보안", "알림", "채팅", "멀티프로필"]
        case .etc:
            return ["고객센터/도움말"]
        }
    }
}


final class BasicSettingsCollectionViewController : UIViewController {
    // MARK: - UI

    lazy var listCollectionView = {
        //⭐️ Layout
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return cv
    }()
    
    // MARK: - Properties
    
    private let sectionList = SettingsSection.allCases
    
    //⭐️ data
    //제네릭 타입 📌<SectionIdentifierType, ItemIdentifierType>
    private var dataSource : UICollectionViewDiffableDataSource<SettingsSection, String>!

    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        //⭐️ PresentationCell/Data
        configureDataSource()
        updateSnapshot()
    }
    
    // MARK: - ConfigureView
    
    private func configureView() {
        view.addSubview(listCollectionView)
        
        listCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }

    
    
    // MARK: - CollectionView Layout

    //⭐️ Layout
    //UICollectionViewFlowLayout(X)
    //UICollectionViewCompositionalLayout(📍13+) - UICollectionLayoutListConfiguration(📍14+)  (O)
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .clear
//        configuration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
        
    }
    
    
    // MARK: - CollectionView PresentationCell/Data
    func configureDataSource() {
        //⭐️ Presentation (어떤 셀 쓰는지 정의)
        //register(X)
        //UICollectionView.CellRegistration(📍14+) (O) CellRegistration<Cell, Item>
        //UICollectionViewListCell -> 시스템 스타일을 사용
        var registration  : UICollectionView.CellRegistration<UICollectionViewListCell, String?>!
        
        //각 셀에 들어갈 데이터가 itemIdentifier 파라미터로 들어온다
        registration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            //⭐️ Presentation
            //Configuration types - ContentConfiguration (📍14+)
            var content = UIListContentConfiguration.valueCell() //시스템셀 지원(📍14+)
//            content.text = itemIdentifier?.name
            content.text = itemIdentifier
            content.textProperties.color = .white
//            content.textProperties.font = .boldSystemFont(ofSize: 20)
//            content.secondaryText = itemIdentifier?.price.formatted()
//            content.secondaryTextProperties.color = .cyan
            
            //Configuration types - BackgroundConfiguration (📍14+)
            var backgroundCongfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundCongfig.backgroundColor = .clear
//            backgroundCongfig.cornerRadius = 20
//            backgroundCongfig.strokeColor = .systemGray
//            backgroundCongfig.strokeWidth = 10

            
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundCongfig
        }
        
        
        //⭐️ Data
        //cellForRowAt(X)
        //UICollectionViewDiffableDataSource(📍13+)
        dataSource = UICollectionViewDiffableDataSource(collectionView: listCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in

            //dequeueReusableCell (X)
            //dequeueConfiguredReusableCell(📍14+) (O)
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    //⭐️ Data
    func updateSnapshot() {
        //📌섹션 구분값을 enum 으로
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, String>()
        let sections = SettingsSection.allCases
        snapshot.appendSections(sections) // 섹션 개수
        sections.forEach{
            snapshot.appendItems($0.items, toSection: $0) //어떤아이템을 어느 섹션에 업데이트할지
        }
        
        // reloadData(X)
        //snapshot(📍14+) (O)
        dataSource.apply(snapshot)
    }

}
