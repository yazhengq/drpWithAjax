<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.gdut.drp.sysmgr.manager.UserManager"%>
<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030" %>
<%@ page import="java.util.*"%>
<%@ page import="com.gdut.drp.sysmgr.domain.*,com.gdut.drp.util.*" %>

<%
	String pageNoString = request.getParameter("pageNo");
	String command = request.getParameter("command");
	if("del".equals(command)){
//ajax是异步调用，不是请求所以取不到值！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！		
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