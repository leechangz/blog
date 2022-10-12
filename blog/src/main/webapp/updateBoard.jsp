<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardList");
		return;
	}
	
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
	
	// 보기
	String boardSql = "SELECT l.location_name locationName, b.board_title boardTitle, b.board_content boardContent, b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
		<div style="background-color:#6B6E6F;">
			<h1 style="text-color:white">BOARD_UPDATE_NO.<%=boardNo%></h1>
			<hr>
		</div>
		<div class="row">
			<div class="col-sm-2">
				<!-- left menu -->
				<div>
					<ul>

						<li><a href="./boardList.jsp">전체</a></li>
						<%
						while (locationRs.next()) {
						%>
						<li><a
							href="./boardList.jsp?locationNo=<%=locationRs.getString("locationNo")%>">
								<%=locationRs.getString("locationName")%>
						</a></li>
						<%
						}
						%>
					</ul>
				</div>
			</div>
			<div class="col-sm-10">
				<%
				if (boardRs.next()) {
				%>
				<form action="./updateBoardAction.jsp" method="post">
				<table class="table table-primary table-boarderd">					
					<tr>
						<td>locationName</td>
						<td>
							<input type="hidden" name="boardNo" value="<%=boardNo%>">
							<input type="text" name="locationName" value="<%=boardRs.getString("locationName")%>" class="form-control" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td>boardTitle</td>
						<td>
							<input type="text" name="boardTitle" value="<%=boardRs.getString("boardTitle")%>" class="form-control">
						</td>
					</tr>
					<tr>
						<td>boardContent</td>
						<td>
							<textarea rows="5" cols="80" name="boardContent" class="form-control"><%=boardRs.getString("boardContent")%></textarea>
						</td>
					</tr>
					<tr>
						<td>createDate</td>
						<td>
							<input type="text" name="createDate" value="<%=boardRs.getString("createDate")%>" class="form-control" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="boardPw" value=""></td>
					</tr>
				</table>
				<%
				}
				%>
				<button type="submit" class="btn btn-success">수정완료</button>
				<a href="./boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-success">취소</a>
				</form>
				
			</div>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>
<%	
	boardRs.close();
	boardStmt.close();
	locationRs.close();
	locationStmt.close();
	conn.close();
%>