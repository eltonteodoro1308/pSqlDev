#include 'totvs.ch'
#include 'sigawin.ch'
#include 'dwconst.ch'
//#include 'protheus.ch'
//#include "stdwin.ch"
//#include 'prconst.ch'

user function pSqlDev()

	Static oDlgMain   := nil
	Static oFontBtn   := TFont():New( 'Consolas',,-12,,.T. )

	Local cCacheFile  := 'pSqlDev.sql'
	Local cCache      := memoRead( cCacheFile )
	Local oDfSzDlg    := FwDefSize():New( .F. )
	Local oDfSzBtn    := FwDefSize():New( .F. )
	Local oBtnQuery   := nil
	local oBtnScript  := nil
	local oBtnParse   := nil
	Local oBtnOpen    := nil
	Local oBtnSave    := nil
	Local oBtnClose   := nil
	Local oChkCommnt  := nil
	Local lChkCommnt  := .T.
	Local oWebChannel := nil
	Local oWebEngine  := nil
	Local cTitle      := 'pSqlDev - Protheus SQL Developer'

	Local nTop    := 0
	Local nBottom := 0
	Local nLeft   := 0
	Local nRight  := 0

	Local nRow    := 0
	Local nColumn := 0
	Local nWidth  := 0
	Local nHeight := 0

	oDfSzDlg:AddObject ( 'oButtons'   , 000, 015, .T., .F. )
	oDfSzDlg:AddObject ( 'oWebEngine' , 000, 000, .T., .T. )
	oDfSzDlg:Process()

	oDfSzBtn:AddObject ( 'oBtnQuery' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnScript', 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnParse' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnOpen'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnSave'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oChkCommnt', 080, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	nTop    := oDfSzBtn:aWindSize[ 1 ]
	nLeft   := oDfSzBtn:aWindSize[ 2 ]
	nBottom := oDfSzBtn:aWindSize[ 3 ]
	nRight  := oDfSzBtn:aWindSize[ 4 ]

	DEFINE MSDIALOG oDlgMain TITLE cTitle FROM nTop, nLeft TO nBottom, nRight PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnQuery', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnQuery', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnQuery', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnQuery', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnQuery PROMPT 'QUERY <F5>' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn;
		ACTION oWebEngine:runJavaScript( 'makeQueryObject( true, "query" )' ) PIXEL
	oBtnQuery:cToolTip := "Executa uma query de consulta ao banco de dados."

	nRow    := oDfSzBtn:GetDimension( 'oBtnScript', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnScript', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnScript', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnScript', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnScript PROMPT 'SCRIPT <F6>' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn ACTION;
		oWebEngine:runJavaScript( 'makeQueryObject( true, "script" )' ) PIXEL
	oBtnScript:cToolTip := "Executa um script sql no banco de dados."

	nRow    := oDfSzBtn:GetDimension( 'oBtnParse', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnParse', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnParse', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnParse', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnParse PROMPT 'PARSE' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn ACTION;
		oWebEngine:runJavaScript( 'makeQueryObject(' + IF( lChkCommnt, 'true', 'false' ) + ',"parse" )' ) PIXEL
	oBtnParse:cToolTip := "Faz o parse da query, tratando e resolvendo o embedded sql."

	nRow    := oDfSzBtn:GetDimension( 'oBtnOpen', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnOpen', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnOpen', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnOpen', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnOpen PROMPT 'ABRIR' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn ACTION alert('ABRIR') PIXEL
	oBtnOpen:cToolTip := "Abre um arquivo salvo."

	nRow    := oDfSzBtn:GetDimension( 'oBtnSave', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnSave', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnSave', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnSave', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnSave PROMPT 'SALVAR' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn ACTION alert('SALVAR') PIXEL
	oBtnSave:cToolTip := "Salvo a consulta."

	nRow    := oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnClose PROMPT 'FECHAR' SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn ACTION oDlgMain:End() PIXEL
	oBtnClose:cToolTip := "Fecha o programa."

	nRow    := oDfSzBtn:GetDimension( 'oChkCommnt', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oChkCommnt', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oChkCommnt', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oChkCommnt', 'YSIZE'  )

	@ nRow+5, nColumn+5 CHECKBOX oChkCommnt VAR lChkCommnt PROMPT "PARSE SEM COMENTÁRIOS" SIZE nWidth, nHeight OF oDlgMain FONT oFontBtn PIXEL
	oChkCommnt:cToolTip := "No parser da query exclui os comentários."

	nRow    := oDfSzDlg:GetDimension( 'oWebEngine', 'LININI' )
	nColumn := oDfSzDlg:GetDimension( 'oWebEngine', 'COLINI' )
	nWidth  := oDfSzDlg:GetDimension( 'oWebEngine', 'XSIZE'  )
	nHeight := oDfSzDlg:GetDimension( 'oWebEngine', 'YSIZE'  )

	oWebChannel := TWebChannel():New()
	oWebChannel:bJsToAdvpl := {|self,key,value| jsToAdvpl(self,key,value, cCacheFile) }
	oWebChannel:connect()

	oWebEngine := TWebEngine():New( oDlgMain, nRow, nColumn, nWidth, nHeight, getUrl(), oWebChannel:nPort )

	oWebEngine:bLoadFinished := { | webengine, url |;
		WebEngine:runJavaScript( "document.querySelector('textarea').value = `" + cCache + "`" ) }

	aEval( oDlgMain:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:disable(), nil ) } )

	oDlgMain:Activate(,,,.T.)

return

static function jsToAdvpl( self, key, value, cCacheFile )

	Local oJson   := jsonObject():New()
	Local cQuery  := ''
	Local aColumn := {}
	Local cAlias  := ''
	Local nStatus := 0
	Local cErro   := ''
	Local bError  := ErrorBlock( { | oErro | cErro := oErro:Description } )

	if key == 'activeButtons'

		aEval( oDlgMain:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:enable(), nil ) } )

	elseIf key == 'recordQuery'

		memoWrite( cCacheFile, value )

	elseIf key $ 'query/script/parse'

		oJson:fromJson( value )
		cQuery := oJson['query']

		parseExp( @cQuery, oJson )
		parseColumns( @aColumn, oJson )
		parseTable( @cQuery, oJson )
		parseBranch( @cQuery, oJson )
		parseOrder( @cQuery, oJson )

		If key == 'query'

			MsgRun ( 'Banco de Dados Processando a Query ...', 'Aguarde ...', { | | cAlias := MpSysOpenQuery( cQuery ) } )

			if empty( cErro )

				showResult( cAlias )

				( cAlias )->( DbCloseArea() )

			else

				AutoGrLog( cErro )
				MostraErro()

			endIf

		elseIf key == 'script'

			MsgRun ( 'Banco de Dados Processando o Script ...', 'Aguarde ...', { | | nStatus := TCSqlExec( cQuery ) } )

			If nStatus < 0

				AutoGrLog( TCSQLError() )
				MostraErro()

			Else

				ApMsgInfo( 'Script Processado Com Sucesso.', 'Atenção !!!' )

			EndIf

		elseIf key == 'parse'

			AutoGrLog( cQuery )
			MostraErro()

		endIf

	endIf

	ErrorBlock( bError )

return

static function showResult( cAlias )

	Local oDfSzDlg  := FwDefSize():New( .F. )
	Local oDfSzBtn  := FwDefSize():New( .F. )
	Local oFontBtn  := TFont():New( 'Consolas',,-12,, .T. )
	Local oFontBrw  := TFont():New( 'Consolas',,-12 )
	Local oDlg      := Nil
	Local oBtn2Exc  := Nil
	Local oBtnClose := Nil
	Local oBrowse   := Nil
	Local aHeaders  := {}
	Local aLinesBrw := {}
	Local bLinesBrw := nil

	Local nTop      := 0
	Local nBottom   := 0
	Local nLeft     := 0
	Local nRight    := 0

	Local nRow      := 0
	Local nColumn   := 0
	Local nWidth    := 0
	Local nHeight   := 0

	oDfSzDlg:AddObject ( 'oButtons', 000, 015, .T., .F. )
	oDfSzDlg:AddObject ( 'oBrowse' , 000, 000, .T., .T. )
	oDfSzDlg:Process()

	oDfSzBtn:AddObject ( 'oBtn2Exc' , 050, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose', 050, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	nTop    := oDfSzDlg:aWindSize[ 1 ]
	nBottom := oDfSzDlg:aWindSize[ 2 ]
	nLeft   := oDfSzDlg:aWindSize[ 3 ]
	nRight  := oDfSzDlg:aWindSize[ 4 ]

	DEFINE MSDIALOG oDlg TITLE cAlias FROM nTop, nBottom  TO nLeft, nRight PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtn2Exc', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtn2Exc', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtn2Exc', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtn2Exc', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtn2Exc PROMPT 'EXCEL' SIZE nWidth, nHeight OF oDlg FONT oFontBtn ACTION alert('EXCEL') PIXEL
	oBtn2Exc:cToolTip := "Exporta para Excel."

	nRow    := oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnClose PROMPT 'FECHAR' SIZE nWidth, nHeight OF oDlg FONT oFontBtn ACTION oDlg:End() PIXEL
	oBtnClose:cToolTip := "Fecha o programa."

	MsgRun ( 'Montando Browse de Exibição ...', 'Aguarde ...',;
		{ || makeLstBrw( cAlias, aHeaders, aLinesBrw, @bLinesBrw ) } )

	bLinesBrw := &( bLinesBrw )

	oBrowse := TWBrowse():New(;
	/* nRow       */ oDfSzDlg:GetDimension( 'oBrowse', 'LININI' ) ,;
	/* nCol       */ oDfSzDlg:GetDimension( 'oBrowse', 'COLINI' ) ,;
	/* nWidth     */ oDfSzDlg:GetDimension( 'oBrowse', 'XSIZE'  ) ,;
	/* nHeight    */ oDfSzDlg:GetDimension( 'oBrowse', 'YSIZE'  ) ,;
	/* bLine      */                                              ,;
	/* aHeaders   */                                     aHeaders ,;
	/* aColSizes  */                                              ,;
	/* oDlg       */                                         oDlg ,;
	/* cField     */                                              ,;
	/* uValue1    */                                              ,;
	/* uValue2    */                                              ,;
	/* bChange    */                                              ,;
	/* bLDblClick */                                              ,;
	/* bRClick    */                                              ,;
	/* oFont      */                                     oFontBrw ,;
	/* oCursor    */                                              ,;
	/* nClrFore   */                                              ,;
	/* nClrBack   */                                              ,;
	/* cMsg       */                                              ,;
	/* uParam20   */                                              ,;
	/* cAlias     */                                              ,;
	/* lPixel     */                                          .T. ,;
	/* bWhen      */                                              ,;
	/* uParam24   */                                              ,;
	/* bValid     */                                              ,;
	/* lHScroll   */                                          .T. ,;
	/* lVScroll   */                                          .T.  )

	oBrowse:setArray( aLinesBrw )
	oBrowse:bLine    := bLinesBrw

	oDlg:Activate(,,,.T.)

return

static function makeLstBrw( cAlias, aHeaders, aLinesBrw, bLinesBrw )

	Local nX   := 0
	Local aAux := {}

	( cAlias )->( DbGoTop() )

	While ! ( cAlias )->( Eof() )

		For nX := 1 To ( cAlias )->( FCount() )

			aAdd( aAux, ( cAlias )->&( FieldName( nX ) ) )

		Next

		aAdd( aLinesBrw, aClone( aAux ) )

		aSize( aAux, 0 )

		( cAlias )->( DbSkip() )

	End

	bLinesBrw := '{||{'

	For nX := 1 To ( cAlias )->( FCount() )

		aAdd( aHeaders, ( cAlias )->( FieldName( nX ) ) )

		bLinesBrw += 'aLinesBrw[ oBrowse:nAt, ' + cValToChar( nX ) + ']'

		If nX < ( cAlias )->( FCount() )

			bLinesBrw += ','

		EndIf

	Next

	bLinesBrw += '}}'

return

static function parseExp( cQuery, oJson )

	Local nX := 0

	if ! Empty( oJson['advplExpressions']  )

		for nX := 1 to Len( oJson['advplExpressions'] )

			Eval( &('{||' + StrTran( oJson['advplExpressions'][ nX ], '--?', '' ) + '}') )

		next

	endIf

	ProcExp( @cQuery, oJson  )

return

static function ProcExp( cQuery, oJson )

	local nX    := 0
	local cExp  := ''
	local aList := oJson['embeddedExpressions']


	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cExp := aList[ nX ]
			cExp := StrTran( cExp, '%', '' )
			cExp := StrTokArr2( cExp, ':', .T. )[2]

			cExp := Eval( &('{||' + cExp + '}') )

			cType := ValType( cExp )

			if cType == 'C'

				cExp := "'" + cExp + "'"

			elseIf cType == 'N'

				cExp := cValToChar( cExp )

			elseIf cType == 'D'

				cExp := "'" + DtoS( cExp ) + "'"

			elseIf cType == 'L'

				cExp := "'" + StrTran( cValToChar( cExp ), '.', '' ) + "'"

			endIf

			cQuery := StrTran( cQuery, aList[ nX ], cExp )

		next nX

	endIf

return

static function parseColumns( aColumn, oJson )

	Local aList      := oJson['columns']
	Local nX         := 0
	Local cAux       := ''
	Local aAux       := {}
	Local cField     := ''
	Local cType      := ''
	Local nSize      := 0
	Local nPrecision := 0

	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cAux := Upper( aList[nX] )
			cAux := StrTran( cAux, 'COLUMN', '' )
			cAux := StrTran( cAux, CR, '')
			cAux := StrTran( cAux, LF, '')
			aAux   := StrTokArr2( cAux, 'AS' )

			cField := AllTrim( aAux[ 1 ] )

			if 'NUMERIC' $ cAux

				cType := 'N'

				nSize := aAux[ 2 ]
				nSize := StrTokArr2( nSize, '(' )[ 2 ]
				nSize := StrTokArr2( nSize, ',' )[ 1 ]
				nSize := Val( nSize )

				nPrecision := aAux[ 2 ]
				nPrecision := StrTokArr2( nPrecision, '(' )[ 2 ]
				nPrecision := StrTokArr2( nPrecision, ',' )[ 2 ]
				nPrecision := StrTran( nPrecision, ')', '' )
				nPrecision := Val( nPrecision )

			else

				cType := AllTrim( aAux[ 2 ] )
				cType := SubStr( cType, 1, 1 )

				nSize := 0
				nPrecision := 0

			endIf

			aAdd( aColumn, { cField, cType, nSize, nPrecision } )

		next nX

	endIf

return

static function parseTable( cQuery, oJson )

	Local nX     := 0
	Local aList  := oJson['tables']
	Local cTable := ''

	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cTable := aList[ nX ]
			cTable := StrTran( cTable, '%', '' )
			cTable := StrTokArr2( cTable, ':', .T. )[2]
			cTable := RetSqlName( cTable )

			cQuery := StrTran( cQuery, aList[ nX ], cTable )

		next

	endIf

return

static function parseBranch( cQuery, oJson )

	Local nX      := 0
	Local aList   := oJson['branchs']
	Local cBranch := ''

	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cBranch := aList[ nX ]
			cBranch := StrTran( cBranch, '%', '' )
			cBranch := StrTokArr2( cBranch, ':', .T. )[2]
			cBranch := xFilial( cBranch )
			cBranch := "'" + cBranch + "'"

			cQuery := StrTran( cQuery, aList[ nX ], cBranch )

		next

	endIf

return

static function parseOrder( cQuery, oJson )

	Local aList    := oJson['order']
	Local nX       := 0
	Local nY       := 0
	Local cOrder   := ''
	Local aOrder   := {}
	Local aAux     := {}
	Local cAux     := ''
	Local lIsDigit := .T.

	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cOrder := aList[ nX ]
			cOrder := StrTran( cOrder, '%', '' )
			cOrder := StrTokArr2( cOrder, ':', .T. )[2]

			aOrder := StrTokArr2( cOrder, ',', .T. )

			DbSelectArea( aOrder[1] )

			if len( aOrder ) == 2

				cAux := 'ABCDEFGHIJKLMNOPQRSTUVXWYZ'
				aAux := array( Len( cAux ) )
				nY   := 0
				aEval( aAux, { || ++nY, aAux[nY] := SubStr( cAux, nY, 1 ) } )

				aEval( aAux, { | i | if( i $ Upper( aOrder[ 2 ] ), lIsDigit := .F., nil) } )

				if lIsDigit

					cOrder := SqlOrder( ( aOrder[1] )->( IndexKey( Val( aOrder[2] ) ) ) )

				else

					cOrder := SqlOrder( ( aOrder[1] )->( DBNickIndexKey( aOrder[2] ) ) )

				endIf

			else

				cOrder := SqlOrder( ( aOrder[1] )->( IndexKey( 1 ) ) )

			endIf


			cQuery := StrTran( cQuery, aList[ nX ], cOrder )

		next nX

	endIf

return

static function getUrl()

	Local cUrl      := ''
	Local cHtmlName := 'pSqlDev.html'

	saveHtml( cHtmlName )

	cUrl += iif( getOS()=="UNIX", "file://", "")
	cUrl += GetTempPath()
	cUrl += cHtmlName

return cUrl

static function saveHtml( cHtmlName )

	Local cTemPath   := ''
	Local aArtefacts := { 'twebchannel.js', cHtmlName }

	cTemPath += iif( getOS() == "UNIX", "l:", "" )
	cTemPath += GetTempPath()

	aEval( aArtefacts, { | cArtefact |;
		nHandle := fCreate( cTemPath + cArtefact ),;
		fWrite( nHandle, GetApoRes( cArtefact ) ),;
		fClose( nHandle );
		})

return

static function getOS()

	local stringOS := Upper(GetRmtInfo()[2])

	if GetRemoteType() == 0 .or. GetRemoteType() == 1

		return "WINDOWS"

	elseif GetRemoteType() == 2

		return "UNIX" // Linux ou MacOS

	elseif GetRemoteType() == 5

		return "HTML" // Smartclient HTML

	elseif ("ANDROID" $ stringOS)

		return "ANDROID"

	elseif ("IPHONEOS" $ stringOS)

		return "IPHONEOS"

	endif

return ''
