 	
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
                }
            ]
	   	}
	]
}
```

**示例**

[/f10/forex/shiborlv?obj=LISH1MABC]($APIHOST$/f10/forex/shiborlv?obj=LISH1MABC)
获取LISH1MABC的SHIBOR利率
