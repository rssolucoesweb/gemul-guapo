<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matricula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo 		= "RemoveInscricaoMatricula_con.asp"
        strPagina				= "RemoveInscricaoMatricula_con.asp"
    
        strSolicitacao 			= Trim(Request.Form("txtSolicitacao"))
        strCodAluno 			= Trim(Request.Form("txtCodAluno"))
        
        strMatricula 			= Trim(Request.Form("txtMatricula"))
        strAluno 				= Trim(Request.Form("txtAluno"))
        strMae 					= Trim(Request.Form("txtMae"))
        strConsultar			= Trim(Request.Form("strConsultar"))
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Remove Inscrição</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input type="hidden" name="strConsultar" id="strConsultar" value="S">
                    <div class="form-group">
                        <label class="form-label">N. Solicitação</label>
                         <input name="txtSolicitacao" type="text" class="form-control" id="txtSolicitacao" style="width:350pt" value="<%=strSolicitacao%>" size="80" maxlength="100" onKeyPress="return formataCampo(this, 2, 10)">
                    </div>
                    <div class="form-group">
                        <label class="form-label"> Matr&iacute;cula</label>
                         <input name="txtMatricula" type="text" class="form-control" id="txtMatricula" style="width:350pt" value="<%=strMatricula%>" size="80" maxlength="100" onKeyPress="return formataCampo(this, 2, 10)">
                    </div>
                    <div class="form-group">
                        <label class="form-label"> N. Inscri&ccedil;&atilde;o</label>
                         <input name="txtCodAluno" type="text" class="form-control" id="txtCodAluno" style="width:350pt" value="<%=strCodAluno%>" size="80" maxlength="100" onKeyPress="return formataCampo(this, 2, 10)">
                    </div>
                    <div class="form-group">
                        <label class="form-label"> Nome do Aluno</label>
                         <input name="txtAluno" type="text" class="form-control" id="txtAluno" style="width:350pt" value="<%=strAluno%>" size="80" maxlength="100">
                    </div>
                    <div class="form-group">
                        <label class="form-label"> Nome do Mãe</label>
                         <input name="txtMae" type="text" class="form-control" id="txtMae" style="width:350pt" value="<%=strMae%>" size="80" maxlength="100">
                    </div>
                    <legend></legend>
                    <input class="btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return ConsultaMat()">
                    <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Solicitação de Matrícula</h3>
                    </div>
                    <div class="panel-body">
                  <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="5%" bgcolor="#95A5A6">N. Sol.</th>
                                    <th width="9%" bgcolor="#95A5A6">Matr&iacute;cula</th>
                                    <th width="20%" bgcolor="#95A5A6">Nome do Aluno</th>
                                  <th width="25%" bgcolor="#95A5A6">Nome da Mãe</th>
                                    <th width="27%" bgcolor="#95A5A6">Escola</th>
                                    <th width="9%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                                  <th width="5%" bgcolor="#95A5A6" align="center"><div align="center">Excluir</div></th>
                                </tr>
                            </thead>
                            <%
							
						cont =0
						strCpf 		= replace(replace(strCpf,".",""),"-","")
						
						if strConsultar <> "" then
						
							sql = "SELECT A.CODIGO, A.MATRICULA, A.NOME, A.DATA_NASCIMENTO, A.MAE, A.COD_EMPRESA, SA.DESC_SITUACAOALUNO, em.RAZAOSOCIAL AS ESCOLA "
							sql = sql & " FROM MAT_INSCRICAO A"
							sql = sql & " LEFT JOIN SCA_ALUNO AL ON AL.CODIGO = A.COD_ALUNO"
							sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = AL.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
							sql = sql & " LEFT JOIN SEG_EMPRESA EM ON EM.codigo = A.COD_EMPRESA "
							sql = sql & " where A.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO=7)	"	
							if strCodAluno <> "" then
								sql = sql & " and A.COD_ALUNO = " & strCodAluno
							end if
							if strMatricula <> "" then
								sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
							end if
							if strSolicitacao <> "" then
								sql = sql & " and A.CODIGO = " & strSolicitacao
							end if
							if strAluno <> "" then
								sql = sql & " and A.NOME LIKE '%" & strAluno & "%'"
							end if
							if strMae <> "" then
								sql = sql & " and A.MAE LIKE '%" & strMae & "%'"
							end if
							sql = sql & " order by A.NOME"
			
			
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("CODIGO"))%></td>
                                    <td><%=trim(rs("MATRICULA"))%></td>
                                    <td align="center"><%=trim(rs("NOME"))%></td>
                                    <td align="center"><%=trim(rs("MAE"))%></td>
                                    <td align="center"><%=trim(rs("escola"))%></td>
                                    <td align="center"><%=trim(rs("DESC_SITUACAOALUNO"))%></td>
                                    <td align="center" ><%if UCASE(trim(rs("DESC_SITUACAOALUNO")))="PRÉ-MATRÍCULA" OR ISNULL(rs("DESC_SITUACAOALUNO")) then%><button class="btn-u btn-u-red" onClick="remover('<%=rs("codigo")%>','<%=rs("cod_empresa")%>')" type="button"><i class="fa fa-trash-o"></i></button> <%END IF%> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
					    end if	
						%>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function ConsultaMat(){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtCodAluno.value=='' && frm.txtSolicitacao.value=='' && frm.txtMatricula.value=='' && frm.txtAluno.value=='' && frm.txtMae.value==''){
			alert("Deve ser informado pelo menos um dos campos para a consulta ser efetuada.")
			return false;
		}
		else
		{
			frm.submit();		
			}
		
	}
	
	function remover(codInscricao,codEmpresa){
		
		var frm = document.getElementById("frm");
		
		if (!confirm('Deseja excluir essa solicitação?'))
			return false;
		else{
			frm.action="RemoveInscricaoMatricula_cod.asp?txtCodigoEmpresa="+codEmpresa+"&txtCodigoInscricao="+codInscricao;
			frm.submit();
			return true;
		}
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 