<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*" %>
<%	
	if(session.getAttribute("loginId") == null) {
		response.sendRedirect("./diary.jsp");
		return;
	} 
	if((Integer)session.getAttribute("loginLevel") < 1) {
		response.sendRedirect("./diary.jsp");
		return;
	}

	Calendar c = Calendar.getInstance();
	int year = Integer.parseInt(request.getParameter("y"));
	int month = Integer.parseInt(request.getParameter("m"));
	int day = Integer.parseInt(request.getParameter("d"));
	
	//String todayYear = c.get(Calendar.YEAR);
	
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
	<div style="background-color:#6B6E6F;">
		<h1 style="text-color:white">DIARY_insert</h1>
		<hr>
	</div>
		<div class="form">
			<form action="./insertDiaryAction.jsp" method="post">
				<table class="table table-primary table-bordered">
					<tr>
						<td>다이어리날짜</td>
						<td><input type="text" name="year" value="<%=year%>" class="form-control" style="width:90%;float:left" readonly><span>년</span></td>
						<td><input type="text" name="month" value="<%=month%>" class="form-control" style="width:90%;float:left" readonly><span>월</span></td>
						<td><input type="text" name="day" value="<%=day%>" class="form-control" style="width:90%;float:left" readonly><span>일</span></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="3">
							<textarea rows="5" cols="80" name="diaryTodo" class="form-control"></textarea>
						</td>
					</tr>
				</table>
				<button type="submit" class="btn btn-dark" style="float:right;">입력</button>
				<button type="reset" class="btn btn-dark" style="float:right;">초기화</button>
			</form>
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>
