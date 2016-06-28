<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<%@ page import="com.gdut.drp.sysmgr.manager.*" %>
<%
// 		out.println("HELLO");
		Thread.currentThread().sleep(3000); 
		String userId = request.getParameter("userId");
		if (UserManager.getInstance().findUserById(userId) != null){
			out.println("用户代码已经存在");
		}
%>
