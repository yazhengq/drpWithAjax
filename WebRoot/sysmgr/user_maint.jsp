<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.gdut.drp.sysmgr.manager.UserManager"%>
<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030" %>
<%@ page import="java.util.*"%>
<%@ page import="com.gdut.drp.sysmgr.domain.*,com.gdut.drp.util.*" %> 

<%
	String pageNoString = request.getParameter("pageNo");
	String command = request.getParameter("command");
	
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//���Ǹ���ҳ�����ǲ��ܵ��ã����ڽ���servlet����!!!
	if("del".equals(command)){
		String[] userIds = request.getParameterValues("selectFlag");
		//����� ��������20�� ����ͨѶҲ��20
/* 		for(int i=0; i<userIds.length; i++){
			UserManager.getInstance().delUser(userIds[i]);
		} */
		UserManager.getInstance().delUser(userIds);
		out.print("�û�ɾ���ɹ���");
	}
	int pageNo = 1;
	if (pageNoString != null && !"".equals(pageNoString)) {
		pageNo = Integer.parseInt(pageNoString);
	}
	int pageSize = 7;
	PageModel<User> pageModel = UserManager.getInstance().findAllUser(pageNo, pageSize);
 %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
		<title>�û�ά��</title>
		<link rel="stylesheet" href="../style/drp.css">
		<script type="text/javascript" src="js/ajax.js"></script>  
		<script type="text/javascript">
	
	var _s="close";
	window.onunload = function(){
	   if(_s=="fresh")
	      alert('ҳ��ˢ����');   
	}
	window.onbeforeunload = function(){
	   _s="fresh";
	}
	
	function addUser() {
		window.self.location = "user_add.jsp";	
	}
	
	function modifyUser() {
		var selectFlags = document.getElementsByName("selectFlag");
		//������
		var count = 0;
		//��¼ѡ�е�checkbox������
		var index = 0;
		for (var i=0; i<selectFlags.length; i++) {
			if (selectFlags[i].checked) {
			    //��¼ѡ�е�checkbox
				count++;
				index = i;
			}
		}
		if(count == 0) {
			alert("��ѡ����Ҫ�޸ĵ����ݣ�");
			return;
		}
		if (count > 1) {
			alert("һ��ֻ���޸�һ���û���");
			return;
		}
		//alert(selectFlags[index].value);
		
		window.self.location = "user_modify.jsp?userId=" + selectFlags[index].value;
	}
	
	function deleteUser() {
		var selectFlags = document.getElementsByName("selectFlag");
		var flag = false;
		for (var i=0; i<selectFlags.length; i++) {
			if (selectFlags[i].checked) {
			    //�Ѿ���ѡ�е�checkbox
				flag = true;
				break;
			}
		}
		if (!flag) {
			alert("��ѡ����Ҫɾ�������ݣ�");
			return;
		}	
		//ɾ����ʾ
		if (window.confirm("ȷ��ɾ����")) {
			with(document.getElementById("userForm")){
				action = "user_maint.jsp";
				method = "post";
				submit();
			}
		}
	}
	
	var xmlHttp;
	function createXMLHttpRequest(){
	//��ʾ��ǰ���������ie����firefox
		if(window.XMLHttpRequest){
			xmlHttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}
	
	function delUser(){
		var selectFlags = document.getElementsByName("selectFlag");
		var flag = false;
		var selectValue = "";
		for (var i=0; i<selectFlags.length; i++) {
			if (selectFlags[i].checked) {
			    //�Ѿ���ѡ�е�checkbox
				selectValue += selectFlags[i].value+",";
			}
		}
		flag = true;
		if (!flag) {
			alert("��ѡ����Ҫɾ�������ݣ�");
			return;
		}	
		if(flag){
			//����XMLHttpRequest
			createXMLHttpRequest();
			var url = "<%=basePath%>servlet/UserDelServlet?selectValue="+ selectValue +"&timestamp=" + new Date().getTime();
//alert(url);
			//�����url-->jsp������ȥ����
			xmlHttp.open("GET", url, true);
			//������ַ��������ɺ��Զ����ã��ص���
				//���������ĺô�������������һ����������
			xmlHttp.onreadystatechange = function() {
						if (xmlHttp.readyState == 4) {//ajax�����ʼ���ɹ�
							if (xmlHttp.status == 200) {//httpЭ��ɹ�
								//alert(xmlHttp.responseText);
								document.getElementById("subFormSpan").innerHTML = xmlHttp.responseText;
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
	
	function checkAll() {
		var selectFlags = document.getElementsByName("selectFlag");
		for (var i=0; i<selectFlags.length; i++) {
			selectFlags[i].checked = document.getElementById("ifAll").checked;
			//����getElementsByName����getElementById
			//selectFlags[i].checked = document.getElementsByName("ifAll")[0].checked;
		}
	}

	function topPage() {
		window.location = "user_maint.jsp?pageNo=<%=pageModel.getTopPageNo()%>"
	}
	
	function previousPage() {
		window.location = "user_maint.jsp?pageNo=<%=pageModel.getPreviousPageNo()%>"
	}	
	
	function nextPage() {
		window.location = "user_maint.jsp?pageNo=<%=pageModel.getNextPageNo()%>"
	}
	
	function bottomPage() {
		window.location = "user_maint.jsp?pageNo=<%=pageModel.getButtomPageNo()%>";
	}

</script>
<base href="<%=basePath %>">
	</head>

	<body class="body1">
		<form name="userform" id="userform">
			<input type="hidden" name="command" value="del">
			<div align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="0"
					height="35">
					<tr>
						<td class="p1" height="18" nowrap>&nbsp;
							
						</td>
					</tr>
					<tr>
						<td width="522" class="p1" height="17" nowrap>
							<img src="../images/mark_arrow_02.gif" width="14" height="14">
							&nbsp;
							<b>ϵͳ����&gt;&gt;�û�ά��</b>
						</td>
					</tr>
				</table>
				<hr width="100%" align="center" size=0>
			</div>
			<table width="95%" height="20" border="0" align="center"
				cellspacing="0" class="rd1" id="toolbar">
				<tr>
					<td width="49%" class="rd19">
						<font color="#FFFFFF">��ѯ�б�</font>
					</td>
					<td width="27%" nowrap class="rd16">
						<div align="right"></div>
					</td>
				</tr>
			</table>
			<div id="subFormSpan">
			<table width="95%" border="1" cellspacing="0" cellpadding="0"
				align="center" class="table1">

				<tr>
					<td width="55" class="rd6">
						<input type="checkbox" name="ifAll" onClick="checkAll()">
					</td>
					<td width="119" class="rd6">
						�û�����
					</td>
					<td width="152" class="rd6">
						�û�����
					</td>
					<td width="166" class="rd6">
						��ϵ�绰
					</td>
					<td width="150" class="rd6">
						email
					</td>
					<td width="153" class="rd6">
						��������
					</td>
				</tr>
				
<%
	List<User> userList = pageModel.getList();
	for(Iterator<User> iter = userList.iterator(); iter.hasNext();){
		User user = iter.next();
%>
			<tr>
				<td class="rd8"><input type="checkbox" name="selectFlag"
					class="checkbox1" value="<%=user.getUserId() %>"></td>
				<td class="rd8"><%=user.getUserId() %></td>
				<td class="rd8"><%=user.getUserName() %></td>
				<td class="rd8"><%=user.getContactTel() == null ? "" : user.getContactTel() %></td>
				<td class="rd8"><%=user.getEmail() %></td>
				<td class="rd8"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(user.getCreateDate()) %></td>
			</tr>

			<%
				}
			%>
	
			</table>
			</div>

			<table width="95%" height="30" border="0" align="center"
				cellpadding="0" cellspacing="0" class="rd1">
				<tr>
					<td nowrap class="rd19" height="2">
						<div align="left">
							<font color="#FFFFFF">&nbsp;��<%=pageModel.getTotalPages() %>ҳ</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<font color="#FFFFFF">��ǰ��</font>&nbsp
							<font color="#FF0000"><%=pageModel.getPageNo() %></font>&nbsp
							<font color="#FFFFFF">ҳ</font>
						</div>
					</td>
					<td nowrap class="rd19">
						<div align="right">
							<input name="btnTopPage" class="button1" type="button"
								id="btnTopPage" value="|&lt;&lt; " title="��ҳ"
								onClick="topPage()">
							<input name="btnPreviousPage" class="button1" type="button"
								id="btnPreviousPage" value=" &lt;  " title="��ҳ"
								onClick="previousPage()">
							<input name="btnNextPage" class="button1" type="button"
								id="btnNextPage" value="  &gt; " title="��ҳ" onClick="nextPage()">
							<input name="btnBottomPage" class="button1" type="button"
								id="btnBottomPage" value=" &gt;&gt;|" title="βҳ"
								onClick="bottomPage()">
							<input name="btnAdd" type="button" class="button1" id="btnAdd"
								value="���" onClick="addUser()">
							<input name="btnDelete" class="button1" type="button"
								id="btnDelete" value="ɾ��" onClick="delUser()">
							<input name="btnModify" class="button1" type="button"
								id="btnModify" value="�޸�" onClick="modifyUser()">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
