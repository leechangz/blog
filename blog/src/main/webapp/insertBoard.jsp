inse<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./index.jsp?errorMsg=do login");
		return;
	} else if ((Integer)session.getAttribute("loginLevel") < 1)	{
		response.sendRedirect("./boardList");
		return;
	}	

	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
		<div style="background-color:#6B6E6F;">
			<h1 style="text-color:white">BOARD_INSERT</h1>
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
				<h3>게시글입력</h3>
				<form action="./insertBoardAction.jsp" method="post">
					<table class="table table-primary table-boarderd">
						<tr>
							<td>locationNo</td>
							<td><select name="locationNo">
									<%
									locationRs.first(); // next로 끝까지 가면 처음으로 돌려야 함

									do { //이미 first에서 next는 second 이므로 do while
									%>
									<option value="<%=locationRs.getString("locationNo")%>">
										<%=locationRs.getString("locationName")%>
									</option>
									<%
									} while (locationRs.next());
									%>
							</select></td>
						</tr>


						<tr>
							<td>제목</td>
							<td><input type="text" name="boardTitle" class="form-control"></td>
						</tr>
						<tr>
							<td>내용</td>
							<td>
								<textarea rows="5" cols="80" name="boardContent" class="form-control"></textarea>
							</td>
						</tr>
						<tr>
							<td>비밀번호</td>
							<td><input type="password" name="boardPw" class="form-control"></td>
						</tr>
					</table>
					<button type="submit" class="btn btn-dark" style="float:right;">입력</button>
					<button type="reset" class="btn btn-dark" style="float:right;">초기화</button>
				</form>
			</div>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>
<%	
	locationRs.close();
	locationStmt.close();
	conn.close();
%>