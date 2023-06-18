Перем Команда;          // КомандаПрилижения   - команда приложения, для которой выполняется чтение параметров
Перем ОпцииИзФайлов;    // Соответствие        - значения опций, прочитанные из переданных файлов параметров

Перем Лог;              // логгер

#Область ПрограммныйИнтерфейс

// Функция - возвращает значение опции по ее имени
//
// Параметры:
//   ИмяОпции                - Строка    - имя опции для которой получается значение
//	 ОшибкаЕслиНеЗаполнено	 - Булево	 - Истина - выдавать ошибку, если опция не заполнена;
//                                         Ложь - не выдавать ошибку
//   ОпцияКомандыРодителя    - Булево    - Истина - использовать значение опции родительской команды;
//                                         Ложь - использовать значение опции команды
//
// Возвращаемое значение:
//   Произвольный    - значение опции
//
Функция ЗначениеОпции(Знач ИмяОпции, Знач ОшибкаЕслиНеЗаполнено = Ложь, Знач ОпцияКомандыРодителя = Ложь) Экспорт

	Если ОпцияКомандыРодителя Тогда
		ЗначениеОпции = Команда.ЗначениеОпцииКомандыРодителя(ИмяОпции);
	Иначе
		ЗначениеОпции = Команда.ЗначениеОпции(ИмяОпции);
	КонецЕсли;

	Если ТипЗнч(ЗначениеОпции) = Тип("Булево") И ЗначениеОпции = Ложь Тогда
		ЗначениеИзФайла = ОпцииИзФайлов[ИмяОпции];

		Если ЗначениеЗаполнено(ЗначениеИзФайла) Тогда
			ЗначениеОпции = ЗначениеИзФайла;
		КонецЕсли;

	ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеОпции) Тогда
		ЗначениеОпции = ОпцииИзФайлов[ИмяОпции];
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ЗначениеОпции) И ОшибкаЕслиНеЗаполнено = Истина Тогда
		
		Если СтрДлина(ИмяОпции) = 1 Тогда
			ПредставлениеОпции = "-" + ИмяОпции;
		Иначе
			ПредставлениеОпции = "--" + ИмяОпции;
		КонецЕсли;
		ТекстОшибки = СтрШаблон("Опция ""%1"" должна быть указана", ПредставлениеОпции);
		ОбщегоНазначения.СистемноеЗавершениеРаботыОшибка(ТекстОшибки);
	КонецЕсли;

	Возврат ЗначениеОпции;

КонецФункции // ЗначениеПараметра()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Процедура - выполняет чтение файлов со значениями параметров
//
// Параметры:
//   ЗначенияПараметров    - Соответствие    - (возвр.) прочитанные параметры
//   ФайлыПараметров       - Строка          - пути к файлам параметров, разделенные ";"
//
Процедура ПрочитатьФайлыПараметров(ЗначенияПараметров, Знач ФайлыПараметров)

	Если НЕ ТипЗнч(ЗначенияПараметров) = Тип("Соответствие") Тогда
		ЗначенияПараметров = Новый Соответствие();
	КонецЕсли;

	ФайлыПараметров = СтрРазделить(ФайлыПараметров, ";", Ложь);

	Для Каждого ТекФайл Из ФайлыПараметров Цикл

		Лог.Отладка("Чтение файла параметров ""%1""", ТекФайл);

		ВремФайл = Новый Файл(ТекФайл);

		Если НЕ (ВремФайл.Существует() И ВремФайл.ЭтоФайл()) Тогда
			ТекстОшибки = СтрШаблон("Не найден файл параметров ""%1"".", ТекФайл);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Попытка
			Чтение = Новый ЧтениеJSON();
			Чтение.ОткрытьФайл(ТекФайл, КодировкаТекста.UTF8);
			
			ПараметрыИзФайла = ПрочитатьJSON(Чтение, Истина);
			
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = СтрШаблон("Ошибка чтения файла параметров ""%1"":%2%3",
			                        ТекФайл,
			                        Символы.ПС,
			                        ТекстОшибки);
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;

		ТипПараметров = ТипЗнч(ПараметрыИзФайла);
		Если НЕ ТипПараметров = Тип("Соответствие") Тогда
			ТекстОшибки = СтрШаблон("Некорректная структура файла параметров ""%1"" - %2, ожидалось ""Соответствие"".",
			                        ТекФайл,
			                        ТипПараметров);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Для Каждого ТекПараметр Из ПараметрыИзФайла Цикл
			ЗначенияПараметров.Вставить(ТекПараметр.Ключ, ТекПараметр.Значение);
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры // ПрочитатьФайлыПараметров()

// Функция - проверяет заполнение обязательных параметров команды
//
// Параметры:
//   ПроверяемаяКоманда    - КомандаПриложения    - команда, параметры которой проверяются
//
// Возвращаемое значение:
//   Массив из Строка    - массив ошибок заполнения обязательных параметров
//
Функция НезаполненныеПараметрыКоманды(Знач ПроверяемаяКоманда)

	НезаполненныеПараметрыКоманды = Новый Массив();

	СписокПараметров = ПроверяемаяКоманда.ПараметрыКоманды();

	ОбработанныеПараметры = Новый Соответствие();

	Для Каждого ТекЭлемент Из СписокПараметров Цикл

		Если ОбработанныеПараметры.Получить(ТекЭлемент.Ключ) = Истина Тогда
			Продолжить;
		КонецЕсли;

		ОписаниеПараметра = ОписаниеПараметраКоманды(ПроверяемаяКоманда, ТекЭлемент.Ключ);

		Если НЕ ОписаниеПараметра.Проверять Тогда
			Продолжить;
		КонецЕсли;

		Значение = ОписаниеПараметра.Значение;

		Если Не ЗначениеЗаполнено(Значение) Тогда
			Синонимы = Новый Массив();
			Если ОписаниеПараметра.ЭтоОпция Тогда
				Для Каждого ИмяСинонима Из ОписаниеПараметра.Описание.НаименованияПараметров Цикл
					Синонимы.Добавить(ИмяСинонима);
					ОбработанныеПараметры.Вставить(ИмяСинонима, Истина);
				КонецЦикла;
			Иначе
				Синонимы.Добавить(ТекЭлемент.Ключ);
			КонецЕсли;
			НезаполненныеПараметрыКоманды.Добавить(СтрШаблон("""%1""", СтрСоединить(Синонимы, " ")));
		КонецЕсли;

	КонецЦикла;

	Возврат НезаполненныеПараметрыКоманды;

КонецФункции // НезаполненныеПараметрыКоманды()

// Функция - получает описание параметра команды
//
// Параметры:
//   ПроверяемаяКоманда    - КомандаПриложения    - команда, для которой получаем описание параметра
//   Параметр              - Строка               - имя параметра
//
// Возвращаемое значение:
//   Структура    - описание параметра команды
//
Функция ОписаниеПараметраКоманды(ПроверяемаяКоманда, Параметр)

	Результат = Новый Структура();

	ЭтоОпция = Лев(Параметр, 1) = "-";
	Если ЭтоОпция Тогда
		ОписаниеПараметра = ПроверяемаяКоманда.ОпцияИзИндекса(Параметр);
		Значение = ПроверяемаяКоманда.ЗначениеОпции(Параметр);
	Иначе
		ОписаниеПараметра = ПроверяемаяКоманда.АргументИзИндекса(Параметр);
		Значение = ПроверяемаяКоманда.ЗначениеАргумента(Параметр);
	КонецЕсли;

	ПроверятьЗаполнение = Истина;
	Если ОписаниеПараметра = Неопределено
		ИЛИ НЕ ОписаниеПараметра.ТребоватьУстановкиПользователем = Истина Тогда
		ПроверятьЗаполнение = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Значение) Тогда
		КоличествоДефисов = 2;
		Для Каждого ИмяСинонима Из ОписаниеПараметра.НаименованияПараметров Цикл
			ИмяОпции = ?(Лев(ИмяСинонима, КоличествоДефисов) = "--", Сред(ИмяСинонима, КоличествоДефисов + 1), ИмяСинонима);
			Значение = ОпцииИзФайлов[ИмяОпции];
			Если ЗначениеЗаполнено(Значение) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Результат.Вставить("ЭтоОпция"  , ЭтоОпция);
	Результат.Вставить("Описание"  , ОписаниеПараметра);
	Результат.Вставить("Проверять" , ПроверятьЗаполнение);
	Результат.Вставить("Значение"  , Значение);

   Возврат Результат;

КонецФункции // ОписаниеПараметраКоманды()

// Процедура - проверяет заполнение обязательных параметров команды и ее родительских команд
//
Процедура ПроверитьЗаполнениеОбязательныхПараметров()

	НезаполненныеПараметры = Новый Массив();

	ПроверяемыеКоманды = Новый Массив();

	Для Каждого ТекКоманда Из Команда.КомандыРодители Цикл
		ПроверяемыеКоманды.Добавить(ТекКоманда);
	КонецЦикла;

	ПроверяемыеКоманды.Добавить(Команда);

	Для Каждого ТекКоманда Из ПроверяемыеКоманды Цикл

		НезаполненныеПараметрыКоманды = НезаполненныеПараметрыКоманды(ТекКоманда);

		Если ЗначениеЗаполнено(НезаполненныеПараметрыКоманды) Тогда
			НезаполненныеПараметры.Добавить(СтрШаблон("Для команды ""%1"" не заполнены параметры %2",
			                                          ТекКоманда.ПолучитьИмяКоманды(),
			                                          СтрСоединить(НезаполненныеПараметрыКоманды, ", ")));
		КонецЕсли;

	КонецЦикла;

	Если ЗначениеЗаполнено(НезаполненныеПараметры) Тогда
		Команда.ВывестиСправку();
		ВызватьИсключение СтрСоединить(НезаполненныеПараметры, Символы.ПС);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеОбязательныхПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//   НоваяКоманда    - КомандаПриложения    - команда приложения для обработки
//
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Знач НоваяКоманда)

	Лог = ПараметрыСистемы.Лог();

	Команда = НоваяКоманда;

	ОпцииИзФайлов = Новый Соответствие();

	ФайлыПараметров = Команда.ЗначениеОпции("settings");

	Если ТипЗнч(ФайлыПараметров) = Тип("Строка") Тогда
		ПрочитатьФайлыПараметров(ОпцииИзФайлов, ФайлыПараметров);
	КонецЕсли;

	ПроверитьЗаполнениеОбязательныхПараметров();

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
