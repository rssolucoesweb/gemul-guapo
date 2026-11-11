<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnnDocumento.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formataData.asp"-->
    <!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        pagina								= "EfetivacaoAluno_con.asp"
        Session("MatriculaInformatizada") 	=  "SIM"
		
        strCod_empresa 		= Session("CodEmpresa")
		intCodTipoEmpresa 	= Trim(Request.Form("cmbTipoEmpresa"))
        intInscricao		= Trim(Request("txtInscricao"))
        strNomealuno 		= Trim(Request.Form("txtNomealuno"))
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Efetivação de Alunos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Inscri&ccedil;&atilde;o:</label>
                          <!--#include file="../includes/inc_cmbTipoEmpresa.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Descrição</label>
                          <input name="txtInscricao" type="text" class="form-control" id="txtInscricao" size="20" maxlength="10" value="<%=intInscricao%>"  onKeyPress="return formataCampo(this, 2, 10)" onblur="submit()" style="width:200pt">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Nome do Aluno</label>
                        <input name="txtNomealuno" type="text" class="form-control" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)" onblur="carregaAlunoSeJaExiste()" style="width:200pt">
                    </div>
                    <legend></legend>
                    <input class="btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onclick="return Consultar()">
                    <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onclick="window.location='<%=strPagina%>'">
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Alunos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="6%" bgcolor="#95A5A6">Inscri&ccedil;&atilde;o</th>
                                    <th width="10%" bgcolor="#95A5A6">Data</th>
                                  <th width="8%" bgcolor="#95A5A6">Via</th>
                                    <th width="10%" bgcolor="#95A5A6">Matricula</th>
                                    <th width="17%" bgcolor="#95A5A6">Nome Aluno</th>
                                    <th width="8%" bgcolor="#95A5A6">Data Nasc.</th>
                                    <th width="18%" bgcolor="#95A5A6">M&atilde;e</th>
                                    <th width="7%" bgcolor="#95A5A6">Ser&iacute;e</th>
                                    <th width="6%" bgcolor="#95A5A6">Turno</th>
                                    <th width="4%" bgcolor="#95A5A6">Curso</th>
                                    <th width="6%" bgcolor="#95A5A6">Escola</th>
                                    <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%
							intPagina = 1
							intQtdeRegistroPorPagina = 1
							cont = 0
							
							sql = "SELECT MT.Codigo, MT.Cod_Aluno, MT.matricula, MT.nome, MT.data_nascimento, MT.mae, MT.cep, MT.Logradouro, "
							sql = sql & " MT.bairro, MT.cidade, MT.email, MT.Cod_periodo, MT.Cod_turno, MT.Cod_empresa, "
							sql = sql & " PE.Descricao, T.DESC_TURNO, SEG_EMPRESA.RAZAOSOCIAL, C.Descricao as Curso, MT.Data_hora_Incl as DataInclusao, MT.usuario_incl"
							sql = sql & " FROM MAT_inscricao  MT "
							sql = sql & " inner join SCA_PERIODO PE on PE.Cod_Periodo = MT.Cod_periodo"
							sql = sql & " inner join SCA_CURSO C on C.Cod_curso = PE.Cod_Curso"
							sql = sql & " inner join SCA_TURNO T on T.COD_TURNO = MT.Cod_turno"
							SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = MT.COD_EMPRESA"
							sql = sql & " where  MT.Cod_empresa = " & strCod_empresa
							sql = sql & " And  MT.Situacao = 'S'"
							sql = sql & " And  isnull(MT.Efetivacao,'N') = 'N'"
						
							if intInscricao <> "" then
								sql = sql & " And  MT.Cod_Aluno = " & intInscricao
							end if
							
							if strNomealuno <> "" then
								sql = sql & " And  MT.nome like '%" & strNomealuno & "%'"
							end if
							'response.write sql
							
							rs.open sql, cnn
							cont=0
							if rs.eof = false then
							while not rs.eof
							cont = cont + 1	
							%>
                            <tbody>
                                <tr>
                                    <td><%=rs("Cod_Aluno")%></td>
                                    <td><%=rs("DataInclusao")%></td>
                                    <td ><%=rs("usuario_incl")%> </td>  
                                    <td ><%=rs("matricula")%> </td>  
                                    <td ><%=rs("nome")%> </td>  
                                    <td ><%=formatadataAP(rs("data_nascimento"))%> </td>  
                                    <td ><%=rs("mae")%> </td>  
                                    <td ><%=rs("Descricao")%> </td>  
                                    <td ><%=rs("DESC_TURNO")%> </td>  
                                    <td ><%=rs("Curso")%> </td>  
                                    <td ><%=rs("RAZAOSOCIAL")%> </td>  
                                    <td ><button class="btn-u btn-u-sea" onclick="Confirmar(<%=rs("Cod_Aluno")%>)" type="button"><i class="fa fa-file-text-o"></i></button></td>  
                                </tr>
                            </tbody>
                            <%			
								cont = cont + 1
								intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
				
								rs.movenext
								wend
							end if
							rs.close
						%>
                        </table>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
		function Confirmar(CodAluno){
			var form = document.getElementById("frm");
			frm.action = "ConfirmacaoAluno_con.asp?txtCodAluno="+CodAluno;
			frm.submit();
			return true;	
		}
		function Consultar(){
			var caminho;
			frm.submit();
			return true;	
		}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 