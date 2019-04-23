//
//  KZRequest.h
//  KZBaseProject
//
//  Created by 孔志林 on 2018/6/7.
//  Copyright © 2018年 KMingMing. All rights reserved.
//  接口地址

#ifndef KZRequest_h
#define KZRequest_h

#define kBaseUrl @"https://www.fgowiki.cn/fgo/"

#define kMainLogo @"account/getTopImgList.do" //主页面图片
/** 新接口：http://118.25.53.99:8080/FGO/servant/getServantList.do
 老接口：servant/getServantList.do
 */
#define kyllb @"http://118.25.53.99:8080/FGO/servant/getServantList.do" //英灵列表
/** 新接口：http://118.25.53.99:8080/FGO/material/getMaterialList.do
    老接口：material/getMaterialList.do
 */
#define kscxx @"http://118.25.53.99:8080/FGO/material/getMaterialList.do" //素材信息
#define khoxq @"material/getEventList.do" //活动详情
//#define kyxxq @"http://118.25.53.99:8080/FGO/servant/getServantInfo.do" //英雄详情
#define kyxxq @"servant/getServantInfo.do" //英雄详情

#define kjssc @"servant/getServantMaterialWithGodCloth.do"//计算素材

#define kScgh @"material/calculateServantMaterial.do" //素材规划页面
#define kdjsc @"material/getMaterialDrop.do" //点击计算后的素材页面
#endif /* KZRequest_h */ 

