	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtAutorizacao.value == "") {
			alert("A Autorizacao de Funcionamento deve ser informada!");
			frm.txtAutorizacao.focus();
			return false;
		} 
		if (frm.txtEndereco.value == "") {
			alert("O Endereço deve ser informado!");
			frm.txtEndereco.focus();
			return false;
		} 
		
		if (frm.txtBairro.value == "") {
			alert("O Bairro deve ser informado!");
			frm.txtBairro.focus();
			return false;
		} 
		
		if (frm.txtMunicipio.value == "") {
			alert("O Municipio deve ser informado!");
			frm.txtMunicipio.focus();
			return false;
		} 
		
		if (frm.txtUF.value == "") {
			alert("O Estado deve ser informado!");
			frm.txtUF.focus();
			return false;
		} 
	
		if (frm.txtTelefone.value == "") {
			alert("O Telefone deve ser informado!");
			frm.txtTelefone.focus();
			return false;
		} 

	
		
			var parametro;
			parametro = "&txtCodEmpresa="+frm.txtCodEmpresa.value;
			parametro = parametro + "&txtAutorizacao="+frm.txtAutorizacao.value;
			parametro = parametro + "&txtDiretor="+frm.txtDiretor.value;
			parametro = parametro + "&txtSecretaria="+frm.txtSecretaria.value;
			parametro = parametro + "&txtContato="+frm.txtContato.value;
			parametro = parametro + "&txtContato1="+frm.txtContato1.value;
			parametro = parametro + "&txtContato2="+frm.txtContato2.value;
			parametro = parametro + "&txtEndereco="+frm.txtEndereco.value;
			parametro = parametro + "&txtBairro="+frm.txtBairro.value;
			parametro = parametro + "&txtMunicipio="+frm.txtMunicipio.value;
			parametro = parametro + "&txtUF="+frm.txtUF.value;
			parametro = parametro + "&txtCep="+frm.txtCep.value;
			parametro = parametro + "&txtTelefone="+frm.txtTelefone.value;
			parametro = parametro + "&txtCodigoCenso="+frm.txtCodigoCenso.value;
			parametro = parametro + "&txtCodigoSetransp="+frm.txtCodigoSetransp.value;
			frm.action="sca_unidade_escolar_autorizacao_cod.asp?acao=" + acao + parametro;
			frm.submit();
			return true;	
	
 	}