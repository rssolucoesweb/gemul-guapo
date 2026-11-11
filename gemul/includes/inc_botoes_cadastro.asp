<%
'Variáveis de controle dos botões:
'strDesabilitaIncluir, 
'strDesabilitaAlterar, 
'strDesabilitaExcluir, 
'strDesabilitaLimpar
'valores possíveis: "disabled" ou ""
'As variáveis deverão ser carregadas na página que chamar esta include

' Desabilita o batao excluit e alterar para Representantes
if trim(Session("codTipoPerfil")) <> "1" and trim(strLiberaAlteracao) = "" then
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaLiberacao  = "disabled"
end if
%> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
		<input type="button" name="cmdIncluir" style="cursor:hand"   value="Incluir" class="botaoIncluir" <%=strDesabilitaIncluir%> onclick="return salvar('I')">
		<input type="button" name="cmdAlterar" style="cursor:hand"  value="Alterar" class="botaoAlterar" <%=strDesabilitaAlterar%> onclick="return salvar('A')">
		<input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir" class="botaoExcluir" <%=strDesabilitaExcluir%> onclick="return salvar('E')">
     	<input type="button" name="cmdLimpar" style="cursor:hand"  value="Limpar" class="botaoLimpar"  onclick="window.location='<%=strPaginaLimpar%>'">
     
       	<%if strMostraBotaoFonteRecurso = "S" then%>
			<input type="button" name="cmdFonte"  style="cursor:hand"  value="Fonte de Recurso"  class="botao" <%=strDesabilitaFonte%>  onClick="return abreConsulta('LiquidacaoDespesasFonteRecurso_cad.asp?CodPL=<%=intCodigo%>')">
		<%end if%>
        <%if strMostraBotaoReciboProtocolo = "S" then%>
			<input type="button" name="cmdRecibo"  style="cursor:hand"  value="Emitir Recibo"  class="botao" <%=strDesabilitaBotaoReciboProtocolo%>  onClick="recibo()">
		<%end if%>       
       	<%if strMostraBotaoGerarPagamento = "S" then%>
			<input type="button" name="cmdPagamento"  style="cursor:hand"  value="Parcelamento"  class="botao" <%=strDesabilitaGerarPagamento%>  onClick="return abreConsulta('ContratoParcelamento_cad.asp?txtCodContrato=<%=intCodigo%>')">
		<%end if%>
        <%if strMostraBotaoPerfilAcesso = "S" then%>
			<input type="button" name="cmdPagamento"  style="cursor:hand"  value="Vincular Perfil para Acesso"  class="botao" <%=strDesabilitaPerfilAcesso%>  onClick="return abreConsulta('Seg_UsuarioEmpresaPerfilAcesso_cad.asp?txtCPF=<%=strCpf%>')">
		<%end if%>
        <%if strMostraBotaoEnviarParaAutorizacao = "S" then%>
			<input type="button" name="cmdAutorizacao"  style="cursor:hand"  value="Enviar para Autorização"  class="botao" <%=strDesabilitaBotaoEnviarParaAutorizacao%>  onClick="enviar()">
		<%end if%>       
         <%if strMostraBotaoAtualizaEstoque = "S" then%>
			<input type="button" name="cmdAutorizacao"  style="cursor:hand"  value="Fechar Balanço e Atualizar Estoque"  class="botao" <%=strDesabilitaBotaoAtualizaEstoque%>  onClick="enviar()">
		<%end if%>       
		<%if strBotaoLimpa = "S" then%>
        	<input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
        <%end if%>

     	<%if session("strRetornarApaginaAnterior") <> "" and strMostraBotaoFechar = "" and strMostraBotaoFecharComSubmit = "" then%>
		<input type="button" name="cmdRetoraAnterior" style="cursor:hand"   value="<< Voltar "  class="botao" onClick="window.location='<%=session("strRetornarApaginaAnterior")%>'">
		<%end if%>
        <%if strBotaoPrincipal = "" then%>
		<input type="button" name="cmdPrincipal" style="cursor:hand"  value="Principal" class="botao" onclick="window.location='default.asp'">
		<%end if%>
        <%if strBotaoFechar = "S" then%>
		<input type="button" name="cmdFechar" style="cursor:hand"  value="Fechar" class="botao" onclick="window.close()">
		<%end if%>
    	</td> 
    </tr>
</table>