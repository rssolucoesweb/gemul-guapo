<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Regime 
-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnnDocumento.asp"-->
<!--#include file="../../includes/inc_log.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	'on error resume next
	'----------Inicia uma tranzação--------------
	cnn.begintrans
	acao 						= Trim(Request.QueryString("acao"))
	intCodEmp			        = Session("CodEmpresa")
	intCodigo			        = trim(request("txtCodigo"))
	intCodProfessor		        = trim(request("cmbProfessor"))
	intCodDisciplina            = trim(request("cmbDisciplinaDoProfessor"))
	strAnoLetivo 		        = Trim(Request("txtAnoLetivo"))
	strMesLancamento 		    = month(Trim(Request("txtDataLancamento")))
	strAnoLancamento			= year(Trim(Request("txtDataLancamento")))
	
 	strCpfTurmaProfessor = ""
    sql = " Select ISNULL(CPF,'') AS CPF, CODIGO_SEG_USUARIOS_SISTEMA"
	sql = sql & " from SRH_COLABORADOR "
	sql = sql & " where codigo = " & intCodProfessor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs1.open sql, cnn
	if rs1.eof = false then
		strCpfTurmaProfessor = TRIM(rs1("CPF"))
		strPara = TRIM(rs1("CODIGO_SEG_USUARIOS_SISTEMA"))
	end if
	rs1.close

	intMesConteudoProgramatico = "1"
	sql = " SELECT top 1 Bloqueia_ConteudoProgramatico "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
	rs.Open SQL, cnn
	if rs.EOF = false then								
		intMesConteudoProgramatico = rs("Bloqueia_ConteudoProgramatico")
	end if
	rs.close
	
	if intMesConteudoProgramatico >= month(strDataInicial) then
		%>
		<script>
			alert("ATENÇÃO: \n\nMês Bloqueado para Liberação, procure a Secretaria Geral.");
			window.location='Conteudo_cad.asp';
		</script>
		<%	
		response.End()
	end if	
	
	sql = "SELECT * FROM SCA_CONTEUDO"
	sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
	sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplina
	sql = sql & " AND YEAR(DATAINICIAL)= " & strAnoLancamento
	sql = sql & " AND MONTH(DATAINICIAL) = " & strMesLancamento 
	sql = sql & " AND COD_COLABORADOR in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')"
	rs.open sql, cnn
	if rs.eof = false then
	   strMensagem = "Registro LIBERADO com sucesso..."
	else   
	   strMensagem = "Não Existem Registros para Liberação. Verifique!"
   	   cnn.commitTrans
	   %>
	   <script>
		 alert("<%=strMensagem%>");
		 window.history.back();
	   </script>
	   <%
	   response.end
    end if
	rs.close

	sql = "UPDATE SCA_CONTEUDO SET FECHAMENTO = 'N' "
	sql = sql & " WHERE COD_EMPRESA = " & intCodEmp
	sql = sql & " AND COD_DISCIPLINA = " & intCodDisciplina
	sql = sql & " AND YEAR(DATAINICIAL)= " & strAnoLancamento
	sql = sql & " AND MONTH(DATAINICIAL) = " & strMesLancamento 
	sql = sql & " AND COD_COLABORADOR in (select codigo From SRH_COLABORADOR WHERE cpf = '" & strCpfTurmaProfessor &"')" 
	cnn.execute sql
	GravarLog sql


   'Para envio da notificacao de devolucao ao professor
	strDe						= session("UsuarioWeb")
	'strPara                    = Valor recebido select colaborador
	strAssunto  				= "Devolução de Conteúdo Programático - Correção"
	strRecado	 				= Replace(Trim(Request.Form("txtRecado")),"'","")
	strData			 			= formataDataBD(date)
	strHora			 			= time
	strStatus					= 1
	
	if strPara <> ""  then 
		sql = "Insert Into SEG_Recados(De, Para, Assunto, recado, data, hora, status )"
		sql = sql & " Values ("
		sql = sql & "'" & strDe & "',"
		sql = sql & "'" & strPara & "',"
		sql = sql & "'" & strAssunto & "',"
		if strRecado <> "" then
			sql = sql & "'" & strRecado & "',"
		else
			sql = sql & " null, " 
		end if
		sql = sql & "'" & strData & "',"
		sql = sql & "'" & strHora & "',"
		sql = sql & "" & strStatus & ")"
		cnn.execute sql
		GravarLog sql
	end if	
	
	if err.number = 0 then
	'----------Finaliza tranzação iniciada--------------
		cnn.commitTrans
		%>
		<script>
			alert("<%=strMensagem%>");
			window.location='Conteudo_cad.asp';
		</script>
		<%
		response.end
	else
		cnn.rollbackTrans
		%>
		<script>
			alert("ATENÇÃO: \n\nNão foi possível executar esse procedimento, tente novamente.\nCaso persistir entre em contato com o administrador do sistema.");
			window.history.back();
		</script>
		<%
	end if
%>