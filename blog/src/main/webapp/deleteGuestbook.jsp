<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if (session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp");
		return;
	}
	
	if(request.getParameter("guestbookNo") == null) {
	    response.sendRedirect("./guestbook.jsp");
	    return;
	}
	
	int guestbookNo = Integer.parseInt(request.getParameter("guestbookNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String sql = "DELETE FROM guestbook WHERE guestbook_no = ? and id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, guestbookNo);
	stmt.setString(2, (String)session.getAttribute("loginId")); // Object, 다형성, 형변환, Map
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect("./guestbook.jsp");
%>
<%	
	stmt.close();
	conn.close();
%>