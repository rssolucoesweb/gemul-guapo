<%@ CodePage=65001 %>
<% Response.Charset = "UTF-8" %>

<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formataCPF.asp"-->
<!--#include file="../menuModulos.asp"-->  
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
		function validaCPFColaborador(campo) {
            var pcpf=campo.value;
            
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace(".","");
            pcpf = pcpf.replace("-","");
            
            if (pcpf != "") {
            
                if (pcpf.length != 11){
                    sim=false;
                }
                else{
                    sim=true;
                }
                
                if ( (pcpf==11111111111) || (pcpf==22222222222) ||
                    (pcpf==33333333333) || (pcpf==44444444444) || (pcpf==55555555555) ||
                    (pcpf==66666666666) || (pcpf==77777777777) || (pcpf==88888888888) ||
                    (pcpf==99999999999) || (pcpf==00000000000) ){
                        sim=false;
                }
                
                if(sim){
                    for (i=0; i<=(pcpf.length-1) && sim; i++){
                        val = pcpf.charAt(i);
                        if((val!="9")&&(val!="0")&&(val!="1")&&(val!="2")&&(val!="3")&&(val!="4")&&( val!="5")&&(val!="6")&&(val!="7")&&(val!="8")){
                            sim=false;
                        }
                    }
                
                    if(sim){
                        soma=0;
                        for (i=0;i<=8;i++){
                            val = eval(pcpf.charAt(i));
                            soma = soma + (val*(i+1));
                        }
                    
                        resto = soma % 11;
                        
                        if (resto>9)
                            dig = resto -10;
                        else
                            dig = resto;
                        
                    
                        if (dig != eval(pcpf.charAt(9))){
                            sim=false
                        }else{
                            soma = 0
                            for (i=0;i<=7;i++){
                                val = eval(pcpf.charAt(i+1))
                                soma = soma +	(val*(i+1))
                            }
                            soma = soma + (dig * 9)
                            resto = soma % 11
                            if (resto>9){
                                dig = resto -10
                            }else{
                                dig = resto
                            }
                    
                            if (dig != eval(pcpf.charAt(10))){
                                sim = false
                            }else{
                                sim = true
                            }
                        }
                    }
                }
                
                if (!sim){
                    alert("CPF inválido!");
					campo.value="";
                    campo.focus();
                    campo.select();
                }
                        
            }
        }
