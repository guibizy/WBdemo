//
//  Config.h
//  WBdemo
//
//  Created by Nick on 15-4-1.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#ifndef WBdemo_Config_h
#define WBdemo_Config_h


#define HTTP_URL @"https://api.weibo.com"

#define GET_OAuth2 [NSString stringWithFormat:@"%@/oauth2/authorize", HTTP_URL]

#define GET_access_token [NSString stringWithFormat:@"%@/oauth2/access_token", HTTP_URL]

#define GET_revokeoauth2 [NSString stringWithFormat:@"%@/oauth2/revokeoauth2", HTTP_URL]

#define GET_get_token_info [NSString stringWithFormat:@"%@/oauth2/get_token_info", HTTP_URL]

//获取当前登录用户及其所关注用户的最新微博
#define GET_statuses_home_timeline [NSString stringWithFormat:@"%@/2/statuses/friends_timeline.json", HTTP_URL]

//通过id获取用户信息
#define GET_USERS_INFO_UID [NSString stringWithFormat:@"%@/2/users/show.json", HTTP_URL]

//获取当前登录用户及其所关注用户的最新微博的ID
#define GET_FRIENDS_TIMELINE [NSString stringWithFormat:@"%@/2/statuses/friends_timeline/ids.json", HTTP_URL]
//根据微博ID返回某条微博的评论列表
/*
 只返回授权用户的评论，非授权用户的评论将不返回；
 使用官方移动SDK调用，可多返回30%的非授权用户的评论；
 */
#define GET_COMMENTS_SHOW [NSString stringWithFormat:@"%@/2/comments/show.json", HTTP_URL]
//评论一条微博
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 comment	true	string	评论内容，必须做URLencode，内容不超过140个汉字。
 id	true	int64	需要评论的微博ID。
 comment_ori	false	int	当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
 rip	false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
#define wb_PINGLUN [NSString stringWithFormat:@"%@/2/comments/create.json", HTTP_URL]
//删除一条评论
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 cid	true	int64	要删除的评论ID，只能删除登录用户自己发布的评论。
 */
#define wb_PINGLUN_destroy [NSString stringWithFormat:@"%@/2/comments/destroy.json", HTTP_URL]
//回复一条评论
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 cid	true	int64	需要回复的评论ID。
 id	true	int64	需要评论的微博ID。
 comment	true	string	回复评论内容，必须做URLencode，内容不超过140个汉字。
 without_mention	false	int	回复中是否自动加入“回复@用户名”，0：是、1：否，默认为0。
 comment_ori	false	int	当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
 rip	false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
#define wb_PINGLUN_reply [NSString stringWithFormat:@"%@/2/comments/reply.json", HTTP_URL]
//转发一条微博
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 id	true	int64	要转发的微博ID。
 status	false	string	添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
 is_comment	false	int	是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
 rip	false	string	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
#define wb_ZHUANFA [NSString stringWithFormat:@"%@/2/statuses/repost.json", HTTP_URL]
//删除一条微博
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 id	true	int64	需要删除的微博ID。
 */
#define wb_ZHUANFA_destroy [NSString stringWithFormat:@"%@/2/statuses/destroy.json", HTTP_URL]
/**
 *  发布一条微博 post
 *
 *  source 	false 	string 	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token 	false 	string 	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 status 	true 	string 	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 visible 	false 	int 	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 list_id 	false 	string 	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 lat 	false 	float 	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 long 	false 	float 	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 annotations 	false 	string 	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
 rip 	false 	string 	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
#define wb_FABU [NSString stringWithFormat:@"%@/2/statuses/update.json", HTTP_URL]
/**
 *  上传图片并发布微博
 *
 *source 	false 	string 	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token 	false 	string 	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 status 	true 	string 	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 visible 	false 	int 	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 list_id 	false 	string 	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 pic 	true 	binary 	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
 lat 	false 	float 	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 long 	false 	float 	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 annotations 	false 	string 	元数据，主要是为了方便第三方应用记录一些适合于自己使用的信息，每条微博可以包含一个或者多个元数据，必须以json字串的形式提交，字串长度不超过512个字符，具体内容可以自定。
 rip 	false 	string 	开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
#define wb_FABU_pic [NSString stringWithFormat:@"%@/2/statuses/upload.json", HTTP_URL]
//获取某个用户的各种消息未读数
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 uid	true	int64	需要获取消息未读数的用户UID，必须是当前登录用户。
 callback	false	string	JSONP回调函数，用于前端调用返回JS格式的信息。
 unread_message	false	boolean	未读数版本。0：原版未读数，1：新版未读数。默认为0
 
 
 返回
 status	int	新微博未读数
 follower	int	新粉丝数
 cmt	int	新评论数
 dm	int	新私信数
 mention_status	int	新提及我的微博数
 mention_cmt	int	新提及我的评论数
 group	int	微群消息未读数
 private_group	int	私有微群消息未读数
 notice	int	新通知未读数
 invite	int	新邀请未读数
 badge	int	新勋章数
 photo	int	相册消息未读数
 msgbox	int	{{{3}}}
 */
