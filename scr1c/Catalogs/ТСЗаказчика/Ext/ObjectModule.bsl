﻿
Процедура ПередЗаписью(Отказ)
	код = Справочники.ТСЗаказчика.фрмГосНомер(код); 
	
	
	Рез="";
	Для а=1 по СтрДлина(код) Цикл
		п = Сред(код,а,1);
		Если п>="0" и п<="9" Тогда
			рез=рез+п;
		ИНачеЕсли Рез<>"" Тогда
				прервать;
		КонецЕслИ;
				
	Конеццикла;
	
	индексГосНомер = рез;  
	
	Если ЗначениеЗаполнено(Номенклатура)=Ложь Тогда
		Номенклатура = Константы.ОсновнаяНоменклатура.Получить();
	КонецеслИ;
	
	Если Активен Тогда
		ПроверкаАктивногоДубля();	
	КонецеслИ;
	
	
КонецПроцедуры  

Функция ПроверкаАктивногоДубля()
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Код",Код);
	Запрос.УстановитьПараметр("Ссылка",ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТСЗаказчика.Ссылка КАК Ссылка,
	               |	ТСЗаказчика.Владелец КАК Владелец
	               |ИЗ
	               |	Справочник.ТСЗаказчика КАК ТСЗаказчика
	               |ГДЕ
	               |	ТСЗаказчика.Код = &Код
	               |	И ТСЗаказчика.Активен = TRUE
	               |	И ТСЗаказчика.Ссылка <> &Ссылка";
	
	Выб = Запрос.Выполнить().Выбрать();
	рез="";
	Пока Выб.Следующий() Цикл
		рез = рез+"--- Автомобиль с гос.номером "+Код+" используется у контрагента "+выб.Владелец+" ";
	КонецЦикла;  
	
	Если рез<>"" Тогда
		ВызватьИсключение рез;
	Конецесли;
	
	Возврат Рез;
	
КонецФункции
