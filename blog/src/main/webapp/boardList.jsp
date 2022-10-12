<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	System.out.println(word + " <-- word");
	
	String locationNo = request.getParameter("locationNo");
	System.out.println(locationNo + " <-- locationNo");
	
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage - 1) * ROW_PER_PAGE;
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://15.165.27.29/blog";
	String dbuser = "root";
	String dbpw = "secret";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	// 메뉴 목록
	String locationSql = "SELECT location_no locationNo, location_name locationName FROM location";
	PreparedStatement locationStmt = conn.prepareStatement(locationSql);
	ResultSet locationRs = locationStmt.executeQuery();

	// 마지막 페이지 계산
	int totalRow = 0;
		
	PreparedStatement countStmt = null;	
	
	if (locationNo == null) {
		if (word == null) {		
			countStmt = conn.prepareStatement("select count(*) from board");
		} else {
			countStmt = conn.prepareStatement("select count(*) from board where board_title like ?");
			countStmt.setString(1,"%"+word+"%");
		}
	} else {
		if (word == null) {
			countStmt = conn.prepareStatement("select count(*) from board where location_no = ?");
			countStmt.setString(1,locationNo);
		} else {
			countStmt = conn.prepareStatement("select count(*) from board where board_title like ? and location_no = ?");
			countStmt.setString(1,"%"+word+"%");
			countStmt.setString(2,locationNo);
		}
	}
	
	ResultSet countRs = countStmt.executeQuery();
	
	if(countRs.next()) {
		totalRow = countRs.getInt("count(*)"); 
	}
	
	int lastPage = totalRow / ROW_PER_PAGE;
	if(totalRow % ROW_PER_PAGE != 0) {
		lastPage += 1;
	}
	System.out.println(totalRow + " <-- totalRow");
	System.out.println(lastPage + " <-- lastPage");
	System.out.println(currentPage + " <-- currentPage");
%>

