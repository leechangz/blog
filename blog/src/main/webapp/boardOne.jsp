<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
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
	
	// 상세보기
	String boardSql = "SELECT l.location_name locationName, b.board_title boardTitle, b.board_content boardContent, b.create_date createDate FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE board_no = ?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
	// 댓글
	String commentSql = "select comment_no commentNo, comment_content commentContent from comment where board_no = ? order by create_date desc";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	ResultSet commentRs = commentStmt.executeQuery();
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
	<div style="background-color:#6B6E6F;">
		<h1 style="text-color:white">BOARD_NO.<%=boardNo%></h1>
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
				<table class="table table-primary table-striped table-bordered">
					<tr>
						<td colspan="3">locationName</td>
						<td colspan="7"><%=boardRs.getString("locationName")%></td>
					</tr>
					<tr>
						<td colspan="3">boardTitle</td>
						<td colspan="7"><%=boardRs.getString("boardTitle")%></td>
					</tr>
					<tr>
						<td colspan="3">boardContent</td>
						<td colspan="7"><textarea rows="10" class="form-control" readonly="readonly"><%=boardRs.getString("boardContent")%></textarea></td>
					</tr>
					<tr>
						<td colspan="3">createDate</td>
						<td colspan="7"><%=boardRs.getString("createDate")%></td>
					</tr>
				</table>
				<%
				}
				
				if((Integer)session.getAttribute("loginLevel") > 0) {
				%>
					<div>
						<a href="./updateBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-dark" style="float:right;">UPDATE</a> 
						<a href="./deleteBoard.jsp?boardNo=<%=boardNo%>" class="btn btn-dark" style="float:right;">DELETE</a>
					</div>
				<%	
				}
				%>
			
			<!-- 댓글 입력 -->
			<div>
				<form action="./insertCommentAction.jsp" method="post">
					<input type="hidden" name="boardNo" value="<%=boardNo%>" class="form-control">
							<span>댓글</span>
							<textarea name="commentContent" rows="2" cols="50" class="form-control"></textarea>
							<span>비밀번호</span>
							<input name="commentPw" type="password" class="form-control">
					<button type="submit"  class="btn btn-success" style="float:right;">insert</button>		
				</form>
			</div>
			<div>
				<%
				if(request.getParameter("errorMsg")!=null &&(Integer)session.getAttribute("loginLevel") < 1 ) {
				%>
				<br>
				<p style="color: red;"><%=request.getParameter("errorMsg")%></p>
				<%
				}
				%>
			</div>
			<!-- 댓글 목록 -->
			<div>
				<table class="table table-hover table-bordered" style="table-layout: fixed">
				<tr>
					<td>No</td>
					<td colspan="9">내용</td>
				</tr>
					<%
						while(commentRs.next()){
					%>		
							<tr>
							<td><%=commentRs.getString("commentNo")%></td>
							<td colspan="8"><%=commentRs.getString("commentContent")%></td>
							<td colspan="1"><a href="deleteCommentForm.jsp?commentNo=<%=commentRs.getString("commentNo")%>&boardNo=<%=boardNo%>" class="btn btn-dark" style="float:right;">DELETE</a></td>
							</tr>
					<%	
						} 
					%>
				</table>
			</div>
		</div>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>

<%	
	commentRs.close();
	commentStmt.close();
	boardRs.close();
	boardStmt.close();
	locationRs.close();
	locationStmt.close();
	conn.close();
%>