(:~
 : Форма расписания сессии ДО для САИВПДС .
 :
 : @author Александр Калинин и Сергей Мишуров, Artel 2019-2020, BSD License
 :)

declare variable $params external;
declare variable $ID external;
declare variable $lisst external;
declare variable $page external;

let $baseURL := '/zapolnititul/api/v2.1/data/publication/'

let $pagesList :=  .//table ['курсы']/row/cell[ @label = 'Курсы' ]/text()
  
  let $menu :=
    for $lisst in $pagesList
      let $href := $baseURL || $ID || '?page=' || $lisst
      return
        <a href = '{ $href }'>{ $lisst }</a>        

let $page := $params?page

let $dataRows := .//table [$page]/row

let $колонки := ('№ п/п', 'дата', 'день недели', 'время', 'дисциплина', 'форма аттестации', 'преподаватель','аудитория' )

let $table := 
	<table border = '1px'>
		<tr>
			{
				for $i in $колонки
				return
					<th>{ $i }</th>
			}
		</tr>
		{
			for $row in $dataRows
			return
				<tr>{
					for $cellName in $колонки
					return
						<td>{ $row/cell[ @label = $cellName ]/text() }</td>
				}</tr>
		}
	
	</table>

return
      <html>
        <link rel="stylesheet" href="http://iro37.ru/res/trac-src/xqueries/saivpds/css/saivpds.css"/>
      
       <header><center>
       <a href="http://saivpds.pravorg.ru"><img src="http://saivpds.pravorg.ru/files/2016/08/%D1%88%D0%B0%D0%BF%D0%BA%D0%B0.jpg"></img></a></center></header>
       
        <body>
           <div>
              <p><center><b> РАСПИСАНИЕ {$dataRows/cell[ @label = 'Сессия' ]/text()} ЗАЧЕТНО-ЭКЗАМЕНАЦИОННОЙ СЕССИИ {$dataRows/cell[ @label = 'Курс' ]/text()}-го КУРСА</b></center> </p>
              <p><center><b> {$dataRows/cell[ @label = 'Учебный год' ]/text()} учебный год </b></center></p>
           </div>
           <div><b> {$page} Выберите курс обучения: {$menu} </b></div>
           <div>
                { $table }
           </div>
           
           <div>
(c)<a href="http://iro37.ru/xqwiki/Artel"> НПО "Artel"</a>. Сделано на платформе <a href="http://dbx.iro37.ru/zapolnititul">ZapolniTitul</a> специально для САИВПДС
           </div>
           
        </body>
        
      </html>
