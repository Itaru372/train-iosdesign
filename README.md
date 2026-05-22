# train-iosdesign
iOSのデザインで日本の鉄道の到着確認アプリ

## 追加した構成

- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/App`
  - `TrainIOSDesignApp.swift`
  - `Info.plist`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/Models`
  - `ODPTModels.swift`
  - `UserPreferences.swift`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/Services`
  - `ODPTClient.swift`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/Managers`
  - `MotionManager.swift`
  - `LocationManager.swift`
  - `TransitTrackingCoordinator.swift`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/Features/Main`
  - `MainView.swift`
  - `TrainStatusViewModel.swift`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesign/Widgets`
  - `TrainActivityAttributes.swift`
  - `TrainLiveActivityWidget.swift`
  - `TrainWidgetBundle.swift`
- `/home/runner/work/train-iosdesign/train-iosdesign/TrainIOSDesignTests`
  - `ETAEstimatorTests.swift`
  - `DelayNormalizerTests.swift`
  - `TransitLogicTests.swift`

## メモ

- `ODPTClient` の APIキーは `REPLACE_WITH_ODPT_API_KEY` を置き換えて使用してください。
- 現在はソースコード骨格の追加で、Xcodeプロジェクト（`.xcodeproj`）自体は未作成です。
