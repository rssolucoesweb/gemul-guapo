$( document ).ready(function() {

    if ($("#txtCodPlanejamentoProfessor").val() != "") {
        carregaPlanejamentoProfessor("1");
        carregaPlanejamentoProfessor("2");
        carregaPlanejamentoProfessor("3");
        carregaPlanejamentoProfessor("4");
        carregaPlanejamentoProfessor("5");
        carregarRecursosPlanejamento();
    }

    $(".salvar").hide();

    $( "#txtMetodologia" ).keyup(function() {
        $("#btnMetodologia").show();
		verificaSituacaoEdicao();
    });   

    $( "#btnMetodologia" ).click(function() {
        incluiItemPlanejamento(3, 0, removeCaracterEspecial($( "#txtMetodologia" ).val()),'N');
        $("#btnMetodologia").hide();
    });   
        
    $( "#txtAvaliacao" ).keyup(function() {
        $("#btnAvaliacao").show();
		verificaSituacaoEdicao();
    });  
    
    $( "#btnAvaliacao" ).click(function() {
        incluiItemPlanejamento(4, 0, removeCaracterEspecial($( "#txtAvaliacao" ).val()),'N');
        $("#btnAvaliacao").hide();
    }); 
	
	$( "#txtRegistroReflexivo" ).keyup(function() {
        $("#btnRegistroReflexivo").show();
		verificaSituacaoEdicao();
    });  
    
    $( "#btnRegistroReflexivo" ).click(function() {
        incluiItemPlanejamento(5, 0, removeCaracterEspecial($( "#txtRegistroReflexivo" ).val()),'N');
        $("#btnRegistroReflexivo").hide();
    });    
	
	$( "#txtObservacaoSecretaria" ).keyup(function() {
        $("#btnObservacaoSecretaria").show();
		verificaSituacaoEdicao();
    });  

});

function removeCaracterEspecial(texto) {
    return texto.replace(/'/g, '´').replace(/>/g, '').replace(/</g, '').trim()
}

toastr.options = {
    "closeButton": true,
    "newestOnTop": false,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }

  function mostraBotaoSalvarConteudo(cod_item_planejamento_professor) {
        $("#btnItem-"+cod_item_planejamento_professor).show();
  }

  function carregaPlanejamento(codPlanejamento) {

    $('#divListaPlanejamento').html('carregando...');
    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: codPlanejamento,
            acao: 'carregaPlanejamento',
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {

        $("#divListaPlanejamento").html(data);
        verificaSituacaoEdicao();
 
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    }); 

}

function controleAbertura(codItemPai,codTipo) {
    if ($("#txtControleAbertura-" + codItemPai + "-" + codTipo).val()=="S") {
        $("#txtControleAbertura-" + codItemPai + "-" + codTipo).val("N")
    }else {
        $("#txtControleAbertura-" + codItemPai + "-" + codTipo).val("S")
    }
}

function carregaItensTipo(codItemPai,codTipo) {

    if ($("#txtControleAbertura-" + codItemPai + "-" + codTipo).val()=="N") {
        $('#div-' + codItemPai + '-' + codTipo).html('fechado');
        return;
    }

    $('#div-' + codItemPai + '-' + codTipo).html('carregando...');

    switch(parseInt(codTipo)) {
        case 1:
        case 2:
        case 3:
        case 4:
          strAcao = 'carregaItensTipo';
          break;
        default:
            strAcao = '';
      }    
//alert($("#bolAulaExtra").val())
    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            codPlanejamento: $("#txtCodPlanejamento").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            Semestre: $("#txtHiddenSemestre").val(),
            codPeriodo:$("#txtHiddenCodPeriodo").val(),
            codBimestre:$("#cmbBimestre").val(),
            codDisciplina:$("#txtHiddenCodDisciplina").val(),            
            codItemPai: $("#cmbUnidadeTematica").val(), 
            bolAulaExtra: $("#bolAulaExtra").val(),
            codTipo: codTipo,
            acao: strAcao,
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        $('#div-' + codItemPai + '-' + codTipo).html(data);
        verificaSituacaoEdicao();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });   
}


