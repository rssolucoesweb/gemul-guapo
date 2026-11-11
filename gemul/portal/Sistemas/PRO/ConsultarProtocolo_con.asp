<%strNomeDaPaginaPortal = "Abrir Protocolo"%>
<!--#include file="topo.asp"-->
<!--#include file="../../../includes/inc_cnn.asp"-->
<!--#include file=../../../includes/inc_aguarde.asp-->
<!--#include file="../../../includes/inc_formataData.asp"-->
<script src="../../../js/js_funcoes_gerais.js"></script>
<!-- Exemplo de validação de formulario para todos os navegadores -->
<script>
	function Descricao(tipo){
	
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
			document.all["mostraDescricao"+tipo].style.background="#AAFFAA";
			document.all["mostraDescricaoLinhaAndamento"+tipo].style.background="#AAFFAA";
			document.all["imgDescricao"+tipo].src="../../../images/up.jpg";
			
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
			document.all["imgDescricao"+tipo].src="../../../images/down.jpg";
			document.all["mostraDescricaoLinhaAndamento"+tipo].style.background="#FFFFFF";
		}
	}	
	function resultadoConsulta(intCodigo){
			frm.txtCodigo.value=intCodigo
			frm.submit();
		}

	function consultar(){
		
		var frm = document.getElementById("frm");
		if (frm.txtNumero.value == "" && frm.txtCPF.value == "" && frm.txtRequerente.value == "" && frm.cmbAssunto.value == "0" && frm.cmbTipoDocumento.value == "0" && frm.cmbSituacao.value == "0") {
			alert("Informe um dos filtros para iniciar a consulta do protocolo!");
			return false;
		}
		frm.action="ConsultarProtocolo_con.asp";
		frm.submit();
		return true;
 	}
</script>
<%  
	principal			= "principal.asp"
	intCodEmpresa		= session("CodEmpresa")	

	strNumero		 	= Trim(Request.Form("txtNumero"))
	strCPF 				= Trim(Request.Form("txtCPF"))
	strRequerente	 	= Trim(Request.Form("txtRequerente"))
	intCodAssunto 		= Trim(Request.Form("cmbAssunto"))
	intCodTipoDocumento = Trim(Request.Form("cmbTipoDocumento"))
	intCodDepartamento 	= Trim(Request.Form("cmbDepartamento"))
	intCodSituacao 		= Trim(Request.Form("cmbSituacao"))

	if intCodAssunto = "" then intCodAssunto = "0"
	if intCodTipoDocumento = "" then intCodTipoDocumento = "0"
	if intCodDepartamento = "" then intCodDepartamento = "0"
	if intCodSituacao = "" then intCodSituacao = "0"
	
