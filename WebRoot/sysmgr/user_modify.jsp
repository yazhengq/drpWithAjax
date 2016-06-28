<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.gdut.drp.sysmgr.manager.UserManager"%>
<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030" %>
<%@ page import="java.util.*"%>
<%@ page import="com.gdut.drp.sysmgr.domain.*,com.gdut.drp.util.*" %> 

<%
	String command = request.getParameter("command");
	if("modify".equals(command)){
		User user = new User();
		user.setUserId(request.getParameter("userId"));
		user.setUserName(request.getParameter("userName"));
		user.setPassword(request.getParameter("password"));
		user.setContactTel(request.getParameter("contactTel"));
		user.setEmail(request.getParameter("email"));
		
		UserManager.getInstance().modifyUser(user);
		out.print("修改成功！");
	}
	String userId = request.getParameter("userId");
	User user = UserManager.getInstance().findUserById(userId);
	if(user != null){
 %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
		<title>修改用户</title>
		<link rel="stylesheet" href="../style/drp.css">
		<script src="../script/client_validate.js"></script>
		<script type="text/javascript">
	function goBack() {
		window.self.location ="user_maint.html"
	}
	
	var modifyXMLHttp;
	function createXMLHttpRequest(){
	//表示当前浏览器不是ie，如firefox
		if(window.XMLHttpRequest){
			modifyXMLHttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			modifyXMLHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	
	function modifyUser() {
		with(document.getElementById("userForm")){
			action = "user_modify.jsp";
			method = "post";
			submit();
		}
	}
	
	function init(){
		document.getElementById("userName").focus();
	}
	
</script>

	</head>

	<body class="body1" onload="init()">
		<form name="userForm" id="userForm">
			<input type="hidden" name="command" value="modify">
			<!-- 隐含域 标识点了修改按钮-->
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
							<b>系统管理&gt;&gt;用户维护&gt;&gt;修改</b>
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<table width="95%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="22%" height="29">
							<div align="right">
								用户代码:&nbsp;
							</div>
						</td>
						<td width="78%">
							<input name="userId" type="text" class="text1" id="userId"
								size="10" maxlength="10" readonly="true" value="<%= user.getUserId() %>">
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
								size="20" maxlength="20" value="<%= user.getUserName() %>">
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
									id="password" size="20" maxlength="20" value="<%=user.getPassword() %>">
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
								id="contactTel" size="20" maxlength="20" value="<%=user.getContactTel() %>">
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
								size="20" maxlength="20" value="<%=user.getEmail() %>">
						</td>
					</tr>
				</table>
				
				<%
					}
				 %>
				
				<hr width="97%" align="center" size=0>
				<div align="center">
					<input name="btnModify" class="button1" type="button"
						id="btnModify" value="修改" onClick="modifyUser()">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input name="btnBack" class="button1" type="button" id="btnBack"
						value="返回" onClick="goBack()" />
				</div>
			</div>
		</form>
	</body>
</html>
