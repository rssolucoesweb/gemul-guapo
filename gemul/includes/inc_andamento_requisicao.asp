<%
SQL = "INSERT EST_RequisicaoAndamento (CODREQUISICAO, SITUACAO, usuario_incl, data_hora_incl) "
SQL = SQL & "VALUES ("&intCodRequisicao&",'"&strSituacaoAndamento&"','" & strUsuario_incl & "','" & strData_hora_incl & "')"
cnn.Execute(sql)
GravarLog sql, nomePagina(request.ServerVariables("SCRIPT_NAME"))			
%>