%>
<!-- fim do codigo asp da pagina -->
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td height="365" bgcolor="#FFFFFF" valign="top" align="center">

        <hr size="1" color="#FFFFFF">
        <table width="97%" cellpadding="0" cellspacing="0" class="TabelaDoCadastro" bgcolor="#F5F5F5">
            <tr>
                <td width="97%" class="TextoForm" align="center" valign="top">
    <form id="frm" name="frm" action="#" method="post">
   	<!-- inicio do formulario da pagina-->
	  <table width="98%" border="0"  align="center" cellpadding="0" cellspacing="0" >
          <tr>
            <td width="137" height="23" class="TextoForm">N&uacute;mero:</td>
            <td width="717" class="TextoForm"><input name="txtNumero" type="text" class="text" id="txtNumero" size="18" maxlength="16" value="<%=strNumero%>"  onKeyPress="return formataCampo(this, 2, 16)"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">CPF/Requerente:</td>
            <td class="TextoForm"><input name="txtCPF" type="text" class="text" id="txtCPF" value="<%=strCPF%>" onBlur="validaCPF(this)" onKeyPress="return formataCampo(this, 5, 14)" size="15" maxlength="14">
              <input name="txtRequerente" type="text" class="text" id="txtRequerente" size="60" maxlength="150" value="<%=strRequerente%>"></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Assunto:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbAssuntoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">Tipo de Documento:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbTipoDocumentoProtocolo.asp"--></td>
          </tr>
          <tr>
            <td height="23" class="TextoForm">	Situa&ccedil;&atilde;o:</td>
            <td class="TextoForm"><!--#include file="../../../includes/inc_cmbSituacaoProtocolo.asp"-->&nbsp;</td>
          </tr>
          <tr>
            <td height="24" colspan="2" class="TextoForm">&nbsp;</td>
          </tr>
        <tr valign="top">
          <td align="center" class="tituloPrincipal style2" colspan="2"><!--#include file="../../../includes/inc_botoes_consulta_principal.asp"-->&nbsp;</td>
        </tr>
        
        <tr valign="top">
          <td class="tituloPrincipal style2" colspan="2"><%
		  		if strNumero <> "" or strRequerente<>"" or strCPF<>"" or intCodAssunto<>"0" or intCodTipoDocumento<>"0" or intCodDepartamento<>"0" or intCodSituacao<>"0" then
					cont =0
					
					sql = "select p.codigo, p.numero, p.ano, p.cpf, p.requerente, a.descricao as assunto, td.descricao as tipodocumento, d.descricao as departamento, s.descricao as situacao"
					sql = sql & " from pro_protocolo p "
					sql = sql & " left join pro_assunto a	   on a.codigo = p.cod_assunto and a.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_tipoDocumento td on td.codigo = p.cod_tipodocumento and td.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_departamento d on d.codigo = p.cod_departamento and d.cod_empresa = p.cod_empresa"
					sql = sql & " left join pro_situacao s on s.codigo = p.cod_situacao"
					sql = sql & " Where p.Cod_Empresa	= " & session("codEmpresa")	
					if strNumero <> "" then
						sql = sql & " and numero = '" & strNumero & "'"
					end if
					if strCPF <> "" then
						sql = sql & " and p.CPF = '" & strCPF & "'"
					end if
					if strRequerente <> "" then
						sql = sql & " and p.Requerente like '%" & strRequerente & "%'"
					end if
					if intCodAssunto <> "0" then
						sql = sql & " and p.cod_assunto = " & intCodAssunto
					end if
					if intCodTipoDocumento <> "0" then
						sql = sql & " and p.cod_tipodocumento = " & intCodTipoDocumento
					end if
					if intCodSituacao <> "0" then
						sql = sql & " and p.cod_situacao = " & intCodSituacao
					end if
					sql = sql & " Order by p.codigo desc"
					rs.open sql, cnn
					if rs.eof = false then
						%>
                        <table width = "100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                        <tr bgcolor="#E5E5E5">
                        <td width="4%" class="celula">&nbsp;</td>
                        <td class="celula"><strong>N&uacute;mero</strong></td>
                        <td width="28%" height="21" class="celula"><strong>Requerente</strong></td>
                        <td width="14%" class="celula"><strong>Tipo Documento</strong></td>
                        <td width="25%" class="celula"><strong>Departamento Destino</strong></td>
                        <td width="22%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                        </tr>
              			<%
						while not rs.eof
							cont = cont + 1	
							%>
                            <tr id="mostraDescricaoLinhaAndamento<%=rs("codigo")%>" style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')">
                            <td class="celula" align="center"><img style="cursor:hand"  id="imgDescricao<%=rs("codigo")%>" src="../../../images/down.jpg"></td>
                            <td width="7%" class="celula"><STRONG><%=rs("numero")%></STRONG></td>
                            <td height="21" class="celula"><%=trim(rs("cpf"))%> - <%=trim(rs("requerente"))%></td>
                            <td height="21" class="celula"><%=trim(rs("tipodocumento"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("departamento"))%>&nbsp;</td>
                            <td height="21" class="celula"><%=trim(rs("situacao"))%>&nbsp;</td>
                            </tr>
                            <tr >
                                <td height="24" colspan="6" class="celula" id="mostraDescricao<%=rs("codigo")%>" style="display:none">
                                    <!-- execucao -->
                                   
                                   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                      <tr bgcolor="#AAFFAA">
                                        <td height="25" colspan="5" align="center" class="celula"><STRONG>Andamento</STRONG></td>
                                      </tr>
                                     <%

                                       	sql = "select "
										sql = sql & " 	pa.codigo,"
										sql = sql & " 	pa.codigo_PRO_protocolo, pa.anotacoes,"
										sql = sql & " 	d.descricao, "
										sql = sql & " 	case	"
										sql = sql & " 		when pa.tipoAndamento = 'R' then 'RECEBIDO'"
										sql = sql & " 		when pa.tipoAndamento = 'E' then 'ENCAMINHADO'"
										sql = sql & " 		when pa.tipoAndamento = 'A' then 'ARQUIVADO'"
										sql = sql & " 		end as tipoAndamento,"
										sql = sql & " 	pa.data_hora_incl, "
										sql = sql & " 	pa.usuario_incl,"
										sql = sql & " 	(select distinct nome from SEG_usuarios where cpf = pa.usuario_incl) as usuario"
										sql = sql & " from PRO_Protocolo_Andamento pa"
										sql = sql & " inner join PRO_Departamento d on d.codigo = pa.cod_departamentoDestino"
										sql = sql & " where pa.codigo_PRO_protocolo = " & rs("codigo")
										sql = sql & " order by pa.codigo"
										rsAux.open sql, cnn
										if rsAux.eof = false then
											while not rsAux.eof
												%>
											   <tr>
												<td width="20%" align="left" class="celula"><STRONG><font color="#0033CC"><%=rsAux("tipoAndamento")%> POR</font></STRONG>&nbsp;</td>
                                                <td width="23%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=ucase(rsAux("usuario"))%></font></STRONG></td>
												<td width="23%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=rsAux("data_hora_incl")%></font></STRONG></td>
												<td width="30%" align="left" class="celula"><STRONG><font color="#0033CC"><%=rsAux("descricao")%></font></STRONG>&nbsp;</td>
                                                <td width="30%" align="left" class="celula"><font color="#0033CC"><%=rsAux("anotacoes")%></font>&nbsp;</td>
										      </tr>
												<%
												rsAux.movenext
											wend
										end if
										rsAux.close
										%>
                                  </table>
                                     <%
                                       	sql = "select "
										sql = sql & " 	pa.codigo, "
										sql = sql & " 	pa.codigo_PRO_protocolo, pa.obs, d.descricao, "
										sql = sql & " 	pa.arquivo, "
										sql = sql & " 	pa.pasta, "
										sql = sql & " 	pa.obs, "
										sql = sql & " 	pa.data_hora_incl, s.descricao as situacao,"
										sql = sql & " 	pa.usuario_incl, "
										sql = sql & " (select distinct nome from SEG_usuarios where cpf = pa.usuario_incl) as usuario "
										sql = sql & " from PRO_Protocolo_Arquivamento pa "
										sql = sql & " inner join PRO_Departamento d on d.codigo = pa.cod_departamento"
										sql = sql & " inner join PRO_Situacao s on s.codigo = pa.cod_situacao"
										sql = sql & " where pa.codigo_PRO_protocolo = " & rs("codigo")
										sql = sql & " order by pa.codigo"
										rsAux.open sql, cnn
										if rsAux.eof = false then
											%>
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
                                          <tr bgcolor="#AAFFAA">
                                            <td height="25" colspan="5" align="center" class="celula"><STRONG>Arquivamento</STRONG></td>
                                          </tr>
										   <tr>
											<td width="15%" align="left" class="celula"><STRONG><font color="#0033CC"><%=rsAux("situacao")%></font></STRONG>&nbsp;</td>
											<td width="20%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=ucase(rsAux("usuario"))%></font></STRONG></td>
											<td width="20%" height="25"  align="center" class="celula"><STRONG><font color="#0033CC"><%=rsAux("data_hora_incl")%></font></STRONG></td>
											<td width="20%" align="left" class="celula"><STRONG><font color="#0033CC">Arquivo: <%=rsAux("arquivo")%> - Pasta: <%=rsAux("pasta")%></font></STRONG>&nbsp;</td>
											<td width="30%" align="left" class="celula"><font color="#0033CC"><%=rsAux("obs")%></font>&nbsp;</td>
										  </tr>
                                  		</table>									 
											<%
										end if
										rsAux.close
										%>
                              </td>
                          </tr>
              				<%				
							rs.movenext
						wend
						%>
						<tr>
						<td height="21" colspan="6" class="celula">Total 
						  Registros : <%=cont%></td>
						</table>
						<%
                    end if
                    rs.close
				end if				  
				  %></td>
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