<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%	
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardList");
		return;
	}

	request.setCharacterEncoding("utf-8");

	int locationNo = Integer.parseInt(request.getParameter("locationNo"));
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	
	// 디버깅
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String boardSql = "INSERT INTO board(location_no,board_title,board_content,board_pw,create_date) VALUES (?,?,?,PASSWORD(?),now())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, locationNo);
	boardStmt.setString(2, boardTitle);
	boardStmt.setString(3, boardContent);
	boardStmt.setString(4, boardPw);
	int row = boardStmt.executeUpdate();
	// 쿼리 실행 결과 디버깅	
	if(row == 1) {
			
	} else {
		
	}
	// 재요청
	response.sendRedirect("./boardList.jsp");
%>
<%	
	boardStmt.close();
	conn.close();
%>