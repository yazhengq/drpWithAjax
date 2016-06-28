
//XMLHttpRequest对象(全局对象)
var xmlHttp;

/**
 * 初始化XMLHttpRequest对象
 * @return
 */
function initXmlHttp(){
	if(xmlHttp != null)
		return;	
	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {	//IE6及其以下的IE版本
		var activeXNames = ["MSXML2.XMLHTTP", "Microsoft.XMLHTTP"];
		for(var i = 0 ; i < activeXName.length ; i ++ ) {
			try {
				xmlHttp = new ActiveXObject(activeXNames[i]);
				break;
			} catch (e) {
			}
		}
	}
	if(! xmlHttp) {
		alert("无法获取XMLHttpRequest, 你的浏览器可能不支持Ajax。");
	}
}

/**
 * Get方式向服务器端异步发送数据
 * @param url 服务器端的路径,数据发送的目的地
 * @param data 发送的数据,格式如: "key1=value1&key2=value2"
 * @param callback 回调函数，
 */
function doGet(url, data, callback) {
	var url = url;
	if(url.indexOf("?") == -1) {
		url = url + "?" + data;
	} else {
		url = url + "&" + data;
	}
	initXmlHttp();
	xmlHttp.onreadystatechange = callback;	//注册回调函数
	xmlHttp.open("GET", url, true);		//设置连接信息
	xmlHttp.send(null);
}

/**
 * Post方式向服务器端异步发送数据
 * @param url 服务器端的路径,数据发送的目的地
 * @param data 发送的数据,格式如: "key1=value1&key2=value2"
 * @param callback 回调函数
 * @return
 */
function doPost(url, data, callback) {
	initXmlHttp();		//初始化
	xmlHttp.onreadystatechange = callback;	//注册回调函数
	xmlHttp.open("POST", url, true);
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlHttp.send(data);
}

/**
 * 默认回调函数
 * 只在测试时使用，在doGet和doPost函数中的第三个参数callback，可由用户自定义回调函数，
 */
function callback() {
	//判断对象的状态是否交互完成
	if(xmlHttp.readyState == 4) {
		//判断http的交互是否成功
		if(xmlHttp.status == 200) {
			//获取服务器返回的纯文本数据
			var responseText = xmlHttp.responseText;
			//获取服务器返回的XML格式数据
			//var responseXml = xmlHttp.responseXML;
			//Alert从服务器端返回的信息
			window.alert(responseText);
		}
	}
}

/**
 * 解析表单的数据,转成ParamMap的形式
 * @param 任意个参数,代表表单子元素的name值
 * @return ParamMap结果集
 */
function parseForm2ParamMap() {
	var map = new ParamMap();
	var length = arguments.length;
	for(var i = 0 ; i < length ; i ++ ) {
		var nodeList = document.getElementsByName(arguments[i]);
		var values = nodeList2ValuesArray(nodeList);
		for(var j = 0 ; j < values.length ; j ++ ) {
			map.put(arguments[i], values[j]);
		}
	}
	return map;
}

/**
 * 获取nodeList的值集
 * @param nodeList Node数组，可通过getElementsByName或者getElementsByTagName等方法获得
 * @return 值数组
 */
function nodeList2ValuesArray(nodeList) {
	//结果值数组，形如：['aaa','bbb','ccc']
	var values = new Array();
	var length = nodeList.length;
	var nodeName = nodeList.item(0).nodeName;
	//对"<input type='xxx'/>"的处理
	if(nodeName == "INPUT") {
		var type = nodeList.item(0).getAttribute("type");
		if(type == "text" || type == "password" || type == "hidden") {
			for(var i = 0 ; i < length ; i ++ ) {
				values.push(nodeList.item(i).value);
			}
		}
		else if(type == "checkbox" || type == "radio") {
			for(var i = 0 ; i < length ; i ++ ) {
				var node = nodeList.item(i);
				if(node.checked) {
					values.push(node.value);
				}
			}
		}
	}
	//对"<textarea>xxx</textarea>"的处理
	else if(nodeName == "TEXTAREA") {
		for(var i = 0 ; i < length ; i ++ ) {
			values.push(nodeList.item(i).value);
		}
	}
	//对"<select></select>"的处理
	else if (nodeName == "SELECT") {
		var subNodeList = nodeList.item(0).getElementsByTagName("option");
		return nodeList2ValuesArray(subNodeList);
	}
	//对<select>的子元素"<option>xxx<option>"的处理
	else if (nodeName == "OPTION") {
		for(var i = 0 ; i < length ; i ++ ) {
			var node = nodeList.item(i);
			if(node.selected){
				values.push(node.value);
			}
		}
	}
	
	
	return values;
}

