	function carregaPeriodo(intCurso, posicao){
		if( intCurso != "0" ) {
			$('#cmbPeriodo'+posicao).html('<option value="0">Carregando...</option>');

			$.getJSON('json/carregar.asp?tipoAcao=CARREGA_PERIODO',{intCodCurso: intCurso, ajax: 'true'}, function(j){
				var options = '<option value="0">Selecione...</option>';		
				for (var i = 0; i < j.length; i++) {
					options += '<option value="' + j[i].codigo + '">' + j[i].nome + '</option>';
				}	
				$('#cmbPeriodo'+posicao).html(options);
			});
			
		} else {
			$('#cmbPeriodo'+posicao).html('<option value="0">Selecione...</option>');
		}
	}
	
	function emitirComprovante(codigo, AnoLetivo, semestre){
	
		if (AnoLetivo==""){
			alert("Ano letivo deve ser informado!");
			return false
		}
		window.open("sca_renovacao_aluno_rel.asp?chkAluno=" + codigo + "&txtAnoLetivo=" + AnoLetivo + "&cmbSemestre=" + semestre,"Comprovantes","top=0,left=0,height=543,width=793,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 	}
	function cancelarComprovante(codigo){
		if (confirm("Você realmente deseja cancelar a renovação da matrícula desse aluno?")) { 
			frm.action="sca_renovacao_aluno_cod.asp?acao=C&codAluno="+codigo;
			frm.submit();
			return true;
		}
 	}
	function marcaTodos(valor){
		
		var form = document.getElementById("frm");

		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				if (form.elements[i].disabled == false){
				form.elements[i].checked=valor;
				}

			}
		}
	}
	
	function salvar(acao){
		var frm = document.getElementById("frm");

		var codAluno = frm.txtCodAluno.value;
		var codCurso = document.getElementById("cmbCurso"+codAluno).value;
		var codPeriodo = document.getElementById("cmbPeriodo"+codAluno).value;
		var codTurno = document.getElementById("cmbTurno"+codAluno).value;
		
		var form = document.getElementById("frm");

		if ( codCurso == "0"){
			alert("Curso deve ser informado!");
			document.getElementById("cmbCurso"+codAluno).focus();
			return false
		}
		if ( codPeriodo == "0"){
			alert("Período deve ser informado!");
			document.getElementById("cmbPeriodo"+codAluno).focus();
			return false
		}
		if ( codTurno == "0"){
			alert("Turno deve ser informado!");
			document.getElementById("cmbTurno"+codAluno).focus();
			return false
		}
		
		frm.action="sca_renovacao_aluno_cod.asp";
		frm.submit();
		return true;
 	}

