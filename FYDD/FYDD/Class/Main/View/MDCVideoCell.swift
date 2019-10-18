//
//  MDCVideoCell.swift
//  MDC
//
//  Created by mac on 2018/12/28.
//  Copyright © 2018 www.mdc.cn.com. All rights reserved.
//

import UIKit
import BMPlayer
import SnapKit

class MDCVideoCell: UITableViewCell {
    let player = BMPlayer()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(player)
        contentView.backgroundColor = UIColor.white
        selectionStyle = .none;
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.loaderType  = .ballRotateChase
        BMPlayerConf.enableBrightnessGestures = true
        BMPlayerConf.enableVolumeGestures = true
        BMPlayerConf.enablePlaytimeGestures = true
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        backgroundColor = UIColor.white
        player.backgroundColor = UIColor.white
        player.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0)
        }
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return
                
                
            }
            
        }


    }
    
    @objc func updatePlay(title:String,url:String,placeCover:String) -> Void{
        let res0 = BMPlayerResourceDefinition(url: URL(string: url)!,
                                              definition: "高清")
        
        let asset = BMPlayerResource(name: title,
                                     definitions: [res0],
                                     cover: URL.init(string: placeCover)!)
        
        
        player.setVideo(resource: asset)
    }
    
    @objc func DimissVideoNote() -> Void{
        player.pause()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
