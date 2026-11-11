
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_formatadata.asp"-->
<!--#include file="config.asp"-->
<!--#include file="topo.asp"-->
<body>
    <!--include file="topo.asp"-->
    <!--=== Breadcrumbs ===-->
     <%
     intCodModulo = request.QueryString("Cm")
	
	 if intCodModulo <> "" then

        sql = "SELECT MOD_COD, MOD_DESCRICAO"
        sql = sql & " FROM SEG_MODULO"
        sql = sql & " where MOD_COD = " & intCodModulo
        rs.open sql, cnn
        
        if rs.eof = false then
	        strModulo	 		= Trim(rs("MOD_DESCRICAO"))
        end if
        rs.close

    end if
  
    %>
    
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Help - <%=strModulo%></h1>
            <ul class="pull-right breadcrumb">
                <li><a href="default.asp">Home</a></li>
                <li><a href="<%=Session("strModulo")%>/default.asp"><%=Session("strModulo")%> </a></li>
                <li><a href="Help.asp?Cm=<%=Session("CodModulo")%>">Help</a></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <!--=== Content Part ===-->
    <div class="container content">
    
     	<!-- General Questions -->
                <div class="headline"><h2><%=strModulo%></h2></div>
                <div class="panel-group acc-v1 margin-bottom-40" id="accordion">
                    
                    <%
							strSite = trim(request.ServerVariables("SERVER_NAME"))
						
							sql = "SELECT Codigo, CodModulo, Titulo, Descricao, LinkTela, LinkVideo, Situacao"
							sql = sql & " FROM Help_Sistema"
							sql = sql & " where CodModulo = " & intCodModulo
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
								%>
								
                                <div class="panel panel-default">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#<%=Trim(rs("Codigo"))%>"><%=Trim(rs("Titulo"))%></a>
									</h4>
								</div>
								<div id="<%=Trim(rs("Codigo"))%>" class="panel-collapse collapse">
									<div class="panel-body">
										<%=Trim(rs("Descricao"))%>
                                        
                                        <%if Trim(rs("LinkTela")) <> "" then %>
                                        <br><br>
                                        <a href="http://<%=strSite%>/Sistema/<%=Trim(rs("LinkTela"))%>">Ir para: <%=Trim(rs("Titulo"))%></a>
                                         <%end if%>
                                        
									</div>
                                    
                                   
								</div>
                                </div>
								
                            <%				
								rs.movenext
								wend
							end if
							rs.close
						%>
                        
                            
                  
                    

                </a></div>
                <!--/acc-v1-->
                <!-- End General Questions -->

  	
    </div>
    <!--/container-->
    <!--=== End Content Part ===-->
    <!--#include file="rodape.asp"-->
    <!--#include file="js.asp"-->
</body>
</html>
