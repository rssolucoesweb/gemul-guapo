<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/02/2008
	::	Desenvolvedores...: Sérgio Borges - sergiob76@gmail.com
	::	Objetivo Pagina...: Posição financeira
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #009900}
-->
</style>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../images/botao_azul_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="topo.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function carregaAluno(){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtMatricula.value != ""){
			frm.action="PortalAluno_PosicaoFinanceira_cad.asp"
			frm.submit();
		}
	}
	function AbreFecha(Linha,Figura){
		if (Linha.style.display == "block"){
			Linha.style.display = "none";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/plus.bmp"
		}
		else{
			Linha.style.display = "block";
			Figura.src="<%=session("strCaminhoRaiz")%>/images/minus.bmp"
		}
	}
		
	function geraBoleto(PaginaBoleto, cod) {
	
		var frm = document.getElementById("frm");
		
		frm.action = "../SCF/"+PaginaBoleto+"?codBebitoAluno=" + cod;
		frm.submit();
	}
	
	function linhaMouseOver(linha){
		linha.style.backgroundColor="#D5EAFF";
		return true;
	}
	
	function linhaMouseOut(linha){
		linha.style.backgroundColor="";
		return true;
	}	
</script>
<%
	strMostraBotaoConsultaPrincipal = "S"
	strMostraBotaoConsultaRetornar 	= "N"

	strDataAtual 		= formataDataCalc(DATE)
	intCodEmpresa		= Session("CodEmpresa")	
	intCodigo	 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))

	intCodAluno				= trim(Session("CodSeguranca"))
	strMatricula			= trim(Session("UsuarioWeb"))

	intCodFuncionario   = ""
	intCodComunidade    = ""
	strTipoAluno 	    = "checked"
	strDescricaoUsuario	= "Aluno"

	CodigoPosicaoFinanceira = ""
	
	
	'busca informações ano e semestre letivo
	sql = " SELECT top 1 Habilitar_PreMatricula, isnull(NC_Matricula_Documentacoes,'N') as NC_Matricula_Documentacoes, isnull(NC_Matricula_Biblioteca,'N') as NC_Matricula_Biblioteca, isnull(Bloqueia_BoletoPortalAluno,'N') as Bloqueia_BoletoPortalAluno"
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & intCodEmpresa 
	sql = sql & " order by ano_letivo desc"
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strHabilitarPreMatricula = trim(rs("Habilitar_PreMatricula"))
		if isnull(strHabilitarPreMatricula) then strHabilitarPreMatricula = "N"
		strNadaConstaDocumentos = trim(rs("NC_Matricula_Documentacoes"))
		strNadaConstaBiblioteca = trim(rs("NC_Matricula_Biblioteca"))
		strBloqueiaBoletoPortalAluno = trim(rs("Bloqueia_BoletoPortalAluno"))
	else
		%>
		<script>
			alert("ATENÇÃO: Período Letivo não Habilitado, procure a Secretaria Geral.");
			window.close();
		</script>
		<%
		response.end
	end if
	rs.close
	
	if strBloqueiaBoletoPortalAluno = "S" then
		%>
		<script>
			alert("ATENÇÃO: Emissão de boleto indisponível, procure a Tesouraria.");
			window.location.href = 'DEFAULT.ASP'
		</script>
		<%
		response.end
	end if	

	if strMatricula <> "" then
	    matriculaLocalizada = false
		sql = "SELECT matricula, codigo, nomealuno"
		sql = sql & " FROM SCA_ALUNO "
		sql = sql & " Where COD_EMPRESA = " & intCodEmpresa
		sql = sql & " And 	matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			intCodAluno			    = TRIM(rs("Codigo"))
			CodigoPosicaoFinanceira = TRIM(rs("Codigo"))
			strMatricula 		    = TRIM(rs("Matricula"))
			strNomealuno 		    = TRIM(rs("Nomealuno"))
			matriculaLocalizada     = true
		else
		   %>
		   <script>
			   alert("Aluno não foi encontrado.");
		   </script>
		   <%
		end if	
		rs.close
	end if
		

