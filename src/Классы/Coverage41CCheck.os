﻿#Использовать 1connector

#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("infobase i", "",
		"Имя информационной базы. По умолчанию DefAlias (не обязательный)")
		.ТСтрока();

	Команда.Опция("debugger u", "",
		"Адрес отладчика. Пример: http://localhost:1550 (обязательный)")
		.ТСтрока();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	Лог.Информация("Запуск Coverage41C");

	Параметры = ПолучитьСтруктуруПараметров(Команда);	
	ПутьКПриложению = ОбщегоНазначения.НайтиПриложениеВСистеме("Coverage41C");
	Если ПараметрыСистемы.ЭтоWindows И НЕ СтрЗаканчиваетсяНа(НРег(ПутьКПриложению), ".bat") Тогда
		ПутьКПриложению = ПутьКПриложению + ".bat";
	КонецЕсли;
	Массив = Новый Массив();
	Массив.Добавить(ФайловыеОперации.ОбернутьПутьВКавычки(ПутьКПриложению));
	Массив.Добавить("check");
	Массив.Добавить("-i " + ФайловыеОперации.ОбернутьПутьВКавычки(Параметры.ИнформационнаяБаза));
	Массив.Добавить("-u " + ФайловыеОперации.ОбернутьПутьВКавычки(Параметры.Отладчик));

	СтрокаЗапуска = СтрСоединить(Массив, " ");
	Процесс = СоздатьПроцесс(СтрокаЗапуска, "./", Истина, Истина);
	Процесс.Запустить();
	Идентификатор = Процесс.Идентификатор;

	ТаймаутПоУмолчанию = 5000;
	Приостановить(ТаймаутПоУмолчанию);
	
	ТекстОстановки = Процесс.ПотокВывода.Прочитать();
	Если СтрНайти(ТекстОстановки, "error") <> 0 Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Ошибка запуска приложения Coverage41C: %1", ТекстОстановки);
	КонецЕсли;

	ОбщегоНазначения.ЗаписатьНастройкуВФайл(Параметры.ИмяФайла, "pid", Идентификатор);
	Лог.Информация("Запуск Coverage41C выполнен");

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;	
	ПараметрыКоманды.Вставить("ИнформационнаяБаза", ЧтениеОпций.ЗначениеОпции("infobase", Ложь, "DefAlias"));
	ПараметрыКоманды.Вставить("Отладчик", ЧтениеОпций.ЗначениеОпции("debugger", Истина));

	Возврат ПараметрыКоманды;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции