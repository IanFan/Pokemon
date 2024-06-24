//
//  AnimationHelper.swift
//  SwiftAnimationTutorial
//

import UIKit

class AnimationFactory: NSObject {
    static func swingAnimation(layer: CALayer, repeatCount: Float = 2, duration: Float = 1.5, force: CGFloat = 1, delay: Float = 0, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation"
        animation.values = [0, 0.3*force, -0.3*force, 0.3*force, -0.3*force, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1] // smooth [0, 0.125, 0.375, 0.625, 0.875, 1]
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime()  + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "swing")
        
        CATransaction.commit()
    }
    
    static func swingOneTimeAnimation(layer: CALayer, repeatCount: Float = 2, duration: Float = 1.5, angle: CGFloat = 1, delay: Float = 0, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation"
        animation.values = [0, angle, -angle, 0]
        animation.keyTimes = [0, 0.25, 0.75, 1]
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime()  + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "swing")
        
        CATransaction.commit()
    }
    
    static func rotateAnimation(layer: CALayer, duration: Float = 1, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation"
        animation.values = [0, 2*Double.pi]
        animation.keyTimes = [0, 1]
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = Float.infinity
        animation.beginTime = CACurrentMediaTime()
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "rotate")
        
        CATransaction.commit()
    }
    
    static func jumpAnimation(layer: CALayer, repeatCount: Float = 2, duration: Float = 1, force: CGFloat = 1, delay: Float = 0, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [0, 2*force, -10*force, 2*force, 0, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "jump")
        
        CATransaction.commit()
    }
    
    static func flipAnimation(layer: CALayer, duration: Float = 1, fromAngle: CGFloat = 0, toAngle: CGFloat = .pi, delay: Float = 0, completionCallBack: @escaping ()->()){
        CATransaction.begin()
        
        var fromValue: CATransform3D
        fromValue = CATransform3DMakeRotation(fromAngle, 0, 1, 0)
        //fromValue = CATransform3DRotate(layer.transform, fromAngle, 0, 1, 0)
        fromValue.m34 = 0.003
        
        var toValue: CATransform3D
        //toValue = CATransform3DRotate(layer.transform, toAngle, 0, 1, 0)
        toValue = CATransform3DMakeRotation(toAngle, 0, 1, 0)
        toValue.m34 = 0.003
        
        let rotateFromView = CABasicAnimation(keyPath: "transform")
        layer.zPosition = 100
        rotateFromView.fromValue = NSValue(caTransform3D: fromValue)
        rotateFromView.toValue = NSValue(caTransform3D: toValue)
        rotateFromView.duration = CFTimeInterval(duration)
        rotateFromView.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        layer.add(rotateFromView, forKey: "flip")
        CATransaction.commit()
    }
    
    static func fallAnimation(layer: CALayer, repeatCount: Float = 1, duration: Float = 2, force: CGFloat = 1, delay: Float = 0, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        layer.opacity = 0
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [-50*force, 5*force, -3*force, 2*force, 0, 0]
        animation.keyTimes = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 1]
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
                
        let fadeAnimation = CAKeyframeAnimation()
        fadeAnimation.keyPath = "opacity"
        fadeAnimation.values = [0, 1.0, 1.0]
        fadeAnimation.keyTimes = [0, 0.075, 1]
        fadeAnimation.duration = CFTimeInterval(duration)
        fadeAnimation.repeatCount = 1
        
        let group = CAAnimationGroup()
        group.duration = CFTimeInterval(duration)
        group.repeatCount = 1
        group.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        group.animations = [fadeAnimation, animation]
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(group, forKey: "fall")
        
        CATransaction.commit()
    }
    
    static func moveXAnimation(layer: CALayer, repeatCount: Float = 1, duration: Float = 0.5, offLength: CGFloat, isFadeIn: Bool = true, isBounce: Bool = false, delay: Float = 0, completionCallBack: @escaping ()->()) {
        CATransaction.begin()
        
        layer.opacity = 0
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        if isFadeIn {
            if isBounce {
                animation.values = [offLength, offLength*1.1, -offLength*0.1, 0, 0]
                animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            } else {
                animation.values = [offLength, 0]
                animation.keyTimes = [0, 1]
            }
        } else {
            if isBounce {
                animation.values = [0, -offLength*0.1, offLength*1.1, offLength, offLength]
                animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            } else {
                animation.values = [0, offLength]
                animation.keyTimes = [0, 1]
            }
        }
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.duration = CFTimeInterval(duration)
        animation.isAdditive = true
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
                
        let fadeAnimation = CAKeyframeAnimation()
        fadeAnimation.keyPath = "opacity"
        if isFadeIn {
            fadeAnimation.values = [0, 0.75, 1.0]
            fadeAnimation.keyTimes = [0, 0.5, 1]
        } else {
            fadeAnimation.values = [1.0, 0.75, 0.0]
            fadeAnimation.keyTimes = [0, 0.5, 1]
        }
        fadeAnimation.duration = CFTimeInterval(duration)
        fadeAnimation.repeatCount = 1
        
        let group = CAAnimationGroup()
        group.duration = CFTimeInterval(duration)
        group.repeatCount = 1
        group.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        group.animations = [fadeAnimation, animation]
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(group, forKey: "move")
        
        CATransaction.commit()
    }
    
    static func pulseAnimation(layer: CALayer, repeatCount: Float = 0, duration: Float = 1, delay: Float = 0) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0 ,1.0, 1.05, 1.0, 1.05, 1.0, 1.0]
        animation.keyTimes = [0 ,0.3, 0.4, 0.5, 0.6, 0.7, 1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        layer.add(animation, forKey: "pulse")
    }
    
    static func popAnimation(layer: CALayer, repeatCount: Float = 1, duration: Float = 1, delay: Float = 0, completionCallBack: @escaping ()->() = {}) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.0 ,1.0, 0.8, 1.0]
        animation.keyTimes = [0 ,0.5, 0.75, 1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "pop")
    }
    
    static func fadeAnimation(isFadeIn:Bool, repeatCount: Float = 1, layer: CALayer, duration: Float = 1, delay: Float = 0, completionCallBack: @escaping ()->() = {}) {
        
        let animationKey: String = "fade"
        layer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        if isFadeIn {
            animation.values = [0, 1]
            animation.keyTimes = [0, 1]
        } else {
            animation.values = [layer.opacity, 0]
            animation.keyTimes = [0, 1]
        }
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: animationKey)
    }
    
    static func scaleAnimation(layer: CALayer, fromValue:Float = 0, toValue:Float = 1, duration: Float = 1, delay: Float = 0, completionCallBack: @escaping ()->() = {}) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [fromValue, toValue]
        animation.keyTimes = [0, 1]
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = CACurrentMediaTime()
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "scale")
    }
    
    static func breatheAnimation(layer: CALayer, repeatCount: Float = 0, duration: Float = 1, scale: Float = 1.15, delay: Float = 0, completionCallBack: @escaping ()->()) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, scale, 1.0, scale, 1.0, 1.0]
        animation.keyTimes = [0 ,0.15, 0.3, 0.45, 0.6, 1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "breathe")
    }
        
    static func breatheAnimationWithDelay(layer: CALayer, repeatCount: Float = 0, duration: Float = 1.2, scale: Float = 1.15, delay: Float = 0, completionCallBack: @escaping ()->()) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, scale, 1.0, 1.0]
        animation.keyTimes = [0 ,0.15, 0.3, 1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "breathe")
    }
    
    static func breatheAndGlareAnimation(layer: CALayer, repeatCount: Float = 0, duration: Float = 2, scale: Float = 1.05, delay: Float = 0, completionCallBack: @escaping ()->()) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, scale, 1.0,1.0]
        animation.keyTimes = [0 ,0.15, 0.25,1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = repeatCount > 0 ? repeatCount : Float.infinity
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        CATransaction.setCompletionBlock({
            completionCallBack()
        })
        
        layer.add(animation, forKey: "breatheAndGlare")
    }
    
    
    static func flashingAnimation(layer: CALayer, duration: Float = 0.8) {
        
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        
        animation.values = [1.0, 0, 1.0, 0, 1.0]
        animation.keyTimes = [0 , 0.25, 0.5, 0.75, 1]
        animation.duration = CFTimeInterval(duration)
        animation.repeatCount = 1
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0.5)
        
        layer.add(animation, forKey: "flashing")
    }
}

