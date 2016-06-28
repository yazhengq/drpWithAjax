<%@ page language="java" contentType="text/html; charset=GB18030"
	pageEncoding="GB18030"%>
<%@ page import="java.util.*" %>   
<%@ page import="com.gdut.drp.basedata.domain.*"%>
<%@ page import="com.gdut.drp.basedata.manager.*"%>
<%@ page import="com.gdut.drp.util.datadict.manager.*"%>
<%@ page import="com.gdut.drp.util.datadict.domain.*"%>
<%@ page import="com.gdut.drp.util.*"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	int pid = Integer.parseInt(request.getParameter("id"));
	
	String command = request.getParameter(Constants.command);
	if (Constants.ADD.equals(command)) {
		Client client = new Client();
		client.setPid(pid);
		client.setClientId(request.getParameter("clientId"));
		client.setName(request.getParameter("clientName"));
		ClientLevel cl = new ClientLevel();
		cl.setId(request.getParameter("clientLevel"));
		//建立与ClientLevel的关联
		client.setClientLevel(cl);
		
		client.setBankAcctNo(request.getParameter("bankAcctNo"));
		client.setContactTel(request.getParameter("contactTel"));
		client.setAddress(request.getParameter("address"));
		client.setZipCode(request.getParameter("zipCode"));
		client.setIsLeaf(Constants.YES);
		client.setIsClient(Constants.YES);
		ClientManager.getInstance().addRegionOrClient(client);
		out.println("添加成功！");
	}	
	List<ClientLevel> clientLevelList = DataDictManager.getInstance().getClientLevelList();
%>

<html>
	<head>
		<base href="<%=basePath %>">
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
		<title>添加分销商</title>
		<link rel="stylesheet" href="style/drp.css">
		<script src="script/client_validate.js"></script>
		<script type="text/javascript">
			function validateForm(form) {
				var msg = "";
				if (trim(form.clientId.value).length == 0) {
					msg+= "分销商代码不能为空！\n";
				}
				if (trim(document.getElementById("clientIdSpan").innerHTML) != "") {
					msg+="分销商代码已经存在！\n";
				}
				if (trim(form.clientName.value).length == 0) {
					msg+= "分销商名称不能为空！"; 
				}
				if (msg != "") {		
					alert(msg);
					return false;		
				}
				return true;
			}
			
			var xmlHttp;
			 
			function createXMLHttpRequest() {
				//表示当前浏览器不是ie,如ns,firefox
				if(window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
				} else if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
			}

			function validateClientId(field) {
				if (trim(field.value).length != 0) {
					//创建XMLHttpRequest
					createXMLHttpRequest();
					var url = "<%=basePath%>servlet/ClientIdValidateServlet?selectFlag=" + trim(field.value) + "&timestamp=" + new Date().getTime();
					xmlHttp.open("GET", url, true);
					//方法地址，处理完成后自动调用，回调
					xmlHttp.onreadystatechange=function() { //匿名函数
						if(xmlHttp.readyState == 4) { //Ajax引擎初始化成功
							if (xmlHttp.status == 200) { //http协议成功
								if (trim(xmlHttp.responseText) != "") {
									document.getElementById("clientIdSpan").innerHTML = "<font color='red'>" + xmlHttp.responseText + "</font>";
								}else {
									document.getElementById("clientIdSpan").innerHTML = "";
								}
							}else {
								alert("请求失败，错误码=" + xmlHttp.status);
							}
						}
					};
					//将参数发送到Ajax引擎
					xmlHttp.send(null);
				}else {
					document.getElementById("clientIdSpan").innerHTML = "";
				}
			}
		</script>
	</head>

	<body class="body1">
		<form name="form1" action="basedata/client_add.jsp" method="post" onsubmit="return validateForm(this)">
			<input type="hidden" name="id" value="<%=pid %>">
			<input type="hidden" name="<%=Constants.command %>" value="<%=Constants.ADD %>">
			<div align="center">
				<table width="95%" border="0" cellspacing="2" cellpadding="2">
					<tr>
						<td>
							&nbsp;
						</td>
					</tr>
				</table>
				<table width="95%" border="0" cellspacing="0" cellpadding="0"
					height="8">
					<tr>
						<td width="522" class="p1" height="2" nowrap>
							<img src="images/mark_arrow_03.gif" width="14" height="14">
							&nbsp;
							<b>基础数据管理&gt;&gt;分销商维护&gt;&gt;添加分销商</b>
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<table width="95%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="22%" height="29">
							<div align="right">
								<font color="#FF0000">*</font>分销商代码:&nbsp;
							</div>
						</td>
						<td width="78%">
							<input name="clientId" type="text" class="text1" id="clientId"
								size="10" maxlength="10" onblur="validateClientId(this)"><span id="clientIdSpan"></span>
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								<font color="#FF0000">*</font>分销商名称:&nbsp;
							</div>
						</td>
						<td>
							<input name="clientName" type="text" class="text1"
								id="clientName" size="40" maxlength="40">
						</td>
					</tr>
					<tr>
						<td height="15">
							<div align="right">
								<font color="#FF0000">*</font>分销商类型:&nbsp;
							</div>
						</td>
						<td>
							<select name="clientLevel" class="select1" id="clientLevel">
							<%
								for (Iterator<ClientLevel> iter = clientLevelList.iterator(); iter.hasNext();) {
									ClientLevel cl = iter.next();
							%>
								<option value="<%=cl.getId() %>"><%=cl.getName() %></option>
							<%
								}
							%>							
							</select>
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								银行帐号:&nbsp;
							</div>
						</td>
						<td>
							<input name="bankAcctNo" type="text" class="text1"
								id="bankAcctNo" size="10" maxlength="10">
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
								id="contactTel" size="10" maxlength="10">
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								地址:&nbsp;
							</div>
						</td>
						<td>
							<input name="address" type="text" class="text1" id="address"
								size="10" maxlength="10">
						</td>
					</tr>
					<tr>
						<td height="26">
							<div align="right">
								邮编:&nbsp;
							</div>
						</td>
						<td>
							<input name="zipCode" type="text" class="text1" id="zipCode"
								size="10" maxlength="10">
						</td>
					</tr>
				</table>
				<hr width="97%" align="center" size=0>
				<div align="center">
					<input name="btnAdd" class="button1" type="submit" id="btnAdd"
						value="添加">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input name="btnBack" class="button1" type="button" id="btnBack"
						value="返回" onclick="location='client_node_crud.jsp?id=<%=pid %>'" />
				</div>
			</div>
		</form>
	</body>
</html>
