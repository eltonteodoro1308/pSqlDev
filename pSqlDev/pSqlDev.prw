#include 'totvs.ch'
#include 'sigawin.ch'
#include 'dwconst.ch'
#include 'prconst.ch'
//#include 'protheus.ch'
//#include "stdwin.ch"

//TODO Incluir um campo onde informar limite de linhas a serem exibidas
//TODO Permitir a execução de mais de um comando sql separados por ;

user function pSqlDev()

	Static oDlgMain   := nil
	Static oFontBtn   := TFont():New( 'Consolas',,-12,,.T. )
	Static lChkChgQry := .F.

	Local cCacheFile  := 'pSqlDev.sql'
	Local cCache      := memoRead( cCacheFile )
	Local oDfSzDlg    := FwDefSize():New( .F. )
	Local oDfSzBtn    := FwDefSize():New( .F. )
	Local oBtnQuery   := nil
	local oBtnScript  := nil
	local oBtnParse   := nil
	local oBtnCsv     := nil
	Local oBtnOpen    := nil
	Local oBtnSave    := nil
	Local oBtnClose   := nil
	Local oChkCommnt  := nil
	Local lChkCommnt  := .T.
	Local oChkChgQry  := nil
	Local oWebChannel := nil
	Local oWebEngine  := nil
	Local cTitle      := 'pSqlDev - Protheus SQL Developer'
	Local bQuery      := { || oWebEngine:runJavaScript( 'editorHandler( true, "query" )' )  }
	Local bScript     := { || oWebEngine:runJavaScript( 'editorHandler( true, "script" )' ) }
	Local bParse      := { || oWebEngine:runJavaScript( 'editorHandler(' + If( lChkCommnt, 'true', 'false' ) + ',"parse" )' ) }
	Local bCsv        := { || oWebEngine:runJavaScript( 'editorHandler( true, "csv" )' )  }

	oDfSzDlg:AddObject ( 'oButtons'   , 000, 015, .T., .F. )
	oDfSzDlg:AddObject ( 'oWebEngine' , 000, 000, .T., .T. )
	oDfSzDlg:Process()

	oDfSzBtn:AddObject ( 'oBtnQuery' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnScript', 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnParse' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnCsv'   , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnOpen'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnSave'  , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose' , 055, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oChkCommnt', 080, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oChkChgQry', 080, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	oDlgMain := MsDialog():New(;
	/* nTop         */ oDfSzDlg:aWindSize[ 1 ] ,;
	/* nLeft        */ oDfSzDlg:aWindSize[ 2 ] ,;
	/* nBottom      */ oDfSzDlg:aWindSize[ 3 ] ,;
	/* nRight       */ oDfSzDlg:aWindSize[ 4 ] ,;
	/* cCaption     */                  cTitle ,;
	/* uParam6      */                         ,;
	/* uParam7      */                         ,;
	/* uParam8      */                         ,;
	/* uParam9      */                         ,;
	/* nClrText     */                         ,;
	/* nClrBack     */                         ,;
	/* uParam12     */                         ,;
	/* oWnd         */                         ,;
	/* lPixel       */                     .T. ,;
	/* uParam15     */                         ,;
	/* uParam16     */                         ,;
	/* uParam17     */                         ,;
	/* lTransparent */                          )

	oBtnQuery := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnQuery', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnQuery', 'COLINI' ) ,;
	/* cCaption */                                   'QUERY <F5>' ,;
	/* oWnd     */                                       oDlgMain ,;
	/* bAction  */                                         bQuery ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnQuery', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnQuery', 'YSIZE'  ) ,;
	/* uParam8  */                                                ,;
	/* oFont    */                                       oFontBtn ,;
	/* uParam10 */                                                ,;
	/* lPixel   */                                            .T. ,;
	/* uParam12 */                                                ,;
	/* uParam13 */                                                ,;
	/* uParam14 */                                                ,;
	/* bWhen    */                                                ,;
	/* uParam16 */                                                ,;
	/* uParam17 */                                                 )

	oBtnQuery:cToolTip := "Executa uma query de consulta ao banco de dados."

	oBtnScript := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnScript', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnScript', 'COLINI' ) ,;
	/* cCaption */                                   'SCRIPT <F6>' ,;
	/* oWnd     */                                        oDlgMain ,;
	/* bAction  */                                         bScript ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnScript', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnScript', 'YSIZE'  ) ,;
	/* uParam8  */                                                 ,;
	/* oFont    */                                        oFontBtn ,;
	/* uParam10 */                                                 ,;
	/* lPixel   */                                             .T. ,;
	/* uParam12 */                                                 ,;
	/* uParam13 */                                                 ,;
	/* uParam14 */                                                 ,;
	/* bWhen    */                                                 ,;
	/* uParam16 */                                                 ,;
	/* uParam17 */                                                  )

	oBtnScript:cToolTip := "Executa um script sql no banco de dados."

	oBtnParse := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnParse', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnParse', 'COLINI' ) ,;
	/* cCaption */                                        'PARSE' ,;
	/* oWnd     */                                       oDlgMain ,;
	/* bAction  */                                         bParse ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnParse', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnParse', 'YSIZE'  ) ,;
	/* uParam8  */                                                ,;
	/* oFont    */                                       oFontBtn ,;
	/* uParam10 */                                                ,;
	/* lPixel   */                                            .T. ,;
	/* uParam12 */                                                ,;
	/* uParam13 */                                                ,;
	/* uParam14 */                                                ,;
	/* bWhen    */                                                ,;
	/* uParam16 */                                                ,;
	/* uParam17 */                                                 )

	oBtnParse:cToolTip := "Faz o parse da query, tratando e resolvendo o embedded sql."

	oBtnCsv := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnCsv', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnCsv', 'COLINI' ) ,;
	/* cCaption */                                        'CSV' ,;
	/* oWnd     */                                     oDlgMain ,;
	/* bAction  */                                         bCsv ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnCsv', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnCsv', 'YSIZE'  ) ,;
	/* uParam8  */                                              ,;
	/* oFont    */                                     oFontBtn ,;
	/* uParam10 */                                              ,;
	/* lPixel   */                                          .T. ,;
	/* uParam12 */                                              ,;
	/* uParam13 */                                              ,;
	/* uParam14 */                                              ,;
	/* bWhen    */                                              ,;
	/* uParam16 */                                              ,;
	/* uParam17 */                                               )

	oBtnCsv:cToolTip := "Exporta o resultado da query diretamente para CSV."

	oBtnOpen := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnOpen', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnOpen', 'COLINI' ) ,;
	/* cCaption */                                       'ABRIR' ,;
	/* oWnd     */                                      oDlgMain ,;
	/* bAction  */                { || openQuery( oWebEngine ) } ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnOpen', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnOpen', 'YSIZE'  ) ,;
	/* uParam8  */                                               ,;
	/* oFont    */                                      oFontBtn ,;
	/* uParam10 */                                               ,;
	/* lPixel   */                                           .T. ,;
	/* uParam12 */                                               ,;
	/* uParam13 */                                               ,;
	/* uParam14 */                                               ,;
	/* bWhen    */                                               ,;
	/* uParam16 */                                               ,;
	/* uParam17 */                                                )

	oBtnOpen:cToolTip := "Abre um arquivo salvo."

	oBtnSave := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnSave', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnSave', 'COLINI' ) ,;
	/* cCaption */                                      'SALVAR' ,;
	/* oWnd     */                                      oDlgMain ,;
	/* bAction  */                { || saveQuery( oWebEngine ) } ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnSave', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnSave', 'YSIZE'  ) ,;
	/* uParam8  */                                               ,;
	/* oFont    */                                      oFontBtn ,;
	/* uParam10 */                                               ,;
	/* lPixel   */                                           .T. ,;
	/* uParam12 */                                               ,;
	/* uParam13 */                                               ,;
	/* uParam14 */                                               ,;
	/* bWhen    */                                               ,;
	/* uParam16 */                                               ,;
	/* uParam17 */                                                )

	oBtnSave:cToolTip := "Salva a consulta."

	oBtnClose := TButton():New(;
	/* nRow     */ oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' ) ,;
	/* nCol     */ oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' ) ,;
	/* cCaption */                                       'FECHAR' ,;
	/* oWnd     */                                       oDlgMain ,;
	/* bAction  */                          { || oDlgMain:End() } ,;
	/* nWidth   */ oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  ) ,;
	/* nHeight  */ oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  ) ,;
	/* uParam8  */                                                ,;
	/* oFont    */                                       oFontBtn ,;
	/* uParam10 */                                                ,;
	/* lPixel   */                                            .T. ,;
	/* uParam12 */                                                ,;
	/* uParam13 */                                                ,;
	/* uParam14 */                                                ,;
	/* bWhen    */                                                ,;
	/* uParam16 */                                                ,;
	/* uParam17 */                                                 )

	oBtnClose:cToolTip := "Fecha o programa."

	oChkCommnt := TCheckBox():New(;
	/* nRow      */ oDfSzBtn:GetDimension( 'oChkCommnt', 'LININI' ) + 5 ,;
	/* nCol      */ oDfSzBtn:GetDimension( 'oChkCommnt', 'COLINI' ) + 5 ,;
	/* cCaption  */                             'PARSE SEM COMENTÁRIOS' ,;
	/* bSetGet   */                                   { || lChkCommnt } ,;
	/* oDlg      */                                            oDlgMain ,;
	/* nWidth    */     oDfSzBtn:GetDimension( 'oChkCommnt', 'XSIZE'  ) ,;
	/* nHeight   */     oDfSzBtn:GetDimension( 'oChkCommnt', 'YSIZE'  ) ,;
	/* uParam8   */                                                     ,; 
	/* bLClicked */                   { || lChkCommnt := ! lChkCommnt } ,;
	/* oFont     */                                            oFontBtn ,;
	/* bValid    */                                                     ,;
	/* nClrText  */                                                     ,;
	/* nClrPane  */                                                     ,;
	/* uParam14  */                                                     ,;
	/* lPixel    */                                                 .T. ,;
	/* cMsg      */                                                     ,;
	/* uParam17  */                                                     ,;
	/* bWhen     */                                                      )

	oChkCommnt:cToolTip := "No parser da query exclui os comentários."

	oChkChgQry := TCheckBox():New(;
	/* nRow      */ oDfSzBtn:GetDimension( 'oChkChgQry', 'LININI' ) + 5 ,;
	/* nCol      */ oDfSzBtn:GetDimension( 'oChkChgQry', 'COLINI' ) + 9 ,;
	/* cCaption  */                                'APLICA CHANGEQUERY' ,;
	/* bSetGet   */                                   { || lChkChgQry } ,;
	/* oDlg      */                                            oDlgMain ,;
	/* nWidth    */     oDfSzBtn:GetDimension( 'oChkChgQry', 'XSIZE'  ) ,;
	/* nHeight   */     oDfSzBtn:GetDimension( 'oChkChgQry', 'YSIZE'  ) ,;
	/* uParam8   */                                                     ,; 
	/* bLClicked */                   { || lChkChgQry := ! lChkChgQry } ,;
	/* oFont     */                                            oFontBtn ,;
	/* bValid    */                                                     ,;
	/* nClrText  */                                                     ,;
	/* nClrPane  */                                                     ,;
	/* uParam14  */                                                     ,;
	/* lPixel    */                                                 .T. ,;
	/* cMsg      */                                                     ,;
	/* uParam17  */                                                     ,;
	/* bWhen     */                                                      )

	oChkChgQry:cToolTip := "Aplica a função ChangeQuery antes de executar a query."

	oWebChannel := TWebChannel():New()
	oWebChannel:bJsToAdvpl := { | self, key, value | jsToAdvpl( self, key, value, cCacheFile ) }
	oWebChannel:connect()

	oWebEngine := TWebEngine():New(;
	/* oWnd    */                                        oDlgMain ,;
	/* nRow    */ oDfSzDlg:GetDimension( 'oWebEngine', 'LININI' ) ,;
	/* nCol    */ oDfSzDlg:GetDimension( 'oWebEngine', 'COLINI' ) ,;
	/* nWidth  */ oDfSzDlg:GetDimension( 'oWebEngine', 'XSIZE'  ) ,;
	/* nHeight */ oDfSzDlg:GetDimension( 'oWebEngine', 'YSIZE'  ) ,;
	/* cUrl    */                                        getUrl() ,;
	/* nPort   */                               oWebChannel:nPort  )

	oWebEngine:bLoadFinished := { | webengine, url |;
		WebEngine:runJavaScript( "document.querySelector('textarea').value = `" + cCache + "`" ) }

	aEval( oDlgMain:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:disable(), nil ) } )

	SetKey( VK_F5, bQuery  )
	SetKey( VK_F6, bScript )

	oDlgMain:Activate(,,,.T.)

