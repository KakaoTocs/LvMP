//
//  MainViewController.swift
//  LvMP
///Users/kakaotocs/Downloads/RazePlayer-Final.zip
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    // file은 파일로 쓰고 폴더를 따로 만들지말고 해당 결로에 쓸때 폴더 생성인자를 true로 구현
    // realm데이터 삭제시 파일 삭제후 realm에서 삭제
    // 서버에서 받은 후 데이터 저장
    // 노래정보를 저장할 싱글톤 필요없음 -> Realm으로 실시간으로 새로고침해 사용가능e
    override func viewDidLoad() {
        super.viewDidLoad()
        // 노래 ㅓ장시 경로 확인 파일 url렘에 저장후 url로 노재 재생
        // Do any additional setup after loading the view.
//        FilesManager.shared.test()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
