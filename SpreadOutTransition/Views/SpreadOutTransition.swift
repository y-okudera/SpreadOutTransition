//
//  SpreadOutTransition.swift
//  SpreadOutTransition
//
//  Created by YukiOkudera on 2018/05/30.
//  Copyright © 2018年 YukiOkudera. All rights reserved.
//

import UIKit

final class SpreadOutTransition: NSObject {

    enum TransitionMode {
        case present
        case dismiss
    }

    var startPoint = CGPoint.zero {
        didSet {
            animationView.center = startPoint
        }
    }

    var transitionMode = TransitionMode.present
    var animationViewColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    private let scale = CGFloat(0.001)
    private var animationView = UIView()

    private func frameForAnimationView(originalCenter: CGPoint, originalSize: CGSize, start: CGPoint) -> CGRect {

        // start.x と (originalSize.width - start.x) の大きい方の値を取得
        let lengthX = fmax(start.x, originalSize.width - start.x)

        // start.y と (originalSize.height - start.y) の大きい方の値を取得
        let lengthY = fmax(start.y, originalSize.height - start.y)

        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)

        return CGRect(origin: CGPoint.zero, size: size)
    }

    /// 対象画面へ遷移するときのアニメーション定義
    private func present(transitionContext: UIViewControllerContextTransitioning, transitionDuration: TimeInterval) {

        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let toViewCenter = toView.center
        let toViewSize = toView.frame.size

        animationView = UIView()
        animationView.frame = frameForAnimationView(
            originalCenter: toViewCenter,
            originalSize: toViewSize,
            start: startPoint
        )
        animationView.layer.cornerRadius = animationView.frame.size.height / 2
        animationView.center = startPoint
        animationView.transform = CGAffineTransform(scaleX: scale, y: scale)
        animationView.backgroundColor = animationViewColor
        containerView.addSubview(animationView)

        toView.center = startPoint
        toView.transform = CGAffineTransform(scaleX: scale, y: scale)
        toView.alpha = 0
        containerView.addSubview(toView)

        UIView.animate(withDuration: transitionDuration, animations: {

            // transformプロパティによる変更をリセットする
            self.animationView.transform = .identity

            toView.transform = .identity
            toView.alpha = 1
            toView.center = toViewCenter

        }, completion: { _ in

            self.animationView.isHidden = true
            transitionContext.completeTransition(true)
        })
    }

    /// 対象画面を閉じるときのアニメーション定義
    private func dismiss(transitionContext: UIViewControllerContextTransitioning, transitionDuration: TimeInterval) {

        let containerView = transitionContext.containerView

        let toView = transitionContext.view(forKey: .to)!
        containerView.addSubview(toView)

        let fromView = transitionContext.view(forKey: .from)!
        let fromViewCenter = fromView.center
        let fromViewSize = fromView.frame.size
        animationView.frame = frameForAnimationView(
            originalCenter: fromViewCenter,
            originalSize: fromViewSize,
            start: startPoint
        )
        animationView.layer.cornerRadius = animationView.frame.size.height / 2
        animationView.center = startPoint
        animationView.isHidden = false
        containerView.addSubview(animationView)

        UIView.animate(withDuration: transitionDuration, animations: {

            // 0.001倍に縮小
            self.animationView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            fromView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)

            fromView.center = self.startPoint
            fromView.alpha = 0

        }, completion: { _ in

            fromView.center = fromViewCenter
            fromView.removeFromSuperview()
            self.animationView.removeFromSuperview()
            toView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension SpreadOutTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let animationDuration = transitionDuration(using: transitionContext)

        if transitionMode == .present {
            present(transitionContext: transitionContext, transitionDuration: animationDuration)
        } else {
            dismiss(transitionContext: transitionContext, transitionDuration: animationDuration)
        }
    }
}

