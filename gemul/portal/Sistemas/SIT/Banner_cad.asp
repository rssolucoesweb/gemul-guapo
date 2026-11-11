<%strNomeDaPaginaPortal = "Cadastro Banners"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file="../../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file="../../../includes/inc_aguarde.asp"-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<script>

		function resultadoConsulta(intCodigo){
		
			var frm = document.getElementById("frm");
			
			frm.action="Banner_cad.asp?txtCodigo="+intCodigo;
			frm.submit();
		}

		function banner(){
			
			var frm = document.getElementById("frm");
			
			var parametro = "Banner_cad.asp?txtCodigo="+frm.txtCodigo.value+"&txtAnuncio="+frm.txtAnuncio.value+"&cboBanner="+frm.cboBanner.value+"&txtDataInicio="+frm.txtDataInicio.value+"&txtDataFinal="+frm.txtDataFinal.value+"&txtSite="+frm.txtSite.value;
			frm.action=parametro;
			frm.submit();
		}

		function qtdeDias(dias){
			
			var frm = document.getElementById("frm");
			
			var parametro = "Banner_cad.asp?txtDiasAnuncio="+dias+"&txtCodigo="+frm.txtCodigo.value+"&txtAnuncio="+frm.txtAnuncio.value+"&cboBanner="+frm.cboBanner.value+"&txtDataInicio="+frm.txtDataInicio.value+"&txtDataFinal="+frm.txtDataFinal.value+"&txtSite="+frm.txtSite.value;
			frm.action=parametro;
			frm.submit();
		}
		
		function salvar(acao){
			
			var frm = document.getElementById("frm");
	
			if (acao=="E"){
				var parametro = "Banner_cod_e.asp?txtCodigo=" + frm.txtCodigo.value + "&txtNomeBanner=" + frm.txtNomeBanner.value;
				frm.action=parametro;
				frm.submit();
				return true;
			}
			
			
			if (acao=="I"){
		
				if (frm.txtAnuncio.value == "") {
					alert("O Anuncio deve ser informado!");
					frm.txtAnuncio.focus();
					return false;
				}
				
				if (frm.cboBanner.value == "0") {
					alert("O Banner deve ser informado !");
					frm.cboBanner.focus();
					return false;
				}
						
				if (frm.txtDataInicio.value == "") {
					alert("A Data Inicio deve ser informada !");
					frm.txtDataInicio.focus();
					return false;
				}
				
				if (frm.txtDiasAnuncio.value == "") {
					alert("A Qtde de dias de Anuncio deve ser informada !");
					frm.txtDiasAnuncio.focus();
					return false;
				}
				
				if (frm.txtDataFinal.value == "") {
					alert("A Data Final deve ser informada !");
					frm.txtDataFinal.focus();
					return false;
				}
				
				if (frm.txtTamanho.value == "") {
					alert("O tamnho do Banner deve ser informado !");
					frm.txtTamanho.focus();
					return false;
				}
				
				if (frm.txtAltura.value == "") {
					alert("A Altura do banner deve ser informado !");
					frm.txtAltura.focus();
					return false;
				}
				
				if (frm.Arq1.value == "") {
						alert("A foto 1 deve ser informada !");
						frm.Arq1.focus();  
						return false;
				}	
				
				if((frm.Arq1.value.lastIndexOf(".jpg")==-1) && (frm.Arq1.value.lastIndexOf(".JPG")==-1) && (frm.Arq1.value.lastIndexOf(".gif")==-1) && (frm.Arq1.value.lastIndexOf(".swf")==-1)&& (frm.Arq1.value.lastIndexOf(".SWF")==-1)){  
					alert("Só é permitido fazer Upload em JPG, GIF OU SWF!"); 
					frm.Arq1.focus();  
					return false  
				}
				
				frm.action="Banner_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			}

	}
</script>
<%
	principal		= "principal.asp"
	strPagina		= "Banner_cad.asp"
	
	intCodEmpresa	= session("codEmpresa")
	intCodigo 		= Trim(Request("txtCodigo"))
	strAnuncio	 	= Trim(Request("txtAnuncio"))
	strTipoBanner 	= Trim(Request("cmbTipoBanner"))
	strBanner 		= Trim(Request("cboBanner"))
	strDiasAnuncio 	= Trim(Request("txtDiasAnuncio"))
	strDataInicio 	= Trim(Request("txtDataInicio"))
	strDataFinal 	= Trim(Request("txtDataFinal"))
	strSite		 	= Trim(Request("txtSite"))
	strTamanho		= Trim(Request("txtTamanho"))
	strAltura		= Trim(Request("txtAltura"))
	strNomeBanner	= Trim(Request("txtNomeBanner"))
	strDataAtual1 	= date
	
	strW = "159"
	strH = "83"
	
	if strBanner = "1" then 
		strW = "980"
		strH = "170"
		strTamanho = "980"
		strAltura  = "170"
	end if

	intQtdeFotos 		= 1

	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, Anuncio, BannerPossicao, DataInicio, DiasAnuncio, DataFinal, Site, Banner, "
		sql = sql & " TipoBanner, Tamanho, Altura "
		sql = sql & " FROM SIT_Banner"
		sql = sql & " Where Codigo = " & intCodigo
		sql = sql & " and codEmpresa = " & intCodEmpresa
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 	= rs("Codigo")
			strAnuncio	 	= rs("Anuncio")
			strBanner 		= rs("BannerPossicao")
			strTipoBanner 	= rs("TipoBanner")
			strDataInicio 	= formataDataAP(rs("DataInicio"))
			strDiasAnuncio 	= rs("DiasAnuncio")
			strDataFinal 	= formataDataAP(rs("DataFinal"))
			strSite		 	= rs("Site")
			strNomeBanner 	= rs("Banner")
			strTamanho		= rs("Tamanho")
			strAltura		= rs("Altura")

			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoFoto   			= ""
			strNovo					= "Nao" 

		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		strNovo					= "Sim" 
		
		if strBanner <> "" and strDataInicio = "" then
			sql = "SELECT Max(SIT_Banner.DataFinal) AS DataFinal "
			sql = sql & " FROM SIT_Banner"
			sql = sql & " GROUP BY SIT_Banner.BannerPossicao"
			sql = sql & " HAVING SIT_Banner.BannerPossicao=" & strBanner
			sql = sql & " and codEmpresa = " & intCodEmpresa
			rs.open sql, cnn
			if rs.eof = false then
				strDataInicio = rs("DataFinal")
				strDataInicio 	=  DateAdd("d", 1, strDataInicio)
				strDataInicio	=  formatadataAP(strDataInicio)
			end if
			rs.close
		end if
		
	end if
	
	IF strNomeFoto <> "" then
		strImagem = "<img src='..\..\..\Banner\" & strNomeFoto & "' border='1' width='85' height='113'>"
	else
		strImagem = "<font color='#CCCCCC'>  FOTO </font>"
	end if
	
	if strDiasAnuncio <> "" and strDataInicio <> "" then
		strDataFinal 	=  DateAdd("d", strDiasAnuncio, strDataInicio)
		strDataFinal	=  formatadataAP(strDataFinal)
	end if
	
	if strNovo = "Sim" then

		if trim(strBanner) <> "" and trim(strDataInicio) <> "" and trim(strDataFinal) <> "" then
			'maior
			if cdate(strDataInicio) < cdate(date) then
				%>
				<script>
					alert("Esse banner não pode ser publicado, data de inicio da publicação menor que a data atual!");
					window.location='Banner_cad.asp';
				</script>
				<%
			end if 
			
			sql = "SELECT Codigo, BannerPossicao, DataInicio, DataFinal, DiasAnuncio"
			sql = sql & " FROM SIT_Banner"
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			sql = sql & " And BannerPossicao = " & strBanner
			sql = sql & " and status='A' "
			sql = sql & " and DataFinal > = '" & formatadataBD(strDataInicio) & "'"
			rs.open sql, cnn
			
			if rs.eof = false then
				rs.close
				%>
				<script>
					alert("Já existe reserva para este Banner, neste periodo informado!");
					window.location='Banner_cad.asp';
				</script>
				<%
			else
				rs.close
			end if 
			'menor
			sql = "SELECT Codigo, BannerPossicao, DataInicio, DiasAnuncio"
			sql = sql & " FROM SIT_Banner"
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			sql = sql & " And BannerPossicao = " & strBanner
			sql = sql & " and status='A' "
			sql = sql & " and DataInicio < '" & formatadataBD(strDataInicio) & "'"
			sql = sql & " and DataFinal > '" & formatadataBD(strDataFinal) & "'"
			rs.open sql, cnn
			if rs.eof = false then
				%>
				<script>
					alert("Já existe reserva para este Banner, neste periodo informado!");
					window.location='Banner_cad.asp';
				</script>
				<%
			end if 
			rs.close
			
			sql = "SELECT Codigo, BannerPossicao, DataInicio, DiasAnuncio"
			sql = sql & " FROM SIT_Banner"
			sql = sql & " Where CodEmpresa = " & intCodEmpresa
			sql = sql & " And BannerPossicao = " & strBanner
			sql = sql & " and status='A' "
			sql = sql & " and DataInicio <= '" & formatadataBD(strDataFinal) & "'"
			sql = sql & " and DataFinal >= '" & formatadataBD(strDataFinal) & "'"
			rs.open sql, cnn
			if rs.eof = false then
				%>
				<script>
					alert("Já existe reserva para este Banner, neste periodo informado!");
					window.location='Banner_cad.asp';
				</script>
				<%
			end if 
			rs.close			

		end if
		'nomeFom = "<form method='post' id='frmConsulta' ENCTYPE='multipart/form-data'>"
	else
		'nomeFom = "<form method='post' id='frm'>" 
	end if
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">
        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="CelulaDoCadastro" align="center" valign="top">
                
   <form method="post" name="frm" id="frm" ENCTYPE="multipart/form-data">
   	<!-- inicio do formulario da pagina-->

    <table width="98%" border="0"  cellpadding="0" cellspacing="0" >
        <tr>
          <td colspan="2"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10" />          </td>
        </tr>
  <td width="13%" height="23"><span class="TextoForm">Anuncio :</span></td>
      <td width="87%"><input class="text" type="text" name="txtAnuncio" id="txtAnuncio" value="<%=strAnuncio%>"  size="60" maxlength="60" ></td>
    </tr>
  <tr>
    <td height="20"><span class="TextoForm">Banner:</span></td>
    <td><span class="TextoForm">
  <select name="cboBanner" class="Combo" id="cboBanner" onChange="banner()" style="width:100pt">
    <option value="0" <%if strBanner = "0" then response.Write("selected") %>>Selecione...</option>
    <option value="1" <%if strBanner = "1" then response.Write("selected") %>>banner Topo 01</option>
</select> obs:( O Banner 1 e o banner do topo ) </span></td>
    </tr>
  <tr>
    <td height="26"><span class="TextoForm">Data Inicio : </span></td>
    <td><input name="txtDataInicio" type="text" class="text" id="txtDataInicio" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataInicio%>" size="11" maxlength="11"></td>
    </tr>
  <tr>
    <td height="23"><span class="TextoForm">Dias Anuncio : </span></td>
    <td><input name="txtDiasAnuncio" type="text" id="txtDiasAnuncio" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strDiasAnuncio%>" maxlength="5" onBlur="qtdeDias(this.value)"></td>
    </tr>
  <tr>
    <td height="23"><span class="TextoForm">Data Final :</span></td>
    <td><input name="txtDataFinal" type="text" class="text" id="txtDataFinal"  onBlur="validaData(this); calculaDiferenca()" onKeyPress="return formataCampo(this, 3, 10)" value="<%=strDataFinal%>" size="11" maxlength="11"></td>
    </tr>
  <tr>
    <td height="25"><span class="TextoForm">Site : </span></td>
    <td><span class="texto">
      <input name="txtSite" type="text" class="text" id="txtSite" onKeyUp="mascara(this,site)"  size="70" maxlength="100" value="<%=strSite%>" />
    </span></td>
    </tr>
   <tr>
     <td height="24" class="TextoForm">Tipo de Arquivo:</td>
     <td><span class="TextoForm">
       <select name="cmbTipoBanner" class="Combo" id="cmbTipoBanner" >
         <option value="I" <%if strTipoBanner = "" or strTipoBanner = "I" then response.Write("selected") %>>Imagem (JPG/GIF)</option>
         <option value="F" <%if strTipoBanner = "F" then response.Write("selected") %>>Imagem (FLASH)</option>
         </select>
     </span></td>
     </tr>
   <tr>
     <td height="24" class="TextoForm">Tamanho:</td>
     <td><input name="txtTamanho" type="text" id="txtTamanho" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strTamanho%>" maxlength="5"></td>
     </tr>
   <tr>
     <td height="23" class="TextoForm">Altura:</td>
     <td><input name="txtAltura" type="text" id="txtAltura" onKeyPress="return formataCampo(this,2,5)" class="text" size="5" value="<%=strAltura%>" maxlength="5" ></td>
     </tr>
   <tr>
 	<%for i=1 to intQtdeFotos%>
	  <td height="24" class="TextoForm">Foto<%=i%>:</td>
	  <td><input class="text" name="Arq<%=i%>" type="file" id="<%=i%>" size="25"><input name="txtNomeBanner" type="text" class="text" id="txtNomeBanner" size="40" maxlength="40" value="<%=strNomeBanner%>" /></td>
	  <%next %>
  </tr>
  <tr>
    <td height="24" colspan="2">&nbsp;</td>
  </tr>
   <tr>
    <td height="24" colspan="2"><!--#include file="../../../includes/inc_botoes_cadastro.asp"--></td>
  </tr>
  <tr>
    <td height="24" colspan="2"><%
		cont =0
		
		sql = "SELECT Codigo, Anuncio, TipoBanner, BannerPossicao, DataInicio, DiasAnuncio, DataFinal, "
		sql = sql & " Site, Banner, status, Tamanho, Altura"
		sql = sql & " FROM SIT_Banner"
		sql = sql & " Where CodEmpresa = " & intCodEmpresa
		sql = sql & " And status = 'A'"
		sql = sql & " Order by DataFinal desc "
		rs.open sql, cnn
		if rs.eof = false then
		%>
        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
          <tr bgcolor="#CCCCCC">
            <td align="center" class="celula"><strong>C&oacute;d.</strong></td>
            <td align="center" class="celula"><strong>Banner Posi&ccedil;&atilde;o</strong></td>
            <td align="center" class="celula"><strong>Tamanho</strong></td>
            <td align="center" class="celula"><strong>Altura</strong></td>
            <td align="center" class="celula"><strong>Data Inicio </strong></td>
            <td align="center" class="celula"><strong>Dias Banner </strong></td>
            <td width="5%" align="center" class="celula"><strong>Data Final</strong></td>
            <td width="4%" align="center" class="celula"><strong>Tipo</strong></td>
            <td width="9%" align="center" class="celula"><strong>Banner</strong></td>
            <td align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
          </tr>
          <%
						while not rs.eof
							cont = cont + 1	
							
							strBanner = ""
							
							if rs("BannerPossicao") = "1" then strBanner = "Banner Topo 1" 
							if rs("BannerPossicao") = "2" then strBanner = "Banner Topo 2" 

							if rs("BannerPossicao") = "3" then strBanner = "banner Lateral 01" 
							if rs("BannerPossicao") = "4" then strBanner = "banner Lateral 02" 
							if rs("BannerPossicao") = "5" then strBanner = "banner Lateral 03" 
							if rs("BannerPossicao") = "6" then strBanner = "banner Lateral 04" 
							if rs("BannerPossicao") = "7" then strBanner = "banner Lateral 05" 
							if rs("BannerPossicao") = "8" then strBanner = "banner Lateral 06" 
							if rs("BannerPossicao") = "9" then strBanner = "banner Lateral 07" 
							if rs("BannerPossicao") = "10" then strBanner = "banner Lateral 08" 
							if rs("BannerPossicao") = "11" then strBanner = "banner Lateral 09" 
							if rs("BannerPossicao") = "12" then strBanner = "banner Lateral 10" 
							if rs("BannerPossicao") = "13" then strBanner = "banner Lateral 11" 
							if rs("BannerPossicao") = "14" then strBanner = "banner Lateral 12" 
							if rs("BannerPossicao") = "15" then strBanner = "banner Lateral 13" 
							if rs("BannerPossicao") = "16" then strBanner = "banner Lateral 14" 
							if rs("BannerPossicao") = "17" then strBanner = "banner Lateral 15" 
						
							strStatus = rs("status")
							strTipoBanner = ""
							if rs("TipoBanner") = "I" then strTipoBanner = "(JPG/GIF)" 
							if rs("TipoBanner") = "F" then strTipoBanner = "(FLASH)" 


							IF strStatus = "A" THEN
								IF CDATE(DATE) >= CDATE(RS("DataInicio")) and CDATE(DATE) <= CDATE(RS("DataFinal"))  THEN
									SITUACAO = "<font color='#00CC00'><strong>Ativo</strong></font>"
								ELSEIF CDATE(DATE) >= CDATE(RS("DataInicio")) and CDATE(DATE) > CDATE(RS("DataFinal"))  THEN
									SITUACAO = "<font color='#FF0000'><strong>Encerrado</strong></font>"
								ELSEIF CDATE(DATE) < CDATE(RS("DataInicio"))  THEN
									SITUACAO = "<font color='#0099FF'><strong>A Publicar</strong></font>"
								END IF
							ELSE
								SITUACAO = "<font color='#FF0000'><strong>Encerrado</strong></font>"
							END IF	
							
							%>
                            <tr bgcolor="#FFFFFF" style="cursor:hand" onClick="return resultadoConsulta('<%=rs("Codigo")%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                            <td width="6%" class="celula"><%=rs("Codigo")%></td>
                            <td width="16%" class="celula"><%=strBanner%>&nbsp;</td>
                            <td width="10%" class="celula"><%=rs("Tamanho")%>&nbsp;</td>
                            <td width="8%" class="celula"><%=rs("Altura")%>&nbsp;</td>
                            <td width="13%" class="celula"><%=formataDataAP(rs("DataInicio"))%></td>
                            <td width="20%" class="celula"><%=rs("DiasAnuncio")%></td>
                            <td class="celula"><%=formataDataAP(rs("DataFinal"))%></td>
                            <td align="center" class="celula"><%=strTipoBanner%></td>
                            <td height="21" align="center" class="celula">
                            <%if rs("TipoBanner") = "F" then%>
							<script type="text/javascript">
                            var FO = { movie:"../../Banners/<%=rs("Banner")%>", width:"65", height:"30", majorversion:"6", build:"0" };
                            UFO.create(FO, "cabecalho<%=rs("Codigo")%>");
                            </script>
                            <div id="cabecalho<%=rs("Codigo")%>"></div>
                            <%else%>
                            <img src="../../../Banners/<%=intCodEmpresa%>/<%=rs("Banner")%>" width="65" height="30">
                            <%end if%>			</td>
                            <td width="9%" class="celula" align="center"><%=SITUACAO%></td> 	
                            </tr>
          						<%				
					rs.movenext
					wend
					%>
          <tr bgcolor="#FFFFFF">
            <td height="21" colspan="10" class="celula">Total 
              Registros : <%=cont%></td>
          </tr>
        </table>
      <%
			  end if
			  rs.close%>    </td>
  </tr>
      </table>

   	<!-- fim do formulario da pagina-->
    </form>                
                
              </td>
            </tr>
        </table>
    	<hr size="1" color="#FFFFFF">
    </td>
  </tr>
</table>
<!--#include file="rodape.asp"-->
</body>
</html>
<script>aguarde.style.display="none";</script>
