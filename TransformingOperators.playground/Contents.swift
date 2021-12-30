import RxSwift

let disposeBag = DisposeBag()

print("------toArray")
Observable.of(1, 2, 3)
    .toArray()
    .subscribe(
        onSuccess: {
            print($0)
        }
    )
    .disposed(by: disposeBag)

print("------map")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------flatMap")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 한국대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 2))
let 미국대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 1))

let 올림픽 = PublishSubject<선수>() // 중첩된 서브젝트!
올림픽.flatMap { 선수 in
    선수.점수
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

올림픽.onNext(한국대표)
한국대표.점수.onNext(10)
올림픽.onNext(미국대표)
한국대표.점수.onNext(9)
미국대표.점수.onNext(8)

print("------flatMapLatest")
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 2))
let 부산 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 1))

let 전국체전 = PublishSubject<선수>()
전국체전.flatMapLatest { 선수 in
    선수.점수
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

전국체전.onNext(서울)
서울.점수.onNext(10)
서울.점수.onNext(9)
전국체전.onNext(부산) // 이시점에서 서울은 해제
서울.점수.onNext(8)
부산.점수.onNext(7)
부산.점수.onNext(6)

print("------materialize and dematerialize")
enum 반칙: Error {
    case 부정출발
}

struct 달리기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 거북이 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 거리100M = BehaviorSubject<선수>(value: 토끼)
거리100M.flatMapLatest { 선수 in
    선수.점수
        .materialize() // 이벤트도 수신
}
.filter {
    guard let error = $0.error else {
        return true
    }
    print(error)
    return false
}
.dematerialize()
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

토끼.점수.onNext(1)
토끼.점수.onError(반칙.부정출발)
토끼.점수.onNext(2)

거리100M.onNext(거북이)
거북이.점수.onNext(3)

print("------전화번호 11자리")
let input = PublishSubject<Int?>()
let list: [Int] = [1]

input.flatMap {
    $0 == nil ? Observable.empty() : Observable.just($0)
}
.map { $0! }
.skip(while: { $0 != 0 }) // 0이 아니라면 스킵, 첫자리 0이 나올때까지
.take(11)
.toArray()
.asObservable() // 투어레이는 싱글로나오니까 다시 옵저버블
.map {
    $0.map { "\($0)" }
}
.map { numbers in
    var numberList = numbers
    numberList.insert("-", at: 3)
    numberList.insert("-", at: 8)
    let number = numberList.reduce("", +)
    return number
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)
input.onNext(7)
