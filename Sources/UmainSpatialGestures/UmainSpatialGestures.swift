// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import RealityKit

@available(visionOS 1.0, *)
extension View {
    // Add a method to apply the custom drag gesture
    public func useDragAndRotateGesture(constrainedToAxis: RotationAxis3D? = .xyz, behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragAndRotateGesture(constrainedToAxis!, behavior!))
    }
    
    public func useDragGesture(behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragGesture(behavior!))
    }
    
    public func useRotateGesture(constrainedToAxis: RotationAxis3D? = .xyz) -> some View {
        self.gesture(CustomGestures.createRotateGesture(constrainedToAxis!))
    }
    
    public func useMagnifyGesture() -> some View {
        self.gesture(CustomGestures.createMagnifyGesture())
    }
    
    public func useDragAndMagnifyGesture(behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragAndMagnifyGesture(behavior!))
    }
    
    public func useFullGesture(constrainedToAxis: RotationAxis3D? = .xyz, behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createFullGesture(constrainedToAxis!, behavior!))
    }
}

struct CustomGestures {
    
    static func createFullGesture(_ constrainedToAxis: RotationAxis3D, _ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
            .onChanged { value in
                
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                
                if let rotation = value.second?.rotation {
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                    value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
                } else if let translation = value.first?.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                } else if let magnification = value.first?.second?.magnification {
                    let scaleTransform = Transform(AffineTransform3D(
                        scale: Size3D(width: magnification, height: magnification, depth: magnification)
                    ))
                    value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
        
    }
    
    static func createDragAndMagnifyGesture(_ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                if let magnification = value.second?.magnification {
                    let scaleTransform = Transform(AffineTransform3D(
                        scale: Size3D(width: magnification, height: magnification, depth: magnification)
                    ))
                    print(sourceTransform!.scale * scaleTransform.scale)
                    value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
                } else if let translation = value.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createMagnifyGesture() -> some Gesture {
        var sourceTransform: Transform?
        
        return MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                
                let scaleTransform = Transform(AffineTransform3D(
                    scale: Size3D(width: value.magnification, height: value.magnification, depth: value.magnification)
                ))
                value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createRotateGesture(_ constrainedToAxis: RotationAxis3D) -> some Gesture {
        var sourceTransform: Transform?
        
        return RotateGesture3D(constrainedToAxis: constrainedToAxis)
            .targetedToAnyEntity()
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                let rotationTransform = Transform(AffineTransform3D(rotation: value.rotation))
                value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createDragGesture(_ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                let convertedTranslation = value.convert(value.translation3D, from: .local, to: value.entity.parent!)
                value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createDragAndRotateGesture(_ constrainedToAxis: RotationAxis3D, _ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                if let rotation = value.second?.rotation {
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                    value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
                } else if let translation = value.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
}
