import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("------single1")
Single<String>.just("🤡")
    .subscribe(
        onSuccess: {
        print($0)
    },
        onFailure: {
        print("error:\($0)")
    },
        onDisposed: {
        print("disposed")
    })
    .disposed(by: disposeBag)

print("------single2")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
.asSingle()
.subscribe(
    onSuccess: {
        print($0)
    },
    onFailure: {
        print("error:\($0.localizedDescription)")
    },
    onDisposed: {
        print("disposed")
    })
.disposed(by: disposeBag)

print("------single2")
struct someJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case DecodingError
}

let json1 = """
{"name":"jang"}
"""

let json2 = """
{"my_name":"kihwa"}
"""

func decode(json: String) -> Single<someJSON> {
    Single<someJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(someJSON.self, from: data) else {
                  observer(.failure(JSONError.DecodingError))
                  return Disposables.create()
              }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("------maybe1")
Maybe<String>.just("🎃")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print($0)
        },
        onCompleted: {
            print("completed")
        },
        onDisposed: {
            print("disposed")
        })
    .disposed(by: disposeBag)

print("------maybe2")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print($0)
    },
    onError: {
        print("error: \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    })
.disposed(by: disposeBag)

print("------completable1")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    })
.disposed(by: disposeBag)

print("------completable2")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    })
.disposed(by: disposeBag)