</script>

    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Gerencial</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
	strPaginaTitulo = "Rel_ConsultarAluno_con.asp"
	strPagina = "Rel_ConsultarAluno_con.asp"
	
	strExecutarSubmitSemestre = "S"
	strExecutarSubmit = "S"
	
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	strNomedoAluno		    = Trim(Request.Form("txtNomedoAluno"))
	strCPF					= formataCpfBD(Request.Form("txtCPF"))
	strMatricula		    = Trim(Request.Form("txtMatricula"))
	intCodEmpresaUsuario    = request.Form("cmdEmpresaUsuario")

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodSemestre = "" then intCodSemestre = "0"
	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	%>
    <!--=== Content Part ===-->
   <form method="post" id="frm" action="#">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta Alunos</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                
                	<input name="txtCodigo" type="hidden" class="text" id="txtCodigo" value="<%=intCodigo%>" size="10">
					<div class="form-group">
							<label class="form-label">Ano Letivo:</label>
							<input name="txtAnoLetivo" type="text" class="form-control" id="txtAnoLetivo" value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
					</div>
					<div class="form-group">
                        <label class="form-label">Buscar pelo CPF</label>
                         <input name="txtCPF" type="text" class="form-control" id="txtCPF" style="width:150pt" value="<%=formataCpfAP(strCPF)%>" size="14" maxlength="20" onkeypress="return formataCampo(this,5,14)" onblur="return validaCPFColaborador(this)"  >
                    </div>
                    <div class="form-group">
                        <label class="form-label">Buscar pela Matrícula</label>
                         <input name="txtMatricula" type="text" class="form-control" id="txtMatricula" style="width:150pt" value="<%=strMatricula%>" size="20" maxlength="20" onkeypress="return formataCampo(this,2,9)">
                    </div>
					<div class="form-group">
                        <label class="form-label">Buscar pelo Nome</label>
                         <input name="txtNomedoAluno" type="text" class="form-control" id="txtNomedoAluno" style="width:350pt" value="<%=strNomedoAluno%>" size="80" maxlength="100"  >
                    </div>
				
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta.asp"-->
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Alunos</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="8%" bgcolor="#95A5A6">Matr&iacute;cula</th>
									<th width="12%" bgcolor="#95A5A6">CPF</th>
                                    <th width="27%" bgcolor="#95A5A6">Nome</th>
                                    <th width="10%" bgcolor="#95A5A6">Dt.Nascimento</th>
                                  <th width="20%" bgcolor="#95A5A6">Turma</th>
                                    <th width="25%" bgcolor="#95A5A6">Local</th>
                                    <th width="23%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
									<th width="10%" bgcolor="#95A5A6">Turno</th>
									<th width="5%" bgcolor="#95A5A6">Ano Letivo</th>
                                </tr>
                            </thead>
                            <%
							 if trim(strNomedoAluno) <> "" or trim(strCPF) <> "" or trim(strMatricula) <> "" then
							
								cont = 0
								'SQL = " SELECT  " & vbCrLf
								'SQL = SQL & "     A.CODIGO,  " & vbCrLf
								'SQL = SQL & "     A.CPF,  " & vbCrLf
								'SQL = SQL & "     A.MATRICULA,  " & vbCrLf
								'SQL = SQL & "     A.FONECELULAR,  " & vbCrLf
								'SQL = SQL & "     A.DATANASCIMENTO,  " & vbCrLf
								'SQL = SQL & "     A.MAE,  " & vbCrLf
								'SQL = SQL & "     A.NOMEALUNO,  " & vbCrLf
								'SQL = SQL & "     CC.ANO_LETIVO,  " & vbCrLf
								'SQL = SQL & "     CC.COD_EMPRESA,  " & vbCrLf
								'SQL = SQL & "     CC.UNIDADE,  " & vbCrLf
								'SQL = SQL & "     A.DATAMATRICULA,  " & vbCrLf
								'SQL = SQL & "     SA.DESC_SITUACAOALUNO,  " & vbCrLf
								'SQL = SQL & "     TT.Desc_Turno,  " & vbCrLf
								'SQL = SQL & "     TT.NomeTurma,  " & vbCrLf
								'SQL = SQL & "     TT.TurmaAluno,  " & vbCrLf
								'SQL = SQL & "     TT.PERIODO  " & vbCrLf
								'SQL = SQL & " FROM SCA_ALUNO A  " & vbCrLf
								'
								'SQL = SQL & " OUTER APPLY (  " & vbCrLf
								'SQL = SQL & "     SELECT TOP 1 WITH TIES  " & vbCrLf
								'SQL = SQL & "         C.ANO_LETIVO,  " & vbCrLf
								'SQL = SQL & "         C.COD_EMPRESA,  " & vbCrLf
								'SQL = SQL & "         C.COD_SITUACAOALUNO,  " & vbCrLf
								'SQL = SQL & "         CAST(E.CODIGO_CENSO AS VARCHAR) + ' - ' + E.RAZAOSOCIAL AS UNIDADE  " & vbCrLf
								'SQL = SQL & "     FROM SCA_CONTROLE_SITUACAO_ALUNO C  " & vbCrLf
								'SQL = SQL & "     INNER JOIN SEG_EMPRESA E ON E.CODIGO = C.COD_EMPRESA  " & vbCrLf
								'SQL = SQL & "     WHERE C.COD_ALUNO = A.CODIGO  " & vbCrLf
								'SQL = SQL & "     ORDER BY ROW_NUMBER() OVER (  " & vbCrLf
								'SQL = SQL & "         PARTITION BY C.ANO_LETIVO  " & vbCrLf
								'SQL = SQL & "         ORDER BY C.CODIGO DESC  " & vbCrLf
								'SQL = SQL & "     )  " & vbCrLf
								'SQL = SQL & " ) CC  " & vbCrLf
								'
								'SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = CC.COD_SITUACAOALUNO  " & vbCrLf
								'
								'SQL = SQL & " OUTER APPLY (  " & vbCrLf
								'SQL = SQL & "     SELECT TOP 1 WITH TIES  " & vbCrLf
								'SQL = SQL & "         AT2.ANO_LETIVO,  " & vbCrLf
								'SQL = SQL & "         AT2.COD_TURMA,  " & vbCrLf
								'SQL = SQL & "         T2.TurmaAluno,  " & vbCrLf
								'SQL = SQL & "         T2.NomeTurma,  " & vbCrLf
								'SQL = SQL & "         TUR.Desc_Turno,  " & vbCrLf
								'SQL = SQL & "         PE.Descricao as PERIODO  " & vbCrLf
								'SQL = SQL & "     FROM SCA_ALUNO_TURMA AT2  " & vbCrLf
								'SQL = SQL & "     INNER JOIN SCA_TURMA T2 ON T2.Cod_Turma = AT2.COD_TURMA  " & vbCrLf
								'SQL = SQL & "     INNER JOIN SCA_TURNO TUR ON TUR.COD_TURNO = T2.COD_TURNO  " & vbCrLf
								'SQL = SQL & "     INNER JOIN SCA_PERIODO PE ON PE.Cod_Periodo = T2.Cod_periodo  " & vbCrLf
								'SQL = SQL & "     WHERE AT2.COD_ALUNO = A.CODIGO  " & vbCrLf
								'SQL = SQL & "       AND AT2.ANO_LETIVO = CC.ANO_LETIVO  " & vbCrLf
								'SQL = SQL & "     ORDER BY AT2.CODIGO DESC  " & vbCrLf
								'SQL = SQL & " ) TT  " & vbCrLf
								'if strNomedoAluno <> ""  then
								'	SQL = SQL & " WHERE A.NOMEALUNO COLLATE Latin1_General_CI_AI LIKE '%" & strNomedoAluno & "%'  " & vbCrLf
								'end if
								'
								'SQL = SQL & " ORDER BY A.NOMEALUNO, CC.ANO_LETIVO  " & vbCrLf
								
								
								SQL = "SET NOCOUNT ON "
								SQL = SQL & " SELECT MAX(AT.codigo) AS codigo_SCA_ALUNO_TURMA,"
								SQL = SQL & "        AT.ANO_LETIVO,"
								SQL = SQL & "        AT.COD_ALUNO,"
								SQL = SQL & "        AT.COD_EMPRESA "
								SQL = SQL & " INTO #SCA_ALUNO_TURMA"
								SQL = SQL & " FROM SCA_ALUNO_TURMA AT"
								SQL = SQL & " INNER JOIN SCA_ALUNO A ON AT.COD_ALUNO = A.CODIGO"
								SQL = SQL & " WHERE A.NOMEALUNO COLLATE Latin1_General_CI_AI LIKE '%" & strNomedoAluno & "%'"
								SQL = SQL & " GROUP BY AT.ANO_LETIVO,"
								SQL = SQL & "          AT.COD_ALUNO,"
								SQL = SQL & "          AT.COD_EMPRESA"

								SQL = SQL & " select max(codigo) as cod_controle_situacao_aluno, cod_aluno, COD_EMPRESA, ano_letivo"
								SQL = SQL & " into #sca_controle_situacao_aluno"
								SQL = SQL & " from sca_controle_situacao_aluno"
								SQL = SQL & " where cod_aluno in (select cod_aluno from #SCA_ALUNO_TURMA)"
								SQL = SQL & " GROUP BY ANO_LETIVO,"
								SQL = SQL & " COD_ALUNO,"
								SQL = SQL & " COD_EMPRESA,"
								SQL = SQL & " ano_letivo"


								SQL = SQL & " select c.cod_aluno, c.COD_EMPRESA, c.ano_letivo, c.COD_SITUACAOALUNO"
								SQL = SQL & " into #sca_controle_situacao_aluno_final"
								SQL = SQL & " from sca_controle_situacao_aluno c"
								SQL = SQL & " inner join #sca_controle_situacao_aluno cc on c.codigo = cc.cod_controle_situacao_aluno"
								

								SQL = SQL & " SELECT distinct AT.ANO_LETIVO,"
								SQL = SQL & "        AT.COD_ALUNO,"
								SQL = SQL & "        AT.COD_EMPRESA,"
								SQL = SQL & "        TU.Desc_Turno,"
								SQL = SQL & "        T.NomeTurma,"
								SQL = SQL & "        T.TurmaAluno,"
								SQL = SQL & "        P.DESCRICAO AS PERIODO INTO #ALUNO_TURMA"
								SQL = SQL & " FROM #SCA_ALUNO_TURMA AT"
								SQL = SQL & " INNER JOIN SCA_ALUNO_TURMA ATT ON ATT.CODIGO = AT.codigo_SCA_ALUNO_TURMA"
								SQL = SQL & " INNER JOIN SCA_TURMA T ON ATT.COD_TURMA = T.Cod_Turma"
								SQL = SQL & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = T.Cod_periodo"
								SQL = SQL & " INNER JOIN SCA_TURNO TU ON TU.Cod_Turno = T.Cod_Turno"
								SQL = SQL & " SELECT distinct A.CODIGO,"
								SQL = SQL & "        IIF(AA.ANO_LETIVO<2026, 'TRANSFERIDO', iif(SA_f.DESC_SITUACAOALUNO is null,SA.DESC_SITUACAOALUNO,SA_f.DESC_SITUACAOALUNO)) AS DESC_SITUACAOALUNO,"
								SQL = SQL & "        A.CPF,"
								SQL = SQL & "        A.MATRICULA,"
								SQL = SQL & "        A.FONECELULAR,"
								SQL = SQL & "        A.DATANASCIMENTO,"
								SQL = SQL & "        A.MAE,"
								SQL = SQL & "        A.NOMEALUNO,"
								SQL = SQL & "        AA.ANO_LETIVO,"
								SQL = SQL & "        AA.COD_EMPRESA,"
								SQL = SQL & "        E.CODIGO_CENSO + ' - ' + E.RAZAOSOCIAL AS UNIDADE,"
								SQL = SQL & "        A.DATAMATRICULA,"
								SQL = SQL & "        TT.Desc_Turno,"
								SQL = SQL & "        TT.NomeTurma,"
								SQL = SQL & "        TT.TurmaAluno,"
								SQL = SQL & "        TT.PERIODO"
								SQL = SQL & " FROM SCA_ALUNO A"
								SQL = SQL & " INNER JOIN SCA_ALUNO_ANO_LETIVO AA ON aa.COD_ALUNO = a.CODIGO"
								SQL = SQL & " INNER JOIN SEG_EMPRESA E ON E.CODIGO = AA.COD_EMPRESA"
								SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = AA.COD_SITUACAOALUNO"
								SQL = SQL & " LEFT JOIN #ALUNO_TURMA TT ON TT.COD_ALUNO = AA.COD_ALUNO"
								SQL = SQL & " left join #sca_controle_situacao_aluno_final cc on cc.COD_ALUNO = a.codigo and aa.ANO_LETIVO = cc.ANO_LETIVO and aa.COD_EMPRESA = cc.COD_EMPRESA"
								SQL = SQL & " INNER JOIN SCA_SITUACAOALUNO SA_f ON SA_f.Cod_SituacaoAluno = cc.COD_SITUACAOALUNO"
								SQL = SQL & " AND TT.COD_EMPRESA = AA.COD_EMPRESA"
								SQL = SQL & " AND TT.ANO_LETIVO = AA.ANO_LETIVO"
								SQL = SQL & " WHERE 1=1"
								if strNomedoAluno<>"" then
									SQL = SQL & " and A.NOMEALUNO COLLATE Latin1_General_CI_AI LIKE '%" & strNomedoAluno & "%'"
								end if
								IF strAnoLetivo <>"" then
									SQL = SQL & " AND AA.ANO_LETIVO = " & strAnoLetivo
								END IF
								IF strCPF <>"" then
									SQL = SQL & " AND replace(replace(A.CPF,'.',''),'-','') = '" & strCPF & "'"
								END IF
								IF strMatricula <>"" then
									SQL = SQL & " AND A.MATRICULA = '" & strMatricula & "'"
								END IF
								SQL = SQL & " ORDER BY A.NOMEALUNO, AA.ANO_LETIVO, DESC_SITUACAOALUNO DESC"
								
								rs.open sql, cnn
								if rs.eof = false then
								while not rs.eof
									strCodigoAluno        = rs("codigo")
									strMatricula		  = rs("MATRICULA")

								%>
								<tbody>
									<tr>
										<td><%=strMatricula%></td>
										<td><%=rs("CPF")%></td>
										<td><%=rs("NOMEALUNO")%></td>
										<td><%=rs("DATANASCIMENTO")%></td>
                                        <td><%=rs("PERIODO")%><br><%=rs("NOMETURMA")%><br><%=rs("TurmaAluno")%></td>
                                        <td><%=rs("UNIDADE")%></td>
                                        <td><%=rs("DESC_SITUACAOALUNO")%></td>
										<td><%=rs("Desc_Turno")%></td>
										<td><%=rs("ano_letivo")%></td>
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
        </form>   
    </div>
  

    <!--/container-->		
   <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 