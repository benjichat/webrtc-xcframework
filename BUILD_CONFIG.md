# Building with dSYM Support

## The Problem
The current LiveKitWebRTC.xcframework releases don't include dSYMs because they weren't built with the correct settings.

## Solution for Framework Builders

When building the XCFramework (at https://github.com/webrtc-sdk/webrtc-build), use these settings:

```bash
# For each platform archive
xcodebuild archive \
  -scheme LiveKitWebRTC \
  -destination "generic/platform=iOS" \
  -archivePath "archives/ios.xcarchive" \
  DEBUG_INFORMATION_FORMAT=dwarf-with-dsym \
  DWARF_DSYM_FILE_SHOULD_ACCOMPANY_PRODUCT=YES \
  GCC_GENERATE_DEBUGGING_SYMBOLS=YES \
  STRIP_INSTALLED_PRODUCT=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create XCFramework with dSYMs
xcodebuild -create-xcframework \
  -framework "archives/ios.xcarchive/Products/Library/Frameworks/LiveKitWebRTC.framework" \
  -debug-symbols "archives/ios.xcarchive/dSYMs/LiveKitWebRTC.framework.dSYM" \
  -framework "archives/ios-simulator.xcarchive/Products/Library/Frameworks/LiveKitWebRTC.framework" \
  -debug-symbols "archives/ios-simulator.xcarchive/dSYMs/LiveKitWebRTC.framework.dSYM" \
  -output "LiveKitWebRTC.xcframework"
```

## Workaround for App Store Submissions (Without dSYMs)

If you need to submit to App Store now without dSYMs:

1. **Disable Bitcode** (if not already):
   - In Xcode: Build Settings → Enable Bitcode = NO
   
2. **Use Manual Symbolication** if crashes occur:
   - Save your archive (.xcarchive) after each App Store submission
   - Use atos command to manually symbolicate crash logs

3. **Alternative**: Build from source with dSYMs:
   ```bash
   git clone https://github.com/webrtc-sdk/webrtc
   git clone https://github.com/webrtc-sdk/webrtc-build
   # Follow their build instructions with the settings above
   ```

## Request dSYM Support

Open an issue at https://github.com/livekit/webrtc-xcframework requesting dSYMs be included in releases.