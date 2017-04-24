
### 本期重大卖出股票_QDII

**URL**

/f10/fund/gpmx/bqzdmcgp_qdii

**描述**

股票明细_本期重大卖出股票_QDII

**参数说明**

|名称|类型|说明|缺省|
| -------- | -------- | -------- | -------- |
|obj\*|字符串|查询股票\*表示必填，必填的字段说明放在前面。如SH600000|无|
|field|字符串|字段以逗号间隔，为空则返回结构所有字段,关注字段以逗号分隔(见返回说明)|无|
|start|整型|行筛选，表示从以上步骤产生的数据的第几行开始往后筛选|无|
|count|整型|行筛选，大于等于0的整数，表示从start的位置往后筛选多少行数据（包括start），0或者空表示之后的所有行|无|


**结果说明**

```json
{
     "Id": 194,
        "RepDataF10FundGpmxBqzdmcgpOutput": [
            {
                "Obj": "OF000041",
                "Data": [
                    {
                        "jzrq": "2007-12-31",
                        "data": [
                            {
                                "gpdm": " 0005  ",		//股票代码	varchar(10)
                                "gpjc": " 汇丰控股 ",	//股票简称	varchar(10)
                                "ljmcjz": 288583967.3,	//累计卖出价值	numeric(19,2) 
                                "zjzbl": 1.08 			//占期初基金资金净值比例	numeric(19,2)
                            }
						]
					}	
				]
			}
   	 	]
}
```

**示例**

[/f10/fund/gpmx/bqzdmcgp_qdii?obj=OF000041]($APIHOST$/f10/fund/gpmx/bqzdmcgp_qdii?obj=OF000041)
获取OF000041的股票明细_本期重大卖出股票_QDII  
