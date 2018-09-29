# LvMP

## 1. 설명
로컬 음악재생 iOS앱

## 2. 기능
~ 9월 27일 :아이튠즈를 통해 폴더 구조로 음악을 넣을 수 있고, 해당 폴더 구조를 유지한체 음악목록을 볼 수 있다.
잠금화면에서 재생 제어
9월 28일 ~: 웹에서 음악 파일들을 선택시 앱에서 받아 저장 및 재생

## 3. 사용 기술
1. Swift
2. Realm
3. RxSwift
4. RxCocoa

1. Node.js
2. Express.js
3. Socket.io
4. Vue.js

## 3. 화면 구성
메인 화면: 상단 일부만 최근 추가된 앨범 리스트, 노래 리스트
아티스트: 아티스트(가수) 목록 -> 해당 아티스트의 앨범 및 하위 노래 목록
앨범: 앨범 목록 -> 하위 노래 목록
폴더: 폴더 목록 (폴더 구조로 접근)

## 4. 시스템 구성도
각 뷰에서 사용자의 응답을 컨트롤러로 어떻게 알리고 반응 할지 등 설명 + 전체 구성도
각 화면에 검색 기능이 있고 RxSwift로 구현!
Model:
1. Music: 앨범, 아티스트와 연결되 프로퍼티를 가지고 있음
    2. Album
    3. Artist
    4. PlayList

## 5. 일정
9월 10일 ~ 9월 16일: Swift 문법 복습\n
9월 17 ~ 9월 23일: 구현할 기능 선정, 사용할 라이브러리 선정, 클래스 작성\n
9월 23일 ~ 9월 26: 목업\n
9월 27일 ~ 10월 14일: 개발\n
10월 15일 ~ 10월 21일: 안정화 및 보수\n
10월 22일 ~ 10월 23일: 정리 

## 6. 진행 사항
9월 27일: [UX]각 화면을 스와이프로 넘기기위해 예제 공부

## 7. 버그 수정
**월 **일: **버그 수정

## 8. 미니 프로젝트
프로젝트 진행중 필요에 의해 구현해야할 기능, 컨포넌트가 생길경우 미니 프로젝트로 진행후 적용
9월 27일: [탐색바] 화면전환을 스와이프외 터치로 넘길수 있는 컨트롤러 필요. 기존의 탭바, 세그컨트롤러와 목적이 맞지않음

## 9. 기타 설명
1. Swift 문법 복습
    - 몰랐거나 적용해보지 못한 문법 탐색
    RxSwift, 함수형/프로토콜 프로그래밍, MVC or MVVM아키텍처적용해 프로젝트 완성이 목표

## 10. 참고
Naming
    https://swift.org/documentation/api-design-guidelines/
    https://github.com/yoonhg84/boostcamp_iOS_5InQueue
RxSwift
1. pilgwon's blog(github Page):  https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html
2. Wade(Brunch): https://brunch.co.kr/@tilltue/2

ContainerView
1. ClintJang(github): https://github.com/ClintJang/sample-swift-containerview

MVC

MVVM

MVP

AudioPlayer: 이 프로젝트의 시초의자 망한 프로젝트 -> 플레이어, 파일 읽기 기능 재활용
naver-music-for-mac: (https://github.com/kjisoo/naver-music-for-mac) mac용 naver music player
