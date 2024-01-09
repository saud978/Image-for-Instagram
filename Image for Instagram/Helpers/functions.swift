//
//  functions.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 15/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//

import Foundation

// Constants
// Test Ads
let GADTestBannerID  = "ca-app-pub-3940256099942544/2934735716"
let GADTestInterstitialID   = "ca-app-pub-3940256099942544/4411468910"
let GADTestInterstitialVideoid  =  "ca-app-pub-3940256099942544/5135589807"
let GADTestRewardedVideoID  =  "ca-app-pub-3940256099942544/1712485313"
let GADTestNativeAdvancedID  =  "ca-app-pub-3940256099942544/3986624511"
let GADTestNativeAdvancedVideoID  =  "ca-app-pub-3940256099942544/2521693316"
// Live Ads
let GADLiveBannerID  = ""
let GADLiveInterstitialID   = ""
let GADLiveInterstitialVideoid  =  ""
let GADLiveRewardedVideoID  =  ""
let GADLiveNativeAdvancedID  =  ""
let GADLiveNativeAdvancedVideoID  =  ""

let defaultHashtags = "#عرب_فوتو #تصويري #السعودية #غرد_بصورة #انستقرام #صور #صورة #صوره #تصميم #كانون #تصوير #كميرا #فوتو #لايك #مضحك #من_تصوير #من_تصميمي #سياحة #عدستي #هاشتاق #غرد #لايك #لقطة #نكت #ضحك #دبي #عرب #saudi #الامارات #love #instagood #photooftheday #fashion #beautiful #happy #cute #followme #picoftheday #follow #me #selfie #summer #art #instadaily #friends #repost #nature #girl #fun #style #smile #food #instalike #family #travel #fitness #igers #tagsforlikes #follow4follow #nofilter #life #beauty #amazing #instamood #instagram #photography #sun #photo #music #beach #bestoftheday #sky #sunset #makeup #hair #pretty #swag #cat #model #motivation #girls #baby #party #cool #lol #gym #design #instapic #funny #healthy #night #yummy #flowers #lifestyle #hot #instafood #wedding #fit #handmade #black #pink #blue #work #workout #blackandwhite #drawing #inspiration #home #holiday #london #sea #instacool #goodmorning"

let productID = "instapost_ads_remove"

var hashtagsArray = [""]

func getHashData() {
    guard let userHashtag = UserDefaults.standard.value(forKey: "hashtags") else {
        print("using default hashtags")
        hashtagsArray = defaultHashtags.components(separatedBy: " ")
        //            print(hashtagsArray.joined(separator: " "))
        UserDefaults.standard.set(hashtagsArray.joined(separator: " "), forKey: "hashtags")
        return
    }
    
    hashtagsArray = (userHashtag as! String).components(separatedBy: " ")
    print(hashtagsArray)
    //        print(hashtagsArray.joined(separator: " "))
    print("using saved hashtags")
}
