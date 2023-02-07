// Project imports:
import 'layout_picture_in_picture.dart';

/// layout mode
enum ZegoLayoutMode {
  /// picture in picture
  pictureInPicture,
}

class ZegoLayout {
  factory ZegoLayout.pictureInPicture({
    /// whether to hide the local View when the local camera is closed
    bool showMyViewWithVideoOnly = false,

    /// small video view is draggable if set true
    bool isSmallViewDraggable = true,

    ///  Whether you can switch view's position by clicking on the small view
    bool switchLargeOrSmallViewByClick = true,

    /// whether to hide the local View when the local camera is closed
    ZegoViewPosition smallViewPosition = ZegoViewPosition.topRight,

    /// self AudioVideoView use small or big view
    /// usually set it to true in live scene, set it to false in call scene
    bool selfUseSmallAudioVideoView = true,
  }) {
    return ZegoLayoutPictureInPictureConfig(
      showMyViewWithVideoOnly: showMyViewWithVideoOnly,
      isSmallViewDraggable: isSmallViewDraggable,
      switchLargeOrSmallViewByClick: switchLargeOrSmallViewByClick,
      smallViewPosition: smallViewPosition,
      selfUseSmallAudioVideoView: selfUseSmallAudioVideoView,
    );
  }

  const ZegoLayout.internal();
}

/// position of small audio video view
enum ZegoViewPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
