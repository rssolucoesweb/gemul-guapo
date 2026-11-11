<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
        <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Publicação</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strAutor			= Trim(Request("txtAutor"))
        strPalavraChave		= Trim(Request("txtPalavraChave"))
        strTitulo			= Trim(Request("txtTitulo"))
        strCdu				= Trim(Request("txtCdu"))
        strCodPublicacao	= Trim(Request("txtCodPublicacao"))
    %>

    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Publicação</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label for="exampleInputEmail1">Palavra Chave</label>
                         <input name="txtPalavraChave" type="text" class="form-control" id="txtPalavraChave" value="<%=strPalavraChave%>" size="80" maxlength="100">
                    </div>
                    
                     <div class="form-group">
                        <label for="exampleInputEmail1">Titulo</label>
                         <input name="txtTitulo" type="text" class="form-control" id="txtTitulo" value="<%=strTitulo%>" size="80" maxlength="100">
                    </div>
                    
                     <div class="form-group">
                        <label for="exampleInputEmail1">Cdu</label>
                         <input name="txtCdu" type="text" class="form-control" id="txtCdu" value="<%=strCdu%>" size="80" maxlength="100">
                    </div>
                    
                     <div class="form-group">
                        <label for="exampleInputEmail1">N. Registro</label>
                         <input name="txtCodPublicacao" type="text" class="form-control" id="txtCodPublicacao" value="<%=strCodPublicacao%>" size="80" maxlength="100">
                    </div>
                    
                    <legend></legend>
                     <!--#include file="../../includes/inc_botoes_consulta.asp"-->
                </form>
            	</div>
                
                <%
		if trim(strAutor) <> "" or trim(strPalavraChave) <> "" or trim(strTitulo) <> "" or trim(strCdu) <> "" or trim(strCodPublicacao) <> "" then
		%>
                   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Autores</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="5%" bgcolor="#95A5A6">Codigo</th>
                            <th width="86%" bgcolor="#95A5A6">Titulo</th>
                            <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                        </tr>
                    </thead>
                    		  <%
			cont =0

			sql = "select distinct "
			sql = sql & " P.Cod_Publicacao, "
			sql = sql & " ED.Nome_Editora, "
			sql = sql & " P.Cod_CDU, "
			sql = sql & " P.Titulo, "
			sql = sql & " P.SubTitulo,"
			sql = sql & " P.ISBN, "
			sql = sql & " P.DataInclusao, "
			sql = sql & " P.NumPaginas, "
			sql = sql & " P.VolumePublicacao, "
			sql = sql & " P.AnoPublicacao,"
			sql = sql & " P.EdicaoPublicacao "
			sql = sql & " From	SCB_PUBLICACAO P"
			sql = sql & " inner	join SCB_Editoras ED			on P.Cod_Editora		= ED.Cod_Editora  and P.cod_empresa = ED.cod_empresa"
			sql = sql & " left join SCB_PublicacaoExemplares E on E.Cod_Publicacao 	= P.Cod_Publicacao"
			sql = sql & " where P.cod_empresa = " & Session("CodEmpresa")
			if strTitulo <> "" then
				sql = sql & " and P.Titulo LIKE '%" & strTitulo & "%'"
			end if
			if strCdu <> "" then
				sql = sql & " AND SUBSTRING(P.COD_CDU,1," & len(strCdu) & " ) = '" & strCdu & "'" 
			end if
			if strCodPublicacao <> "" then
				sql = sql & " AND P.Cod_Publicacao = " & strCodPublicacao
			end if
			if trim(strAutor) <> "" or trim(strPalavraChave) <> "" then
			
				sql = sql & " and E.Cod_PublicacaoExemplares in "
				sql = sql & " ("
				sql = sql & " 	select	distinct E.Cod_PublicacaoExemplares "
				sql = sql & " 	from	SCB_PUBLICACAO P"
				sql = sql & " 	inner	join SCB_PUBLICACAOAUTORES PA		on P.cod_publicacao		= PA.cod_publicacao"
				sql = sql & " 	inner	join SCB_Autores A					on A.Cod_Autor			= PA.Cod_Autor and A.cod_empresa = P.cod_empresa"
				sql = sql & " 	inner	join SCB_PUBLICACAOEXEMPLARES E		on P.Cod_Publicacao		= E.Cod_Publicacao"
				sql = sql & " 	inner	join SCB_PUBLICACAOPALAVRACHAVE PPC on PPC.Cod_Publicacao	= P.Cod_Publicacao "
				sql = sql & " 	inner	join SCB_PALAVRACHAVE PC			on PC.Cod_Palavra		= PPC.Cod_PalavraChave and PC.cod_empresa = P.cod_empresa"
				sql = sql & " 	where	1=1"
				sql = sql & " 	and		P.cod_empresa		= " & Session("CodEmpresa")
				sql = sql & " 	and		E.Cod_TipoUsuario is null "
				
				if strAutor <> "" then
					sql = sql & " and A.Nome_Autor LIKE '%" & strAutor & "%'"
				end if
				
				if strPalavraChave <> "" then
					sql = sql & " and PC.Nome_Palavra LIKE '%" & strPalavraChave & "%'"
				end if
				
				sql = sql & " )"
			end if
			sql = sql & " order by 2"
			rs.open sql, cnn
				
			if rs.eof = false then

				while not rs.eof
					
					cont = cont + 1	
					selecionado = ""
					strDescAutor = ""
					
					intCodPublicacao	= rs("Cod_Publicacao")
					Editora		 		= rs("Nome_Editora")
					CDU		 			= rs("Cod_CDU")
					Titulo		 		= rs("Titulo")
					SubTitulo			= rs("SubTitulo")
					ISBN		 		= rs("ISBN")
					Volume		 		= rs("VolumePublicacao")
					NPaginas			= rs("NumPaginas")
					
					' Consulta os Autores
					sql = " SELECT SCB_PUBLICACAOAUTORES.Cod_Autor, SCB_AUTORES.Nome_Autor "
					sql = sql & " FROM SCB_PUBLICACAOAUTORES INNER JOIN SCB_AUTORES "
					sql = sql & " ON (SCB_PUBLICACAOAUTORES.Cod_Autor = SCB_AUTORES.Cod_Autor) "
					sql = sql & " WHERE SCB_PUBLICACAOAUTORES.Cod_Publicacao = " & intCodPublicacao
					rsAux.open sql, cnn		
					
					if rsAux.eof = false then
						
						while not rsAux.eof
						
							if trim(strDescAutor) = "" then
								strDescAutor	= rsAux("Nome_Autor")
							else
								strDescAutor	= strDescAutor & ", " & rsAux("Nome_Autor")
							end if
							rsAux.movenext
					
						wend
					end if
					rsAux.close
					
					
					if intCod_TipoUsuario <> "" then 
						strSeleciona 	= ""
						strSituacao 	= "EMPRESTADO"
						strCor			= "#990000"
					else
						strSeleciona 	= "bgcolor='#FFFFFF' style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' onClick=resultadoConsulta(" & rs("Cod_Publicacao") &")"
						strSituacao 	= "DISPONÍVEL"
						strCor			= "#000000"
					end if
					
					%>

                    <tbody>
                        <tr <%=strSeleciona%>>
                            <td><%=trim(rs("Cod_Publicacao"))%></td>
                            <td><%=trim(rs("Titulo"))%></td>
                            <td align="center" >
                            <button class="btn-u btn-u-sea" onClick="resultadoConsulta(<%=trim(rs("Cod_Publicacao"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                            </td> 
                        </tr>
                    </tbody>
                    <%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                %>
                </table>
            </div>                      
        </div>
        <%end if%>
        <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->    
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script type="text/javascript">
        function resultadoConsulta(intCodigo){
            window.opener.frm.txtCodigo.value = intCodigo;
            window.opener.frm.submit();
            window.close();
        }
		
		Consulta
    </script>
    <!--#include file="../jsModulo.asp"-->
</body>
</html> 