return

static function openQuery( oWebEngine )

	Local cFile := tFileDialog('SQL files (*.sql)')

	if !empty( cFile )

		oWebEngine:runJavaScript( "document.querySelector('textarea').value = `" + memoRead( cFile ) + "`" )

	endIf

return

static function saveQuery( oWebEngine )

	oWebEngine:runJavaScript( 'editorHandler( null, "save" )' )

return

static function jsToAdvpl( self, key, value, cCacheFile )

	Local oJson   := jsonObject():New()
	Local cQuery  := ''
	Local aColumn := {}
	Local cAlias  := ''
	Local nStatus := 0
	Local cErro   := ''
	Local bError  := ErrorBlock( { | oErro | cErro := oErro:Description } )
	Local nX      := 0

	if key == 'activeButtons'

		aEval( oDlgMain:aControls, { |item| if( getClassName( item ) $ 'TBUTTON/TCHECKBOX', item:enable(), nil ) } )

	elseIf key == 'recordQuery'

		memoWrite( cCacheFile, value )

	elseIf key == 'save'

		cFile := tFileDialog(,,,,.T.)

		if !Empty(cFile)

			memoWrite( cFile, value )

		endIf

	elseIf key $ 'query/script/parse/csv'

		oJson:fromJson( value )
		cQuery := oJson['query']

		parseExp( @cQuery, oJson )
		parseColumns( @aColumn, oJson )
		parseTable( @cQuery, oJson )
		parseBranch( @cQuery, oJson )
		parseOrder( @cQuery, oJson )

		if lChkChgQry .And. ! oJson['noParser']

			cQuery := changeQuery( cQuery )

		endIf

		If key $ 'query/csv'

			MsgRun ( 'Banco de Dados Processando a Query ...', 'Aguarde ...', { | | cAlias := MpSysOpenQuery( cQuery ) } )

			if empty( cErro )

				if key == 'query'

					for nX := 1 to Len( aColumn )

						TCSetField( cAlias, aColumn[ nX, 1 ],  aColumn[ nX, 2 ],  aColumn[ nX, 3 ],  aColumn[ nX, 4 ] )

					next nX

					showResult( cAlias )

				elseIf key == 'csv'

					expToCsv( cAlias )

				endIf

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
	Local oFontBrw  := TFont():New( 'Consolas',,-12 )
	Local oDlg      := Nil
	Local oBtn2Csv  := Nil
	Local oBtnClose := Nil
	Local oBrowse   := Nil
	Local aHeaders  := {}
	Local aLinesBrw := {}
	Local bLinesBrw := nil
	Local bBlkF5    := SetKey( VK_F5, {||} )
	Local bBlkF6    := SetKey( VK_F6, {||} )

	oDfSzDlg:AddObject ( 'oButtons', 000, 015, .T., .F. )
	oDfSzDlg:AddObject ( 'oBrowse' , 000, 000, .T., .T. )
	oDfSzDlg:Process()

	oDfSzBtn:AddObject ( 'oBtn2Csv' , 050, 015, .F., .F. )
	oDfSzBtn:AddObject ( 'oBtnClose', 050, 015, .F., .F. )
	oDfSzBtn:lLateral := .T.
	oDfSzBtn:Process()

	oDlg := MsDialog():New(;
	/* nTop         */ oDfSzDlg:aWindSize[ 1 ] ,;
	/* nLeft        */ oDfSzDlg:aWindSize[ 2 ] ,;
	/* nBottom      */ oDfSzDlg:aWindSize[ 3 ] ,;
	/* nRight       */ oDfSzDlg:aWindSize[ 4 ] ,;
	/* cCaption     */                  cAlias ,;
	/* uParam6      */                         ,;
	/* uParam7      */                         ,;
	/* uParam8      */                         ,;
	/* uParam9      */                         ,;
	/* nClrText     */                         ,;
	/* nClrBack     */                         ,;
	/* uParam12     */                         ,;
	/* oWnd         */                         ,;
	/* lPixel       */                     .T. ,;
	/* uParam15     */                         ,;
	/* uParam16     */                         ,;
	/* uParam17     */                         ,;
	/* lTransparent */                          )

	oBtn2Csv := TButton():New(;
	/* nRow     */  oDfSzBtn:GetDimension( 'oBtn2Csv', 'LININI' ) ,;
	/* nCol     */  oDfSzBtn:GetDimension( 'oBtn2Csv', 'COLINI' ) ,;
	/* cCaption */                                          'CSV' ,;
	/* oWnd     */                                           oDlg ,;
	/* bAction  */                      { || expToCsv( cAlias ) } ,;
	/* nWidth   */  oDfSzBtn:GetDimension( 'oBtn2Csv', 'XSIZE'  ) ,;
	/* nHeight  */  oDfSzBtn:GetDimension( 'oBtn2Csv', 'YSIZE'  ) ,;
	/* uParam8  */                                                ,;
	/* oFont    */                                       oFontBtn ,;
	/* uParam10 */                                                ,;
	/* lPixel   */                                            .T. ,;
	/* uParam12 */                                                ,;
	/* uParam13 */                                                ,;
	/* uParam14 */                                                ,;
	/* bWhen    */                                                ,;
	/* uParam16 */                                                ,;
	/* uParam17 */                                                 )

	oBtn2Csv:cToolTip := "Exporta para Csv."

	oBtnClose := TButton():New(;
	/* nRow     */  oDfSzBtn:GetDimension( 'oBtnClose', 'LININI' ) ,;
	/* nCol     */  oDfSzBtn:GetDimension( 'oBtnClose', 'COLINI' ) ,;
	/* cCaption */                                        'FECHAR' ,;
	/* oWnd     */                                            oDlg ,;
	/* bAction  */                               { || oDlg:End() } ,;
	/* nWidth   */  oDfSzBtn:GetDimension( 'oBtnClose', 'XSIZE'  ) ,;
	/* nHeight  */  oDfSzBtn:GetDimension( 'oBtnClose', 'YSIZE'  ) ,;
	/* uParam8  */                                                 ,;
	/* oFont    */                                        oFontBtn ,;
	/* uParam10 */                                                 ,;
	/* lPixel   */                                             .T. ,;
	/* uParam12 */                                                 ,;
	/* uParam13 */                                                 ,;
	/* uParam14 */                                                 ,;
	/* bWhen    */                                                 ,;
	/* uParam16 */                                                 ,;
	/* uParam17 */                                                  )

	oBtnClose:cToolTip := "Fecha a Janela."

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

	SetKey( VK_F5, bBlkF5 )
	SetKey( VK_F6, bBlkF6 )
	aLinesBrw := nil
	aHeaders := nil

