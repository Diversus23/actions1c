#Использовать logos

// BSLLS:ExportVariables-off
// Скрипт запущен на Windows
Перем ЭтоWindows Экспорт;
// Лог приложения
Перем Лог Экспорт;
// Текущий уровень лога приложения
Перем ЛогПриложения Экспорт;
// Главное приложение запуска
Перем Приложение Экспорт;
// Замеры времени
Перем Замеры Экспорт;
// BSLLS:ExportVariables-on

//	Возвращает идентификатор лога приложения
//
// Возвращаемое значение:
//   Строка   - Значение идентификатора лога приложения
//
Функция ИмяЛогаСистемы() Экспорт
	
	Возврат "oscript.app." + ИмяПриложения();
	
КонецФункции // ИмяЛогаСистемы

//	Возвращает текущую версию продукта
//
// Возвращаемое значение:
//   Строка   - Значение текущей версии продукта
//
Функция Версия() Экспорт
	
	Версия = "0.5.1";
	Возврат Версия;
	
КонецФункции // ВерсияПродукта()

// Возвращает имя продукта
//
//  Возвращаемое значение:
//   Строка - имя продукта
//
Функция ИмяПриложения() Экспорт
	
	Возврат "actions";
	
КонецФункции

// Имя файла настроек по умолчанию
//
// Возвращаемое значение:
//   Строка - settings.json
//
Функция ИмяФайлаНастроек() Экспорт
	
	Возврат "settings.json";
	
КонецФункции

// Описание приложения
//
// Возвращаемое значение:
//   Строка - описание приложения
//
Функция ОписаниеПриложения() Экспорт
	
	Возврат СтрШаблон("%1 %2", 
		"Программная среда CI/CD для платформы 1С и не только. Позволяет выполнять сборку, доставку, тестирование ПО",
		"и многое из того, что может понадобиться в DevOps");
	
КонецФункции

// Возвращает лог приложения
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция ПолучитьЛог() Экспорт
	
	Возврат Лог();
	
КонецФункции

// Функция - возвращает текущий уровень лога приложения
//
// Возвращаемое значение:
//  Строка      - текущий уровень лога приложения
//
Функция УровеньЛога() Экспорт

	Возврат ЛогПриложения.Уровень();

КонецФункции // УровеньЛога()

// Функция - форматирует для лога вывод
//
// Возвращаемое значение:
//  Строка      - отформатированная строка вывода сообщения
//
Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

// Процедура - включает режим отладки
//
// Параметры:
//	РежимОтладки    - Булево     - Истина - включить режим отладки
//
Процедура УстановитьРежимОтладки(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда		
		Лог().УстановитьУровень(УровниЛога.Отладка);
	КонецЕсли;
	
КонецПроцедуры // УстановитьРежимОтладки()

// Функция - при необходимости, инициализирует и возвращает объект управления логированием
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция Лог() Экспорт
	
	Если ЛогПриложения = Неопределено Тогда
		ЛогПриложения = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
		ЛогПриложения.УстановитьРаскладку(ЭтотОбъект);
	КонецЕсли;	

	Возврат ЛогПриложения;

КонецФункции // Лог()

// Функция - возвращает имя лога приложения
//
// Возвращаемое значение:
//  Строка      - имя лога приложения
//
Функция ИмяЛогаПриложения() Экспорт

	Возврат "oscript.app." + ИмяПриложения();

КонецФункции // ИмяЛогаПриложения()