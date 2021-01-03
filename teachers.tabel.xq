(:~
 : Функции для Электронного журнала.
 :
 : @author Александр Калинин и Сергей Мишуров, Artel 2019-2020, BSD License
 :)

module namespace jour = 'jour';

import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';

(:~
 : Формирует список заданий по классу по предметам на дату.
 : @param  $data  множество элементов <table></table> - каждый элемент 
 : - отдельный лист журнала по предмету
 : @param  $date  дата, на которую формируется отчет
 : @return element(ul)
 :)
declare 
  %public
function 
jour:заданияПоКлассу( $data as element( table )*, $date as xs:date ) 
  as element( table )*
{
  <table border = '1'>
           <tr>
             <th width="25%"> { "Курс" } </th>
             <th width="25%"> { "Дисциплина" } </th>
             <th width="25%"> { "Тема занятия" } </th>
             <th width="25%"> { "Самостоятельная работа" } </th>
           </tr>
   {
    for $i in $data
    let $класс :=  
      number(
        tokenize( $i/row[ 1 ]/cell[ 1 ]/@label/data(), ',' )[ 2 ]
      )
    where $класс
    order by $класс
    group by $класс
    
    return
        for $ii in $i/row
        
        let $d :=  dateTime:dateParse( $ii/cell[ 1 ]/text() )
        where not( empty( $d ) )
        where  $d =  $date
        
        let $предмет := tokenize( $ii/cell[ 1 ]/@label/data(), ',' )[ 1 ]
        group by $предмет
        
        let $href := 
          let $задание :=  
            if( $ii/cell[ @label="Самостоятельная работа" ]/text() )
            then( $ii/cell[ @label="Самостоятельная работа" ]/text() )
            else('>>Нет задания<<') 
          
          let $заданиеURL := 
                if( $ii/cell[ @label="Самостоятельная работа. Ссылка" ]/text() )
                then( $ii/cell[ @label="Самостоятельная работа. Ссылка" ]/text() )
                else()
          return
            if(  starts-with( $заданиеURL, 'http' ) )
            then( <a href = '{ $заданиеURL }'>{ $задание }</a> )
            else( <span>{ $задание }</span>)
          
          
       let $темаЗанятия :=  
          if( $ii/cell[ @label="Тема занятия" ]/text() )
          then( $ii/cell[ @label="Тема занятия" ]/text() )
          else('>>Нет темы<<')
        
        return
          (
           <tr>
             <td width="25%"> { $класс } </td>
             <td width="25%"> { string-join ($предмет) } </td>
             <td width="25%"> { distinct-values ($темаЗанятия) } </td>
             <td width="25%"> { $href } </td>
           </tr>
          )      
    }
  </table>
};


let $data :=
  .//table
  
return $data