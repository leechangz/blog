<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.Diary"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./diary.jsp");
		return;
	} 
	if((Integer)session.getAttribute("loginLevel") < 1) {
		response.sendRedirect("./diary.jsp");
		return;
	}
	request.setCharacterEncoding("utf-8");
	int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
	String diaryTodo = request.getParameter("diaryTodo");	
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 상세보기
	String updateSql = "UPDATE diary SET diary_todo = ? WHERE diary_no = ?";
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, diaryTodo);
	updateStmt.setInt(2, diaryNo);
	ResultSet updateRs = updateStmt.executeQuery();
	
	updateRs.close();
	updateStmt.close();
	conn.close();
	
	response.sendRedirect("./diaryOne.jsp?diaryNo="+diaryNo);
%>