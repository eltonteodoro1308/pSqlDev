#include 'totvs.ch'
#include 'sigawin.ch'
#include 'dwconst.ch'
//#include 'protheus.ch'
//#include "stdwin.ch"
//#include 'prconst.ch'

//TODO Permitir a transposição de colunas em linhas
//TODO Em parâmetros quantidade de linhas máximas a exibir, se faz o changequery, se tira os comentários na exportação do parser
//TODO Para script sql considerar ; para processar mais de um commando de uma vez

user function pSqlDev()

	Static oDialog   := nil

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
	Local oChkTransp  := nil
	Local lChkTransp  := .F.
	Local oWebChannel := nil
	Local oWebEngine  := nil
	Local cTitle      := 'pSqlDev - Protheus SQL Developer'
	Local oFontBtn    := TFont():New( 'Consolas',,-12,,.T. )

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
	oDfSzBtn:AddObject ( 'oChkTransp', 080, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	nTop    := oDfSzBtn:aWindSize[ 1 ]
	nLeft   := oDfSzBtn:aWindSize[ 2 ]
	nBottom := oDfSzBtn:aWindSize[ 3 ]
	nRight  := oDfSzBtn:aWindSize[ 4 ]

	DEFINE MSDIALOG oDialog TITLE cTitle FROM nTop, nLeft TO nBottom, nRight PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnQuery', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnQuery', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnQuery', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnQuery', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnQuery PROMPT 'QUERY <F5>' SIZE nWidth, nHeight OF oDialog FONT oFontBtn;
		ACTION oWebEngine:runJavaScript( 'makeQueryObject( true, "query" )' ) PIXEL
	oBtnQuery:cToolTip := "Executa uma query de consulta ao banco de dados."

	nRow    := oDfSzBtn:GetDimension( 'oBtnScript', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnScript', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnScript', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnScript', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnScript PROMPT 'SCRIPT <F6>' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION;
		oWebEngine:runJavaScript( 'makeQueryObject( true, "script" )' ) PIXEL
	oBtnScript:cToolTip := "Executa um script sql no banco de dados."

	nRow    := oDfSzBtn:GetDimension( 'oBtnParse', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnParse', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnParse', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnParse', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnParse PROMPT 'PARSE' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION;
		oWebEngine:runJavaScript( 'makeQueryObject(' + IF( lChkCommnt, 'true', 'false' ) + ',"parse" )' ) PIXEL
	oBtnParse:cToolTip := "Faz o parse da query, tratando e resolvendo o embedded sql."

	nRow    := oDfSzBtn:GetDimension( 'oBtnOpen', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnOpen', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnOpen', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnOpen', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnOpen PROMPT 'ABRIR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION alert('ABRIR') PIXEL
	oBtnOpen:cToolTip := "Abre um arquivo salvo."

	nRow    := oDfSzBtn:GetDimension( 'oBtnSave', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnSave', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnSave', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnSave', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnSave PROMPT 'SALVAR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION alert('SALVAR') PIXEL
	oBtnSave:cToolTip := "Salvo a consulta."

	nRow    := oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnClose PROMPT 'FECHAR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION oDialog:End() PIXEL
	oBtnClose:cToolTip := "Fecha o programa."

	nRow    := oDfSzBtn:GetDimension( 'oChkCommnt', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oChkCommnt', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oChkCommnt', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oChkCommnt', 'YSIZE'  )

	@ nRow+5, nColumn+5 CHECKBOX oChkCommnt VAR lChkCommnt PROMPT "PARSE SEM COMENTÁRIOS" SIZE nWidth, nHeight OF oDialog FONT oFontBtn PIXEL
	oChkCommnt:cToolTip := "No parser da query exclui os comentários."

	nRow    := oDfSzBtn:GetDimension( 'oChkTransp', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oChkTransp', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oChkTransp', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oChkTransp', 'YSIZE'  )

	@ nRow+5, nColumn+10 CHECKBOX oChkTransp VAR lChkTransp PROMPT "TRANSPOR A CONSULTA" SIZE nWidth, nHeight OF oDialog FONT oFontBtn PIXEL
	oChkTransp:cToolTip := "Faz a transposição da consulta."

	nRow    := oDfSzDlg:GetDimension( 'oWebEngine', 'LININI' )
	nColumn := oDfSzDlg:GetDimension( 'oWebEngine', 'COLINI' )
	nWidth  := oDfSzDlg:GetDimension( 'oWebEngine', 'XSIZE'  )
	nHeight := oDfSzDlg:GetDimension( 'oWebEngine', 'YSIZE'  )

	oWebChannel := TWebChannel():New()
	oWebChannel:bJsToAdvpl := {|self,key,value| jsToAdvpl(self,key,value, cCacheFile) }
	oWebChannel:connect()

	oWebEngine := TWebEngine():New( oDialog, nRow, nColumn, nWidth, nHeight, getUrl(), oWebChannel:nPort )

	oWebEngine:bLoadFinished := { | webengine, url |;
		WebEngine:runJavaScript( "document.querySelector('textarea').value = `" + cCache + "`" ) }

	aEval( oDialog:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:disable(), nil ) } )

	ACTIVATE DIALOG oDialog CENTERED

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

		aEval( oDialog:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:enable(), nil ) } )

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

			else

				AutoGrLog( cErro )
				MostraErro()

			endIf

		elseIf key == 'script'

			MsgRun ( 'Banco de Dados Processando a Script ...', 'Aguarde ...', { | | nStatus := TCSqlExec( cQuery ) } )

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

	Local oDlg      := nil
	Local oDfSzDlg  := FwDefSize():New( .F. )
	Local oDfSzBtn  := FwDefSize():New( .F. )
	Local oBtnPrint := nil
	Local oBtnClose := nil
	Local oFontBtn  := TFont():New( 'Consolas',,-12,,.T. )
	Local oFontBrw  := TFont():New( 'Consolas',,-14,,.F. )
	Local oBrowse   := nil
	Local nX        := 0
	Local cField    := ''

	oDfSzDlg:AddObject ( 'oButtons'  , 000, 015, .T., .F. )
	oDfSzDlg:AddObject ( 'oBrGetDDB' , 000, 000, .T., .T. )
	oDfSzDlg:Process()

	oDfSzBtn:AddObject ( 'oBtnPrint' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose' , 055, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	nTop    := oDfSzBtn:aWindSize[ 1 ]
	nLeft   := oDfSzBtn:aWindSize[ 2 ]
	nBottom := oDfSzBtn:aWindSize[ 3 ]
	nRight  := oDfSzBtn:aWindSize[ 4 ]

	DEFINE DIALOG oDlg TITLE cAlias FROM nTop, nLeft TO nBottom, nRight PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnPrint', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnPrint', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnPrint', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnPrint', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnPrint PROMPT 'IMPRIMIR' SIZE nWidth, nHeight OF oDlg FONT oFontBtn ACTION alert('IMPRIMIR') PIXEL
	oBtnPrint:cToolTip := "Imprimir resultado da query."

	nRow    := oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnClose PROMPT 'FECHAR' SIZE nWidth, nHeight OF oDlg FONT oFontBtn ACTION oDlg:End() PIXEL
	oBtnClose:cToolTip := "Fecha o programa."

	nRow    := oDfSzDlg:GetDimension( 'oBrGetDDB', 'LININI' )
	nColumn := oDfSzDlg:GetDimension( 'oBrGetDDB', 'COLINI' )
	nWidth  := oDfSzDlg:GetDimension( 'oBrGetDDB', 'XSIZE'  )
	nHeight := oDfSzDlg:GetDimension( 'oBrGetDDB', 'YSIZE'  )

	oBrowse := BrGetDDB():new(;
    /* nRow       */     nRow,;
    /* nCol       */  nColumn,;
    /* nWidth     */   nWidth,;
    /* nHeight    */  nHeight,;
    /* bLine      */         ,;
    /* aHeaders   */         ,;
    /* aColSizes  */         ,;
    /* oWnd       */     oDlg,;
    /* cField     */         ,;
    /* uVal1      */         ,;
    /* uVal2      */         ,;
    /* bChange    */         ,;
    /* bLDblClick */         ,;
    /* bRClick    */         ,;
    /* oFont      */ oFontBrw,;
    /* oCursor    */         ,;
    /* nClrFore   */         ,;
    /* nClrBack   */         ,;
    /* cMsg       */         ,;
    /* uParam1    */         ,;
    /* cAlias     */   cAlias,;
    /* lPixel     */      .T.,;
    /* bWhen      */         ,;
    /* uParam2    */         ,;
    /* bValid     */         ,;
    /* uParam3    */         ,;
    /* uParam4    */          )

	( cAlias )->( DbGoTop() )

	For nX := 1 To ( cAlias )->( FCount() )

		cField := ( cAlias )->( FieldName( nX ) )

		oBrowse:addColumn( TCColumn():new( cField, &('{ || ( cAlias )->' + cField + ' }'),,,, 'LEFT',, .F., .F.,,,, .F. ) )

	Next

	ACTIVATE DIALOG oDlg CENTERED

	( cAlias )->( DbCloseArea() )

return

static function parseExp( cQuery, oJson )

	Local nX := 0

	if ! Empty( oJson['advplExpressions']  )

		for nX := 1 to Len( oJson['advplExpressions'] )

			Eval( &('{||' + StrTran( oJson['advplExpressions'][ nX ], '--?', '' ) + '}') )

		next

		ProcExp( @cQuery, oJson  )

	endIf

return

static function ProcExp( cQuery, oJson )

	local nX    := 0
	local cExp  := ''
	local aList := oJson['embeddedExpressions']


	if ! Empty( aList  )

		for nX := 1 to Len( aList )

			cExp   := aList[ nX ]
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