/**
 * ParamMap类，用于存储HTTP请求中的Get方法或者Post方法所传递的参数
 * 继承于Map类，但改写一些方法，以适合HTTP请求中的参数格式
 * 与Map不同之处有：ParamMap允许多个同名的"key"存在，
 * toString方法返回的"key=value"对以"&"号连接，而不是","号，等等。
 */
function ParamMap() {
	
	//继承Map类
	Map.call(this);
	
	//重写put方法，允许多个同名key存在
	this.put = function(key, value){
		if(key == null || key == undefined) 
			return;
		this.keys.push(key);
		this.values.push(value);
	};
	
	//重写get方法，返回values数组
	this.get = function(key) {
		var results = new Array();
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key)
				results.push(this.values[i]);
		}
		return results;
	};
	
	//重写remove方法
	this.remove = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				while(i < length - 1) {
					this.keys[i] = this.keys[i+1];
					this.values[i] = this.values[i+1];
					i ++ ;
				}
				//处理最后一个元素
				this.keys.pop();
				this.values.pop();
			}
		}
	};
	
	//重写toString方法, 转成XMLHttpRequest.send(ajaxString)方法的参数格式的字符串，
	//形如：key1=value1&key2=value2
	this.toString = function() {
		var length = this.size();
		var str = "";
		for(var i = 0 ; i < length ; i ++ ) {
			str = str + this.keys[i] + "=" + this.values[i];
			if(i != length-1)
				str += "&";
		}
		return str;
	};
}

/**
 * Map类
 * 实现了类似于Java语言中的Map接口的常用方法
 */
function Map(){
	
	//key集
	this.keys = new Array();
	
	//value集
	this.values = new Array();	
	
	//添加key-value进Map
	this.put = function(key, value){
		if(key == null || key == undefined)
			return;
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			//如果keys数组中有相同的记录，则不保存重复记录
			if(this.keys[i] == key)
				return;
		}
		this.keys.push(key);
		this.values.push(value);
	};
	
	//获取指定key的value
	this.get = function(key){
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				return this.values[i];
			} else {
				continue;
			}
			return null;
		}
	};

	//移除指定key所对应的map
	this.remove = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				while(i < length - 1) {
					this.keys[i] = this.keys[i+1];
					this.values[i] = this.values[i+1];
					i ++ ;
				}
				//处理最后一个元素
				this.keys.pop();
				this.values.pop();
				break;
			}
		}
	};
	
	//是否包含指定的key
	this.containsKey = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				return true;
			}
		}
		return false;
	};
	
	//是否包含指定的value
	this.containsValue = function(value) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.values[i] == value) {
				return true;
			}
		}
		return false;
	};
	
	//包含记录总数
	this.size = function() {
		return this.keys.length;
	};
	
	//是否为空
	this.isEmpty = function() {
		return this.size() == 0 ? true : false;
	};
	
	//清空Map
	this.clear = function() {
		this.keys = new Array();
		this.values = new Array();
	};
	
	//将map转成字符串，格式：key1=value1,key2=value2
	this.toString = function() {
		var length = this.size();
		var str = "";
		for(var i = 0 ; i < length ; i ++ ) {
			str = str + this.keys[i] + "=" + this.values[i];
			if(i != length-1)
				str += ",";
		}
		return str;
	};
}





