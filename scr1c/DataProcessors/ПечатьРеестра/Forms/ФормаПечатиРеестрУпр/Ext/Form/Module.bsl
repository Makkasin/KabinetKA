﻿&НаСервереБезКонтекста
Функция СформироватьНаСервере(Договор,Дт1,Дт2)
	
	обр = Обработки.ПечатьРеестра.Создать();
	
	Возврат  обр.ПолучитьТАБ(Договор.владелец,Договор,НачалоДня(Дт1),КонецДня(Дт2));
	
КонецФункции


&НаКлиенте
Процедура Сформировать(Команда=Неопределено)
	Результат = СформироватьНаСервере(Договор,Дт1,Дт2);
КонецПроцедуры


&НаКлиенте
Процедура кнПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода,ВыборКварталов", ДобавитьМесяц(ТекущаяДата(),-1), ДобавитьМесяц(ТекущаяДата(),-1), ложь);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	дт1 = РезультатВыбора.НачалоПериода;
	Дт2= РезультатВыбора.КонецПериода;
	
	//Таб = Печать(РезультатВыбора.НачалоПериода);
	//Таб.Показать();


КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Док") ТОгда
		Дт1 = НачалоМесяца(Параметры.Док.Дата);
		Дт2 = КонецМесяца(Параметры.Док.Дата);
		Договор = Параметры.Док.Договор;
	КонецеслИ;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Дт1<Дата(2000,1,1) ТОгда
		Дт1 = НачалоМесяца(ТекущаяДАта());
		Дт2 = КонецМесяца(ТекущаяДАта());
	ИНАчеЕСли ЗначениеЗаполнено(Договор) ТОгда
		Сформировать();
	КонецЕслИ;
КонецПроцедуры

