<%if left(acao,1) = "I" then%>
	<button onClick="salvar('I')"  type="button" class="btn btn-outline-success">Incluir</button>
<%end if%>
<%if left(acao,1) = "A" then%>
	<button onClick="salvar('A')"  type="button" class="btn btn-outline-info">Alterar</button>
<%end if%>
<%if right(acao,1) = "E" then%>
	<button onClick="salvar('E')"  type="button" class="btn btn-outline-danger">Excluir</button>
<%end if%>
<%if strRetiraBotaoRecibo="S" then%>
	<button onclick="return abreConsulta('Recibo_servico_rel.asp?id=<%=id%>')"  type="button" class="btn btn-outline-info">Excluir</button>
<%end if%>
<%if strRetiraBotaolimparTela="" then%>
<button onClick="window.location='<%=replace(pagina_atual,"/app/","")%>'"  type="button" class="btn btn-outline-warning">Limpar tela</button>
<%end if%>
<button onClick="window.close()"  type="button" class="btn btn-outline-secondary">Fechar</button>