extension AnimationFactory {
    
    static func fadeOutAndRemoveFromSuperview(_ view: UIView, duration: Float = 0.25) {
        let handler = { (isComplete:Bool) -> Void in
            view.removeFromSuperview()
        }
        UIView.transition(with: view,
        duration: TimeInterval(duration),
        options: .transitionCrossDissolve,
        animations: { view.alpha = 0 },
        completion: handler)
    }
    
    static func fadeIn(_ view: UIView, duration: Float = 0.25, alpha: CGFloat = 1, completionCallBack: (()->())? = nil) {
        UIView.transition(with: view,
        duration: TimeInterval(duration),
        options: .curveLinear,
        animations: { view.alpha = alpha },
        completion: { (isComplete: Bool) -> Void in
            completionCallBack?()
        })
    }
    
    static func fallAnimation(view: UIView, duration: Float = 2, force: CGFloat = 3, delay: Float = 0, completionCallBack: @escaping ()->()) {
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: 0, y: -50*force)
        
        UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: [.calculationModeCubic], animations: {() -> Void in
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: { () -> Void in
                view.transform = CGAffineTransform(translationX: 0, y: 5*force)
                view.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: { () -> Void in
                view.transform = CGAffineTransform(translationX: 0, y: -3*force)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: { () -> Void in
                view.transform = CGAffineTransform(translationX: 0, y: 2*force)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: { () -> Void in
                view.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
        }, completion: {(isComplete: Bool) -> Void in
            completionCallBack()
        })
    }
    
    static func jumpToTopAnimation(view: UIView, duration: Float = 0.8, force: CGFloat = 1, delay: Float = 0, completionCallBack: @escaping ()->()) {
        let height = view.frame.size.height
        view.alpha = 1
        view.transform = CGAffineTransform(translationX: 0, y: -height/2.0)
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: [.calculationModeCubic], animations: {() -> Void in

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: { () -> Void in
                view.transform = CGAffineTransform(scaleX: 1.25, y: 0.5)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { () -> Void in
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
                view.transform = CGAffineTransform(translationX: 0, y: -height*force)
            })

        }, completion: {(isComplete: Bool) -> Void in
            completionCallBack()
        })
    }
}

extension AnimationFactory {
    static func fadeTransition(isFadein: Bool, view: UIView, duration: Float = 0.35, completionCallBack: @escaping ()->()) {
        if isFadein {
            if view.alpha == 1 {
                completionCallBack()
                return
            }
        } else {
            if view.alpha == 0 {
                completionCallBack()
                return
            }
        }
        UIView.transition(with: view,
        duration: TimeInterval(duration),
        options: .transitionCrossDissolve,
        animations: { view.alpha = isFadein ? 1.0 : 0.0 },
        completion: { (isSuccess: Bool) -> Void in
            completionCallBack()
        })
    }
    
