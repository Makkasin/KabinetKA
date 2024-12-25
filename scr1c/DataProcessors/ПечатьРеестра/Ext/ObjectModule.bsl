﻿
Функция Данные(Контрагент,ТекДоговор, Дата1='00010101', Дата2='00010101')
	
	Запрос = новый Запрос;      
	 Запрос.Текст =               "ВЫБРАТЬ
	 |	РегистрацияПроезда.ТС КАК ТС,
	 |	РегистрацияПроезда.ТС.Код КАК Код,
	 |	РегистрацияПроезда.ТС.Номенклатура КАК Номенклатура,
	 |	РегистрацияПроезда.Номер КАК Номер,
	 |	РегистрацияПроезда.Дата КАК Дата,
	 |	РегистрацияПроезда.Масса КАК Масса,
	 |	РегистрацияПроезда.Тариф КАК Тариф,
	 |	РегистрацияПроезда.Сумма КАК Сумма,
	 |	Выразить(РегистрацияПроезда.Сумма * 1.20 как Число(18,2)) КАК СуммаСНДС
	 |ИЗ
	 |	Документ.РегистрацияПроезда КАК РегистрацияПроезда
	 |ГДЕ
	 |	РегистрацияПроезда.Дата >= &Дата1
	 |	И РегистрацияПроезда.Дата <  &Дата2
	 |	И РегистрацияПроезда.ПометкаУдаления = Ложь
	 //|	И РегистрацияПроезда.Контрагент = &Контрагент
	 |ORDER BY Номенклатура,Дата,Номер
	 |";
	
	
				   Запрос.УстановитьПараметр("Дата1",Дата1);
				   Запрос.УстановитьПараметр("Дата2",Дата2+1);
				   Запрос.УстановитьПараметр("КА",Контрагент);
				   //Запрос.УстановитьПараметр("Дог",ТекДоговор);
				   
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьТАБ(Контрагент,ТекДоговор, Дата1, Дата2) Экспорт
	
	Таб = Новый ТабличныйДокумент;
	Таб.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Реестр";
	
	ТБл = Данные(Контрагент,ТекДоговор, Дата1, Дата2);
	Если ТБл.КОличество()=0 ТОгда Возврат Таб; Конецесли;
	СткШапка = СткШапка(Контрагент,Дата2,ТБл[0].Номенклатура);  
	
	Макет = ПолучитьМакет("Макет");
	
	Обл = макет.ПолучитьОбласть("Шапка");
	Обл.Параметры.Заполнить(СткШапка);
	Если НачалоМЕсяца(Дата1)<>НачалоДня(Дата1) 
		или КонецМЕсяца(Дата2)<>КонецДня(Дата2) Тогда
    	Обл.Параметры.Месяц = Формат(Дата1,"ДФ=dd.MM.yyyy")+" - "+Формат(Дата2,"ДФ=dd.MM.yyyy");
	КонецЕсли;
	Таб.Вывести(Обл);
	
	Обл = макет.ПолучитьОбласть("Строка");
	облНом = макет.ПолучитьОбласть("Строка1");
	//пНомен = Неопределено;
	Ном = 0;
	ТблНом = Тбл.Скопировать(,"Номенклатура,Сумма,СуммаСНДС,Масса");
	ТблНом.Свернуть("Номенклатура", "Сумма,СуммаСНДС,Масса");
	ТблНом.Сортировать("Номенклатура");
	Для Каждого СтрНом Из ТблНом Цикл
				
		//Если ТблНом.Количество()>1 И пНомен<>Стр.Номенклатура Тогда
		//	облНом.Параметры.Заполнить(Стр);
		//	Таб.Вывести(облНом);
		//	пНомен = Стр.Номенклатура;			 			
		//КонецЕСЛИ;
		
		Если ТблНом.Количество()>1  Тогда
			облНом.Параметры.Заполнить(СтрНом);
			Таб.Вывести(облНом);
			//пНомен = Стр.Номенклатура;			 			
		КонецЕСЛИ;
		              
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", СтрНом.Номенклатура);
		масСтр = Тбл.НайтиСтроки(Отбор);
		Для каждого Стр из масСтр Цикл						
			Ном = Ном+1;
			Обл.Параметры.Заполнить(Стр);
			Обл.Параметры.Ном = Ном;
			Таб.Вывести(Обл);
		КонеЦЦикла;
		
		Если ТблНом.Количество()>1  Тогда		
		    ОблИтНом = макет.ПолучитьОбласть("ИтогоНом");
			ОблИтНом.Параметры.Заполнить(СтрНом);  
			облИтНом.Параметры.СуммаСНДС = ОКР(СтрНом.Сумма*глСтавкаНДС(Дата2),2,1);
		    Таб.Вывести(ОблИтНом);
	    КонецЕсли;
		
	КонеЦЦикла;

	Тбл.свернуть("","Масса,Сумма,СуммаСНДС");
		
	
	Обл = макет.ПолучитьОбласть("Подвал");
	Обл.Параметры.Заполнить(СткШапка);
	Обл.Параметры.Заполнить(Тбл[0]);
	Обл.Параметры.СуммаСНДС = ОКР(ТБл[0].СУмма*глСтавкаНДС(Дата2),2,1);
	
	Если ТблНом.Количество()>1  Тогда
        Обл.Параметры.Масса = "              Х";
	КонецЕсли;
	Таб.Вывести(Обл);
	
	Таб.ПовторятьПриПечатиСтроки = таб.Область(14,,14);
	
	Таб.ТолькоПросмотр = Истина;
	Таб.ОтображатьЗаголовки = Ложь;
	Таб.ОтображатьСетку = Ложь;
	Возврат Таб;
	//Таб.Показать("Реестр");
	
