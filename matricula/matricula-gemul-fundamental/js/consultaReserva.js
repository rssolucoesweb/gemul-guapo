var inscricao = function () {

    var inicialize = function () {
		
        definirMascara();

        $("#btnSalvar").on("click", function () {
            consultar();
        });
		
        $("#DataNascimento").on("blur", function () {
			if ($("#DataNascimento").val().length != 10) {
				alert("O campo data de nascimento deve estar no formato dd/mm/aaaa. Ex: 14/01/2014!");
				return false
			}	
				   
        });
    };

    var limparExcecaoFormulario = function () {
        $("span[data-campo]").text("");
        $("div .has-error .remover").remove("span");
        $("div .has-error").removeClass("has-error has-feedback")
    }


    var definirMascara = function () {
        $("#DataNascimento").mask('00/00/0000');
		$("#Numero").mask("000000000");
    };

    var consultar = function () {
		if (efetuarValidacao("Para acessar e atualizar o cadastro de reserva é necessário que seja informado o Protocolo ou Dados Pessoais do Aluno")) {
            return;
        }

		$("#btnSalvar").val("Aguarde, reserva está sendo acessada!");
		$("#btnSalvar").prop('disabled', true);
			
		frm.action="reserva.asp";
		frm.submit();
    };

   var efetuarValidacao = function (msg) {

        var inconsistencia = false;

        if ($("#Numero").val() === "" && $("#DataNascimento").val() === "" && $("#Aluno").val() ==="" && $("#Mae").val() ==="") {
			alert("Para acessar e atualizar o cadastro de reserva é necessário que seja informado o Protocolo ou Dados Pessoais do Aluno");
			$("#Numero").focus();
            return true;
        }

        if ($("#Numero").val() !== "" ) {
			adiconarRemoverClasseInconsistencia($("#Numero"), false)
	    }
        else {
            if ($("#Aluno").val() !== "") {
                adiconarRemoverClasseInconsistencia($("#Aluno"), false)
            }
            else {
                adiconarRemoverClasseInconsistencia($("#Aluno"), true, "O campo aluno é obrigatório")
                inconsistencia = true;
            }

            if ($("#Mae").val() !== "") {
                adiconarRemoverClasseInconsistencia($("#Mae"), false)
            }
            else {
                adiconarRemoverClasseInconsistencia($("#Mae"), true, "O campo mãe é obrigatório")
                inconsistencia = true;
            }

			if ($("#DataNascimento").val() !== "") {
                adiconarRemoverClasseInconsistencia($("#DataNascimento"), false)
            }
            else {
                adiconarRemoverClasseInconsistencia($("#DataNascimento"), true, "O campo data de nascimento é obrigatório")
                inconsistencia = true;
            }

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

    return {
        inicialize: inicialize
    };
}()