    static func MoveTransition(view: UIView, duration: Float = 0.35, moveX: CGFloat = 0, moveY: CGFloat = 0, completionCallBack: @escaping ()->()) {
        UIView.transition(with: view,
        duration: TimeInterval(duration),
        options: .curveEaseOut,
        animations: {
            view.transform = CGAffineTransform(translationX: moveX, y: moveY)
        },
        completion: { (isSuccess: Bool) -> Void in
            view.transform = CGAffineTransform(translationX: 0, y: 0)
            completionCallBack()
        })
    }
    
    static func fadeAndMoveTransition(isFadein: Bool, view: UIView, duration: Float = 0.35, moveX: CGFloat = 0, moveY: CGFloat = 0, completionCallBack: @escaping ()->()) {
        UIView.transition(with: view,
        duration: TimeInterval(duration),
        options: .curveEaseOut,
        animations: {
            view.transform = CGAffineTransform(translationX: moveX, y: moveY)
            view.alpha = isFadein ? 1.0 : 0.0
        },
        completion: { (isSuccess: Bool) -> Void in
            completionCallBack()
        })
    }
    
    static func scaleTransition(view: UIView, toValue: CGFloat = 1.1, duration: Float = 1, completionCallBack: @escaping ()->() = {}) {
        UIView.transition(with: view,
                          duration: TimeInterval(duration),
                          options: .curveLinear,
                          animations: {
                            view.transform = CGAffineTransform(scaleX: toValue, y: toValue)
                          },
                          completion: { (isComplete:Bool) -> Void in
                            completionCallBack()
                          })
    }
    
}

extension AnimationFactory{
    static func randomHintMoveToUpperRight(view: UIView,moveX:CGFloat,moveY:CGFloat, completionCallBack: @escaping ()->()) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            view.transform = CGAffineTransform.identity.translatedBy(x: moveX, y: moveY).scaledBy(x: 1/2.05, y: 1/2.05)
        }, completion: {(isSuccess: Bool)-> Void in completionCallBack()})
    }
    
    static func randomHintMoveToCenter(view: UIView,moveX:CGFloat,moveY:CGFloat, completionCallBack: @escaping ()->()) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            view.transform = CGAffineTransform.identity.translatedBy(x: moveX, y: moveY).scaledBy(x: 1.6, y: 1.6)
        }, completion: {(isSuccess: Bool)-> Void in completionCallBack()})
    }
    
    static func shineAndFadeoutAnimation(view: UIView,duration: CGFloat = 0.5, scale: CGFloat = 1.4, completionCallBack: @escaping ()->()) {
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .transitionCrossDissolve, animations: {
            view.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: scale, y: scale);
        }, completion: {(isSuccess: Bool)-> Void in completionCallBack()})
    }
}
