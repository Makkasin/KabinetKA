﻿Функция фрмГосНомер(Зн) Экспорт
	
	пЗн = СтрЗаменить(Зн," ","");
	пЗН = ТрансЛит(пЗН);
	
	
	Возврат пЗн;
	
КонецФункции    

// @strict-types
Функция ТрансЛит(текСтр)
	
	рез = ВРЕГ(текСтр);
	рез = СтрЗаменить(рез,"A","А");
	рез = СтрЗаменить(рез,"B","В");
	рез = СтрЗаменить(рез,"C","С");
	рез = СтрЗаменить(рез,"E","Е");
	рез = СтрЗаменить(рез,"H","Н");
	рез = СтрЗаменить(рез,"K","К");
	рез = СтрЗаменить(рез,"M","М");
	рез = СтрЗаменить(рез,"N","И");
	рез = СтрЗаменить(рез,"O","О");
	рез = СтрЗаменить(рез,"P","Р");
	рез = СтрЗаменить(рез,"T","Т");
	рез = СтрЗаменить(рез,"X","Х");
	
	вОЗВРАТ Рез;
	
	
КонецФункции
