# SimpleMoney
> 지출 관리 어플리케이션 개발

<p align="center">
  <img src="https://github.com/user-attachments/assets/b10af43f-f519-40e3-9fe0-fa44fedd0d79" width="582" height="605" alt="image 3" />
</p>


## MVVM-C 아키텍처 적용

- **View와 비즈니스 로직을 분리**하기 위해 MVVM 패턴 도입
- **화면 전환을 담당**하기 위한 Coordinator 패턴 도입
- **테스트 가능한 구조 설계**를 위한 DI 적용


<p align="center">
    <img width="870" alt="image" src="https://github.com/user-attachments/assets/990f21a9-fe87-4217-871c-db2755f48103"/>
</p>

---


## 기술 스택

### RxSwift

- RxSwift는 반응형 프로그래밍을 구현하기에 매우 유용한 라이브러리입니다. 생명주기 관리와 다양한 오퍼레이터를 지원합니다.
- RxSwift를 적용하여 View와 ViewModel의 데이터를 바인딩하고 단방향으로 설계했습니다.

직접 사용해보면서 작성한 [RxSwift 시리즈](https://velog.io/@rkdeogns4567/series/RxSwift)입니다.

### Coordinator 패턴

- Coordinator는 화면 전환의 책임을 별도의 객체로 분리하는 구조입니다.
- View는 데이터 표시와 화면 렌더링에만 집중할 수 있게 되어, 화면 전환 로직과의 의존성을 줄일 수 있도록 설계했습니다.

Coordinator 패턴을 적용해보면서 느꼈던 점을 기록한 [포스트](https://velog.io/@rkdeogns4567/Coordinator-%ED%99%94%EB%A9%B4-%EC%9D%B4%EB%8F%99-%EB%B0%A9%EC%8B%9D)입니다.

### DI Container

- DI Container는 객체 간 의존성을 주입하고 관리해주는 도구입니다.
- 객체 생성 과정에서 발생할 수 있는 의존 관계의 복잡도나 결합도 문제를 해결할 수 있습니다.

DI Container를 적용했던 이유와 DI에 대해서 기록한 [포스트](https://velog.io/@rkdeogns4567/iOS-DI-Container%EB%9E%80)입니다.

## 사용된 라이브러리 (서드파티)
- FSCalendar
- RxSwift
- DGCharts
- RealmDB
