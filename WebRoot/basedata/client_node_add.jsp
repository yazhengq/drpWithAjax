<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<%@ page import="com.gdut.drp.basedata.manager.*" %>   
<%@ page import="com.gdut.drp.basedata.domain.*" %> 
<%@ page import="com.gdut.drp.util.*" %>    
<%
	int pid = Integer.parseInt(request.getParameter("id"));
	String command = request.getParameter("command");
	if (Constants.ADD.equals(command)) {
		Client region = new Client();
		region.setPid(pid);
		region.setName(request.getParameter("name"));
		region.setIsLeaf(Constants.YES);
		region.setIsClient(Constants.NO);
		
		ClientManager.getInstance().addRegionOrClient(region);
		out.println("��ӳɹ���");
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel="stylesheet" href="../style/drp.css" />
		<script src="../script/client_validate.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030" />
		<title>�������ڵ�</title>
		<script type="text/javascript">
			function addRegion() {
				if (trim(document.getElementById("name").value).length == 0) {
					alert("�������Ʋ���Ϊ�գ�");
					document.getElementById("name").focus();
					return;
				}
				with(document.forms[0]) {
					action="client_node_add.jsp";
					method="post";
					submit();
				}
				
			}
			
			function goBack() {
				location = "client_node_crud.jsp?id=<%=pid%>";
			}
		</script>
	</head>

	<body class="body1">
		<form>
		<input type="hidden" name="command" value="<%=Constants.ADD %>">
		<input type="hidden" name="id" value="<%=pid %>">
			<table width="95%" border="0" cellspacing="0" cellpadding="0"
				height="8">
				<tr>
					<td width="522" class="p1" height="2" nowrap="nowrap">
						<img src="../images/mark_arrow_03.gif" width="14" height="14" />
						&nbsp;
						<b>�������ݹ���&gt;&gt;������ά��&gt;&gt;�������ڵ�</b>
					</td>
				</tr>
			</table>
			<hr width="97%" align="center" size="0" />
			<p></p>
			<p></p>
			<table width="95%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="213">
						<div align="right">
							<font color="#FF0000">*</font>�������ƣ�
						</div>
					</td>
					<td width="410">
						<label>
							<input name="name" type="text" class="text1" id="name" />
						</label>
					</td>
				</tr>
			</table>
			<p></p>
			<label>
				<br />
			</label>
			<hr />
			<p align="center">
				<input name="btnAdd" class="button1" type="button" value="���" onclick="addRegion()"/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="btnBack" class="button1" type="button" value="����"
					onclick="goBack()" />
			</p>
		</form>
	</body>
</html>
