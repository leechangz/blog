<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	if(session.getAttribute("loginId") != null) {
		session.invalidate(); // 세션 리셋
		response.sendRedirect("./index.jsp");
		return;
	} else {
		response.sendRedirect("./index.jsp?errorMsg=fail");
		return;
	}
%>