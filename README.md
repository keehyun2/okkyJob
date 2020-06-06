
1. flutter sdk 설치
2. 안드로이드 스튜디오 설치
3. 에뮬레이터 설치
4. flutter doctor 실행해서 안내대로 하기. (toolchain)

아래 명령어로 테스트용 apk 생성
flutter build apk --split-per-abi

생성됨 apk 는 아래 경로에 있음
<app dir>/build/app/outputs/apk/release/app-armeabi-v7a-release.apk
<app dir>/build/app/outputs/apk/release/app-arm64-v8a-release.apk
