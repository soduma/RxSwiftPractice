import RxSwift

print("------just")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("------of")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("------of2")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("------from")
//array만 받음
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("------subscribe")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("------subscribe2")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("------subscribe3")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

//즉시종료, 의도적으로 0개 리턴같은 경우 사용, 컴플리트만 방출
print("------empty")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }

print("------never")
Observable<Void>.never()
    .debug("never")
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("completed")
        })

print("------range")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0) = \(2*$0)")
    })

print("------dispose")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose() // 갯수가 정해져있기 때문에 있든 없든 차이없음. 옵저버블의 생명주기라고 생각하자

print("------disposeBag")
let disposeBag = DisposeBag()
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag) //각각의 구독에 대해 하나씩 dispose는 효율적이지 않기 때문에 백사용!

print("------create1")
Observable.create { observer -> Disposable in
    observer.onNext(1)
//    observer.on(.next(1)) // 위와 같은 표현
    observer.onCompleted() // 여기서 옵저버블 종료하기 때문에 onNext(2)는 ㄴㄴ
//    observer.on(.completed) // 위와 같은 표현
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("------create2")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    })
.disposed(by: disposeBag) //에러, 컴플리트, 디스포즈 셋다 주석해버리면 메모리낭비

print("------deffered1")
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("------deffered2")
var 뒤집기: Bool = false
let factory: Observable<String> = Observable.deferred { //디펄드는 팩토리를 통해서 생성할 수 있는 연산자라고 생각
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...4 {
    factory.subscribe(onNext: {
        print($0)
    })
        .disposed(by: disposeBag)
}
