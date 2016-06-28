<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.gdut.drp.sysmgr.domain.*" %>   
<%@ page import="com.gdut.drp.sysmgr.manager.*" %> 
<%
 	//编码
  	request.setCharacterEncoding("GB18030");
  	//在url地址中添加了command参数！！！
  	String command = request.getParameter("command");
 //out.println("command=" + command);
 	String userId = "";
 	String userName = "";
 	String password = "";
 	String contactTel = "";
 	String email = "";

 	if ("add".equals(command)) {//这种写法可以防止空指针异常！！！
 		if (UserManager.getInstance().findUserById(
 				request.getParameter("userId")) == null) {
 			User user = new User();
 			user.setUserId(request.getParameter("userId"));
 			user.setUserName(request.getParameter("userName"));
 			user.setPassword(request.getParameter("password"));
 			user.setContactTel(request.getParameter("contactTel"));
 			user.setEmail(request.getParameter("email"));
 			user.setCreateDate(new Date());
 			
 			UserManager.getInstance().addUser(user);
 			out.println("添加成功！");
 		} else {
 		//将这些变量存一份
 			userId = request.getParameter("userId");
 			userName = request.getParameter("userName");
 			password = request.getParameter("password");
 			contactTel = request.getParameter("contactTel");
 			email = request.getParameter("email");
 			out.println("用户代码重复，代码=[" + request.getParameter("userId")
 					+ "]");
 		}
 	}
 %>    
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
		<title>添加用户</title>
		<link rel="stylesheet" href="../style/drp.css">
		<script src="../script/client_validate.js"></script>
		<script type="text/javascript">
	function goBack() {
		window.self.location="user_maint.jsp"
	}
	
	function addUser() {
		var userIdField = document.getElementById("userId");
		//用户代码不能为空
		if (trim(userIdField.value) == "") {
			alert("用户代码不能为空！");
			userIdField.focus();
			return;
		}
		
		//用户代码至少4个字符
		/*
		if (trim(userIdField.value).length < 4) {
			alert("用户代码至少4个字符！");
			userIdField.focus();
			return;
		}
		*/
		
		//第1个字符必须是字母
		/*
		if (!(trim(userIdField.value).charAt(0) >= 'a' && trim(userIdField.value).charAt(0) <='z')) {
			alert("用户代码首字符必须为字母！");
			userIdField.focus();
			return;
		}
		*/
		
		//使用正则表达式判断第1个字符必须是字母
		var re = new RegExp(/^[a-zA-Z]/);
		if (!re.test(trim(userIdField.value))) {
			alert("用户代码首字符必须为字母！");
			userIdField.focus();
			return;
		}

		//必须输入数字和字母，字符个数是4~6位
		re.compile(/^[a-zA-Z0-9]{4,6}$/);
		if (!re.test(trim(userIdField.value))) {
			alert("必须输入数字和字母，字符个数是4~6位！");
			userIdField.focus();
			return;
		}
		
		//用户名称不能为空
		var userNameField = document.getElementById("userName");
		if (trim(userNameField.value).length == 0) {
			alert("用户名称不能为空！");
			userNameField.focus();
			return;
		}
		
		//密码至少6位！
		var passwordField = document.getElementById("password");
		if (trim(passwordField.value).length < 6) {
			alert("密码至少6位！");
			passwordField.focus();
			return;
		} 
		
		//如果电话号码输入了判断，电话号码必须为数值
		/*
		var contactTelField = document.getElementById("contactTel");
		if (trim(contactTelField.value).length != 0) {
			var contactTelValue = trim(contactTelField.value);
			for (var i=0; i<contactTelValue.length; i++) {
				if (!(contactTelValue.charAt(i) >='0' && contactTelValue.charAt(i) <=9)) {
					alert("电话号码必须是数字！");
					contactTelField.focus();
					return;
				}
			}
			
		}
		*/
		//采用正则表达式判断电话号码必须为数值（作业）
		var contactTelField = document.getElementById("contactTel");
		if (trim(contactTelField.value).length != 0) {
			re.compile(/\d/);
			if (!re.test(contactTelField.value)) {
					alert("电话号码必须是数字！");
					contactTelField.focus();
					return;
			}
		}
		
		//如果email了进行判断，判断规则是只要包含@即可(作业)
		var emailField = document.getElementById("email");
		if (trim(emailField.value) != "") {
			if (emailField.value.search("@") == -1) {
				alert("email格式不正确！");
				emailField.focus();
				return;
			}
		}
		
		//取得form对象提交表单
		/*
		document.getElementById("userForm").method="post";
		document.getElementById("userForm").action="user_add.jsp";
		document.getElementById("userForm").submit();
		*/
		
		//等同与上面的写法
		with(document.getElementById("userForm")) {
			method="post";
			action="user_add.jsp?command=add";
			submit();
		}
		
	}
	
	document.onkeydown =function() {
		if (event.keyCode == 13 && event.srcElement.type != 'button') {
			//赋值为tab键值
			event.keyCode = 9;
		}
	}
	
	function userIdOnKeyPress() {
		if (!(event.keyCode >=48 && event.keyCode <=57) && !(event.keyCode >=97 && event.keyCode <=122)) {
			event.keyCode = 0;
		}  
	}
	
	function init() {
		document.getElementById("userId").focus();
	}	
	
	//多个xmlHttp对象时，可以使用jquery解决
	var xmlHttp;
	function createXMLHttpRequest(){
	//表示当前浏览器不是ie，如firefox
		if(window.XMLHttpRequest){
			xmlHttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	
	function validate(field){
		//alert((field.value).length);
		if(trim(field.value).length != 0){
			//创建XMLHttpRequest
			createXMLHttpRequest();
			var url = "user_validate.jsp?userId=" + trim(field.value) + "&timestamp=" + new Date().getTime();
			//alert(url);
			//请求的url-->jsp，让它去处理
			xmlHttp.open("GET", url, true);
			//方法地址，处理完成后自动调用，回调！
				//匿名函数的好处，不用再命名一个函数！！
			xmlHttp.onreadystatechange = function() {
						if (xmlHttp.readyState == 4) {//ajax引擎初始化成功
							if (xmlHttp.status == 200) {//http协议成功
								//alert(xmlHttp.responseText);
								document.getElementById("userIdSpan").innerHTML = "<font color='red'>"
										+ xmlHttp.responseText + "</font>"
							} else {
								alert("请求失败，错误码=" + xmlHttp.status);
							}
						}
					};
			//将参数发送到Ajax引擎，而没有真正的执行；
			xmlHttp.send(null);
		} else {
			document.getElementById("userIdSpan").innerHTML = "";
		}
	}
		</script>
	</head>

	<body class="body1" onload="init()">
		<form name="userForm" target="_self" id="userForm">
			<div align="center">
				<table width="95%" border="0" cellspacing="2" cellpadding="2">
					<tr>
						<td>&nbsp;
							
						</td>
					</tr>
				</table>
				<table width="95%" border="0" cellspacing="0" cellpadding="0"
					height="25">
					<tr>
						<td width="522" class="p1" height="25" nowrap>
							<img src="../images/mark_arrow_03.gif" width="14" height="14">
							&nbsp;
							<b>系统管理&gt;&gt;用户维护&gt;&gt;添加</b>
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<table width="95%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="22%" height="29">
							<div align="right">
								<font color="#FF0000">*</font>用户代码:&nbsp;
							</div>
						</td>
						<td width="78%">
							<input name="userId" type="text" class="text1" id="userId"
								size="10" maxlength="10" onkeypress="userIdOnKeyPress()" value="<%=userId %>" onblur="validate(this)">
								<!-- this 指的就是当前的dom对象 -->
								<span id="userIdSpan"></span>
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								<font color="#FF0000">*</font>用户名称:&nbsp;
							</div>
						</td>
						<td>
							<input name="userName" type="text" class="text1" id="userName"
								size="20" maxlength="20" value="<%=userName %>">
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								<font color="#FF0000">*</font>密码:&nbsp;
							</div>
						</td>
						<td>
							<label>
								<input name="password" type="password" class="text1"
									id="password" size="20" maxlength="20" value="<%=password %>">
							</label>
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								联系电话:&nbsp;
							</div>
						</td>
						<td>
							<input name="contactTel" type="text" class="text1"
								id="contactTel" size="20" maxlength="20" value="<%=contactTel %>">
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								email:&nbsp;
							</div>
						</td>
						<td>
							<input name="email" type="text" class="text1" id="email"
								size="20" maxlength="20" value="<%=email %>">
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<div align="center">
					<input name="btnAdd" class="button1" type="button" id="btnAdd"
						value="添加" onClick="addUser()">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input name="btnBack" class="button1" type="button" id="btnBack"
						value="返回" onClick="goBack()" />
				</div>
			</div>
		</form>
	</body>
</html>
