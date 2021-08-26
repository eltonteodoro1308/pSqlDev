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

	Static oDialog    := nil

	Local oDfSzDlg    := FwDefSize():New( .F. )
	Local oDfSzBtn    := FwDefSize():New( .F. )
	Local oBtnQuery   := nil
	local oBtnScript  := nil
	Local oBtnOpen    := nil
	Local oBtnSave    := nil
	Local oBtnParam   := nil
	Local oBtnClose   := nil
	Local oWebChannel := nil
	Local oWebEngine  := nil
	Local cTitle      := 'pSqlDev - Protheus SQL Developer'
	Local cCache      := memoRead( 'pSqlDev.sql' )
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
	oDfSzBtn:AddObject ( 'oBtnOpen'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnSave'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnParam' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose' , 055, 015, .F., .F. )
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

	@ nRow, nColumn BUTTON oBtnQuery PROMPT 'QUERY <F5>' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION oWebEngine:runJavaScript('makeQueryObject(true,"query")') PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnScript', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnScript', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnScript', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnScript', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnScript PROMPT 'SCRIPT <F6>' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION oWebEngine:runJavaScript('makeQueryObject(true,"script")') PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnOpen', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnOpen', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnOpen', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnOpen', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnOpen PROMPT 'ABRIR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION alert('ABRIR') PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnParam', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnParam', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnParam', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnParam', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnParam PROMPT 'PARAMETROS' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION alert('PARAMETROS') PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnSave', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnSave', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnSave', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnSave', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnSave PROMPT 'SALVAR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION alert('SALVAR') PIXEL

	nRow    := oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' )
	nColumn := oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' )
	nWidth  := oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  )
	nHeight := oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  )

	@ nRow, nColumn BUTTON oBtnClose PROMPT 'FECHAR' SIZE nWidth, nHeight OF oDialog FONT oFontBtn ACTION oDialog:End() PIXEL

	nRow    := oDfSzDlg:GetDimension( 'oWebEngine', 'LININI' )
	nColumn := oDfSzDlg:GetDimension( 'oWebEngine', 'COLINI' )
	nWidth  := oDfSzDlg:GetDimension( 'oWebEngine', 'XSIZE'  )
	nHeight := oDfSzDlg:GetDimension( 'oWebEngine', 'YSIZE'  )

	oWebChannel := TWebChannel():New()
	oWebChannel:bJsToAdvpl := {|self,key,value| jsToAdvpl(self,key,value) }
	oWebChannel:connect()

	oWebEngine := TWebEngine():New( oDialog, nRow, nColumn, nWidth, nHeight, getUrl(), oWebChannel:nPort )

	oWebEngine:bLoadFinished := { | webengine, url |;
		WebEngine:runJavaScript( "document.querySelector('textarea').value = `" + cCache + "`" ) }

	aEval( oDialog:aControls, { |item| if( getClassName( item ) == 'TBUTTON', item:disable(), nil ) } )

	ACTIVATE DIALOG oDialog CENTERED

return

static function jsToAdvpl( self, key, value )

	Local oJson := jsonObject():New()

	if key == 'activeButtons'

		aEval( oDialog:aControls, { |item| if( getClassName( item ) == 'TBUTTON', item:enable(), nil ) } )

	elseIf key == 'query'

		oJson:fromJson(value)
	
	elseIf key == 'script'

		oJson:fromJson(value)

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
