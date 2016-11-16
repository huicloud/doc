## 访问令牌生成方式

###描述

生成云平台的访问令牌 token

###参数说明

|名称|类型|说明|
| -------- | -------- | -------- |
|appid|字符串|预先向第三方应用分配的appid,32个字符|
|secret_key|字符串|预先向第三方应用分配的secret key,16个字符|
|short_id|字符串|预先向第三方应用分配的short id,8个字符
|expired_time|字符串|过期时间,int64转换过后的值,标准unix时间戳 单位（秒）,不建议设置过长，防止被盗链

###token生成算法

token的生成算法为 对 appid,expired_time,secret_key 的组合字符串使用secret_key进行 HMAC-SHA1 加密算法生成mask掩码，再使用appid的short_id,过期时间,加密掩码进行组合生成token:short_id:expired_time:mask

###算法示例

**1. 组合appid、expired_time、secret_key**

    appid = "173a9608f2d411e4936600ffa64984b5"
    expired_time = "1452663274"
    secret_key = "aOahcMWCoX6I"
    rawMask = appid + "_" + expired_time + "_" + secret_key

**2. 用secret_key对rawMask进行HMAC-SHA1加密**

    mask = hmac_sha1(rawMask, secret_key)
	
**3. 对mask进行16进制转换**

    hex_mask = hex.encode(mask)

**4. 组合short_id、expired_time、hex_mask生成token**

    short_id = "00000001"
    token = short_id + ":" + expired_time + ":" + hex_mask

**5. 生成结果**

    00000001:1452663274:1ad06631188024c9e2be9af41bf9474517b33ee3