function verificaSituacaoEdicao() {
		
		if ($("#edicao").val()=="S"){
			$('#btnMetodologia').hide();
			$('#btnAvaliacao').hide();
			$('#btnRegistroReflexivo').hide();
			$(".textArea").attr("disabled", true);
            $(".recurso-edicao").hide();
			//$('.edicao').hide();
		}

}
function excluir() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            acao: "ExcluirPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {

        carregaPlanejamentoProfessor("1");
        carregaPlanejamentoProfessor("2");
        carregaPlanejamentoProfessor("3");
        carregaPlanejamentoProfessor("4");
        carregaPlanejamentoProfessor("5");

        $("#txtCodPlanejamentoProfessor").val("");

        toastr.success("Planejamento excluido com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function validar() {

   

    if( $("#cmbValidado").val()=="S" && ($("#txtMetodologia" ).val().trim() ==="" || $("#txtAvaliacao" ).val().trim() ==="" ||  $("#div-2").html().search("Nenhum item incluído") > -1)) {
        toastr.error("Atenção! Não é possível validar pois os campos Objetos de conhecimento, Metodologia e/ou Avaliação não foram informados pelo(a) professor(a).");
        return false;
    }


    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacao: $("#txtObservacao").val(),
            validado: $("#cmbValidado").val(),
            acao: "ValidarPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {
        toastr.success("Planejamento validado com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function salvarObservacaoSecretaria() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacaoSecretaria: $("#txtObservacaoSecretaria").val(),
            acao: "salvarObservacaoSecretaria"

        }
    )
    .done(function() {
        toastr.success("Observação da Secretaria salva com sucesso!");
		$('#btnObservacaoSecretaria').hide();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}

function cancelar() {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            anoLetivo: $("#txtHiddenAnoLetivo").val(),
            semestre: $("#txtSemestre").val(),
            codProfessor: $("#txtCodProfessor").val(),
            numeroAula: $("#txtHiddenAula").val(),
            observacao: $("#txtObservacao").val(),
            validado: $("#cmbValidado").val(),
            acao: "CancelarValidacaoPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function() {
        toastr.success("Validação do Planejamento foi cancelado com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });    

}
function incluiItemPlanejamento(codTipo, codItemPlanejamento, descricao, itemSelecionado) {
	descricaoExistente = ""
	if ($("#edicao").val()!="S"){

		if (codTipo==3 || codTipo==4 || codTipo==5) {
            if (itemSelecionado==="S") {
			    descricaoExistente = preencheCampo(codTipo, descricao);
                if (descricaoExistente!=undefined) {
                    descricao = descricaoExistente;
                }
            } 
		}
		
		if (codTipo==1 || codTipo==2) {
			if ($("#btnMetodologia").is(":visible")) {
				alert("Você ainda não salvou a Metodologia digitada!");
			}
			if ($("#btnAvaliacao").is(":visible")) {
				alert("Você ainda não salvou a Avaliação digitada!");
			}
			if ($("#btnRegistroReflexivo").is(":visible")) {
				alert("Você ainda não salvou o Registro Reflexivo digitado!");
			}
		}
		
		$.post( "sca_planejamento_professor_aula_cod.asp", 
			{ 
				cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
				cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
				cod_item_planejamento_geral: codItemPlanejamento,
				anoLetivo: $("#txtHiddenAnoLetivo").val(),
				semestre: $("#txtSemestre").val(),
				codProfessor: $("#txtCodProfessor").val(),
				numeroAula: $("#txtHiddenAula").val(),
				bolAulaExtra: $("#bolAulaExtra").val(),
				cod_periodo: $("#txtCodPeriodo").val(),
				codDisciplina: $("#txtCodDisciplina").val(), 
				codTurno: $("#txtCodTurno").val(),
				codTurma: $("#txtCodTurma").val(),
				descricao: descricao,            
				codTipo: codTipo,
				acao: "incluiItemPlanejamento",
                periodoValido: $("#periodoValido").val()

			}
		)
		.done(function( data ) {
			
			var retorno = $.trim(data);

			// Habilidade duplicada
			if (retorno === "DUPLICADO|HABILIDADE") {

				toastr.warning(
					"Atenção! Esta habilidade já foi cadastrada neste planejamento."
				);

				return;
			}


			// Objeto de conhecimento / Conteúdo duplicado
			if (retorno === "DUPLICADO|CONTEUDO") {

				toastr.warning(
					"Atenção! Este Objetivo do conhecimento / conteúdo já foi cadastrado neste planejamento."
				);

				return;
			}


			// Erro retornado pelo ASP
			if (retorno.indexOf("ERRO|") === 0) {

				toastr.error(
					retorno.replace("ERRO|", "")
				);

				return;
			}


			var vetRetorno = retorno.split(",");

			if ($("#txtCodPlanejamentoProfessor").val() === "") {
				$("#txtCodPlanejamentoProfessor").val(vetRetorno[0]);
			}


			if (codTipo == 1 || codTipo == 2) {
				carregaPlanejamentoProfessor(codTipo);
			}


			toastr.success("Item incluído com sucesso!");
		})
		.fail(function() {
			toastr.error("Ocorreu um erro");
		});    
	}
}

function preencheCampo(codTipo, texto) {
    var descricao = ""
    var descItem = ""

    if (codTipo==3) {
        descItem = "Metodologia"
    } else if (codTipo==4) {
        descItem = "Avaliacao"
    } else if (codTipo==5) {
		descItem = "RegistroReflexivo"
    }

    descricao = $("#txt" + descItem).val();

    if (descricao !="") {
        descricao += ", "
    } 

    descricao += texto
    $("#txt" + descItem).val(descricao);
    return descricao;
}

function carregaPlanejamentoProfessor(codTipo) {


    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
            codTipo: codTipo,
            acao: "carregaPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        switch(parseInt(codTipo)) {
            case 1:
            case 2:
                $('#div-' + codTipo).html(data);
                break;
            case 3:
            case 4:
                if (codTipo==3) {
                    descItem = "Metodologia"
                }else {
                    descItem = "Avaliacao"
                }                
                $("#txt" + descItem).val(data);
              break;
			case 5:
                descItem = "RegistroReflexivo"
                $("#txt" + descItem).val(data);
              break;
			  
            default:
                break;
        }
        
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function removeItemPlanejamentoProfessor(codItemPlanejamentoProfessor, codTipo) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_item_planejamento_professor: codItemPlanejamentoProfessor,
            acao: "removeItemPlanejamentoProfessor",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        carregaPlanejamentoProfessor(codTipo);
        toastr.success("Item excluído com sucesso!");
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function salvaComplemento(codItemPlanejamentoProfessor) {

    $.post( "sca_planejamento_professor_aula_cod.asp", 
        { 
            cod_item_planejamento_professor: codItemPlanejamentoProfessor,
            descricao: $("#txtItem-"+codItemPlanejamentoProfessor).val(),
            acao: "salvaComplemento",
            periodoValido: $("#periodoValido").val()

        }
    )
    .done(function( data ) {
        toastr.success("Complemento incluído com sucesso!");
        $("#btnItem-"+codItemPlanejamentoProfessor).hide();
    })
    .fail(function() {
        toastr.error("Ocorreu um erro");
    });      

}

function atualizaBimestreTela() {

    for (let i = 1; i < 4; i++) {
        if ($("#txtControleAbertura-" + $("#txtCodPlanejamento").val() + "-" + i).val()=="S") {
            carregaItensTipo($("#txtCodPlanejamento").val(),i);
        }
    }

}


// -----------------------------------------------------------------------------
// Materiais de apoio - Arquivos e Links
// -----------------------------------------------------------------------------
function dadosBasePlanejamento() {
    return {
        cod_planejamento_geral: $("#txtCodPlanejamentoEscola").val(),
        cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val(),
        anoLetivo: $("#txtHiddenAnoLetivo").val(),
        semestre: $("#txtSemestre").val(),
        codProfessor: $("#txtCodProfessor").val(),
        numeroAula: $("#txtHiddenAula").val(),
        bolAulaExtra: $("#bolAulaExtra").val(),
        cod_periodo: $("#txtCodPeriodo").val(),
        codDisciplina: $("#txtCodDisciplina").val(),
        codTurno: $("#txtCodTurno").val(),
        codTurma: $("#txtCodTurma").val(),
        periodoValido: $("#periodoValido").val()
    };
}

function carregarRecursosPlanejamento() {
    var codPlanejamentoProfessor = $("#txtCodPlanejamentoProfessor").val();

    if (!codPlanejamentoProfessor || codPlanejamentoProfessor === "0") {
        $("#divRecursosPlanejamento").html("<div class='text-muted'>Nenhum material de apoio incluído.</div>");
        return;
    }

    $("#divRecursosPlanejamento").html("carregando...");

    $.post("sca_planejamento_professor_aula_cod.asp", {
        acao: "listarRecursosPlanejamento",
        cod_planejamento_professor: codPlanejamentoProfessor,
        edicao: $("#edicao").val()
    })
    .done(function(data) {
        $("#divRecursosPlanejamento").html(data);
    })
    .fail(function() {
        $("#divRecursosPlanejamento").html("<div class='text-danger'>Não foi possível carregar os materiais de apoio.</div>");
    });
}

function enviarArquivoPlanejamento() {
    if ($("#edicao").val() === "S") {
        toastr.warning("Este planejamento está bloqueado para edição.");
        return;
    }

    var input = document.getElementById("arquivoPlanejamento");
    if (!input.files || input.files.length === 0) {
        toastr.warning("Selecione um arquivo.");
        return;
    }

    var arquivo = input.files[0];
    var limiteBytes = 10 * 1024 * 1024;
    var extensoesPermitidas = ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "jpg", "jpeg", "png", "zip"];
    var partesNome = arquivo.name.split(".");
    var extensao = partesNome.length > 1 ? partesNome.pop().toLowerCase() : "";

    if ($.inArray(extensao, extensoesPermitidas) === -1) {
        toastr.warning("Tipo de arquivo não permitido.");
        return;
    }

    if (arquivo.size > limiteBytes) {
        toastr.warning("O arquivo deve possuir no máximo 10 MB.");
        return;
    }

    var reader = new FileReader();
    $("#btnEnviarArquivoPlanejamento").prop("disabled", true).html("<i class='fal fa-spinner fa-spin mr-1'></i> Enviando...");

    reader.onload = function(e) {
        var resultado = e.target.result || "";
        var posVirgula = resultado.indexOf(",");
        var base64 = posVirgula >= 0 ? resultado.substring(posVirgula + 1) : resultado;
        var dados = dadosBasePlanejamento();

        dados.acao = "incluirArquivoPlanejamento";
        dados.descricaoRecurso = $("#txtDescricaoArquivo").val();
        dados.nomeArquivo = arquivo.name;
        dados.tipoArquivo = arquivo.type || "application/octet-stream";
        dados.tamanhoArquivo = arquivo.size;
        dados.arquivoBase64 = base64;

        $.ajax({
            url: "sca_planejamento_professor_aula_cod.asp",
            type: "POST",
            data: dados
        })
        .done(function(data) {
            var retorno = $.trim(data);
            if (retorno.indexOf("OK|") === 0) {
                var partes = retorno.split("|");
                if (partes.length > 1 && partes[1] !== "") {
                    $("#txtCodPlanejamentoProfessor").val(partes[1]);
                }
                $("#arquivoPlanejamento").val("");
                $("#txtDescricaoArquivo").val("");
                carregarRecursosPlanejamento();
                toastr.success("Arquivo incluído com sucesso!");
            } else {
                toastr.error(retorno.replace("ERRO|", "") || "Não foi possível incluir o arquivo.");
            }
        })
        .fail(function(xhr) {
            if (xhr.status === 413) {
                toastr.error("O arquivo excedeu o limite de requisição configurado no IIS.");
            } else {
                toastr.error("Ocorreu um erro ao enviar o arquivo.");
            }
        })
        .always(function() {
            $("#btnEnviarArquivoPlanejamento").prop("disabled", false).html("<i class='fal fa-upload mr-1'></i> Enviar arquivo");
        });
    };

    reader.onerror = function() {
        $("#btnEnviarArquivoPlanejamento").prop("disabled", false).html("<i class='fal fa-upload mr-1'></i> Enviar arquivo");
        toastr.error("Não foi possível ler o arquivo selecionado.");
    };

    reader.readAsDataURL(arquivo);
}

function adicionarLinkPlanejamento() {
    if ($("#edicao").val() === "S") {
        toastr.warning("Este planejamento está bloqueado para edição.");
        return;
    }

    var url = $.trim($("#txtUrlPlanejamento").val());
    if (url === "") {
        toastr.warning("Informe o link.");
        return;
    }

    if (!/^https?:\/\//i.test(url)) {
        toastr.warning("Informe um link iniciado por http:// ou https://.");
        return;
    }

    var dados = dadosBasePlanejamento();
    dados.acao = "incluirLinkPlanejamento";
    dados.descricaoRecurso = $("#txtDescricaoLink").val();
    dados.urlRecurso = url;

    $("#btnAdicionarLinkPlanejamento").prop("disabled", true);

    $.post("sca_planejamento_professor_aula_cod.asp", dados)
    .done(function(data) {
        var retorno = $.trim(data);
        if (retorno.indexOf("OK|") === 0) {
            var partes = retorno.split("|");
            if (partes.length > 1 && partes[1] !== "") {
                $("#txtCodPlanejamentoProfessor").val(partes[1]);
            }
            $("#txtDescricaoLink").val("");
            $("#txtUrlPlanejamento").val("");
            carregarRecursosPlanejamento();
            toastr.success("Link incluído com sucesso!");
        } else {
            toastr.error(retorno.replace("ERRO|", "") || "Não foi possível incluir o link.");
        }
    })
    .fail(function() {
        toastr.error("Ocorreu um erro ao incluir o link.");
    })
    .always(function() {
        $("#btnAdicionarLinkPlanejamento").prop("disabled", false);
    });
}

function excluirRecursoPlanejamento(codigo) {
    if ($("#edicao").val() === "S") {
        toastr.warning("Este planejamento está bloqueado para edição.");
        return;
    }

    if (!confirm("Deseja realmente excluir este material de apoio?")) {
        return;
    }

    $.post("sca_planejamento_professor_aula_cod.asp", {
        acao: "excluirRecursoPlanejamento",
        codigoRecurso: codigo,
        cod_planejamento_professor: $("#txtCodPlanejamentoProfessor").val()
    })
    .done(function(data) {
        var retorno = $.trim(data);
        if (retorno === "OK") {
            carregarRecursosPlanejamento();
            toastr.success("Material excluído com sucesso!");
        } else {
            toastr.error(retorno.replace("ERRO|", "") || "Não foi possível excluir o material.");
        }
    })
    .fail(function() {
        toastr.error("Ocorreu um erro ao excluir o material.");
    });
}

$(window).on("load", function(){
   verificaSituacaoEdicao();
   	$('#btnObservacaoSecretaria').hide();
});