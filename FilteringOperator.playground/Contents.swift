import RxSwift

let disposeBag = DisposeBag()

print("------ignoreElements")
let 취침모드 = PublishSubject<String>()
취침모드.ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

취침모드.onNext("📣")
취침모드.onNext("📣")
취침모드.onNext("📣") // 온넥스트는 무시됨
취침모드.onCompleted()

print("------elementAt")
let 두번울면깨는사람 = PublishSubject<String>()
두번울면깨는사람.element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🛎")
두번울면깨는사람.onNext("🛎")
두번울면깨는사람.onNext("😃")
두번울면깨는사람.onNext("🛎")

print("------filter")
Observable.of(1, 2, 3, 4, 5)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skip")
Observable.of(1, 2, 3, 4, 5)
    .skip(2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipWhile")
Observable.of(1, 2, 3, 4, 5)
    .skip(while: {
        $0 != 3 // false인것 부터 방출
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipUntil")
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님.skip(until: 문여는시간)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("1 😃")
문여는시간.onNext("ㅎㅇ")
손님.onNext("2 😃")
손님.onNext("3 😃")

print("------take")
Observable.of(1, 2, 3, 4, 5)
    .take(3) //skip의 반대
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeWhile")
Observable.of(1, 2, 3, 4, 5)
    .take(while: {
        $0 != 3 // true에 해당하는 값을 방출
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------enumerated") // 방출된 요소의 인덱스를 확인하고 싶을때 사용
Observable.of(1, 2, 3, 4, 5)
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------takeUntil")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청.take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("1 ✋")
수강신청.onNext("2 ✋")
신청마감.onNext("끝")
수강신청.onNext("3 ✋")

print("------distinctUntilChanged")
Observable.of(1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5, 1)
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