return

static function expToCsv( cAlias )

	MsgRun( 'Gerando CSV ...', 'Aguarde ...', {|| makeCsv( cAlias ) } )

return

static function makeCsv( cAlias )

	Local cPath     := ''
	Local cFile     := GetNextAlias() + '.csv'
	Local nHandle   := 0
	Local cBuffer   := ''
	Local cAux      := ''
	Local nQtdBytes := 0
	Local nX        := 0
	Local cValType  := ''

	if GetRemoteType() # 5

		cPath := tFileDialog(,,,,,GETF_RETDIRECTORY)

		if !Empty( cPath )

			cFile   := cPath + '\' + cFile

		else

			return

		endIf

	endIf

	nHandle := FCreate( cFile )

	If nHandle # -1

		//-- Gera Cabeçalho do arquivo
		For nX := 1 To ( cAlias )->( FCount() )

			cBuffer += ( cAlias )->( FieldName( nX ) )

			If nX < ( cAlias )->( FCount() )

				cBuffer += ";"

			EndIf

		Next

		cBuffer += CRLF

		nQtdBytes := Len( cBuffer )

		FSeek(nHandle, 0, FS_END)

		FWrite( nHandle, cBuffer, nQtdBytes )

		cBuffer := ''

		//-- Gera dados do arquivo
		( cAlias )->( DbGoTop() )

		While ! ( cAlias )->( Eof() )

			For nX := 1 To ( cAlias )->( FCount() )

				cValType := ValType( ( cAlias )->&( FieldName( nX ) ) )

				If cValType == 'N'

					cAux    := cValTochar( ( cAlias )->&( FieldName( nX ) ) )
					cAux    := StrTran( cAux, '.', ',' )
					cBuffer += cAux

				ElseIf cValType $ 'DL'

					cBuffer +=  cValTochar( ( cAlias )->&( FieldName( nX ) ) )

				Else

					//cBuffer += '="'
					cBuffer +=  cValTochar( ( cAlias )->&( FieldName( nX ) ) )
					//cBuffer +=  '"'

				EndIf

				If nX < ( cAlias )->( FCount() )

					cBuffer += ";"

				EndIf

			Next

			cBuffer += CRLF

			nQtdBytes := Len( cBuffer )

			FSeek(nHandle, 0, FS_END)

			FWrite( nHandle, cBuffer, nQtdBytes )

			cBuffer := ''

			( cAlias )->( DbSkip() )

		End

	EndIf

	FClose( nHandle )

	if GetRemoteType() # 5

		ShellExecute( 'Open', cFile, '', '', 1 )

	else

		CpyS2TW( cFile, .T.)
		FErase( cFile )

	endIf

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
