﻿
&НаСервереБезКонтекста
Процедура ОбновитьДанныеНаСервере(ссКА)
	// Вставить содержимое обработчика.
	Справочники.Контрагенты.ОбновитьДанныеКонтрагента(ссКА);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)  
	ссКА = Элементы.Список.ТекущаяСтрока;
	ОбновитьДанныеНаСервере(ссКА);  
	ОповеститьОбИзменении(ссКА);
КонецПроцедуры
