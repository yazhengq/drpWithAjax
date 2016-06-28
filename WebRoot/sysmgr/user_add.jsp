<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030" %>
<%@ page import="java.util.*" %>    
<%@ page import="com.gdut.drp.sysmgr.domain.*" %>   
<%@ page import="com.gdut.drp.sysmgr.manager.*" %> 
<%
 	//����
  	request.setCharacterEncoding("GB18030");
  	//��url��ַ�������command����������
  	String command = request.getParameter("command");
 //out.println("command=" + command);
 	String userId = "";
 	String userName = "";
 	String password = "";
 	String contactTel = "";
 	String email = "";

 	if ("add".equals(command)) {//����д�����Է�ֹ��ָ���쳣������
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
 			out.println("��ӳɹ���");
 		} else {
 		//����Щ������һ��
 			userId = request.getParameter("userId");
 			userName = request.getParameter("userName");
 			password = request.getParameter("password");
 			contactTel = request.getParameter("contactTel");
 			email = request.getParameter("email");
 			out.println("�û������ظ�������=[" + request.getParameter("userId")
 					+ "]");
 		}
 	}
 %>    
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
		<title>����û�</title>
		<link rel="stylesheet" href="../style/drp.css">
		<script src="../script/client_validate.js"></script>
		<script type="text/javascript">
	function goBack() {
		window.self.location="user_maint.jsp"
	}
	
	function addUser() {
		var userIdField = document.getElementById("userId");
		//�û����벻��Ϊ��
		if (trim(userIdField.value) == "") {
			alert("�û����벻��Ϊ�գ�");
			userIdField.focus();
			return;
		}
		
		//�û���������4���ַ�
		/*
		if (trim(userIdField.value).length < 4) {
			alert("�û���������4���ַ���");
			userIdField.focus();
			return;
		}
		*/
		
		//��1���ַ���������ĸ
		/*
		if (!(trim(userIdField.value).charAt(0) >= 'a' && trim(userIdField.value).charAt(0) <='z')) {
			alert("�û��������ַ�����Ϊ��ĸ��");
			userIdField.focus();
			return;
		}
		*/
		
		//ʹ��������ʽ�жϵ�1���ַ���������ĸ
		var re = new RegExp(/^[a-zA-Z]/);
		if (!re.test(trim(userIdField.value))) {
			alert("�û��������ַ�����Ϊ��ĸ��");
			userIdField.focus();
			return;
		}

		//�����������ֺ���ĸ���ַ�������4~6λ
		re.compile(/^[a-zA-Z0-9]{4,6}$/);
		if (!re.test(trim(userIdField.value))) {
			alert("�����������ֺ���ĸ���ַ�������4~6λ��");
			userIdField.focus();
			return;
		}
		
		//�û����Ʋ���Ϊ��
		var userNameField = document.getElementById("userName");
		if (trim(userNameField.value).length == 0) {
			alert("�û����Ʋ���Ϊ�գ�");
			userNameField.focus();
			return;
		}
		
		//��������6λ��
		var passwordField = document.getElementById("password");
		if (trim(passwordField.value).length < 6) {
			alert("��������6λ��");
			passwordField.focus();
			return;
		} 
		
		//����绰�����������жϣ��绰�������Ϊ��ֵ
		/*
		var contactTelField = document.getElementById("contactTel");
		if (trim(contactTelField.value).length != 0) {
			var contactTelValue = trim(contactTelField.value);
			for (var i=0; i<contactTelValue.length; i++) {
				if (!(contactTelValue.charAt(i) >='0' && contactTelValue.charAt(i) <=9)) {
					alert("�绰������������֣�");
					contactTelField.focus();
					return;
				}
			}
			
		}
		*/
		//����������ʽ�жϵ绰�������Ϊ��ֵ����ҵ��
		var contactTelField = document.getElementById("contactTel");
		if (trim(contactTelField.value).length != 0) {
			re.compile(/\d/);
			if (!re.test(contactTelField.value)) {
					alert("�绰������������֣�");
					contactTelField.focus();
					return;
			}
		}
		
		//���email�˽����жϣ��жϹ�����ֻҪ����@����(��ҵ)
		var emailField = document.getElementById("email");
		if (trim(emailField.value) != "") {
			if (emailField.value.search("@") == -1) {
				alert("email��ʽ����ȷ��");
				emailField.focus();
				return;
			}
		}
		
		//ȡ��form�����ύ��
		/*
		document.getElementById("userForm").method="post";
		document.getElementById("userForm").action="user_add.jsp";
		document.getElementById("userForm").submit();
		*/
		
		//��ͬ�������д��
		with(document.getElementById("userForm")) {
			method="post";
			action="user_add.jsp?command=add";
			submit();
		}
		
	}
	
	document.onkeydown =function() {
		if (event.keyCode == 13 && event.srcElement.type != 'button') {
			//��ֵΪtab��ֵ
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
	
	//���xmlHttp����ʱ������ʹ��jquery���
	var xmlHttp;
	function createXMLHttpRequest(){
	//��ʾ��ǰ���������ie����firefox
		if(window.XMLHttpRequest){
			xmlHttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	
	function validate(field){
		//alert((field.value).length);
		if(trim(field.value).length != 0){
			//����XMLHttpRequest
			createXMLHttpRequest();
			var url = "user_validate.jsp?userId=" + trim(field.value) + "&timestamp=" + new Date().getTime();
			//alert(url);
			//�����url-->jsp������ȥ����
			xmlHttp.open("GET", url, true);
			//������ַ��������ɺ��Զ����ã��ص���
				//���������ĺô�������������һ����������
			xmlHttp.onreadystatechange = function() {
						if (xmlHttp.readyState == 4) {//ajax�����ʼ���ɹ�
							if (xmlHttp.status == 200) {//httpЭ��ɹ�
								//alert(xmlHttp.responseText);
								document.getElementById("userIdSpan").innerHTML = "<font color='red'>"
										+ xmlHttp.responseText + "</font>"
							} else {
								alert("����ʧ�ܣ�������=" + xmlHttp.status);
							}
						}
					};
			//���������͵�Ajax���棬��û��������ִ�У�
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
							<b>ϵͳ����&gt;&gt;�û�ά��&gt;&gt;���</b>
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<table width="95%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="22%" height="29">
							<div align="right">
								<font color="#FF0000">*</font>�û�����:&nbsp;
							</div>
						</td>
						<td width="78%">
							<input name="userId" type="text" class="text1" id="userId"
								size="10" maxlength="10" onkeypress="userIdOnKeyPress()" value="<%=userId %>" onblur="validate(this)">
								<!-- this ָ�ľ��ǵ�ǰ��dom���� -->
								<span id="userIdSpan"></span>
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								<font color="#FF0000">*</font>�û�����:&nbsp;
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
								<font color="#FF0000">*</font>����:&nbsp;
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
								��ϵ�绰:&nbsp;
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
						value="���" onClick="addUser()">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input name="btnBack" class="button1" type="button" id="btnBack"
						value="����" onClick="goBack()" />
				</div>
			</div>
		</form>
	</body>
</html>
