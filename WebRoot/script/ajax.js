
//XMLHttpRequest����(ȫ�ֶ���)
var xmlHttp;

/**
 * ��ʼ��XMLHttpRequest����
 * @return
 */
function initXmlHttp(){
	if(xmlHttp != null)
		return;	
	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {	//IE6�������µ�IE�汾
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
		alert("�޷���ȡXMLHttpRequest, �����������ܲ�֧��Ajax��");
	}
}

/**
 * Get��ʽ����������첽��������
 * @param url �������˵�·��,���ݷ��͵�Ŀ�ĵ�
 * @param data ���͵�����,��ʽ��: "key1=value1&key2=value2"
 * @param callback �ص�������
 */
function doGet(url, data, callback) {
	var url = url;
	if(url.indexOf("?") == -1) {
		url = url + "?" + data;
	} else {
		url = url + "&" + data;
	}
	initXmlHttp();
	xmlHttp.onreadystatechange = callback;	//ע��ص�����
	xmlHttp.open("GET", url, true);		//����������Ϣ
	xmlHttp.send(null);
}

/**
 * Post��ʽ����������첽��������
 * @param url �������˵�·��,���ݷ��͵�Ŀ�ĵ�
 * @param data ���͵�����,��ʽ��: "key1=value1&key2=value2"
 * @param callback �ص�����
 * @return
 */
function doPost(url, data, callback) {
	initXmlHttp();		//��ʼ��
	xmlHttp.onreadystatechange = callback;	//ע��ص�����
	xmlHttp.open("POST", url, true);
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlHttp.send(data);
}

/**
 * Ĭ�ϻص�����
 * ֻ�ڲ���ʱʹ�ã���doGet��doPost�����еĵ���������callback�������û��Զ���ص�������
 */
function callback() {
	//�ж϶����״̬�Ƿ񽻻����
	if(xmlHttp.readyState == 4) {
		//�ж�http�Ľ����Ƿ�ɹ�
		if(xmlHttp.status == 200) {
			//��ȡ���������صĴ��ı�����
			var responseText = xmlHttp.responseText;
			//��ȡ���������ص�XML��ʽ����
			//var responseXml = xmlHttp.responseXML;
			//Alert�ӷ������˷��ص���Ϣ
			window.alert(responseText);
		}
	}
}

/**
 * ������������,ת��ParamMap����ʽ
 * @param ���������,�������Ԫ�ص�nameֵ
 * @return ParamMap�����
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
 * ��ȡnodeList��ֵ��
 * @param nodeList Node���飬��ͨ��getElementsByName����getElementsByTagName�ȷ������
 * @return ֵ����
 */
function nodeList2ValuesArray(nodeList) {
	//���ֵ���飬���磺['aaa','bbb','ccc']
	var values = new Array();
	var length = nodeList.length;
	var nodeName = nodeList.item(0).nodeName;
	//��"<input type='xxx'/>"�Ĵ���
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
	//��"<textarea>xxx</textarea>"�Ĵ���
	else if(nodeName == "TEXTAREA") {
		for(var i = 0 ; i < length ; i ++ ) {
			values.push(nodeList.item(i).value);
		}
	}
	//��"<select></select>"�Ĵ���
	else if (nodeName == "SELECT") {
		var subNodeList = nodeList.item(0).getElementsByTagName("option");
		return nodeList2ValuesArray(subNodeList);
	}
	//��<select>����Ԫ��"<option>xxx<option>"�Ĵ���
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
 * ParamMap�࣬���ڴ洢HTTP�����е�Get��������Post���������ݵĲ���
 * �̳���Map�࣬����дһЩ���������ʺ�HTTP�����еĲ�����ʽ
 * ��Map��֮ͬ���У�ParamMap������ͬ����"key"���ڣ�
 * toString�������ص�"key=value"����"&"�����ӣ�������","�ţ��ȵȡ�
 */
function ParamMap() {
	
	//�̳�Map��
	Map.call(this);
	
	//��дput������������ͬ��key����
	this.put = function(key, value){
		if(key == null || key == undefined) 
			return;
		this.keys.push(key);
		this.values.push(value);
	};
	
	//��дget����������values����
	this.get = function(key) {
		var results = new Array();
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key)
				results.push(this.values[i]);
		}
		return results;
	};
	
	//��дremove����
	this.remove = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				while(i < length - 1) {
					this.keys[i] = this.keys[i+1];
					this.values[i] = this.values[i+1];
					i ++ ;
				}
				//�������һ��Ԫ��
				this.keys.pop();
				this.values.pop();
			}
		}
	};
	
	//��дtoString����, ת��XMLHttpRequest.send(ajaxString)�����Ĳ�����ʽ���ַ�����
	//���磺key1=value1&key2=value2
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
 * Map��
 * ʵ����������Java�����е�Map�ӿڵĳ��÷���
 */
function Map(){
	
	//key��
	this.keys = new Array();
	
	//value��
	this.values = new Array();	
	
	//���key-value��Map
	this.put = function(key, value){
		if(key == null || key == undefined)
			return;
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			//���keys����������ͬ�ļ�¼���򲻱����ظ���¼
			if(this.keys[i] == key)
				return;
		}
		this.keys.push(key);
		this.values.push(value);
	};
	
	//��ȡָ��key��value
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

	//�Ƴ�ָ��key����Ӧ��map
	this.remove = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				while(i < length - 1) {
					this.keys[i] = this.keys[i+1];
					this.values[i] = this.values[i+1];
					i ++ ;
				}
				//�������һ��Ԫ��
				this.keys.pop();
				this.values.pop();
				break;
			}
		}
	};
	
	//�Ƿ����ָ����key
	this.containsKey = function(key) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.keys[i] == key) {
				return true;
			}
		}
		return false;
	};
	
	//�Ƿ����ָ����value
	this.containsValue = function(value) {
		var length = this.size();
		for(var i = 0 ; i < length ; i ++ ) {
			if(this.values[i] == value) {
				return true;
			}
		}
		return false;
	};
	
	//������¼����
	this.size = function() {
		return this.keys.length;
	};
	
	//�Ƿ�Ϊ��
	this.isEmpty = function() {
		return this.size() == 0 ? true : false;
	};
	
	//���Map
	this.clear = function() {
		this.keys = new Array();
		this.values = new Array();
	};
	
	//��mapת���ַ�������ʽ��key1=value1,key2=value2
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





