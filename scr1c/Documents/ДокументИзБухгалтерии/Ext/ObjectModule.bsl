﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Вставить содержимое обработчика.
	
	ЗАп = Движения.РасчетыЗаПроезд.Добавить(); 
	Зап.ВидДвижения=ВидДвиженияНакопления.Приход;
	Зап.Период = Дата;
	Зап.Договор = Договор;
	Зап.Контрагент = Контрагент; 
	Зап.сумма = Сумма;
	
	Движения.РасчетыЗаПроезд.Записать();	
	
КонецПроцедуры
