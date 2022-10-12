<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
int diaryNo = Integer.parseInt(request.getParameter("diaryNo"));
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
		<div style="background-color:#6B6E6F;">
			<h1 style="text-color:white">DIARY_NO.<%=diaryNo%>_DELETE</h1>
			<hr>
		</div>
		<div class="d-flex justify-content-center container">
			<h3><%=diaryNo%>번 글 삭제하시겠습니까?</h3>
		</div>
		<div class="d-flex justify-content-center container">
			<a href="./deleteDiaryAction.jsp?diaryNo=<%=diaryNo%>" class="btn btn-dark">Y</a>
			<a href="./diaryOne.jsp?diaryNo=<%=diaryNo%>" class="btn btn-dark">N</a>	
		</div>
	</div>
<%@ include file="inc/footer.jsp"%>