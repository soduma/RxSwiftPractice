import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposeBag = DisposeBag()

print("------replay") //버퍼의 수만큼 구독전의 최신 순서대로 받음
let 인사말 = PublishSubject<String>()
let 반복하는앵무새 = 인사말.replay(1)

반복하는앵무새.connect() // replay쓸때는 반드시 connect 써야함

인사말.onNext("1 ㅎㅇㅎㅇ")
인사말.onNext("2 ㅎㅇㅎㅇ")
인사말.onNext("3 ㅎㅇㅎㅇ")

반복하는앵무새
    .subscribe(onNext: {
    print($0)
})
    .disposed(by: disposeBag)
인사말.onNext("4 ㅎㅇㅎㅇ")

print("------replayAll") //구독 이전의 모든 값을 받음
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll()
타임스톤.connect()

닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러 왔다")

타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------buffer") //카운트 값만큼 배열로 내뱉어줌, 없으면 빈 어레이
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume() // 반드시 해주기
//
//source
//    .buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------window") //카운트와 비슷하지만 옵저버블 방출
//let 만들어낼최대observable수 = 5
//let 만들시간 = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimeSource = DispatchSource.makeTimerSource()
//windowTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimeSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimeSource.resume()
//
//window
//    .window(timeSpan: 만들시간, count: 만들어낼최대observable수, scheduler: MainScheduler.instance)
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------delaySubscription") // 딜레이시킨후 구독
//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------delay") //전체 시퀀스를 뒤로
//let delaySubject = PublishSubject<Int>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySubject.onNext(delayCount)
//}
//delayTimeSource.resume()
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------interval") //rx에서 제공하는 편한 타이머, 위에서 했던 카운트/타이머 안써도 알아서 작동됨
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------timer") //period는 옵셔널, NSTimer보다 가독성좋음
//Observable<Int>
//    .timer(.seconds(5), period: .seconds(2), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("------timerout") //시간을 초과하면 에러방출
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러주세요", for: .normal)
누르지않으면에러.sizeToFit()

PlaygroundPage.current.liveView = 누르지않으면에러

누르지않으면에러.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
