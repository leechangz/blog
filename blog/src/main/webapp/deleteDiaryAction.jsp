<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 상세보기
	String deleteSql = "DELETE FROM diary WHERE diary_no = ?";
	PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
	deleteStmt.setInt(1, diaryNo);
	ResultSet deleteRs = deleteStmt.executeQuery();
	
	deleteRs.close();
	deleteStmt.close();
	conn.close();
	
	response.sendRedirect("./diary.jsp");
%>