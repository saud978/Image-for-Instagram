//
//  GADInterstitialDelegate.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 16/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//
import GoogleMobileAds
import Foundation

extension ViewController: GADInterstitialDelegate {

    func initInterstitialAdView() {
        interstitial = GADInterstitial(adUnitID: GADLiveInterstitialID)
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
    }
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsEditViewController") as! HashtagsEditViewController
        self.present(vc, animated: true, completion: nil)
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}

