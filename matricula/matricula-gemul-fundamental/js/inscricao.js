var inscricao = function () {

    var inicialize = function () {
		
		var descCurso = $("#descricao_curso").val();
		
		$("#alerta_cadastro_reserva").hide();
		
        definirMascara();
		$("#listaDeficiencias").hide();

        $("#btnLimpar").on("click", function () {
            limparFormulario();
        });

        $("#btnSalvar").on("click", function () {
			validaAlunoSeJaExiste("carregaAlunoSeJaExisteMatricula");					
            incluir();
        });
		
        $("#CEP").on("blur", function () {
            var cep = $(this).val();
            obterEndercoPorCEP(cep);			
			$("#bolsa_familia").val("0");
			$("#codigo_serie").val("0");
			$("#codigo_turno").val("0");
			$("#codigo_escola").val("0");
			$("#codigo_turno").prop('disabled', true);
			$("#codigo_escola").prop('disabled', true);	
        });
		
		$("#CPFAluno").on("blur", function () {
            if ($("#CPFAluno").val().trim().length > 0) {
				validaAlunoSeJaExiste("carregaAlunoSeJaExisteMatricula");	
			}
        });

        limparFormulario();

        $("#DataNascimento").on("blur", function () {
			var data = $(this).val();
			if (data==""){
				$("#txtMostraIdadeAluno").val("");
				return false
			}
			if ($("#DataNascimento").val().trim().length != 10) {
				alert("O campo data de nascimento deve estar no formato dd/mm/aaaa. Ex: 14/01/2014!");
				window.location='inscricao.html';
				return false
			}	
				   
			$("#txtMensagemValidaIdade").val("");
			$("#txtMensagemValidaIdadeParaMatricula").val("");

			efetuarValidacaoDatas();
			efetuarValidacaoRegraEspecial();
			
        });
		
		$("#codigo_serie").change(function () {
		   listarTurnos($(this).val());
        });

		$("#bolsa_familia").change(function () {
			if ($("#bolsa_familia").val()=='N'){
				$("#numero_bolsa_familia").val("");
		   		$("#numero_bolsa_familia").prop('disabled', true);
			}
			else
			{
				$("#numero_bolsa_familia").prop('disabled', false);
			}
			
			$("#txtMensagemValidaIdade").val("");
			$("#txtMensagemValidaIdadeParaMatricula").val("");

			efetuarValidacaoDatas();			
        });

		$("#Mae").on("blur", function () {
			validaAlunoSeJaExiste("carregaAlunoSeJaExisteMatricula");					
		});
		
		
		var efetuarValidacaoDatas = function()
		{
			validaIdade();
		}
		var efetuarValidacaoRegraEspecial = function()
		{
			validaRegraEspecial();
		}
		var validaRegraEspecial = function () {
			var descCurso = $("#descricao_curso").val();
			var dataNascimento = $("#DataNascimento").val();
			if (dataNascimento!=""){
				
				var url = "ajax/inc_retorno_ajax.asp";				
				var tipoAcao = "validaRegraEspecialDoisAgrupamentos";
				
				$.get(url, 
				{
				  strTipoAcao: tipoAcao, 
				  data_nascimento: dataNascimento
				})
				.done(function (data) {
					var json = jQuery.parseJSON(data);
					
					if (json.mostra_regra_especial == "S"){
						$("#msn_mostra_regra_especial").show();	
					}else{
						$("#msn_mostra_regra_especial").hide();	
					}
					
					listarSeries(descCurso);
		
				}).fail(function (jqxhr, textStatus, error) {
					var err = textStatus + ", " + error;
					//console.log("Request Failed: " + err);
				}).always(function () {
					$.unblockUI();
				});
			}
		}
		
		var mostrarMensagemCadastroReserva = function()
		{
			$("#alerta_cadastro_reserva").hide();
			var descTurno = $("#codigo_turno").val();
			var descCurso = $("#descricao_curso").val();
			
			//if (descTurno == "INTEGRAL" ){
				$("#alerta_cadastro_reserva").show();
			//}else{
			//	$("#alerta_cadastro_reserva").hide();
			//}
		}
		
		var validaAlunoSeJaExiste = function (tipoAcao) {
			var aluno = $("#Aluno").val();
			var CPFAluno = $("#CPFAluno").val();
			var data_nascimento = $("#DataNascimento").val();
			var mae = $("#Mae").val();
			
			if ((aluno!="" && data_nascimento!="" && mae!="") || (CPFAluno!="")){
				$("#txtMensagemJaExiste").val("");
				bloquearTela();
				var url = "ajax/inc_retorno_ajax.asp";
				//var tipoAcao = "carregaAlunoSeJaExisteMatricula";
				//var tipoAcao = "carregaAlunoSeJaExisteReserva";
				
				$.get(url, 
				{
				  strTipoAcao: tipoAcao,
				  strAluno: aluno,
				  strCPFAluno: CPFAluno,
				  strDataNascimento: data_nascimento,
				  strMae: mae
				})
				.done(function (data) {
					 var json = jQuery.parseJSON(data);
	
					 var mensagemJaExiste = json.mensagem;
					 
					 if (mensagemJaExiste!='' && mensagemJaExiste!='ok') {
						var destino = json.destino;
						$("#txtMensagemJaExiste").val(mensagemJaExiste);
						alert(mensagemJaExiste);
						window.location=destino;
					 }
		
				}).fail(function (jqxhr, textStatus, error) {
					var err = textStatus + ", " + error;
					//console.log("Request Failed: " + err);
				}).always(function () {
					$.unblockUI();
				});
			}
		}	
		
		var validaIdade = function () {
			var dataNascimento = $("#DataNascimento").val();
			if (dataNascimento!=""){
				bloquearTela();
				
				var url = "ajax/inc_retorno_ajax.asp";				
				var tipoAcao = "carregaIdadeAluno";
				
				$.get(url, 
				{
				  strTipoAcao: tipoAcao, 
				  data_nascimento: dataNascimento
				})
				.done(function (data) {
					var json = jQuery.parseJSON(data);
					
					$("#txtHiddenIdade").val(json.idade);
					$("#txtMostraIdadeAluno").val(json.mensagem);
					
					var idade = $("#txtHiddenIdade").val();
					
					if (parseInt(idade) > 90) {
						$("#txtMensagemValidaIdade").val("A idade não é permitida para inclusão na rede municipal de ensino");
						alert('A idade não é permitida para inclusão na rede municipal de ensino!');
						window.location='inscricao.html';
						return false
					}
					else
					{
						validaIdadeParaMatricula();
					}
		
				}).fail(function (jqxhr, textStatus, error) {
					var err = textStatus + ", " + error;
					//console.log("Request Failed: " + err);
				}).always(function () {
					$.unblockUI();
				});
			}
		}
		var validaIdadeParaMatricula = function () {
			var DescCurso = $("#descricao_curso").val();
			var dataNascimento = $("#DataNascimento").val();
	
			if (DescCurso=="" || dataNascimento==""){
				return false
			}
			
			if (DescCurso!="" && dataNascimento!=""){
				
				var url = "ajax/inc_retorno_ajax.asp";				
				var tipoAcao = "validaIdadeParaMatricula";
				
				$.get(url, 
				{
				  strTipoAcao: tipoAcao, 
				  curso: DescCurso,
				  data_nascimento: dataNascimento
				})
				.done(function (data) {
					var json = jQuery.parseJSON(data);
					var mensagem = json.mensagem;
					 
					if (mensagem!="" && mensagem!="ok") {
						$("#txtMensagemValidaIdadeParaMatricula").val(mensagem);
						alert(mensagem);
						window.location='inscricao.html';
						return false
					}
					else
					{
						listarSeries(descCurso);
					}
		
				}).fail(function (jqxhr, textStatus, error) {
					var err = textStatus + ", " + error;
					//console.log("Request Failed: " + err);
				}).always(function () {
					$.unblockUI();
					return true
				});
			}
		}

		$('#cadastro_reserva').change(function () {
			var descReserv = $("#cadastro_reserva").val();
			if (descReserv == "S"){
				$("#codigo_escola").val("0");
				$("#btnSalvar").attr('value', 'Salvar Cadastro de Reserva');
			}else{
				$("#btnSalvar").attr('value', 'Salvar Inscrição de Matrícula');
			}
		});
		
		//Ao selecionar a série, a combo turno será preenchida com os turnos que tiverem vagas
		$('#codigo_turno').change(function () {
			var descTurno = $("#codigo_turno").val();
			if (descTurno == "INTEGRAL") {
				$("#codigo_escola").val("0");
				$("#cadastro_reserva").val("S");
				$("#escola_disponivel").hide();
				$("#btnSalvar").attr('value', 'Salvar Cadastro de Reserva');
				validaAlunoSeJaExiste("carregaAlunoSeJaExisteReserva");	
				mostrarMensagemCadastroReserva();
				listarEscolas($(this).val());
			} else {
				
				$("#btnSalvar").attr('value', 'Salvar Inscrição de Matrícula');				
				$("#cadastro_reserva").val("0");
				
				if (descTurno == "0"){
					$("#codigo_escola").val("0");
					$("#escola_disponivel").hide();
				} else {
					validaAlunoSeJaExiste("carregaAlunoSeJaExisteMatricula");
					$("#cadastro_reserva").val("0");
					$("#escola_disponivel").show();
				}
				mostrarMensagemCadastroReserva();
				listarEscolas($(this).val());
			}
		});

		//Ao selecionar a série, a combo turno será preenchida com os turnos que tiverem vagas
		$('#codigo_escola').change(function () {
			var Curso = $("#descricao_curso").val();
			var descEscola = $("#codigo_escola").val();
			var descReserv = $("#cadastro_reserva").val();
			var descTurno = $("#codigo_turno").val();
			
			if (descEscola != "0"){	
				$("#cadastro_reserva").val("0");
				$("#btnSalvar").attr('value', 'Salvar Inscrição de Matrícula');
			}else{
				if (descReserv != "0"){
					//$("#btnSalvar").attr('value', 'Salvar Cadastro de Reserva');
				}else{
					$("#btnSalvar").attr('value', 'Salvar Inscrição de Matrícula');
				}
			}
		});
		
        definirMascaraCelular($("#TelefoneContato"));
        definirMascaraCelular($("#FoneMae"));
        definirMascaraCelular($("#FonePai"));
        definirMascaraCelular($("#FoneResponsavel"));
    };

    var obtenhaInscricao = function () {
        return jQuery.parseJSON(sessionStorage.getItem("inscricao"));
    };

    var limparFormulario = function () {
        $("input[type=text]").val("");
        $("select").val("0");

        $("input:radio").prop('checked', false);
        $("input:radio").prop('checked', true);

        $("#Aluno").focus();
        $("#id").val("");
        $("#codigo_turno").val("0");
        $("#codigo_serie").val("0");
        $("#codigo_escola").val("0");
        $("#codigo_serie").prop('disabled', true);
        $("#codigo_turno").prop('disabled', true);
        $("#codigo_escola").prop('disabled', true);

        limparExcecaoFormulario();
    };

    var limparExcecaoFormulario = function () {
        $("span[data-campo]").text("");
        $("div .has-error .remover").remove("span");
        $("div .has-error").removeClass("has-error has-feedback")
    }


    var definirMascara = function () {
        $("#DataNascimento").mask('00/00/0000');
        $("#CPFAluno").mask('000.000.000-00', { reverse: true });
        $("#CEP").mask('00000-000');
        $("#Numero").mask("9999");
		$("#numero_bolsa_familia").mask("99999999999");
    };

    var definirMascaraCelular = function (el) {
        $(el).keydown(function (event) {
            var target, phone, element;
            target = (event.currentTarget) ? event.currentTarget : event.srcElement;
            phone = target.value.replace(/\D/g, '');
            element = $(target);
            element.unmask();
            if (phone.length > 5 && (phone.substr(2, 1) == "9")) { //ele só vai colocar no formato de SP quando for ddd 11 e iniciar com 9.
                element.mask("(00) 00000-0000");
            } else {
                element.mask("(00) 0000-0000");
            }
        });
    }

    var incluir = function () {
		limparValidacoes();
		if ($("#txtMensagemValidaIdade").val().trim().length > 0){
			alert($("#txtMensagemValidaIdade").val())	;
			return false
		}
		if ($("#txtMensagemValidaIdadeParaMatricula").val().trim().length > 0){
			alert($("#txtMensagemValidaIdadeParaMatricula").val())	;
			return false
		}
		if ($("#txtMensagemJaExiste").val().trim().length > 0){
			alert($("#txtMensagemJaExiste").val())	;
			return false
		}
		
		$("#Municipio").prop('disabled', false);
		$("#UF").prop('disabled', false);
		$("#Bairro").prop('disabled', false);
		$("#Endereco").prop('disabled', false);
				
		if (efetuarValidacao() === false) {
            limparValidacoes();
			
			var descReserv = $("#cadastro_reserva").val();
			if (descReserv == "S"){
				$("#btnSalvar").val("Aguarde, reserva está sendo processada!");
				//$("#btnSalvar").val("Aguarde, inscrição está sendo processada!");
			}else{
				$("#btnSalvar").val("Aguarde, inscrição está sendo processada!");
			}
			
			$("#btnSalvar").prop('disabled', true);
			frm.action="inscricao_cod.asp";
			frm.submit();
        }
    };

    var limparValidacoes = function () {
        $("input").parent().removeClass("has-error has-feedback");
        $("select").parent().removeClass("has-error has-feedback");
        $(".remover").remove();
        $(".help-block").text("");
    };

    var bloquearTela = function () {
        $.blockUI({ message: '<h1>Aguarde...</h1>' });
    };

    var listarSeries = function (descCurso) {
        bloquearTela();
		var	dataNascimento = $("#DataNascimento").val();
		
        $("#codigo_turno").val("0");
		$("#codigo_escola").val("0");

        $("#codigo_turno").prop('disabled', true);
        $("#codigo_escola").prop('disabled', true);

		var tipoAcao = "carregaPeriodo";
		var url = "ajax/inc_retorno_ajax.asp";
		$("#codigo_serie").prop('disabled', false);
		$('#codigo_serie').html('<option value="0">Carregando...</option>');

		$.get(url, 
			{
	          strTipoAcao: tipoAcao,
			  curso: descCurso,
			  data_nascimento: dataNascimento
	        })
         .done(function (data) {
             var $ListaSerie = $("#codigo_serie");
			 var json = jQuery.parseJSON(data);
			 $('#codigo_serie').html('<option value="0">Selecione...</option>');
             for (var i = 0; i < json.length; i++) {
                 var option = document.createElement('option');

                 option.text = json[i].descricao;
                 option.value = json[i].codigo;

                 $ListaSerie.append(option);
             }

         }).fail(function (jqxhr, textStatus, error) {
             var err = textStatus + ", " + error;
            // console.log("Request Failed: " + err);
         }).always(function () {
             $.unblockUI();
         });		
    };

    var listarTurnos = function (descSerie) {
        bloquearTela();
		var	dataNascimento = $("#DataNascimento").val();
		
		$("#escola").val("0");
		$("#codigo_turno").prop('disabled', false);
		$("#codigo_escola").prop('disabled', false);

		var tipoAcao = "carregaTurno";
		var url = "ajax/inc_retorno_ajax.asp";
		$("#codigo_turno").prop('disabled', false);
		$('#codigo_turno').html('<option value="0">Carregando...</option>');

		$.get(url, 
			{
	          strTipoAcao: tipoAcao,
			  serie: descSerie,
			  data_nascimento: dataNascimento
	        })
         .done(function (data) {
             var $Lista = $("#codigo_turno");
			 var json = jQuery.parseJSON(data);
			 $('#codigo_turno').html('<option value="0">Selecione...</option>');
             for (var i = 0; i < json.length; i++) {
                 var option = document.createElement('option');

                 option.text = json[i].descricao;
                 option.value = json[i].codigo;

                 $Lista.append(option);
             }

         }).fail(function (jqxhr, textStatus, error) {
             var err = textStatus + ", " + error;
             //console.log("Request Failed: " + err);
         }).always(function () {
             $.unblockUI();
         });		
    };

    var listarEscolas = function (descTurno) {
		bloquearTela();
		var descBairro = $("#Bairro").val().replace("'","´");
		var descCurso = $("#descricao_curso").val();
		var	descSerie = $("#codigo_serie").val();
		var	bolsa_familia = $("#bolsa_familia").val();
		
		$("#escola").val("0");
		$("#codigo_escola").prop('disabled', false);

		var tipoAcao = "carregaEscola";
		var url = "ajax/inc_retorno_ajax.asp";
		$("#codigo_escola").prop('disabled', false);
		$('#codigo_escola').html('<option value="0">Carregando...</option>');

		$.get(url, 
			{
	          strTipoAcao: tipoAcao,
			  curso: descCurso,
			  turno: descTurno,
			  serie: descSerie,
			  bairro: descBairro,
			  bolsaFamilia: bolsa_familia
	        })
         .done(function (data) {
             var $Lista = $("#codigo_escola");
			 var json = jQuery.parseJSON(data);
			 $('#codigo_escola').html('<option value="0">Selecione...</option>');
             for (var i = 0; i < json.length; i++) {
                 var option = document.createElement('option');
				  
				 if (json[i].descricao!="Não existe escola disponível"){
				 	$("#alerta_cadastro_reserva").show();
				 }
				 
                 option.text = json[i].descricao;
                 option.value = json[i].codigo;

                 $Lista.append(option);
             }

         }).fail(function (jqxhr, textStatus, error) {
             var err = textStatus + ", " + error;
             //console.log("Request Failed: " + err);
         }).always(function () {
             $.unblockUI();
         });	
    }

    var efetuarValidacao = function () {

        var inconsistencia = false;

        if ($("#Aluno").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#Aluno"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#Aluno"), true, "O campo nome do aluno é obrigatório")
            inconsistencia = true;
        }
		if ($("#CPFAluno").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#CPFAluno"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#CPFAluno"), true, "O campo CPF do aluno é obrigatório")
            inconsistencia = true;
        }
        if ($("#DataNascimento").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#DataNascimento"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#DataNascimento"), true, "O campo data de nascimento é obrigatório")
            inconsistencia = true;
        }
		
		if ($("#sexo").val().trim() != "0") {
            adiconarRemoverClasseInconsistencia($("#sexo"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#sexo"), true, "O campo sexo é obrigatório")
            inconsistencia = true;
			$("#sexo").focus();
        }

        if ($("#Mae").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#Mae"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#Mae"), true, "O campo nome da mãe é obrigatório")
            inconsistencia = true;
        }

        adiconarRemoverClasseInconsistencia($("#TelefoneContato"), false)
        if ($("#TelefoneContato").val().trim().length > 0 && $("#TelefoneContato").val().trim().length < 14) {
            adiconarRemoverClasseInconsistencia($("#TelefoneContato"), true, "A quantidade de dígitos é inválida")
            inconsistencia = true;
        }

        if ($("#TelefoneContato").val().trim().length < 1) {
            adiconarRemoverClasseInconsistencia($("#TelefoneContato"), true, "O campo telefone é obrigatório")
            inconsistencia = true;
        }

        if ($("#FoneMae").val().trim().length > 0 && $("#FoneMae").val().trim().length < 14) {
            adiconarRemoverClasseInconsistencia($("#FoneMae"), true, "A quantidade de dígitos é inválida")
            inconsistencia = true;
        }
        else {
            adiconarRemoverClasseInconsistencia($("#FoneMae"), false)
        }

        if ($("#FonePai").val().trim().length > 0 && $("#FonePai").val().trim().length < 14) {
            adiconarRemoverClasseInconsistencia($("#FonePai"), true, "A quantidade de dígitos é inválida")
            inconsistencia = true;
        }
        else {
            adiconarRemoverClasseInconsistencia($("#FonePai"), false)
        }

        if ($("#FoneResponsavel").val().trim().length > 0 && $("#FoneResponsavel").val().trim().length < 14) {
            adiconarRemoverClasseInconsistencia($("#FoneResponsavel"), true, "A quantidade de dígitos é inválida")
            inconsistencia = true;
        }
        else {
            adiconarRemoverClasseInconsistencia($("#FoneResponsavel"), false)
        }

        if ($("#CEP").val().trim().length === 9) {
            adiconarRemoverClasseInconsistencia($("#CEP"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#CEP"), true, "O campo CEP é obrigatório")
            inconsistencia = true;
        }
		/*
        if ($("#Endereco").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#Endereco"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#Endereco"), true, "O campo endereço é obrigatório")
            inconsistencia = true;
        }

        if ($("#Bairro").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#Bairro"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#Bairro"), true, "O campo bairro é obrigatório")
            inconsistencia = true;
        }

        if ($("#UF").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#UF"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#UF"), true, "O campo UF é obrigatório")
            inconsistencia = true;
        }

        if ($("#Municipio").val().trim().length > 0) {
            adiconarRemoverClasseInconsistencia($("#Municipio"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#Municipio"), true, "O campo município é obrigatório")
            inconsistencia = true;
        }
		*/
		
		if ($("#descricao_curso").val() == "EDUCACAO_INFANTIL"){
			if ($("#bolsa_familia").val().trim() != "0") {
				adiconarRemoverClasseInconsistencia($("#bolsa_familia"), false)
			}
			else {
				adiconarRemoverClasseInconsistencia($("#bolsa_familia"), true, "Cartão do Programa Bolsa Família é obrigatório")
				inconsistencia = true;
			}
			if ($("#bolsa_familia").val().trim() == "S") {
				if ($("#numero_bolsa_familia").val().trim() == "") 
				{
					adiconarRemoverClasseInconsistencia($("#numero_bolsa_familia"), true, "O campo número da bolsa família é obrigatório")
					inconsistencia = true;
				}
				else
				{
					if ($("#numero_bolsa_familia").val().trim().length!=11) {
						adiconarRemoverClasseInconsistencia($("#numero_bolsa_familia"), true, "O campo número da bolsa família deve ser preenchido com 11 números")
						inconsistencia = true;
					}
					else
					{
						adiconarRemoverClasseInconsistencia($("#numero_bolsa_familia"), false)					
					}
				}
			}
		}
        if ($("#codigo_serie").val().trim() != "0") {
            adiconarRemoverClasseInconsistencia($("#codigo_serie"), false)
        }
        else {
            adiconarRemoverClasseInconsistencia($("#codigo_serie"), true, "O campo serie é obrigatório")
            inconsistencia = true;
        }
		
		if ($("#codigo_serie").val().trim() != "0") {
			if ($("#codigo_turno").val().trim() != "0") {
				adiconarRemoverClasseInconsistencia($("#codigo_turno"), false)
			}
			else {
				
				adiconarRemoverClasseInconsistencia($("#codigo_turno"), true, "O campo turno é obrigatório")
				inconsistencia = true;
			}
		}
		
		if ($("#codigo_serie").val().trim() != "0" && $("#codigo_turno").val().trim() != "0") {
			if ($("#codigo_escola").val() != "0") {
				adiconarRemoverClasseInconsistencia($("#codigo_escola"), false)
			}
			else 
			{
				if ($("#cadastro_reserva").val() == "S"){
					adiconarRemoverClasseInconsistencia($("#codigo_escola"), false)
				}else{
					adiconarRemoverClasseInconsistencia($("#codigo_escola"), true, "O campo escola é obrigatório")
					inconsistencia = true;
				}
			}
		}
				
        adiconarRemoverClasseInconsistencia($("#Email"), false);

        if ($("#Email").val().length > 0 && !validarEmail($("#Email").val())) {
            adiconarRemoverClasseInconsistencia($("#Email"), true, "O e-mail informado é inválido")
            inconsistencia = true;
        }

        $(".has-error.has-feedback > input").first().focus();

        return inconsistencia;
    };

    var adiconarRemoverClasseInconsistencia = function (componente, inconsistencia, mensagem) {

        $(componente).parent().removeClass("has-error has-feedback");
        var campo = $(componente).attr("id");
        var el = $(componente).parent();
        $(el).children(".remover").remove();
        $("span[data-campo='" + campo + "']").text("");

        if (inconsistencia) {

            $(componente).parent().addClass("has-error has-feedback");
            $(componente).parent().append("<span class='glyphicon glyphicon-remove form-control-feedback remover' aria-hidden='true'></span>");

            if (mensagem.length > 0) {
                var campo = $(componente).attr("id");
                $("span[data-campo='" + campo + "']").text(mensagem).show();
            }
        }
    };

    var obterEndercoPorCEP = function (numeroCEP) {
        adiconarRemoverClasseInconsistencia($("#CEP"), false);

        $("#Endereco").val("");
        $("#Bairro").val("");
        $("#UF").val("");
        $("#Municipio").val("");
        $("#Numero").val("");
        $("#Complemento").val("");

        bloquearTela();

        var cep = numeroCEP.replace("-", "");
        var url = "https://viacep.com.br/ws/" + cep + "/json/";
//var url = "https://opencep.com/v1/" + cep + ".json";
				
        $.getJSON(url, cep)
         .done(function (endereco) {
             if (endereco != null) {
                 $("#Endereco").val($.trim(endereco.logradouro));
                 $("#Bairro").val(endereco.bairro);
                 $("#UF").val(endereco.uf);
                 $("#Complemento").val(endereco.complemento);
                 $("#Municipio").val(endereco.localidade);
             }

             if (endereco.erro === true) {
                 adiconarRemoverClasseInconsistencia($("#CEP"), true, "O CEP informado não foi encontrado")
             }
         }).fail(function (jqxhr, textStatus, error) {
             var err = textStatus + ", " + error;
             //console.log("Request Failed: " + err);
             adiconarRemoverClasseInconsistencia($("#CEP"), true, "O CEP informado é inválido")
         }).always(function () {
             $.unblockUI();
         });;
    };

    function validarEmail($email) {
        var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
        return emailReg.test($email);
    }

    return {
        inicialize: inicialize
    };
}()


function verificaOpcaoDeficiencia(){
	if (document.getElementById("rdbDeficienciaSim").checked){
		$("#listaDeficiencias").show();	
	}
	if (document.getElementById("rdbDeficienciaNao").checked){
		$("#listaDeficiencias").hide();	
	}
}

function validaCPF(campo) {
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
		}
				
	}
}
