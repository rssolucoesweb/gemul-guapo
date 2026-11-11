<%
'option explicit
'Classe para Upload
class PatUpload

	private maxLen_			'tamanho maximo do arquivo
	private reqData_		'objeto request
	private path_			'caminho em que sera salvo o arquivo
							'ATENCAO: deve haver permissao de escrita no diretorio

	Private m_FormList		'colecao das variaveis do form
	private FormsCount_		'numero de campos da colecao form


	Private m_FileList		'colecao dos arquivos recebidos
	private FilesCount_		'numero de arquivos enviados

   Private SaveAll_

   Public property get SaveAll()
		SaveAll = SaveAll_
   end property

	'inicializacao das variaveis de controle
	private sub class_initialize()
		FilesCount_ = 0
		FormsCount_ = 0
	end sub

	'tamanho maximo do Upload
	public default property get MaxLen()
		MaxLen = maxLen_
	end property

	public property let MaxLen(val)
		maxLen_ = val
	end property


	'Atribuicao dos campos
	public sub SetData(oRequest, Path, SaveAll)
		'set reqData_ = val
		path_ = Path

       SaveAll_ = SaveAll

		dim byteCount, RequestBin

		byteCount = oRequest.TotalBytes
		'Response.BinaryWrite(Request.BinaryRead(varByteCount))

		RequestBin = oRequest.BinaryRead(byteCount)

		BuildUploadRequest  RequestBin, SaveAll

	end sub

	private Sub BuildUploadRequest(RequestBin, SaveAll)

		dim PosBeg, PosEnd, boundary, boundaryPos
		dim Pos, PosBound, PosFile, iposb
		dim Name, Value, FileName, ContentType
		dim oAuxFile

		'Get the boundary
		PosBeg = 1
		PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
		boundary = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
		boundaryPos = InstrB(1,RequestBin,boundary)

		'Get all data inside the boundaries
		Do until (boundaryPos=InstrB(RequestBin,boundary & getByteString("--")))
			'Members variable of objects are put in a dictionary object
			'Get an object name
			Pos = InstrB(BoundaryPos,RequestBin,getByteString("Content-Disposition"))
			Pos = InstrB(Pos,RequestBin,getByteString("name="))
			PosBeg = Pos+6
			PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(34)))
			Name = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
			PosFile = InstrB(BoundaryPos,RequestBin,getByteString("filename="))
			PosBound = InstrB(PosEnd,RequestBin,boundary)
			'Test if object is of file type
			If  PosFile<>0 AND (PosFile<PosBound) Then
				'Get Filename, content-type and content of file
				PosBeg = PosFile + 10
				PosEnd =  InstrB(PosBeg,RequestBin,getByteString(chr(34)))

				FileName = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))

				Pos = InstrB(PosEnd,RequestBin,getByteString("Content-Type:"))
				PosBeg = Pos+14
				PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))


				'Add content-type to dictionary object
				ContentType = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))

				'Get content of object
				PosBeg = PosEnd+4
				PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
				Value = MidB(RequestBin,PosBeg,PosEnd-PosBeg)

				iposb = InStrRev(FileName,"\")

				'obtem o nome do arquivo
				FileName = Mid(FileName, iposb+1)

               if (trim(FileName)<>"")then

	               'adiciona o arquivo a colecao de arquivos
	               'retorna uma referencia ao arquivo adicionado

	               set oAuxFile = AddFile(Name, FileName, Value, path_, 10)

	               'caso tenha sido solicitado salva o arquivo
	               if(SaveAll_) then
	                   oAuxFile.SaveFile path_,1
	               end if
               end if
			Else
				'Get content of object
				Pos = InstrB(Pos,RequestBin,getByteString(chr(13)))
				PosBeg = Pos+4
				PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
				Value = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))

				'adiciona a variavel de form
				AddForm Name, Value

			End If

			BoundaryPos=InstrB(BoundaryPos+LenB(boundary),RequestBin,boundary)
		Loop

	End Sub

	'funcao para adicionar uma variavel de form
	private Function AddForm(sName, sValue)
		Dim oForm
		Dim oNode,opal

		if Not IsObject(m_FormList) then

			Set oForm = new clsForm

			oForm.Name = sName
			oForm.Value = sValue
			Set m_FormList =new Node
			Set m_FormList.Node = oForm
		Else
			'the list is not empty so just add to it
			Set opal = m_FormList
			'loop until the last node.
			Do While(IsObject(opal))
				if(Not IsObject(opal.pNext)) then
					exit Do
				End if
				Set opal = opal.pNext
			Loop

			Set oForm =new clsForm
			oForm.Name = sName
			oForm.Value = sValue
			Set oNode = new Node

			'insert into the end of the list
			Set oNode.Node = oForm
			oNode.pNext = opal.pNext
			Set opal.pNext = oNode
		End if

		FormsCount_ = FormsCount_ + 1

	End Function


	public Function Form(name)
		Dim opal,i,obj
		Set opal = m_Formlist
		i = 0
		Do While(IsObject(opal))

			Set obj = opal.Node

			if obj.Name = name then
				exit Do
			End if

			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opal = opal.pNext
		Loop

		if Not IsObject(obj) then
			Set Form = Null
		Else
			Set Form = obj
		End if
	End Function

	Private Function AddFile(sName, sFileName, sBinaryData, sPath, iSize)
		Dim oFile
		Dim oNode,opal

       if Not IsObject(m_FileList) then

			Set oFile = new clsFile

			oFile.FileName = sFileName
			oFile.Name = sName
			oFile.Path = path_
			oFile.BinaryData = sBinaryData

			Set m_FileList = new Node
			Set m_FileList.Node = oFile
		Else
			'the list is not empty so just add to it
			Set opal = m_FileList
			'loop until the last node.
			Do While(IsObject(opal))
				if(Not IsObject(opal.pNext)) then
					exit Do
				End if
				Set opal = opal.pNext
			Loop

			Set oFile =new clsFile
			oFile.Name = sName
			oFile.FileName = sFileName
			oFile.BinaryData = sBinaryData
			Set oNode = new Node

			'insert into the end of the list
			Set oNode.Node = oFile
			oNode.pNext = opal.pNext
			Set opal.pNext = oNode
		End if

		FilesCount_ = FilesCount_ + 1

		set AddFile = oFile

	End Function

	public Property Get FilesCount()
		FilesCount = FilesCount_
	End Property

	public Property Get FormsCount()
		FormsCount = FormsCount_
	End Property

	public Function File(name)
		Dim opal,i,obj
		Set opal = m_Filelist
		i = 0
		Do While(IsObject(opal))

			Set obj = opal.Node

			if obj.Name = name then
				exit Do
			End if

			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opal = opal.pNext
		Loop

		if Not IsObject(obj) then
			Set File = Null
		Else
			Set File = obj
		End if
	End Function

	public Function FileByIndex(index)
		Dim opal,i,obj
		Set opal = m_Filelist
		i = 0

		Do While(IsObject(opal))

			if index = i then
				Set obj = opal.Node
				exit Do
			else
				i = i + 1
			End if

			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opal = opal.pNext
		Loop
		if Not IsObject(obj) then
			set FileByIndex = Null
		Else
			set FileByIndex = obj
		End if
	End Function

	public Function FormByIndex(index)
		Dim opal,i,obj
		Set opal = m_Formlist
		i = 0
		Do While(IsObject(opal))

			if index = i then
				Set obj = opal.Node
				exit Do
			else
				i = i + 1
			End if

			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opal = opal.pNext
		Loop
		if Not IsObject(obj) then
			set FormByIndex = Null
		Else
			set FormByIndex = obj
		End if
	End Function


	'String to byte string conversion
	private Function getByteString(StringStr)
		dim i, char
		For i = 1 to Len(StringStr)
			char = Mid(StringStr,i,1)
			getByteString = getByteString & chrB(AscB(char))
		Next
	End Function

	'Byte string to string conversion
	private Function getString(StringBin)
		dim i, intCount
		getString =""
		For intCount = 1 to LenB(StringBin)
			getString = getString & chr(AscB(MidB(StringBin,intCount,1)))
		Next
	end function

	Private Sub Class_Terminate()
		'free all my resources.
		Call Me.Free()
	End Sub

	'----------------------------------------------------
	'Free
	'----------------------------------------------------
	Private Function Free()
		Dim opal,opalNext
		Set opal = m_FormList
		'loop through the list and free Nodes.
		Do While(IsObject(opal))
			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opalNext = opal.pNext
			Set opal = Nothing
			Set opal = opalNext
		Loop

		Set opal = m_FileList
		Do While(IsObject(opal))
			if(Not IsObject(opal.pNext)) then
				exit Do
			End if
			Set opalNext = opal.pNext
			Set opal = Nothing
			Set opal = opalNext
		Loop
		Set opal = Nothing
	End Function