КонецФункции

Функция глСтавкаНДС(дт)
	Возврат 1.2;
КонецФункции



Функция СткШапка(Контрагент,Дата,Номенклатура)
	Организация = Константы.ОсновнаяОрганизация.Получить();
	
	
	Стк = Новый Структура;
	
	СведенияОбОрганизации    = Справочники.Контрагенты.СведенияОЮрФизЛице(Организация, Дата); 
	
	Стк.Вставить("полнИмя",СведенияОбОрганизации.полнИмя);
	Стк.Вставить("НазваниеОрганизации",СведенияОбОрганизации.НазваниеОрганизации);
	Стк.Вставить("ИНН", СведенияОбОрганизации.ИНН);
	Стк.Вставить("КПП", СведенияОбОрганизации.КПП);
	Стк.Вставить("ЮридическийАдрес", СведенияОбОрганизации.ЮридическийАдрес);
	
	
	СведенияОКонтрагенте     = Справочники.Контрагенты.СведенияОЮрФизЛице(Контрагент, Дата);
	
	Стк.Вставить("НаименованиеКонтрагента", СведенияОКонтрагенте.полнИмя);
	Стк.Вставить("ИННКА", СведенияОКонтрагенте.ИНН);
	Стк.Вставить("КППКА", СведенияОКонтрагенте.КПП);
	Стк.Вставить("ЮридическийАдресКА", СведенияОКонтрагенте.ЮридическийАдрес);
	Стк.Вставить("РекБанкКА", СведенияОКонтрагенте.РекБанк);
	
	Стк.Вставить("Номер","");
	Стк.Вставить("Месяц",Формат(Дата,"ДФ='MMMM yyyy'"));
	Стк.Вставить("Дт",ФОРМат(НачалоМЕсяца(НачалоМЕсяца(Дата)-1)+25*3600*24,"ДФ=dd.MM.yyyy"));
	Стк.Вставить("Дт1",ФОРМат(НачалоМЕсяца(Дата)+24*3600*24,"ДФ=dd.MM.yyyy"));
	
	Стк.Вставить("Длж",СведенияОбОрганизации.Должность);
	Стк.Вставить("Рук",СведенияОбОрганизации.ФИОкратко);
	
	Стк.Вставить("ДлжКА",СведенияОКонтрагенте.Должность);
	Стк.Вставить("РукКА",СведенияОКонтрагенте.ФИОкратко);
	 
	
	Стк.Вставить("Номенклатура",СокрЛП(Номенклатура));
	//Стк.Вставить("Артикул",СокрЛП(Номенклатура.Артикул));
	
	Возврат Стк;
	
КонецФункции