%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="99%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td align="center" class="tituloSistema"><strong>IMPRESS&Atilde;O DE BOLETO(S) </strong></td>
            </tr>
          </table>
		  <br>
		  <table width="99%" border="0" cellspacing="0" cellpadding="0">
          
          <tr>
            <td colspan="4">&nbsp;</td>
          </tr>
           <tr>
            <td colspan="4"></td>
          </tr>
        </table>
	    <%	if CodigoPosicaoFinanceira <> "" then %>
		      <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
			    <% if intDbtoNp <> 0 or intDbtocheque<> 0 then %>
					
				<%end if%>	
                <tr bgcolor="#E5E5E5"> 
                  <td colspan="14" class="celula"><div align="center"><strong>Informa&ccedil;&otilde;es 
                      Financeiras do Aluno </strong></div></td>
                </tr>
                <tr bgcolor="#E5E5E5"> 
                  <td width="3%" class="celula"><div align="center"><strong>Ano</strong></div></td>
                  <td width="4%" class="celula"><div align="center"><strong>Parc.</strong></div></td>
                  <td width="3%" class="celula"><div align="center"><strong>Tipo</strong></div></td>
                  <td width="8%" class="celula"><div align="center"><strong>Turma</strong></div></td>
                  <td width="3%" class="celula"><div align="center"><strong>Doc.</strong></div></td>
                  <td width="5%" class="celula"><div align="center"><strong>Acresc.</strong></div></td>
                  <td width="7%" class="celula"><div align="center"><strong>Dt.Vencto</strong></div></td>
                  <td width="4%" class="celula"><div align="center"><strong>Dt. Pagto</strong></div></td>
                  <td width="4%" class="celula"><div align="center"><strong>Valor Nominal </strong></div></td>
                  <td width="5%" class="celula"><div align="center"><strong>Vr. Pago</strong></div></td>
                  <td width="2%" class="celula"><div align="center"><strong>Sit.</strong></div></td>
                  <td width="2%" class="celula"><div align="center"><strong>Via</strong></div></td>
                  <td colspan="2" class="celula"><div align="center"><strong>Impress&atilde;o</strong></div></td>
                </tr>
                <%
			sql = "SELECT DE.codigo,"
		    sql = sql & " 	DE.Cod_Aluno,"
		    sql = sql & "	A.NOMEALUNO,"
			sql = sql & "	DE.Ano,"
			sql = sql & "	DE.Parcela,"
			sql = sql & "	TP.DESC_TIPO,"
			sql = sql & "	DE.Cod_TipoParcela,"
			sql = sql & "	DE.OutrosDescontos,"
			sql = sql & "	DE.Perc_Desconto,"
			sql = sql & "	DE.Perc_Desconto2,"
			sql = sql & "	DE.Perc_Desconto3,"
			sql = sql & "	DE.Perc_Desconto4,"
			sql = sql & "	DE.OutrosAcrescimo,"
			sql = sql & "	DE.Vencimento1,"
			sql = sql & "	DE.Vencimento2,"
			sql = sql & "	DE.Vencimento3,"
			sql = sql & "	DE.Vencimento4,"
			sql = sql & "	DE.Valor1,"
			sql = sql & "	DE.Valor2,"
			sql = sql & "	DE.Valor3,"
			sql = sql & "	DE.Valor4,"
			sql = sql & "	DE.COD_SITUACAO_PAGAMENTO,"
			sql = sql & "	SI.DESCRICAO AS SITUACAO,"
			sql = sql & "	DE.DATAPAGAMENTO,"
			sql = sql & "	DE.ValorTotalPago,"
			sql = sql & "	DE.mora,"
			sql = sql & "	DE.multa,"
			sql = sql & "	DE.NUMEROVIA, TX.DESCRICAO AS DESC_TAXA, TU.NOMETURMA, DE.CODIGO, PP.MATRICULA, CT.PaginaBoleto "
			sql = sql & " FROM SCF_DEBITOALUNO DE"
		    sql = sql & " LEFT JOIN SCA_ALUNO A		ON A.CODIGO = DE.COD_ALUNO AND A.COD_EMPRESA = DE.COD_EMPRESA "
			sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP	ON TP.COD_TIPO = DE.Cod_TipoParcela AND DE.COD_EMPRESA = TP.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCF_SITUACAO_PAGAMENTO SI	ON SI.CODIGO = DE.COD_SITUACAO_PAGAMENTO"
			sql = sql & " LEFT JOIN SCF_TAXA TX	ON TX.COD_TAXA = DE.COD_TAXA AND TX.COD_EMPRESA = DE.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCA_TURMA TU ON TU.COD_TURMA = DE.COD_TURMA AND TU.COD_EMPRESA = DE.COD_EMPRESA"
			sql = sql & " LEFT JOIN SCF_PLANOPARCELA PP on PP.codigo = DE.Cod_planoParcela and PP.cod_empresa = DE.Cod_empresa "
			sql = sql & " LEFT JOIN scf_Conta_Corrente CT ON TU.Cod_ContaCorrente = CT.CODIGO "
			sql = sql & " WHERE	DE.COD_EMPRESA	= " & intCodEmpresa
		    sql = sql & " AND	DE.COD_ALUNO     	= " & intCodAluno
		    sql = sql & " AND	DE.COD_SITUACAO_PAGAMENTO 	= 1" 
 			sql = sql & " ORDER BY DE.Cod_TipoParcela, DE.ANO, DE.Vencimento1, DE.PARCELA"
			rs.open sql, cnn
			if rs.eof = false then
				intTotalOutrosDescontos = 0
				intTotalOutrosAcrescimo = 0
				intTotalValorParcela 	= 0
				intTotalValorPagamento 	= 0
				intTotalDebito          = 0
				while not rs.eof
					cont = cont + 1	
					SIT = RS("SITUACAO")
					estiloImagemAberto = ""
					IF RS("COD_SITUACAO_PAGAMENTO") = 1 THEN 
					'DEVE
						estiloImagemAberto = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					end if

					estiloImagemProtesto = ""
					IF RS("COD_SITUACAO_PAGAMENTO") = 6 THEN 
					'PROTESTO
						estiloImagemProtesto = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					END IF

					estiloImagemPago = ""
					IF RS("COD_SITUACAO_PAGAMENTO") = 2 THEN 
					'PAGO
						estiloImagemPago = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					END IF
					
					if rs("parcela") = "999" then
						strParcelaComZero 	= "TX"
					else
						strParcelaComZero 	= string(2-len(rs("parcela")),"0") & rs("parcela")
					end if
					'estiloImagemPagto = ""
					'if not isnull(rs("DATAPAGAMENTO")) then
					'	estiloImagemPagto = "style='cursor:default; Filter: Alpha(Opacity=100, FinishOpacity=0, Style=2, StartX=20, StartY=40, FinishX=0, FinishY=0)'"
					'end if
					ValorTotalPago = ""
					if not isnull(rs("ValorTotalPago")) then
						ValorTotalPago = formatnumber(rs("ValorTotalPago"),2)
					end if
					mostraFuncaoAlteracao = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' onClick='alteracao(""" & TRIM(rs("codigo")) & """)'"
					
					'vencimentoParcela 	= rs("Vencimento1")
					'valorParcela 		= formatnumber(rs("Valor1"),2)

					vencimento1 = formataDataCalc(rs("Vencimento1"))
					if isnull(vencimento1) then vencimento1 = ""
					
		            vencimento2 = formataDataCalc(rs("Vencimento2"))
					if isnull(vencimento2) then vencimento2 = ""
					
			        vencimento3 = formataDataCalc(rs("Vencimento3"))
					if isnull(vencimento3) then vencimento3 = ""

					vencimento4 = formataDataCalc(rs("Vencimento4"))
					if isnull(vencimento4) then vencimento4 = ""

					valor1 		= rs("Valor1")
					valor2 		= rs("Valor2")
					valor3 		= rs("Valor3")
					valor4 		= rs("Valor4")
					
					Desc1 		= rs("Perc_Desconto")
					Desc2 		= rs("Perc_Desconto2")
					Desc3 		= rs("Perc_Desconto3")
					Desc4 		= rs("Perc_Desconto4")

					
					vencimentoParcela 	       = rs("Vencimento1")
					valorParcela 		       = rs("Valor1")
					strParcelaMatricula   	   = Trim(rs("matricula"))
					if isnull(strParcelaMatricula) then strParcelaMatricula = "N"
					strPaginaBoleto 		   = trim(rs("PaginaBoleto"))
					bolMulta	= false
					
					if vencimento2 = "" and vencimento3 = "" and vencimento4 = "" then
					
					   vencimentoParcela 	= rs("Vencimento1")
					   valorParcela 		= rs("Valor1")
					
					elseif vencimento3 = "" and vencimento4 = "" then     ' Testa o 3º vencimento
					
					    if cLng(strDataAtual) > cLng(vencimento2) then
						  	vencimentoParcela 	= rs("Vencimento2")
						  	valorParcela 		= rs("Valor2")
							bolMulta 			= true
					   	elseif cLng(strDataAtual) > cLng(vencimento1) and cLng(strDataAtual) <= cLng(vencimento2) then
						  	vencimentoParcela   = rs("Vencimento1")
						  	valorParcela 		= rs("Valor1")
					   	else
						  	vencimentoParcela   = rs("Vencimento1")
						  	valorParcela 		= rs("Valor1")
						end if  
					
					elseif vencimento4 = "" then    ' Testa o 4º vencimento
					
					    if cLng(strDataAtual) > cLng(vencimento3) then
						  	vencimentoParcela 	= rs("Vencimento3")
						  	valorParcela 		= rs("Valor3")
							bolMulta 			= true
					   	elseif cLng(strDataAtual) > cLng(vencimento2) and cLng(strDataAtual) <= cLng(vencimento3) then
						  	vencimentoParcela   = rs("Vencimento3")
						  	valorParcela 		= rs("Valor3")
					   	elseif cLng(strDataAtual) > cLng(vencimento1) and cLng(strDataAtual) <= cLng(vencimento2) then
						  	vencimentoParcela   = rs("Vencimento2")
						  	valorParcela 		= rs("Valor2")
					   	else
						  	vencimentoParcela   = rs("Vencimento1")
						  	valorParcela 		= rs("Valor1")
						end if  
						
					else

					   if cLng(strDataAtual) > cLng(vencimento4) then
						  	vencimentoParcela 	= rs("Vencimento4")
						  	valorParcela 		= rs("Valor4")
							bolMulta 			= true
					   	elseif cLng(strDataAtual) > cLng(vencimento3) and cLng(strDataAtual) <= cLng(vencimento4) then
						  	vencimentoParcela   = rs("Vencimento4")
						  	valorParcela 		= rs("Valor4")
					   	elseif cLng(strDataAtual) > cLng(vencimento2) and cLng(strDataAtual) <= cLng(vencimento3) then
						  	vencimentoParcela   = rs("Vencimento3")
						  	valorParcela 		= rs("Valor3")
					   	elseif cLng(strDataAtual) > cLng(vencimento1) and cLng(strDataAtual) <= cLng(vencimento2) then
						  	vencimentoParcela   = rs("Vencimento2")
						  	valorParcela 		= rs("Valor2")
					   	else
						  	vencimentoParcela   = rs("Vencimento1")
						  	valorParcela 		= rs("Valor1")
						end if  
					end if

					'validação para o acrescimo de multa e mora
					'Inserir calculo de mora e multa quando o boleto estiver vencido ex:
					if isnull(valorParcela) then
					   valorParcela = 0
					end if   
					strCalculado = valorParcela
					if bolMulta then
						strCalculado = 0
						strNumDiaVencido= dateDiff("d", vencimentoParcela, date)
						strValorMora	= ""
						strValorMultaMora = 0
						if not isnull(rs("Mora")) then
							strMora			= rs("Mora") * strNumDiaVencido
							strValorMora	= (strMora * valorParcela)/100
							strCalculado	= strCalculado + strValorMora
							strValorMultaMora = strValorMultaMora + strValorMora
						end if
						strValorMulta	= ""
						if not isnull(rs("Multa")) then
							strValorMulta	= (rs("Multa") * valorParcela)/100
							strCalculado	= strCalculado + strValorMulta
							strValorMultaMora = strValorMultaMora + strValorMulta
						end if
						if strValorMultaMora = 0 then 
							strValorMultaMora = ""
						else
							'strValorMultaMora = formatNumber(strValorMultaMora,2)
						end if
						strCalculado		= formatNumber(strCalculado + valorParcela,2) 
						if strCalculado - fix(strCalculado) <> 0 then
						   strCalculado = fix(strCalculado) + 1
						end if   
						'vencimentoParcela 	= DateAdd("d", 2, date)
					end if	
					if strCalculado = "" then
				      	strCalculado = 0
					end if   
					
					IF strParcelaMatricula = "S" then
					    strMostraParcelaMatricula = "N"
						sql = " SELECT DE.codigo, PP.MATRICULA "
						sql = sql & " FROM SCF_DEBITOALUNO DE "
						sql = sql & " LEFT JOIN SCA_ALUNO A ON A.CODIGO = DE.COD_ALUNO AND A.COD_EMPRESA = DE.COD_EMPRESA "
						sql = sql & " LEFT JOIN SCF_TIPOPARCELA TP ON TP.COD_TIPO = DE.Cod_TipoParcela AND DE.COD_EMPRESA = TP.COD_EMPRESA "
						sql = sql & " LEFT JOIN SCF_SITUACAO_PAGAMENTO SI ON SI.CODIGO = DE.COD_SITUACAO_PAGAMENTO "
						sql = sql & " LEFT JOIN SCF_TAXA TX ON TX.COD_TAXA = DE.COD_TAXA AND TX.COD_EMPRESA = DE.COD_EMPRESA "
						sql = sql & " LEFT JOIN SCA_TURMA TU ON TU.COD_TURMA = DE.COD_TURMA AND TU.COD_EMPRESA = DE.COD_EMPRESA "
						sql = sql & " LEFT JOIN SCF_PLANOPARCELA PP on PP.codigo = DE.Cod_planoParcela and PP.cod_empresa = DE.Cod_empresa "
						sql = sql & " WHERE	DE.COD_EMPRESA	= " & intCodEmpresa
						sql = sql & " AND	DE.COD_ALUNO   	= " & intCodAluno 
						sql = sql & " AND DE.COD_SITUACAO_PAGAMENTO = 1 "
						sql = sql & " AND PP.MATRICULA = 'N' "
						rsaux.open sql, cnn
						if rsaux.eof = true then
						   strMostraParcelaMatricula = "S"
						end if  
						rsaux.close
						'
						sql = " SELECT CODIGO FROM SCF_DEBITOALUNO_CHEQUES "
						sql = sql & " WHERE COD_EMPRESA = " & intCodEmpresa
						sql = sql & " AND TIPO = 'NP' "
						sql = sql & " AND COD_SITUACAO_CHEQUE <> 1 "
						sql = sql & " AND	COD_ALUNO = " & intCodAluno 
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strMostraParcelaMatricula = "N"
							%>
						    <script>
							   alert("Pendência de NOTA PROMISSÓRIA. Procure a Tesouraria");
						    </script>
						    <%
						end if
						rsaux.close
						'
						sql = " SELECT CODIGO FROM SCF_DEBITOALUNO_CHEQUES "
						sql = sql & " WHERE COD_EMPRESA = " & intCodEmpresa
						sql = sql & " AND TIPO = 'CH' "
						sql = sql & " AND COD_SITUACAO_CHEQUE <> 1 "
						sql = sql & " AND	COD_ALUNO = " & intCodAluno 
						rsaux.open sql, cnn
						if rsaux.eof = false then
							strMostraParcelaMatricula = "N"
							%>
						    <script>
							   alert("Pendência de CHEQUE. Procure a Tesouraria");
						    </script>
						    <%
						end if
						rsaux.close

						if strNadaConstaDocumentos = "S" then
							sql = " Select Cod_aluno, Cod_documentacoes, data_prorrogacao, situacao, doc.descricao "
							sql = sql & " From SCA_ALUNO_DOCUMENTACOES  AD "
							sql = sql & " inner JOIN SCA_DOCUMENTACOES Doc ON AD.Cod_documentacoes = Doc.Codigo "
							sql = sql & " Where AD.Cod_aluno = " & intCodAluno
							sql = sql & " and convert(datetime,convert(varchar, data_prorrogacao, 103),103) <  convert(datetime, GETDATE(),103) "
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strMostraParcelaMatricula = "N"
								%>
								<script>
								   alert("Verifique sua Documentação. Procure a Secretaria");
								</script>
								<%
							end if
							rsaux.close
						end if
						
						if strNadaConstaBiblioteca = "S" then
							sql = " select * from scb_emprestimo e "
							sql = sql & " inner join scb_emprestimoitens i on e.Cod_Emprestimo = i.Cod_Emprestimo "
							sql = sql & " where	e.cod_empresa = " & intCodEmpresa
							sql = sql & " and i.Status = 'A' "
							sql = sql & " and e.situacao = 'E' "
							sql = sql & " and convert(datetime,convert(varchar, i.DataDevolucao, 103),103) <  convert(datetime, GETDATE(),103) "
							sql = sql & " and e.cod_Aluno = " & intCodAluno
							rsaux.open sql, cnn
							if rsaux.eof = false then
								strMostraParcelaMatricula = "N"
								%>
								<script>
								   alert("Verifique sua situação junto a Biblioteca.");
								</script>
								<%
							end if
							rsaux.close
						end if	
						
					end if				
					'1	DEVE
					'2	PAGO
					'3	ABONO
					'4	100%
					'5	ADVOGADO
					'6	PROTESTO
					%>
                <tr> 
	              <td class="celula9" align="center">&nbsp;<%=rs("ano")%>&nbsp;</td>
                  <td class="celula9" align="center">&nbsp;<%=strParcelaComZero%>&nbsp;</td>
                  <td class="celula9">&nbsp;<%=rs("DESC_TIPO")%>&nbsp;<%=rs("DESC_TAXA")%></td>
                  <td class="celula9" align="right">&nbsp;<%=rs("NOMETURMA")%>&nbsp;</td>
                  <td class="celula9" align="right">&nbsp;<%=rs("CODIGO")%>&nbsp;</td>
                  <td class="celula9" align="right">&nbsp;<%=formatnumber(rs("OutrosAcrescimo"),2)%>&nbsp;</td>
                  <td class="celula9" align="center">&nbsp;<%=formatadataAP(vencimentoParcela)%>&nbsp;</td> 
                  <td class="celula9" align="center">&nbsp;<%=formatadataAP(rs("DATAPAGAMENTO"))%>&nbsp;</td>
                  <td class="celula9" align="right">&nbsp;<%=formatNumber(strCalculado,2)%>&nbsp;</td>
                  <td class="celula9" align="right">&nbsp;<%=ValorTotalPago%>&nbsp;</td>
				  <%
				  if RS("COD_SITUACAO_PAGAMENTO") <> 2 then
				     %>
                     <td class="celula9" align="center"><strong><font color='#FF0000'><%=SIT%></font></strong></td>
					 <%
				  else
					 %>
					 <td class="celula9" align="center">&nbsp;</td>
					 <%
				  end if

				  'Bloqueio  pelo painel de controle 
				  if strHabilitarPreMatricula <> "S" then
				     strMostraParcelaMatricula = "N"
				  end if	 
				  
				  %>	 
					 	
                  <td width="2%" align="center" class="celula9">&nbsp;------</td>
				
				  <% if strParcelaMatricula = "N" then %>
                        <td width="3%" colspan="2" align="left" class="celula9"> <div align="center"><a href="#" <% if trim(estiloImagemProtesto) = "" and estiloImagemPago="" then %> onClick="geraBoleto('<%=trim(strPaginaBoleto)%>','<%=rs("codigo")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('impressoraImage<%=rs("codigo")%>','','../../images/impressora_over.gif',1)" <%end if%>><img align="absmiddle" src="../../images/impressora_on.gif" alt="Clique para imprimir o boleto dessa parcela." name="impressoraImage<%=rs("codigo")%>" border="0" <%=estiloImagemProtesto%> <%=estiloImagemPago%> ></a></div></td>
				  <% else %>
				         <% if strMostraParcelaMatricula = "S" then %>
						    <td width="3%" colspan="2" align="left" class="celula9"> <div align="center"><a href="#" <% if trim(estiloImagemProtesto) = "" and estiloImagemPago="" then %> onClick="geraBoleto('<%=trim(strPaginaBoleto)%>','<%=rs("codigo")%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('impressoraImage<%=rs("codigo")%>','','../../images/impressora_over.gif',1)" <%end if%>><img align="absmiddle" src="../../images/impressora_on.gif" alt="Clique para imprimir o boleto dessa parcela." name="impressoraImage<%=rs("codigo")%>" border="0" <%=estiloImagemProtesto%> <%=estiloImagemPago%> ></a></div></td>
						  <% else %>
						   <td width="3%" colspan="2" align="center" class="celula9"><font color='#FF0000'>Renovação de Matr&iacute;cula Indisponível</font></td>	
				  		   <% end if %>		
				  <% end if %>		
                </tr>
                <%			
						intTotalOutrosDescontos = intTotalOutrosDescontos + rs("OutrosDescontos")
						intTotalOutrosAcrescimo = intTotalOutrosAcrescimo + rs("OutrosAcrescimo")
						intTotalValorParcela = intTotalValorParcela + strCalculado
						if RS("COD_SITUACAO_PAGAMENTO") <> 2 then
						   intTotalDebito = intTotalDebito + strCalculado
						end if   
						if not isnull(rs("ValorTotalPago")) then
							intTotalValorPagamento = intTotalValorPagamento + rs("ValorTotalPago")
						end if
					rs.movenext
				wend
				%>
                <tr bgcolor="#E5E5E5">
                <td colspan="3" align="center" class="celula"><strong>TOTAIS:</strong></td>
                <td align="right" class="celula">&nbsp;</td>
                <td align="right" class="celula">&nbsp;</td>
                <td align="right" class="celula"><strong><%=formatnumber(intTotalOutrosAcrescimo,2)%></strong></td>
                <td align="center" class="celula">&nbsp;</td>
                <td align="right" class="celula">&nbsp;</td>
                <td align="right" class="celula"><strong><%=formatnumber(intTotalValorParcela,2)%></strong></td>
                <td align="right" class="celula"><strong><%=formatnumber(intTotalValorPagamento,2)%></strong></td>
                <td align="center" class="celula">&nbsp;</td>
                <td class="celula">&nbsp;</td>
                <td width="10%" class="celula"><strong>TOTAL: </strong></td>
                <td width="15%" class="celula"><div align="right"><strong><%=formatnumber(intTotalDebito,2)%></strong></div></td>
                </tr>
            <%else%>
                <tr> 
                <td height="130" colspan="14" align="center" class="celula style1"><p>Não 
                foi encontrado débitos para esse aluno.</p>
		    <%end if 
   		    rs.close
	        %>		   </tr>
				<%
          end if
		  %>
          </table>
	      <div align="left">&nbsp;	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
		</form>		</td>
      </tr>
      
        <tr> 
           <td height="21" colspan="14" align="center" class="celula"><p><strong>Aten&ccedil;&atilde;o! Caso exista alguma mensalidade em aberto e tenha sido paga, favor V&ordf;. S&ordf;. traz&ecirc;-la para a devida baixa.</strong>
           </tr>
			

    </table>
	</td>
  </tr>
</table>
<br>
</body>
</html>