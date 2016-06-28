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
	
	//这是给本页处理是才能调用，现在交给servlet处理!!!
	if("del".equals(command)){
		String[] userIds = request.getParameterValues("selectFlag");
		//多个！ 调用链接20次 网络通讯也是20
/* 		for(int i=0; i<userIds.length; i++){
			UserManager.getInstance().delUser(userIds[i]);
		} */
		UserManager.getInstance().delUser(userIds);
		out.print("用户删除成功！");
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
		<title>用户维护</title>
		<link rel="stylesheet" href="../style/drp.css">
		<script type="text/javascript" src="js/ajax.js"></script>  
		<script type="text/javascript">
	
	var _s="close";
	window.onunload = function(){
	   if(_s=="fresh")
	      alert('页面刷新了');   
	}
	window.onbeforeunload = function(){
	   _s="fresh";
	}
	
	function addUser() {
		window.self.location = "user_add.jsp";	
	}
	
	function modifyUser() {
		var selectFlags = document.getElementsByName("selectFlag");
		//计数器
		var count = 0;
		//记录选中的checkbox索引号
		var index = 0;
		for (var i=0; i<selectFlags.length; i++) {
			if (selectFlags[i].checked) {
			    //记录选中的checkbox
				count++;
				index = i;
			}
		}
		if(count == 0) {
			alert("请选择需要修改的数据！");
			return;
		}
		if (count > 1) {
			alert("一次只能修改一个用户！");
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
			    //已经有选中的checkbox
				flag = true;
				break;
			}
		}
		if (!flag) {
			alert("请选择需要删除的数据！");
			return;
		}	
		//删除提示
		if (window.confirm("确认删除？")) {
			with(document.getElementById("userForm")){
				action = "user_maint.jsp";
				method = "post";
				submit();
			}
		}
	}
	
	var xmlHttp;
	function createXMLHttpRequest(){
	//表示当前浏览器不是ie，如firefox
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
			    //已经有选中的checkbox
				selectValue += selectFlags[i].value+",";
			}
		}
		flag = true;
		if (!flag) {
			alert("请选择需要删除的数据！");
			return;
		}	
		if(flag){
			//创建XMLHttpRequest
			createXMLHttpRequest();
			var url = "<%=basePath%>servlet/UserDelServlet?selectValue="+ selectValue +"&timestamp=" + new Date().getTime();
//alert(url);
			//请求的url-->jsp，让它去处理
			xmlHttp.open("GET", url, true);
			//方法地址，处理完成后自动调用，回调！
				//匿名函数的好处，不用再命名一个函数！！
			xmlHttp.onreadystatechange = function() {
						if (xmlHttp.readyState == 4) {//ajax引擎初始化成功
							if (xmlHttp.status == 200) {//http协议成功
								//alert(xmlHttp.responseText);
								document.getElementById("subFormSpan").innerHTML = xmlHttp.responseText;
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
	
	function checkAll() {
		var selectFlags = document.getElementsByName("selectFlag");
		for (var i=0; i<selectFlags.length; i++) {
			selectFlags[i].checked = document.getElementById("ifAll").checked;
			//采用getElementsByName代替getElementById
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
							<b>系统管理&gt;&gt;用户维护</b>
						</td>
					</tr>
				</table>
				<hr width="100%" align="center" size=0>
			</div>
			<table width="95%" height="20" border="0" align="center"
				cellspacing="0" class="rd1" id="toolbar">
				<tr>
					<td width="49%" class="rd19">
						<font color="#FFFFFF">查询列表</font>
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
						用户代码
					</td>
					<td width="152" class="rd6">
						用户名称
					</td>
					<td width="166" class="rd6">
						联系电话
					</td>
					<td width="150" class="rd6">
						email
					</td>
					<td width="153" class="rd6">
						创建日期
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
							<font color="#FFFFFF">&nbsp;共<%=pageModel.getTotalPages() %>页</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<font color="#FFFFFF">当前第</font>&nbsp
							<font color="#FF0000"><%=pageModel.getPageNo() %></font>&nbsp
							<font color="#FFFFFF">页</font>
						</div>
					</td>
					<td nowrap class="rd19">
						<div align="right">
							<input name="btnTopPage" class="button1" type="button"
								id="btnTopPage" value="|&lt;&lt; " title="首页"
								onClick="topPage()">
							<input name="btnPreviousPage" class="button1" type="button"
								id="btnPreviousPage" value=" &lt;  " title="上页"
								onClick="previousPage()">
							<input name="btnNextPage" class="button1" type="button"
								id="btnNextPage" value="  &gt; " title="下页" onClick="nextPage()">
							<input name="btnBottomPage" class="button1" type="button"
								id="btnBottomPage" value=" &gt;&gt;|" title="尾页"
								onClick="bottomPage()">
							<input name="btnAdd" type="button" class="button1" id="btnAdd"
								value="添加" onClick="addUser()">
							<input name="btnDelete" class="button1" type="button"
								id="btnDelete" value="删除" onClick="delUser()">
							<input name="btnModify" class="button1" type="button"
								id="btnModify" value="修改" onClick="modifyUser()">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
