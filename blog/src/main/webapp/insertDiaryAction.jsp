<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Diary" %>
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

	Calendar c = Calendar.getInstance();
	String year = request.getParameter("year");
	int monthex = Integer.parseInt(request.getParameter("month"));
	String month = (monthex<10)? "0"+monthex:""+monthex;
	int dayex = Integer.parseInt(request.getParameter("day"));
	String day = (dayex<10)? "0"+dayex:""+dayex;
	String date = year+"-"+month+"-"+day;
	String todo = request.getParameter("diaryTodo");
	System.out.print(date);
	System.out.print(todo);
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String insertSql = "INSERT INTO diary (diary_date, diary_todo, create_date) VALUES (?, ?, now())";
	PreparedStatement insertStmt = conn.prepareStatement(insertSql);
	insertStmt.setString(1, date);
	insertStmt.setString(2, todo);
	ResultSet insertRs = insertStmt.executeQuery();
	
	insertRs.close();
	insertStmt.close();
	conn.close();
	
	response.sendRedirect("./diary.jsp");
%>