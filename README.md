# LvMP

## 1. 설명
로컬 음악재생 iOS앱

## 2. 기능
컴퓨터에서 음악 파일들을 선택시 서버(네트워크)를 통해 앱에서 받아 저장 및 재생  
아직 PlayerView는 구현중...  
![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/DEMO.gif)


## 3. 실행 방법
❗️많은 파일일 전송시 아직 "다운로드 중인 상태 확인" UI가 구현 되지 않아 많이 지루할 수 있습니다.  
(http://18.223.169.157)에서 "Server is running..."중인지 확인해 서버가 작동중인지 확인 필요!!  
1. LvMP 프로젝트 통째로 download 후 압축 풀기
2. (Mac, Xcode: 9.4.1) LvMP/Client/LvMP-Mac에서 "LvMP-Mac.xcworkspace" 실행 후 빌드
3. (iOS, Xcode: 10) LvMP/Client/LvMP에서 "LvMP.xcworkspace" 실행 후 빌드
4. Mac 실행모습 ![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/Mac_paring.png)
5. iPhone 실행모습![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/iPhone_run.png) 
6. 페어링 부분 상태 확인![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/Mac_paring.png) 
7. Mac에서 파일 또는 폴더 선택![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/Mac_fileSelecting.png) 
8. Mac에서 선택한 파일(폴더) 확인 후 전송![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/Mac_fileSelected.png) 
9. iPhone에서 다운로드한 파일 확인![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/ETC/iPhone_download.png) 


## 4. 사용 기술
- Moblie APP
    1. Swift
    2. UIKit
    3. Realm
    4. Socket.io
    5. RxSwift(사용 예정)

- Desktop APP
    1. Swift
    2. Cocoa
    3. Socket.io
    
- Server
    1. Node.js
    2. Express.js
    3. Socket.io


## 5. 화면 구성
Home 화면: 상단 - 최근 추가된 앨범 리스트, 하단 - 재생목록 리스트  
Music: 노래 목록 -> 재생  
Artist: 아티스트(가수) 목록 -> 해당 아티스트의 앨범 및 하위 노래 목록 -> 재생  
Album: 앨범 목록 -> 하위 노래 목록 -> 재생  
<!--폴더: 폴더 목록 (폴더 구조로 접근)  -->

## 6. 뷰 관계
![Alt Text](https://github.com/KakaoTocs/LvMP/blob/master/Client/LvMP/Info/ViewStructure.png)
<!--각 뷰에서 사용자의 응답을 어떻게 처리할지 생각 하기(사용자 응답 고려)-->

Model:
1. Music: 앨범, 아티스트와 연결되 프로퍼티를 가지고 있음
2. Album: 아티스트와 연결된 프로퍼티를 가지고 있음
3. Artist: 기본 정보만 가지고 있음
4. PlayList: 재생목록에 포함된 음악들의 id를 가지고 있음
6. ResponseFiles: 서버로 데이터를 받기위해 사용

Class:
1. FilesManager: 서버로 받은 파일(음원)을 메모리에 쓰고 지우는 클래스
2. Player : 노래 재생(정지, 일시정지), 재생목록 관리

## 7. 일정
9월 10일 ~ 9월 16일: Swift 문법 복습  
9월 17 ~ 9월 23일: 구현할 기능 선정, 사용할 라이브러리 선정, 클래스 작성  
9월 23일 ~ 9월 26: 목업  
9월 27일 ~ 10월 31일: 개발
11월 ~ : 정리
<!--10월 15일 ~ 10월 21일: 안정화 및 보수  -->
<!--10월 22일 ~ 10월 23일: 정리  -->

## 8. 진행 사항
9월 27일: [UX]각 화면을 스와이프로 넘기기위해 예제 공부. 
9월 28일 ~ : [Dev] Mac App 개발   
10월 3일: MenuBar를 구현중. 
                    색, 상태를 변경하는 메서드를 어디까지 쪼개서 구현해야할지 고민된다. 
                    아이템 터치시 색을 지정해주는 메서드는 상태를 저장하는 프로퍼티 값이 바뀔때 설정: 상태를 알려주기 위한 표현이라 상태가 바뀐다는 확신이 있어야하고, 옵셔널 바인딩을 한번만 하면 되서. 
                    MenuBar에서 내부 설정을 위한 메서드들은 해당 파일 안에서만 쓰이기 때문에 fileprivate로 지정. 
10월 4일: MenuBar클래스에 selectItem메서드 생성 및 Button의 tag값으로 Enum값으로 바꾸는 부분을  이동: 클래스내, 클래스밖(MenuBar를 사용하는 컨트롤러)에서 Button에 엑션함수 추가시 작업을 위해. 
10월 5일: 옛날 파일에서 메타정보 추출시 인코딩문제 발생 ㅠ. 
10월 12일: 파일 전송 속도문제 해결, MenuBar완성. 
10월 14일: MenuBar DelegatePattern 적용. 
10월 15일: File에서 metadata추출시 Album or Artist정보가 없을시 빈 인스턴스로 모두 연결고리를 만들어 줌(즉 모든 Music은 Album과Artist를 가지고 있다). 
10월 16일 ~: commit기록 참고. 

## 9. 버그/오류 수정
**월 **일: **버그 수정. 
10월 12일: 파일(음악파일)전송을 Socket.io로 처리시 속도가 많이 늦음 -> 파일전송은 HTTP네트워킹(Stream)으로 변경, 페어링은 Socket.io로 유지(http://toma0912.tistory.com/69, https://d2.naver.com/helloworld/1336). 
10월 15일: DB구조상 중복저장 문제 발견: Music에 Album, Artist저장, Album에 Artist저장 =>  Artist가 두군데저장됨 -> File에서 metadata추출시 Album != nil or Artist != nil일때 최대한 정보를 사용하기위해 따로 저장 즉 "현재 구조 유지". 
10월 15일: Music생성 불가 -> Realm에서 UInt64 미지원 => playTime을 Int로 변경. 

## 10. 미니 프로젝트
프로젝트 진행중 필요에 의해 구현해야할 기능, 컨포넌트가 생길경우 미니 프로젝트로 진행후 적용. 
9월 27일: [탐색바] 화면전환을 스와이프외 터치로 넘길수 있는 컨트롤러 필요. 기존의 탭바, 세그컨트롤러와 목적이 맞지않음
-> MenuBar와 RootVIewController의 ScrollView를 합쳐 라이브러리 만들기. 

## 11. 기타
1. 파일 읽기 쓰기시 에러 처리, 실패시 처리
2. 파일 경로 저장방법 URL - URL사용 권장 (https://developer.apple.com/documentation/foundation/filemanager), 사용시 URL로 사용함
3. 에러처리: 에러가 발생할 수 있는 함수는 반환값을 Bool타입으로 받아 false시 사용자에게 행위 제한(나중에 재요청)
1. Swift 문법 복습
    - 몰랐거나 적용해보지 못한 문법 탐색
    RxSwift, 함수형/프로토콜 프로그래밍, MVC or MVVM아키텍처적용해 프로젝트 완성이 목표. 
    Rx적용: 각 뷰마다 검색기능, 파일 다운시 현재 받은 파일 실시간으로 보여주기. 

## 11. 참고
- Naming
    1. Apple 가이드라인: https://swift.org/documentation/api-design-guidelines/
    2. 노수진(Swift 개발자처럼 변수 이름 짓기): https://soojin.ro/?fbclid=IwAR19z0rIgb5cPiYY3803g-yUv82EGoUmP5F8zhGC0c2uekPbG7z9xxxPbFM
    3. 부스트캠프 네이밍 수정 사항: https://github.com/yoonhg84/boostcamp_iOS_5InQueue
    
- RxSwift
    1. pilgwon's blog(github Page):  https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html
    2. Wade(Brunch): https://brunch.co.kr/@tilltue/2

- ContainerView
    1. ClintJang(github): https://github.com/ClintJang/sample-swift-containerview
    
- Project
    1. AudioPlayer: 이 프로젝트의 시초이자 망한 프로젝트 -> 플레이어, 파일 읽기, metadata추출 참고
    2. naver-music-for-mac: (https://github.com/kjisoo/naver-music-for-mac) mac용 naver music player

- Cocoa
    1. 关于 Cocoa Programming For OSX 中文第五版(gitbook): https://josercc.gitbooks.io/cocoa-programming-for-osx/content/
    2. Warren Burton(raywenderlich): https://www.raywenderlich.com/830-macos-nstableview-tutorial
    
- Delegate
    1. 마기의 개발 블로그(Git Page): https://magi82.github.io/ios-delegate/, https://github.com/KakaoTocs/iOS_Example/tree/master/DelegatePattern
