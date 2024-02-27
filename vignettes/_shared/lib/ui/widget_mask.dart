import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Acts exactly like a `Stack` however the first child acts like an alpha mask when rendering the rest of the children
class RenderWidgetMask extends RenderStack {
  RenderWidgetMask(
      {List<RenderBox>? children,
      required AlignmentGeometry alignment,
      required TextDirection textDirection,
      required StackFit fit,
      required Clip clip})
      : super(
          children: children,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          clipBehavior: clip,
        );

  @override
  void paintStack(context, offset) {
    // Early exit on no children
    if (firstChild == null) return;

    final paintContent = (PaintingContext context, Offset offset) {
      // Paint all but the first child
      RenderBox? child = (firstChild?.parentData as StackParentData?)?.nextSibling;
      while (child != null) {
        final childParentData = child.parentData as StackParentData?;
        final lastChildRenderObject = lastChild as RenderObject?;
        if (childParentData != null && lastChildRenderObject != null) {
          context.paintChild(lastChildRenderObject, offset + childParentData.offset);
        }
        child = childParentData?.nextSibling;
      }
    };

    final paintMask = (PaintingContext context, Offset offset) {
      context.paintChild(firstChild as RenderObject, offset + (firstChild?.parentData as StackParentData).offset);
    };

    final paintEverything = (PaintingContext context, Offset offset) {
      paintContent(context, offset);
      context.canvas.saveLayer(offset & size, Paint()..blendMode = BlendMode.dstIn);
      paintMask(context, offset);
      context.canvas.restore();
    };

    // Force the foreground content to be composited onto this layer
    context.pushOpacity(offset, 255, paintEverything);
  }
}

/// Is a simple wrapper around the `Stack` widget that creates a custom stack based render object
class WidgetMask extends Stack {
  WidgetMask(
      {Key? key,
      AlignmentGeometry alignment = AlignmentDirectional.topStart,
      TextDirection? textDirection,
      StackFit fit = StackFit.loose,
      Clip clip = Clip.hardEdge,
      required Widget maskChild,
      required Widget child})
      : super(
          key: key,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          clipBehavior: clip,
          children: [maskChild, child],
        );

  @override
  RenderStack createRenderObject(context) {
    return RenderWidgetMask(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      clip: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderWidgetMask renderObject) {
    renderObject
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.of(context)
      ..fit = fit
      ..clipBehavior = clipBehavior;
  }
}
