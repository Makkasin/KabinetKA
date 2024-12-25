﻿Процедура УстановитьТекущегоПользователя() Экспорт
	
	текИмяПользователя = ИмяПользователя();
	Если текИмяПользователя="" Тогда
		текИмяПользователя = "<Не авторизован>";
	КонецеслИ;
	
	Запрос = новый Запрос; 
	Запрос.УстановитьПараметр("Код",текИмяПользователя);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.ссылка КАК Пользователь
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.Код = &Код";      
	Выб = Запрос.Выполнить().Выбрать();

	Если Выб.Следующий()=Ложь ТОгда
		Обк = Справочники.Пользователи.СоздатьЭлемент();
		Обк.Код = текИмяПользователя;  
		Обк.Наименование = ПолноеИмяПользователя();
		Обк.Записать();  
		ссПлз = обк.Ссылка;
	Иначе
		ссПлз = Выб.Пользователь;
	КонецесЛИ;                   
	
	ПараметрыСеанса.ТекущийПользователь = ссПлз;
	
КонецПроцедуры