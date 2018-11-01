//
//  BGMPlayControlView.swift
//  Duluo
//
//  Created by apple on 2017/5/5.
//  Copyright © 2017年 tts. All rights reserved.
//

import UIKit

class BGMPlayControlView: UIView {

    var selectedButton: ((UIButton, Int) -> ())?
    
    class func show(atView: UIView) -> BGMPlayControlView {
        let view = BGMPlayControlView(frame: CGRect(x: kScreenWidth - 150, y: kScreenHeight/2, width: 150, height: 70))
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.2)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        let pauseBtn = UIButton(frame: CGRect(x: 20, y: (view.frame.height - 36)/2, width: 36, height: 36))
        pauseBtn.setImage(#imageLiteral(resourceName: "music_play"), for: .normal)
        pauseBtn.setImage(#imageLiteral(resourceName: "music_stop"), for: .selected)
        pauseBtn.addTarget(view, action: #selector(BGMPlayControlView.pauseButtonAction(btn:)), for: .touchUpInside)
        view.addSubview(pauseBtn)
        
        let stopBtn = UIButton(frame: CGRect(x: view.frame.width - 56, y: pauseBtn.frame.minY, width: 36, height: 36))
        stopBtn.setImage(#imageLiteral(resourceName: "music_over"), for: .normal)
        stopBtn.addTarget(view, action: #selector(BGMPlayControlView.stopButtonAction(btn:)), for: .touchUpInside)
        view.addSubview(stopBtn)
        atView.addSubview(view)
//        let lyeGesture = LyeCustomGestureRecognizer(target: nil, action: nil)
//        view.addGestureRecognizer(lyeGesture)
        return view
    }
    func stopButtonAction(btn: UIButton) {
        selectedButton?(btn, 2)
        self.removeFromSuperview()
    }
    func pauseButtonAction(btn: UIButton) {
        selectedButton?(btn, 1)
    }
}
