 	
## SHIBOR利率

**URL**

/f10/forex/shiborlv

**描述**

SHIBOR利率

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|zhdm\*|字符串|外汇组合代码\*表示必填，必填的字段说明放在前面。如IBAUD18MS|无|
|field|字符串|字段以逗号间隔，为空则返回结构所有字段,关注字段以逗号分隔(见返回说明)|无|


**结果说明**

```json

{
	"Id": 244,
    "RepDataF10ForexShiborlvOutput": [
        {
            "zhdm": "LISH1MABC",			// 组合代码  varchar(25)
            "Data": [
                {
                    "rn": 1,				// 排序  int               
                    "zdzwmc": "代码",       // 字段中文名称  nvarchar(250) 
                    "zdz": "SH1MABC.ABC",   // 字段值  nvarchar(-1)     
                    "stype": 104008         // 证券类型  int             
                },
                {
                    "rn": 2,								// 排序  int               
                    "zdzwmc": "名称",                       // 字段中文名称  nvarchar(250) 
                    "zdz": "SHIBOR利率报价1月-农业银行",    // 字段值  nvarchar(-1)     
                    "stype": 104008                         // 证券类型  int             
                },
                {
                    "rn": 3,			// 排序  int               
                    "zdzwmc": "期限",   // 字段中文名称  nvarchar(250) 
                    "zdz": "1M",        // 字段值  nvarchar(-1)     
                    "stype": 104008     // 证券类型  int             
                },
                {
                    "rn": 4,				// 排序  int               
                    "zdzwmc": "来源",       // 字段中文名称  nvarchar(250) 
                    "zdz": "中国农业银行",  // 字段值  nvarchar(-1)     
                    "stype": 104008         // 证券类型  int             
                },
                {	
                    "rn": 5,                // 排序  int               
                    "zdzwmc": "公布时间",   // 字段中文名称  nvarchar(250) 
                    "zdz": "11:30",         // 字段值  nvarchar(-1)     
                    "stype": 104008         // 证券类型  int             
                },
                {
                    "rn": 6,				// 排序  int               
                    "zdzwmc": "交易模式",   // 字段中文名称  nvarchar(250) 
                    "zdz": "报价",          // 字段值  nvarchar(-1)     
                    "stype": 104008         // 证券类型  int             
                },
                {
                    "rn": 7,                	// 排序  int               
                    "zdzwmc": "利率简介",       // 字段中文名称  nvarchar(250) 
                    "zdz": "上海银行间同业拆放利率（ShanghaiInterbank Offered Rate，简称Shibor），以位于上海的全国银行间同业拆借中心为技术平台计算、发布并命名，是由信用等级较高的银行组成报价团自主报出的人民币同业拆出利率计算确定的算术平均利率，是单利、无担保、批发性利率。银行间同业拆借中心受权Shibor的报价计算和信息发布。每个交易日根据各报价行的报价，剔除最高、最低各2家报价，对其余报价进行算术平均计算后，得出每一期限品种的Shibor，并于11:30对外发布。",   // 字段值  nvarchar(-1)      
                    "stype": 104008             // 证券类型  int             
                }
            ]
	   	}
	]
}
```

**示例**

[http://10.15.208.66/f10/forex/shiborlv?obj=LISH1MABC]
获取LISH1MABC的SHIBOR利率
