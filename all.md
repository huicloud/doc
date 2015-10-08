
# 开发指南

## 开发说明

大智慧信息服务云平台（简称云平台）包括了各种类型的金融数据，包括股票行情、新闻公告、信息资讯等。

同时，云平台提供了一套统一、标准且安全的数据访问API接口，以方便开发者能快速的接入云平台，极大地帮助开发者节省开发成本与周期。

## 协议支持

云平台数据请求支持两种通讯协议: http、websocket

http协议多用于单次数据查询类请求

websocket是HTML5开始提供的一种浏览器与服务器间进行全双工通讯的网络技术，主要用于订阅推送类请求，也支持单次查询类

### http协议

http请求URL表示形式，如下：

http://hostname[:port]/path?query  (带方括号[]的为可选项)

动态行情请求举例:

http://hostname:8080/quote/dyna?obj=SH600000&sub=0&qid=1&token=xxxxx

http协议支持GET,POST; GET和POST的请求内容和响应内容是完全一致的。

因为HTTP对请求URI是有长度限制的，过长的URI，就可以通过使用POST方式将QUERY内容放置于BODY中来进行提交。

### websocket协议

websocket请求前需要先建立websocket长连接，连接的url如下：

ws://hostname:port/ws?token=xxxx
(连接的port与token与http请求相同)

连接建立成功后可进行数据的单次请求、订阅、订阅取消

动态行情订阅推送请求举例：

/quote/dyna?obj=SH600000&sub=1&qid=1

取消上面的订阅请求

/cancel?qid=1
 
## 请求格式

**URL简介**

统一资源定位符（Uniform Resource Locator，缩写为URL）是对可以从互联网上得到的资源的位置和访问方法的一种简洁的表示，是互联网上标准资源的地址。

互联网上的每个文件都有一个唯一的URL，它包含的信息指出文件的位置以及浏览器应该怎么处理它。

URL由三部分组成：资源类型、存放资源的主机域名、资源文件名。

URL的一般语法格式为：
protocol://hostname[:port]/path[?query]#fragment                   (带方括号[]的为可选项)

