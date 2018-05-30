//
//  TennisMotionWorkoutManager.swift
//  MDProject WatchKit Extension
//
//  Created by Yevgeny Beygel on 12/16/17.
//  Copyright © 2017 BGU. All rights reserved.
//

import UIKit
import Common

class TennisMotionWorkoutManager : PMotionWorkoutManager {
    
    var delegate: WorkoutManagerDelegate?
    let sampler: PMotionSampler = TennisMotionSampler()
    var isSampling : Bool {
        return (sampler as? TennisMotionSampler)?.isSampling == true
    }
    
    var sampledMotions = [TennisMLSample]()
    
    var forhandCount : Int {
        return sampledMotions.filter{
            (sample: TennisMLSample) -> Bool in
            return sample.classification == MotionType.forhand.rawValue
            }.count
    }
    var backhandCount : Int {
        return sampledMotions.filter{
            (sample: TennisMLSample) -> Bool in
            return sample.classification == MotionType.backhand.rawValue
            }.count
    }
    init() {
        sampler.delegate = self
    }
    
    func startWorkout() {
        sampler.startSampling()
    }
    
    func stopWorkout() {
        sampler.stopSampling()
        delegate?.didFinishSamplingMotions(sampledMotions)
    }
}


// MARK: - MotionSampler delegate functions
extension TennisMotionWorkoutManager {
    func motionSampler(_ sampler: PMotionSampler, didSampleMotion motion: PMLMotion) {
        guard let currTennisMotion = motion as? TennisMLSample else { return }
        
        if let lastTennisMotion = sampledMotions.last,
            lastTennisMotion.classification != currTennisMotion.classification,
            currTennisMotion.timestamp == lastTennisMotion.timestamp {
            return
        }
        
        sampledMotions.append(currTennisMotion)
        if !isSampling {
            delegate?.didPerformMotion(currTennisMotion)
        }
    }
}
