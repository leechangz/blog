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
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 상세보기
	String diarySql = "SELECT diary_date diaryDate, diary_todo diaryTodo FROM diary WHERE diary_no = ? ";
	PreparedStatement diaryStmt = conn.prepareStatement(diarySql);
	diaryStmt.setInt(1, diaryNo);
	ResultSet diaryRs = diaryStmt.executeQuery();
	
	ArrayList<Diary> list = new ArrayList<Diary>();
	while (diaryRs.next()) {
		Diary d = new Diary(); // 행의 수 만큼 생성자를 만들어야 하므로 while문 안에서 생성
		d.diaryNo = diaryNo;
		d.diaryDate = diaryRs.getString("diaryDate");
		d.diaryTodo = diaryRs.getString("diaryTodo");
		list.add(d);
	}
	
	diaryRs.close();
	diaryStmt.close();
	conn.close();
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
		<div style="background-color:#6B6E6F;">
			<h1 style="text-color:white">DIARY_UPDATE</h1>
			<hr>
		</div>
		<form action="updateDiaryAction.jsp" method="get">
			<div>
				<table class="table table-primary table-bordered">
					<%
					for (Diary d : list) {
					%>
					<tr>
						<td colspan="2">글 번호</td>
						<td colspan="8"><input type="text" name="diaryNo" value="<%=d.diaryNo%>"
							class="form-control" readonly></td>
					</tr>
					<tr>
						<td colspan="2">날짜</td>
						<td colspan="8"><input type="text" name="diaryDate"
							class="form-control" value="<%=d.diaryDate%>" readonly></td>
					</tr>
					<tr>
						<td colspan="2">내용</td>
						<td colspan="8"><input type="text" name="diaryTodo"
							class="form-control" value="<%=d.diaryTodo%>"></td>
					</tr>
					<%
					}
					%>
				</table>
			</div>
			<div>
				<button type="submit" class="btn btn-dark"> 완료</button> 
				<a href="./diaryOne.jsp?diaryNo=<%=diaryNo%>" class="btn btn-dark">취소</a>
			</div>
		</form>
	</div>
<%@ include file="inc/footer.jsp"%>

