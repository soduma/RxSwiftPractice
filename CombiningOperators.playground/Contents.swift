import RxSwift

let disposeBag = DisposeBag()

print("------startWith") //초기값이 필요할 때
let 노랑반 = Observable.of("a", "b", "c")

노랑반
    .enumerated()
    .map({ index, element in
         "\(index)" + element + "어린이"
    })
    .startWith("d")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------concat1")
let 노랑반어린이들 = Observable.of("a", "b", "c")
let 선생님 = Observable.of("d")

let 줄서서걷기 = Observable.concat([선생님, 노랑반어린이들])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------concat2")
선생님.concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------concatMap") //각각의 시퀀스가 다음 시퀀스가 구독되기 전에 합쳐지도록 보증
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("1", "2", "3"),
    "파랑반": Observable.of("4", "5")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------merge1") //순서보장 X, 합쳐줌
let 강북 = Observable.from(["강북구", "성북구", "동대문구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge() //하나라도 에러면 전체가 에러후 종료
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------merge2") //순서를 보장하는 것처럼 보임, 강북부터 끝내고 강남돌림
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------combineLatest1")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("재석")
이름.onNext("명수")
이름.onNext("준하")
성.onNext("이")
성.onNext("박")
성.onNext("장")

print("------combineLatest2")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        })

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------combineLatest3")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("장")
firstName.onNext("기화")
firstName.onNext("지은")
firstName.onNext("이유")

print("------zip") //순서를 보장하면서 합쳐짐, 둘중 하나라도 완료되면 전체가 완료
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable.of("1", "2", "3", "4", "5", "6")

let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + "\(결과)"
    }

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------withLatestFrom1") //트리거가 발생된 시점의 가장 최신값
let 총 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

총
    .withLatestFrom(달리기선수)
//    .distinctUntilChanged() //sample처럼 사용가능해짐
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("1")
달리기선수.onNext("2")
달리기선수.onNext("3")
총.onNext(Void())
총.onNext(Void())

print("------sample") //withLatestFrom1 거의비슷하지만 1번만 작동
let 출발 = PublishSubject<Void>()
let 자동차선수 = PublishSubject<String>()

자동차선수
    .sample(출발, defaultValue: "")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

자동차선수.onNext("1")
자동차선수.onNext("2")
자동차선수.onNext("3")
출발.onNext(Void())
출발.onNext(Void())
출발.onNext(Void())

print("------amb") //두가지 옵져버블 다 구독하지만, 먼저 방출하는 친구만 방출, 첨에 뭐부터 시작하는지 애매하니깐 지켜봄
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()
let 버스정류장 = 버스1.amb(버스2)

버스정류장
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

버스2.onNext("버2승0: a")
버스1.onNext("버1승0: b")
버스1.onNext("버1승1: c")
버스2.onNext("버2승1: d")
버스1.onNext("버1승2: e")
버스2.onNext("버2승2: f")

print("------switchLatest") //해당 시퀀스의 아이템만 구독
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()
let 손든사람만말할수있는교실 = 손들기.switchLatest()

손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1)
학생1.onNext("11111")
학생2.onNext("22222")
학생1.onNext("1111111111")

손들기.onNext(학생2)
학생2.onNext("22222")
학생1.onNext("11111")

손들기.onNext(학생3)
학생1.onNext("11111")
학생3.onNext("33333")
학생2.onNext("22222")

손들기.onNext(학생1)
학생1.onNext("11111")
학생3.onNext("33333")

print("------reduce")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------scan")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