<%@ include file="inc/header2.jsp"%>
	<div class="container-fluid">
	<div style="background-color:#6B6E6F;">
		<h1 style="text-color:white">BOARD</h1>
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
				if(session.getAttribute("loginId") != null ) {
				%>
					<div style="float: right;">	
				<%
					if((Integer)session.getAttribute("loginLevel") > 0) {	
				%>
						<a href = "./insertBoard.jsp" class="btn btn-primary">글입력</a>
					</div>	
				<%
					}
				}
				%>
				<!-- main -->
				<%
				// 게시글 목록
				String boardSql = "";
				PreparedStatement boardStmt = null;
				if (locationNo == null) {
					if(word == null){		
						boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no ORDER BY board_no DESC LIMIT ?, ?";
						boardStmt = conn.prepareStatement(boardSql);
						boardStmt.setInt(1, beginRow); 
						boardStmt.setInt(2, ROW_PER_PAGE);
					} else {
						boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.board_title like ? ORDER BY board_no DESC LIMIT ?, ?";
						boardStmt = conn.prepareStatement(boardSql);
						boardStmt.setString(1, "%"+word+"%");
						boardStmt.setInt(2, beginRow);
						boardStmt.setInt(3, ROW_PER_PAGE);
					}
				} else {
					if(word == null){		
						boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? ORDER BY board_no DESC LIMIT ?, ?";
						boardStmt = conn.prepareStatement(boardSql);
						boardStmt.setInt(1, Integer.parseInt(locationNo));
						boardStmt.setInt(2, beginRow);
						boardStmt.setInt(3, ROW_PER_PAGE);
					} else {
						boardSql = "SELECT l.location_name locationName, b.location_no locationNo, b.board_no boardNo, b.board_title boardTitle FROM location l INNER JOIN board b ON l.location_no = b.location_no WHERE b.location_no = ? and b.board_title like ? ORDER BY board_no DESC LIMIT ?, ?";
						boardStmt = conn.prepareStatement(boardSql);
						boardStmt.setInt(1, Integer.parseInt(locationNo));
						boardStmt.setString(2, "%"+word+"%");
						boardStmt.setInt(3, beginRow);
						boardStmt.setInt(4, ROW_PER_PAGE);
					}
				}
				ResultSet boardRs = boardStmt.executeQuery();
				%>

				<table class="table table-primary">
					<thead>
						<tr>
							<th>locationName</th>
							<th>boardNo</th>
							<th>boardTitle</th>
						</tr>
					</thead>
					<tbody>
						<%
						while (boardRs.next()) {
						%>
						<tr>
							<td><%=boardRs.getString("locationName")%></td>
							<td><%=boardRs.getInt("boardNo")%></td>
							<td>
								<a href="./boardOne.jsp?boardNo=<%=boardRs.getInt("boardNo")%>">
									<%=boardRs.getString("boardTitle")%>
								</a>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>

				<div>
					<form class="form-inline" action="./boardList.jsp" method="post">
						<%
						if (locationNo != null) {
						%>
						<input type="hidden" name="locationNo" value="<%=locationNo%>">
						<%
						}
						%>
						<div class="row" style="justify-content: center;">
							<div class="col-sm-8">
								<input type="text" class="form-control" name="word" placeholder="제목검색">
							</div>
							<div class="col-sm-2">
								<button type="submit" class="btn btn-dark">SEARCH</button>
							</div>
						</div>					
					</form>
				</div>

				<!--  페이징 -->
				<div class="text-center">
					<br>
					<ul class="pagination justify-content-center">
						<!-- 이전 -->
						<%					
						if (locationNo == null) {
							if (word == null) {		
								if(currentPage > 1) {
						%>			
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage - 1%>">이전</a></li>
						<%
								}
							} else {
								if(currentPage > 1) {
						%>		
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage - 1%>&word=<%=word%>">이전</a></li>
						<%
								}
							}
						} else {
							if (word == null) {
								if(currentPage > 1) {
						%>					
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage - 1%>&locationNo=<%=locationNo%>">이전</a></li>
						<%
								}
							} else {
								if(currentPage > 1) {
						%>
								<li class="page-item"><a class="page-link"
											href="./boardList.jsp?currentPage=<%=currentPage - 1%>&locationNo=<%=locationNo%>&word=<%=word%>">이전</a></li>
						<%
								}
							}
						}
						%>
						
						<!-- 페이지 번호 -->
						<%	
						 	int pageCount = 10;
							int startPage = ((currentPage - 1) / pageCount) * pageCount + 1;
					    	int endPage = (((currentPage - 1) / pageCount) + 1) * pageCount;
					    	
					    	for (int i = startPage; i <= endPage; i++) {
					    		if (i <= lastPage) {
					    			if (locationNo == null) {
					    				if (word == null) {
					    					if (lastPage < endPage) {
						        				endPage = lastPage;
						    				}
					    %>								
					    					<li class="page-item"><a class="page-link"
					    							href="./boardList.jsp?currentPage=<%=i%>"><%=i%></a></li>
					    <%
					    					
					    				} else {
					    					if (lastPage < endPage) {
						        				endPage = lastPage;
						    				}
					    %>		
					    					<li class="page-item"><a class="page-link"
					    							href="./boardList.jsp?currentPage=<%=i%>&word=<%=word%>"><%=i%></a></li>
					    <%
					    					
					    				}
					    			} else {
					    				if (word == null) {
					    					if (lastPage < endPage) {
						        				endPage = lastPage;
						    				}
					    %>					
					    					<li class="page-item"><a class="page-link"
					    							href="./boardList.jsp?currentPage=<%=i%>&locationNo=<%=locationNo%>"><%=i%></a></li>
					    <%
					    					
					    				} else {
					    					if (lastPage < endPage) {
						        				endPage = lastPage;
						    				}	
					    %>
					    					<li class="page-item"><a class="page-link"
					    								href="./boardList.jsp?currentPage=<%=i%>&locationNo=<%=locationNo%>&word=<%=word%>"><%=i%></a></li>
					    <%
					    					
					    				}
					    			}
					    		}
					    	}
						%>
						
						<!-- 다음 -->
						<%					
						if (locationNo == null) {
							if (word == null) {		
								if(currentPage < lastPage) {
						%>			
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage + 1%>">다음</a></li>
						<%
								}
							} else {
								if(currentPage < lastPage) {
						%>		
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage + 1%>&word=<%=word%>">다음</a></li>
						<%
								}
							}
						} else {
							if (word == null) {
								if(currentPage < lastPage) {
						%>					
								<li class="page-item"><a class="page-link"
										href="./boardList.jsp?currentPage=<%=currentPage + 1%>&locationNo=<%=locationNo%>">다음</a></li>
						<%
								}
							} else {
								if(currentPage < lastPage) {
						%>
								<li class="page-item"><a class="page-link"
											href="./boardList.jsp?currentPage=<%=currentPage + 1%>&locationNo=<%=locationNo%>&word=<%=word%>">다음</a></li>
						<%
								}
							}
						}
						%>
					</ul>
				</div>

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