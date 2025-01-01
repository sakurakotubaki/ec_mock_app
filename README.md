# ec_mock_app
Flutter3.27.0
Dart3.6.0

## Deep Linking

This app supports deep linking, allowing you to open specific pages directly through custom URLs.

### URL Scheme

The app uses the custom URL scheme: `ecmockapp://`

### Supported Deep Links

- Product Detail Page: `ecmockapp://product/{productId}?source={source}`
  - Example: `ecmockapp://product/2?source=share`

### Setup Instructions

#### iOS Configuration
1. Open `ios/Runner/Info.plist`
2. Add the following configuration under `<dict>`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>ecmockapp</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.example.ecmockapp</string>
    </dict>
</array>
```

#### Android Configuration
1. Open `android/app/src/main/AndroidManifest.xml`
2. Add the following inside the `<activity>` tag:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="ecmockapp" />
</intent-filter>
```

### Implementation Details

The deep linking is implemented using GoRouter. The route configuration can be found in `lib/router/router.dart`:

```dart
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProductDetailRoute>(
      path: 'product/:productId',
    ),
    // ...
  ],
)
```

The `productId` parameter from the URL is automatically parsed and passed to the appropriate page.
