#include 'totvs.ch'
#include 'sigawin.ch'
//#include 'protheus.ch'
//#include "stdwin.ch"
//#include 'prconst.ch'
//#include 'dwconst.ch'

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

	@ nRow+5, nColumn+10 CHECKBOX oChkTransp VAR lChkTransp PROMPT "TRANSPÕE A CONSULTA" SIZE nWidth, nHeight OF oDialog FONT oFontBtn PIXEL
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

	Local oJson  := jsonObject():New()
	Local cQuery := ''

	if key == 'activeButtons'

		aEval( oDialog:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:enable(), nil ) } )

	elseIf key == 'recordQuery'

		memoWrite( cCacheFile, value )

	elseIf key $ 'query/script/parse'

		oJson:fromJson( value )
		cQuery := oJson['query']

		parseExp( @cQuery, oJson )

		If key == 'query'

		elseIf key == 'script'

		endIf

	endIf

return

static function parseExp( cQuery, oJson )

	Local nX := 0

	for nX := 1 to Len( oJson['advplExpressions'] )

		Eval( &('{||' + StrTran( oJson['advplExpressions'][ nX ], '--?', '' ) + '}') )

	next

	ProcExp( @cQuery, oJson  )

return

static function ProcExp( cQuery, oJson )

	local nX    := 0
	local cExp  := ''
	local aList := oJson['embeddedExpressions'] 


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
