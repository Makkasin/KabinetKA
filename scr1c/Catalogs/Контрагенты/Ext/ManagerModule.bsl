﻿
Функция НайтиКонтрагентаПоемайл(емайл,пароль=неопределено) Экспорт   
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("емайл",НРЕГ(СокрЛП(емайл)));
	Запрос.УстановитьПараметр("пароль",пароль);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	(Контрагенты.пароль = &пароль или &пароль=неопределено)
	               | и	Контрагенты.емайл = &емайл"; 
	
	Выб = Запрос.Выполнить().Выбрать();
	Если выб.Следующий() Тогда
		Возврат выб.ссылка;
	ИНаче
		Возврат Неопределено;
	КонецЕсли;
	
	
	
КонецФункции   


Функция НайтиКонтрагентаПоLink(Link) Экспорт   
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("ссылкаНаВосстановлениеПароля",Link);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	(Контрагенты.пароль = &пароль или &пароль=неопределено)
	               | и	Контрагенты.емайл = &емайл"; 
	
	Выб = Запрос.Выполнить().Выбрать();
	Если выб.Следующий() Тогда
		Возврат выб.ссылка;
	ИНаче
		Возврат Неопределено;
	КонецЕсли;
	
	
	
КонецФункции   

Функция НайтиКонтрагентаПоТокену(Токен) Экспорт   
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Токен",Токен);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Контрагенты.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.Токен = &Токен
	               | "; 
	
	Выб = Запрос.Выполнить().Выбрать();
	Если выб.Следующий() Тогда
		Возврат выб.ссылка;
	ИНаче
		Возврат Неопределено;
	КонецЕсли;
	
	
	
КонецФункции

Функция СведенияОЮрФизЛице(ссКа,Дт) Экспорт
	
	Запрос = Новый Запрос;  
	Запрос.УстановитьПараметр("Ссылка",ссКА);
	Запрос.Текст ="ВЫБРАТЬ
	              |	Контрагенты.Наименование КАК Наименование,
	              |	Контрагенты.Наименование КАК полнИмя,
	              |	Контрагенты.Наименование КАК НазваниеОрганизации,
	              |	Контрагенты.код КАК ИНН,
	              |	Контрагенты.КПП КАК КПП,
	              |	Контрагенты.ЮридическийАдрес КАК ЮридическийАдрес,
	              |	Контрагенты.РекБанк КАК РекБанк,
	              |	Контрагенты.Должность КАК Должность,
	              |	Контрагенты.Руководитель КАК ФИОкратко,
	              |	Контрагенты.Доверенность КАК Доверенность,
	              |	Контрагенты.Телефон КАК Телефон
	              |ИЗ
	              |	Справочник.Контрагенты КАК Контрагенты
	              |ГДЕ
	              |	Контрагенты.Ссылка = &Ссылка"; 
	
	Рез = Новый Структура();
	Тбл = Запрос.Выполнить().Выгрузить(); 
	
	Для каждого Кол из тбл.Колонки Цикл
		Рез.Вставить(кол.имя,"");
	КонецЦикла;
	
	ДЛя каждого Стр из Тбл Цикл
		ЗаполнитьЗначенияСвойств(Рез,Стр);	
		прервать;
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

Процедура ОбновитьДанныеКонтрагента(ссКА) Экспорт
	
	Стк = Новый Структура("ид",ссКА.УникальныйИдентификатор());
	
	РезСтк = глОбщий.ДанныеАПИ("KADATA",Стк);
	
	Обк = ссКА.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(Обк,резСтк);
	ЗаписатьРеквизит(обк.Должность,резСтк.РукКАДлж);
	ЗаписатьРеквизит(обк.ДолжностьРП,резСтк.РукКАДлжРП);
	ЗаписатьРеквизит(обк.Руководитель,резСтк.РукКА);
	ЗаписатьРеквизит(обк.РуководительРП,резСтк.РукКАРП);
	ЗаписатьРеквизит(обк.Доверенность,резСтк.РукКАОсн);

	
	обк.Записать();
	
КонецПроцедуры  

Процедура ЗаписатьРеквизит(Рек,зн)
	Если ЗначениеЗаполнено(зн)=Ложь Тогда Возврат; Конецесли;
	
	Рек = Зн;
	
КонецПроцедуры