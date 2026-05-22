# train-iosdesign
iOSのデザインで日本の鉄道の到着確認アプリ

## 追加した構成

- `TrainIOSDesign/App`
  - `TrainIOSDesignApp.swift`
  - `Info.plist`
- `TrainIOSDesign/Models`
  - `ODPTModels.swift`
  - `UserPreferences.swift`
- `TrainIOSDesign/Services`
  - `ODPTClient.swift`
- `TrainIOSDesign/Managers`
  - `MotionManager.swift`
  - `LocationManager.swift`
  - `TransitTrackingCoordinator.swift`
- `TrainIOSDesign/Features/Main`
  - `MainView.swift`
  - `TrainStatusViewModel.swift`
- `TrainIOSDesign/Widgets`
  - `TrainActivityAttributes.swift`
  - `TrainLiveActivityWidget.swift`
  - `TrainWidgetBundle.swift`
- `TrainIOSDesignTests`
  - `ETAEstimatorTests.swift`
  - `DelayNormalizerTests.swift`
  - `TransitLogicTests.swift`

## メモ

- `ODPTClient` のAPIキーは `Info.plist` の `ODPTAPIKey`（`$(ODPT_API_KEY)`）または環境変数 `ODPT_API_KEY` で設定してください。
- 現在はソースコード骨格の追加で、Xcodeプロジェクト（`.xcodeproj`）自体は未作成です。