#define wb_unread [NSString stringWithFormat:@"%@/2/remind/unread_count.json", HTTP_URL]
//获取某个用户最新发表的微博列表
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 uid	false	int64	需要查询的用户ID。
 screen_name	false	string	需要查询的用户昵称。
 since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 count	false	int	单页返回的记录条数，最大不超过100，超过100以100处理，默认为20。
 page	false	int	返回结果的页码，默认为1。
 base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 feature	false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 trim_user	false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
 

 获取自己的微博，参数uid与screen_name可以不填，则自动获取当前登录用户的微博；
 指定获取他人的微博，参数uid与screen_name二者必选其一，且只能选其一；
 接口升级后：uid与screen_name只能为当前授权用户；
 读取当前授权用户所有关注人最新微博列表，请使用：获取当前授权用户及其所关注用户的最新微博接口（statuses/home_timeline）；
 此接口最多只返回最新的5条数据，官方移动SDK调用可返回10条
 */
#define wb_id_userwb [NSString stringWithFormat:@"%@/2/statuses/user_timeline.json", HTTP_URL]
//根据微博ID获取单条微博内容    get
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 id	true	int64	需要获取的微博ID。
 
 返回
 created_at	string	微博创建时间
 id	int64	微博ID
 mid	int64	微博MID
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 source	string	微博来源
 favorited	boolean	是否已收藏，true：是，false：否
 truncated	boolean	是否被截断，true：是，false：否
 in_reply_to_status_id	string	（暂未支持）回复ID
 in_reply_to_user_id	string	（暂未支持）回复人UID
 in_reply_to_screen_name	string	（暂未支持）回复人昵称
 thumbnail_pic	string	缩略图片地址，没有时不返回此字段
 bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
 original_pic	string	原始图片地址，没有时不返回此字段
 geo	object	地理信息字段 详细
 user	object	微博作者的用户信息字段 详细
 retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 mlevel	int	暂未支持
 visible	object	微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
 pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
 ad	object array	微博流内的推广微博ID
 */
#define wb_onewb [NSString stringWithFormat:@"%@/2/statuses/show.json", HTTP_URL]
//获取最新的提到当前登录用户的评论，即@我的评论
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 since_id	false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
 max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count	false	int	单页返回的记录条数，默认为50。
 page	false	int	返回结果的页码，默认为1。
 filter_by_author	false	int	作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
 filter_by_source	false	int	来源筛选类型，0：全部、1：来自微博的评论、2：来自微群的评论，默认为0。
 */
#define wb_mypinglun [NSString stringWithFormat:@"%@/2/comments/mentions.json", HTTP_URL]
//获取当前登录用户所接收到的评论列表
/**
 source	false	string	采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 since_id	false	int64	若指定此参数，则返回ID比since_id大的评论（即比since_id时间晚的评论），默认为0。
 max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的评论，默认为0。
 count	false	int	单页返回的记录条数，默认为50。
 page	false	int	返回结果的页码，默认为1。
 filter_by_author	false	int	作者筛选类型，0：全部、1：我关注的人、2：陌生人，默认为0。
 filter_by_source	false	int	来源筛选类型，0：全部、1：来自微博的评论、2：来自微群的评论，默认为0。
 */
#define wb_mypinglun_to_me [NSString stringWithFormat:@"%@/2/comments/to_me.json", HTTP_URL]


#endif
