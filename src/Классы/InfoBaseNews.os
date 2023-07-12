﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
			
	// Добавление дополнительных опций
	ПараметрыОпций = Работа1С.КонструкторОбщий();
	Работа1С.ОписаниеКоманды(Команда, ПараметрыОпций);
	Шаблон2 = "%1 %2";

	ТекстШаблона = СтрШаблон(Шаблон2, "Путь к %1, куда будет сохранена информация об обновлении.",
		СтрокаОшибкиФайлов() + " (не обязательный)");

	Текст = СтрШаблон(ТекстШаблона, "HTML-файлу");
	Команда.Опция("html h", "", Текст)
		.ТСтрока();

	Текст = СтрШаблон(ТекстШаблона, "текстовому файлу");
	Команда.Опция("txt t", "", Текст)
		.ТСтрока();

	Текст = СтрШаблон(Шаблон2,
		"Общий макет в конфигурации где хранится описание изменений.",
		"Необходим для создания новости. По умолчанию ""ОписаниеИзмененийСистемы"" (не обязательный)");
	Команда.Опция("maket m", "", Текст)
		.ТСтрока();

	Текст = СтрШаблон(Шаблон2,
		"Версия для создания новости.",
		"Если не задана, то будет определена последняя версия из конфигурации (не обязательный)");
	Команда.Опция("version v", "", Текст)
		.ТСтрока();

	Текст = СтрШаблон(Шаблон2,
		"Дата выхода обновления в формате ""dd.MM.yyyy"". Может быть датой в будущем (когда планируется релиз).",
		"Если не задана, то будет использована текущая дата (не обязательный)");
	Команда.Опция("date d", "", Текст)
		.ТДата("dd.MM.yyyy");

	Текст = СтрШаблон(Шаблон2,
		"Сохранить HTML-файл в полном оформлении, теги html, body и стили.",
		"Если не задана, то будет сохранено все содержимое тега body без стилей (не обязательный)");
	Команда.Опция("withstyle", "", Текст)
		.ТБулево();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Параметры = ПолучитьСтруктуруПараметров(Команда);
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора();
	МенеджерКонфигуратора.Инициализация(Параметры);
	МенеджерКонфигуратора.СохранитьИнформациюОбОбновлении(Параметры);
	МенеджерКонфигуратора.Деструктор();
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);
	
	ПараметрыОпций = Работа1С.КонструкторСозданияДистрибутива();
	ПараметрыКоманды = Работа1С.ПрочитатьПараметры(Команда, ПараметрыОпций);
	
	ПараметрыКоманды.Вставить("HTML", ЧтениеОпций.ЗначениеОпции("html"));
	ПараметрыКоманды.Вставить("TXT", ЧтениеОпций.ЗначениеОпции("txt"));
	Если НЕ ЗначениеЗаполнено(ПараметрыКоманды.HTML) И НЕ ЗначениеЗаполнено(ПараметрыКоманды.TXT) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка(СтрокаОшибкиФайлов());
	КонецЕсли;
	ПараметрыКоманды.Вставить("ИмяМакета", ЧтениеОпций.ЗначениеОпции("maket", Ложь, "ОписаниеИзмененийСистемы"));
	ПараметрыКоманды.Вставить("Версия", ЧтениеОпций.ЗначениеОпции("version"));
	ПараметрыКоманды.Вставить("Дата", ЧтениеОпций.ЗначениеОпции("date", Ложь, ТекущаяДата()));
	ПараметрыКоманды.Вставить("ВклюаяСтили", ЧтениеОпций.ЗначениеОпции("withstyle"));
	ПараметрыКоманды.ВклюаяСтили = ЗначениеЗаполнено(ПараметрыКоманды.ВклюаяСтили);
	
	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

Функция СтрокаОшибкиФайлов()
	Возврат "Необходимо заполнение одной из двух опций ""--html"" или ""--txt""";
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции