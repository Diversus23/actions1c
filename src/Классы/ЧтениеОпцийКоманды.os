Перем Команда; // КомандаПрилижения   - команда приложения, для которой выполняется чтение параметров
Перем ОпцииИзФайлов; // Соответствие        - значения опций, прочитанные из переданных файлов параметров

Перем Лог; // логгер

#Область ПрограммныйИнтерфейс

// Функция - возвращает значение опции по ее имени
//
// Параметры:
//   ИмяОпции                - Строка    - имя опции для которой получается значение
//	 ОшибкаЕслиНеЗаполнено	 - Булево	 - Истина - выдавать ошибку, если опция не заполнена;
//                                         Ложь - не выдавать ошибку
//   ЗначениеПоУмолчанию    - Произвольный - Если значение опции не будет найдено, то присвоится это значение.
//
// Возвращаемое значение:
//   Произвольный    - значение опции
//
Функция ЗначениеОпции(Знач ИмяОпции, Знач ОшибкаЕслиНеЗаполнено = Ложь, Знач ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	ЗначениеОпции = Команда.ЗначениеОпции(ИмяОпции);
	
	Если ТипЗнч(ЗначениеОпции) = Тип("Булево") И ЗначениеОпции = Ложь Тогда
		ЗначениеИзФайла = ОпцииИзФайлов[ИмяОпции];
		
		Если ЗначениеЗаполнено(ЗначениеИзФайла) Тогда
			ЗначениеОпции = ЗначениеИзФайла;
		КонецЕсли;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ЗначениеОпции) Тогда
		ЗначениеОпции = ОпцииИзФайлов[ИмяОпции];
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ЗначениеОпции) И ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
		ЗначениеОпции = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЗначениеОпции) И ОшибкаЕслиНеЗаполнено = Истина Тогда		
		Опция = Команда.ОпцияИзИндекса(ИмяОпции);	
		ПредставлениеОпции = Опция.НаименованияПараметров[0];
		СинонимыОпции = СтрСоединить(Опция.НаименованияПараметров, ", ");
		ТекстОшибки = "Опция ""%1"" должна быть указана (синонимы: %2). Описание: %3";
		ОбщегоНазначения.ЗавершениеРаботыОшибка(ТекстОшибки, ПредставлениеОпции, СинонимыОпции, Опция.Описание);
	КонецЕсли; 
	
	Возврат ЗначениеОпции;
	
КонецФункции // ЗначениеПараметра()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Процедура - выполняет чтение файлов со значениями параметров
//
// Параметры:
//   ЗначенияПараметров    - Соответствие    - (возвр.) прочитанные параметры
//   ФайлыПараметров       - Массив          - массив строк путей к файлам параметров, разделенные
//	 Команда			   - КомандаПриложения    - команда, параметры которой считываются из файлов
//
Процедура ПрочитатьФайлыПараметров(ЗначенияПараметров, Знач ФайлыПараметров, Знач Команда)
	
	Если НЕ ТипЗнч(ЗначенияПараметров) = Тип("Соответствие") Тогда
		ЗначенияПараметров = Новый Соответствие();
	КонецЕсли;
	
	Для Каждого ИмяФайла Из ФайлыПараметров Цикл
		
		Лог.Отладка("Чтение файла параметров ""%1""", ИмяФайла);
		
		ВремФайл = Новый Файл(ИмяФайла);
		
		Если НЕ (ВремФайл.Существует() И ВремФайл.ЭтоФайл()) Тогда
			Лог.Отладка("Файл параметров ""%1"" не найден. Продолжаем работу", ИмяФайла);
			Продолжить;
		КонецЕсли;
		
		Попытка
			
			НастройкиИзФайла = ОбщегоНазначения.ПрочитатьФайлJSON(ИмяФайла);
			
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = СтрШаблон("Ошибка чтения файла параметров ""%1"":%2%3",
					ИмяФайла,
					Символы.ПС,
					ТекстОшибки);
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		
		ДополнитьОпцииИзФайлаНастроек(ЗначенияПараметров, Команда, НастройкиИзФайла);
		
		ТипПараметров = ТипЗнч(ЗначенияПараметров);
		Если НЕ ТипПараметров = Тип("Соответствие") Тогда
			ТекстОшибки = СтрШаблон("Некорректная структура файла параметров ""%1"" - %2, ожидалось ""Соответствие"".",
					ИмяФайла,
					ТипПараметров);
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПрочитатьФайлыПараметров()

Процедура ДополнитьОпцииИзФайлаНастроек(ЗначенияПараметров, Знач Команда, Знач НастройкиИзФайла)
		
	// Получаем настройки из файла settings.json секций комманд, которые есть
	// Если задана команда "zip add", то сначала считаем из секции zip, потом из секции add
	// {"zip":{"param1":"value1", "add": {"param2":"value2"}} => param1 равен value1, param2 равен value2
	МассивКоманд = ОбщегоНазначения.РодительскиеКоманды(Команда);
	НастройкиКоманды = ПолучитьИерархическиеНастройки(НастройкиИзФайла, СтрСоединить(МассивКоманд, "."));
	
	// Получаем настройки из файла settings.json секции  default
	КлючПоУмолчанию = "default";
	НастройкиПоУмолчанию = ПолучитьИерархическиеНастройки(НастройкиИзФайла, КлючПоУмолчанию);

	ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, НастройкиКоманды);
	ДополнитьСоответствиеСУчетомПриоритета(ЗначенияПараметров, НастройкиПоУмолчанию);
	
	Для Каждого Элемент Из ЗначенияПараметров Цикл
		Лог.Отладка("Получен параметр из файла настроек <%1> = <%2>", Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
КонецПроцедуры // ДополнитьОпцииИзФайлаНастроек

// BSLLS:CognitiveComplexity-off

Процедура ДополнитьСоответствиеСУчетомПриоритета(КоллекцияОсновная, Знач КоллекцияДоп)
		
	Для Каждого Элемент Из КоллекцияДоп Цикл
		Значение = КоллекцияОсновная.Получить(Элемент.Ключ);
		Если Значение = Неопределено Тогда
			КоллекцияОсновная.Вставить(Элемент.Ключ, Элемент.Значение);
		Иначе
			Если ТипЗнч(Значение) = Тип("Булево") И НЕ Значение Тогда

				// Это строка
				ЭтоИстина = ТипЗнч(Элемент.Значение) = Тип("Строка") 
					И (Элемент.Значение = "1" 
					ИЛИ НРег(Элемент.Значение) = "истина" 
					ИЛИ НРег(Элемент.Значение) = "true");
				Если ЭтоИстина Тогда
					КоллекцияОсновная.Вставить(Элемент.Ключ, Истина);
				КонецЕсли;

				// Это Булево
				Если ТипЗнч(Элемент.Значение) = Тип("Булево") И Элемент.Значение Тогда
					КоллекцияОсновная.Вставить(Элемент.Ключ, Истина);
				КонецЕсли;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ДополнитьСоответствиеСУчетомПриоритета

// BSLLS:CognitiveComplexity-on

Функция ПолучитьИерархическиеНастройки(Знач Настройки, Знач Адрес)
	
	мНастройки = Настройки;
	Результат = Новый Соответствие();
	
	Массив = СтроковыеОперации.РазложитьСтрокуВМассивПодстрок(Адрес, ".", Истина);
	Для Индекс = 0 По Массив.Количество() - 1 Цикл
		ИмяНастройки = Массив[Индекс];
		Если мНастройки.Получить(ИмяНастройки) <> Неопределено Тогда
			мНастройки = мНастройки.Получить(ИмяНастройки);
			Для Каждого Настройка Из мНастройки Цикл
				Если ТипЗнч(Настройка.Значение) = Тип("Соответствие") 
					ИЛИ ТипЗнч(Настройка.Значение) = Тип("Структура") Тогда

					Продолжить;
					
				КонецЕсли;
				Результат.Вставить(Настройка.Ключ, Настройка.Значение);
			КонецЦикла;
		Иначе
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

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
		
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
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
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда
		КоличествоДефисов = 2;
		Для Каждого ИмяСинонима Из ОписаниеПараметра.НаименованияПараметров Цикл
			ИмяОпции = ?(Лев(ИмяСинонима, КоличествоДефисов) = "--", Сред(ИмяСинонима, КоличествоДефисов + 1), ИмяСинонима);
			Значение = ОпцииИзФайлов[ИмяОпции];
			Если ЗначениеЗаполнено(Значение) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Результат.Вставить("ЭтоОпция", ЭтоОпция);
	Результат.Вставить("Описание", ОписаниеПараметра);
	Результат.Вставить("Проверять", ПроверятьЗаполнение);
	Результат.Вставить("Значение", Значение);
	
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
			Текст = СтрШаблон("Для команды ""%1"" не заполнены параметры %2",
				ТекКоманда.ПолучитьИмяКоманды(),
				СтрСоединить(НезаполненныеПараметрыКоманды, ", "));
			НезаполненныеПараметры.Добавить(Текст);
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
	ФайлыПараметров = ОбщегоНазначения.ПолучитьФайлыНастроек(Команда);
	ПрочитатьФайлыПараметров(ОпцииИзФайлов, ФайлыПараметров, Команда);
	
	ПроверитьЗаполнениеОбязательныхПараметров();
	
КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий