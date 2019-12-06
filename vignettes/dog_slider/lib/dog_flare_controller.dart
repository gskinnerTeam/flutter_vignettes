import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';

//A simple FlareController that does not worry about mixing, and only plays a single layer at a time.
class DogFlareControls extends FlareController {
  Function(String) onCompleted;

  FlutterActorArtboard _artBoard;
  FlareAnimationLayer _animationLayer;
  String _animationName;

  @override
  void initialize(FlutterActorArtboard artBoard) {
    _artBoard = artBoard;
  }

  // Create new animation, and assign it as current
  void play(String name) {
    _animationName = name;
    //Exit early if name or artboard are null
    if (_animationName == null || _artBoard == null) return;
    //Check if animation actually exists
    ActorAnimation animation = _artBoard.getAnimation(_animationName);
    if (animation != null) {
      //If all is good, start new animation
      _animationLayer = FlareAnimationLayer()
        ..name = _animationName
        ..animation = animation;
      isActive.value = true;
    }
  }

  // Advance animation and call onComplete when a non-looping anim has finished.
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if(_animationLayer == null){ return false; }
    FlareAnimationLayer layer = _animationLayer;
    layer.time += elapsed;
    //Loop?
    if (layer.animation.isLooping) {
      layer.time %= layer.animation.duration;
    }
    //Advance animation, with full mix
    layer.animation.apply(layer.time, _artBoard, 1);
    //Remove anim if it's complete
    if (layer.time > layer.animation.duration) {
      //Stop animation from playing
      _animationLayer = null;
      if (onCompleted != null) {
        onCompleted(layer.animation.name);
      }
    }
    return _animationLayer != null;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