End Class

'classe dos arquivos
class clsFile

	public Name			'nome do campo no form
	private FileName_	'nome do arquivo. Apos salvar contem o nome do arquivo
						'  salvo. Pode ser diferente do original se overwrite = false
	public Size			'tamanho do arquivo em Bytes
	public Path			'path em que sera salvo o arquivo
	public BinaryData	'dados binarios do arquivo
	public ContentType	'typo do arquivo


	'retorna o nome atual do arquivo
	'propriedade default
	public default Property Get FileName()
		FileName = FileName_
	end property

	'atribui o nome do arquivo
	public Property let FileName(val)
		FileName_ = val
	end property

	'salva o arquivo no caminho especificado
	' com o nome FileName_
	'Se overwrite for false Gera um nome no formato nomearquivo(N).ext
	'  onde N primeiro numero inteiro disponivel

	public sub SaveFile(caminho, Overwrite)
		dim  MyFile
		dim i, ScriptObject
		Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")

       path = caminho
	   'path = Server.MapPath("teste")
       if(mid(path,len(path),1)<>"\") then
			path = path & "\"
       end if

		Set MyFile = ScriptObject.CreateTextFile(path &  FileName_)
		
		For i = 1 to LenB(BinaryData)
			MyFile.Write chr(AscB(MidB(BinaryData,i,1)))
		Next

	end sub
end class

'classe das variaveis de form
class clsForm
	public Name			'Nome do campo no form
	private Value_		'Variavel interna do form

	'propriedade default que retorna o nome do campo
	public default property GET Value()
		Value = Value_
	end property

	'propriedade default que retorna o nome do campo
	public property Let Value(val)
		Value_ = Val
	end property

end class

'classe de controle de colecao
Class Node
	Public	Node  'variavel atual
	Public  pNext 'proxima variavel
End Class

%>