URL详细描述参见：[RFC1738](http://www.w3.org/Addressing/rfc1738.txt)

**请求格式**

云平台的请求串格式，使用URL的path+query来构成，语法为：

/path?query

- path    -  路径，由零或多个“/”符号隔开的字符串构成，指定云平台中对外提供的服务名。
- query  -  查询，用于传递查询参数，多个参数用“&”符号隔开，每个参数的名和值用“=”符号隔开；请求字符串的编码规范，完全符合URL。

**PATH部分**

path路径，指定云平台的应用服务名，通过它能唯一找到相应的应用服务来处理请求。

- /quote/dyna: 动态行情服务
- /cancel: 取消订阅服务
- /group: 请求组服务

**QUERY部分**

通用参数，对所有请求有效

- output - 可选。指定数据结果的返回格式：json（缺省值），protobuff

- qid - 必填(websocket协议)。请求ID，指定请求的唯一标识；请求ID最大长度支持32位，无字符内容限制。
	- 普通请求 - 同个连接通道下不可重复，不同通道不限制；重复ID的请求，UA不受理，直接返回异常响应。
	- 取消请求 - 和普通请求限制刚好相反，该参数值唯一指定通过该连接通道已被发送的请求标识；

  如果指定未知的请求标识或是已被处理过的单次查询请求标识，UA会返回找不到请求标识之类的错误。

  **注：该参数仅仅在Websocket通道下才有效；HTTP协议将被忽略。**

- sub - 可选。指定是否订阅更新。0: 不订阅（缺省值）, 1: 订阅
注：HTTP下不存在推送订阅情况，设置sub=1时将返回错误响应。

**取消请求**

基于长连接通道(Websocket)的推送类请求，很多情况下我们都需要应用主动的来取消不再需要的服务，这样可以避免造成许多无必要的资源浪费。

云平台提供了通用的请求取消服务（/cancel）来取消指定请求。

服务示例：   /cancel?qid=req0001

服务PATH： /cancel

服务参数：   qid            唯一指定通过该连接通道已被发送的请求标识

**使用场景**

在不同的请求协议中，对请求串的使用可能会有些不同。

- http   -   需要构建完整的URL串来完成一次请求，构建方式：  http://hostname[:port] + 请求串。
- websocket   -   一个消息体（MESSAGE），即表示一次请求。 消息体内容使用请求串填充即可。

## 响应格式

云平台数据服务API目前支持的响应编码格式：json, protobuffer

云平台返回的响应编码格式由开发者来指定

**格式描述**

响应结果由二部分构成：数据描述和数据结果

```json
{
     /***********数据描述***********/
    "Qid": "0", 
    "Err": 0, 
    "Counter": 1, 
     /***********数据结果***********/
    "Data": {
         "Id": 1,
         "MsgName":[{...},...]
    }
}
```

**字段说明**

| 名称  |  类型 | 说明  |
| ------------ | ------------ | ------------ |
| Qid  | 字符串  | 请求序号(请求时指定)，唯一标识请求  |
| Err  | 数值  | 错误码。０: 成功； 其它值：失败  |
| Counter  | 数值  | 响应的序号。从1开始递增，每响应一次就累加1 |
| Data | 对象 | 具体的响应数据 |
| Data.Id | 数值 | 消息ID，指定某类响应消息类型；一般情况下，不同的数据服务返回的消息ID不一样 |
| Data.MsgName | 数组 | 消息记录数组，具体消息记录内容参考各具体数据服务的响应描述; 不同的Id，MsgName的实际命名是不一样的 |

**响应示例**

请求示例

/quote/dyna?obj=SH600000&qid=123456

响应示例

```json
{
    Qid: "123456",
    Err: 0,
    Counter: 1,
    Data: {
        Id: 20,
        RepDataQuoteDynaSingle: [
            {
                Obj: "SH600000",
                Data: {
                    Id: 655361,
                    ShiJian: 369535629040,
                    ZuiXinJia: 1597,
                    KaiPanJia: 1579,
                    ZuiGaoJia: 1599,
                    ZuiDiJia: 1567,
                    ZuoShou: 1592,
                    JunJia: 1583,
                    ZhangDie: 5,
                    ZhangFu: 31,
                    ZhenFu: 201,
                    ChengJiaoLiang: 29226592220,
                    XianShou: 29226592220,
                    ChengJiaoE: 46276645232640,
                    ZongChengJiaoBiShu: 683308,
                    HuanShou: 77,
                    LiangBi: 120,
                    NeiPan: 15940076336,
                    WaiPan: 13288219820
                }
            }
        ]
    }
}
```
## 授权认证

### 获取授权令牌

**URL**

/token/access

**描述**

传入预先分配的appid和secret key，获取授权令牌。
通过授权令牌访问大智慧云平台服务资源。

**访问授权须通过HTTPS方式授权。**

**参数说明**

|名称|类型|说明|缺省|
|----:|----|----|:----:|
|appid|字符串|应用ID，必填，预先分配值|无|
|secret_key|字符串|应用安全码,必填|无|
|deviceid|字符串|设备ID，选填|无|

**结果说明**

```json
{
    "Id": 44,
    "RepDataToken": [{
        "result": 0,
        "token": "1a22fb65e84c42618fef68a8985cb457",
        "create_time": 1443576846,
        "duration": 86400,
        "appid": "5efa6dc3619a11e5a3490242ac1115f5"
    }]
}
```

**返回结果说明**

|名称|类型|说明|缺省|
|----:|:----|----|:----:|
|result|整型|返回结果:<br/>&nbsp;0 授权成功，<br/>-1 授权失败，<br/>-2 appid不存在，<br/>-3 appid授权数已满|0|
|token|字符串|授权令牌|无|
|create_time|长整型|授权令牌创建时间|无|
|duration|整型|授权令牌存续时间。<br/>令牌过期时间=创建时间+存续时间|无|
|appid|字符串|返回传入原值|无|

**示例**

[/token/access?appid=5efa6dc3619a11e5a3490242ac1115f5&secret_key=U0pmuLhJf6zK](http://10.15.144.101/token/access?appid=5efa6dc3619a11e5a3490242ac1115f5&secret_key=U0pmuLhJf6zK "授权地址")

-------------------------------------------------------------

### 刷新授权令牌

**URL**

/token/refresh

**描述**

刷新授权令牌，延长令牌过期时间

**参数说明**

|名称|类型|说明|缺省|
|----:|:----|----|:----:|
|access_token|字符串|授权令牌|无|
|duration|整型|存续时间:<br/>1. 当传入duration值时，按duration值刷新，duration是存续秒数，过期时间为当前时间加存续秒数<br/>2. 当未传入duration时，按最大存续秒数刷新。过期时间为当前时间加存续秒数|无|

**结果说明**

```json
{
    "Id": 44,
    "RepDataToken": [{
        "result": 0,
        "token": "1a22fb65e84c42618fef68a8985cb457",
        "refresh_time": 1443578582,
        "duration": 86400
    }]
}
```

**返回结果说明**

|名称|类型|说明|缺省|
|----:|:----|----|:----:|
|result|整型|返回结果:<br/>&nbsp;0 授权成功，<br/>-1 授权失败，<br/>-2 appid不存在|0|
|token|字符串|授权令牌|无|
|refresh_time|长整型|授权令牌刷新时间|无|
|duration|整型|授权令牌存续时间。<br/>令牌过期时间=刷新时间+存续时间|无|

**示例**

[/token/refresh?access_token=1a22fb65e84c42618fef68a8985cb457&duration=86400](http://10.15.144.101/token/refresh?access_token=1a22fb65e84c42618fef68a8985cb457&duration=86400 "刷新授权令牌")

# 服务列表

## 行情服务

### 动态行情

**URL**

qoute/dyna

**描述**

动态行情服务

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段过滤(见返回说明)|无|

**结果说明**

```json

{
    "Id": 20,
    "RepDataQuoteDynaSingle": [
        {
            "Obj": "SH601519",
            "Data": {
                "Id": 638231067,//说明
                "ShiJian": 369065887036,//时间
                "ZuiXinJia": 970,//最新价
                "KaiPanJia": 890,
                "ZuiGaoJia": 972,
                "ZuiDiJia": 868,
                "ZuoShou": 894,
                "JunJia": 909,
                "ZhangDie": 76,
                "ZhangFu": 850,
                "ZhenFu": 1163,
                "ChengJiaoLiang": 10520025720,
                "XianShou": 704460,
                "ChengJiaoE": 9579555514880,
                "ZongChengJiaoBiShu": 680146,
                "NeiPan": 4850371956,
                "WaiPan": 5671357700
            }
        }
    ]
}
```

**示例**

[/quote/dyna?obj=SH600000](http://10.15.144.101/quote/dyna?obj=SH600000)

### k线服务

**URL**

qoute/dyna

**描述**

动态行情服务

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段过滤(见返回说明)|无|

**结果说明**

```json

{
    "Id": 20,
    "RepDataQuoteDynaSingle": [
        {
            "Obj": "SH601519",
            "Data": {
                "Id": 638231067,//说明
                "ShiJian": 369065887036,//时间
                "ZuiXinJia": 970,//最新价
                "KaiPanJia": 890,
                "ZuiGaoJia": 972,
                "ZuiDiJia": 868,
                "ZuoShou": 894,
                "JunJia": 909,
                "ZhangDie": 76,
                "ZhangFu": 850,
                "ZhenFu": 1163,
                "ChengJiaoLiang": 10520025720,
                "XianShou": 704460,
                "ChengJiaoE": 9579555514880,
                "ZongChengJiaoBiShu": 680146,
                "NeiPan": 4850371956,
                "WaiPan": 5671357700
            }
        }
    ]
}
```

**示例**

[/quote/dyna?obj=SH600000](http://10.15.144.101/quote/dyna?obj=SH600000)

### 分笔行情
**URL**

qoute/dyna

**描述**

动态行情服务

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段过滤(见返回说明)|无|

**结果说明**

```json

{
    "Id": 20,
    "RepDataQuoteDynaSingle": [
        {
            "Obj": "SH601519",
            "Data": {
                "Id": 638231067,//说明
                "ShiJian": 369065887036,//时间
                "ZuiXinJia": 970,//最新价
                "KaiPanJia": 890,
                "ZuiGaoJia": 972,
                "ZuiDiJia": 868,
                "ZuoShou": 894,
                "JunJia": 909,
                "ZhangDie": 76,
                "ZhangFu": 850,
                "ZhenFu": 1163,
                "ChengJiaoLiang": 10520025720,
                "XianShou": 704460,
                "ChengJiaoE": 9579555514880,
                "ZongChengJiaoBiShu": 680146,
                "NeiPan": 4850371956,
                "WaiPan": 5671357700
            }
        }
    ]
}
```

**示例**

[/quote/dyna?obj=SH600000](http://10.15.144.101/quote/dyna?obj=SH600000)

## 消息服务

### 消息发送

**URL**

qoute/dyna

**描述**

动态行情服务

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段过滤(见返回说明)|无|

**结果说明**

```json

{
    "Id": 20,
    "RepDataQuoteDynaSingle": [
        {
            "Obj": "SH601519",
            "Data": {
                "Id": 638231067,//说明
                "ShiJian": 369065887036,//时间
                "ZuiXinJia": 970,//最新价
                "KaiPanJia": 890,
                "ZuiGaoJia": 972,
                "ZuiDiJia": 868,
                "ZuoShou": 894,
                "JunJia": 909,
                "ZhangDie": 76,
                "ZhangFu": 850,
                "ZhenFu": 1163,
                "ChengJiaoLiang": 10520025720,
                "XianShou": 704460,
                "ChengJiaoE": 9579555514880,
                "ZongChengJiaoBiShu": 680146,
                "NeiPan": 4850371956,
                "WaiPan": 5671357700
            }
        }
    ]
}
```

**示例**

[/quote/dyna?obj=SH600000](http://10.15.144.101/quote/dyna?obj=SH600000)

### 消息订阅

**URL**

qoute/dyna

**描述**

动态行情服务

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段过滤(见返回说明)|无|

**结果说明**

```json

{
    "Id": 20,
    "RepDataQuoteDynaSingle": [
        {
            "Obj": "SH601519",
            "Data": {
                "Id": 638231067,//说明
                "ShiJian": 369065887036,//时间
                "ZuiXinJia": 970,//最新价
                "KaiPanJia": 890,
                "ZuiGaoJia": 972,
                "ZuiDiJia": 868,
                "ZuoShou": 894,
                "JunJia": 909,
                "ZhangDie": 76,
                "ZhangFu": 850,
                "ZhenFu": 1163,
                "ChengJiaoLiang": 10520025720,
                "XianShou": 704460,
                "ChengJiaoE": 9579555514880,
                "ZongChengJiaoBiShu": 680146,
                "NeiPan": 4850371956,
                "WaiPan": 5671357700
            }
        }
    ]
}
```

**示例**

[/quote/dyna?obj=SH600000](http://10.15.144.101/quote/dyna?obj=SH600000)
