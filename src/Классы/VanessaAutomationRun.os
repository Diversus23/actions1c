﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
		
	// Добавление дополнительных опций
	ПараметрыОпций = Работа1С.КонструкторТестированиеВанесса();
	Работа1С.ОписаниеКоманды(Команда, ПараметрыОпций);

	Команда.Опция("path p", "",
		"Путь для запуска тестов. Можно указывать как каталог с фичами, так и конкретную фичу (не обязательный)")
		.ТСтрока();

	Команда.Опция("pathvanessa pathepf e", "",
		"Путь к epf-файлу Vanessa Automation для загрузки ИБ (обязательный)")
		.ТСтрока();
	
	Команда.Опция("vanessasettings vs", "",
		"Путь к файлу настроек фреймворка тестирования. Как правило это ""VAParams.json"" (обязательный)")
		.ТСтрока();

	Команда.Опция("workspace w", "",
		"Путь к папке, относительно которой будут определятся макросы $workspace. По умолчанию текущий (не обязательный)")
		.ТСтрока();

	Команда.Опция("tagsignore ti", "",
		"Теги игнорирования фича-файлов (не обязательный)")
		.ТСтрока();

	Команда.Опция("tagsfilter tf", "",
		"Теги отбор фича-файлов (не обязательный)")
		.ТСтрока();

	Команда.Опция("additionalkeys addkeys ak", "",
		"Дополнительные параметры, передаваемые в параметр /С (не обязательный)")
		.ТСтрока();		

	Команда.Опция("nowait", "",
		"Не ожидать завершения запущенной команды/действия (не обязательный)")
		.ТБулево();		

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Лог = ПараметрыСистемы.Лог();
	Лог.Информация("Начало тестирования vanessa automation");
	Параметры = ПолучитьСтруктуруПараметров(Команда);
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора();
	МенеджерКонфигуратора.Инициализация(Параметры);
	Попытка
		МенеджерКонфигуратора.ВыполнитьТестированиеVanessaAutomation(Параметры.ПутьКФичам,
			Параметры.РабочийКаталогПроекта,
			Параметры.ИмяФайлаНастроек,
			Параметры.ПутьВанесса,
			Параметры.ЗапускатьТолстыйКлиент, 
			Параметры.ОжидатьЗавершения,
			"",
			Параметры.ТегиИгнорирования,
			Параметры.ТегиФильтр,
			Параметры.ДопКлючи,
			Параметры.КаталогКонтроляОткрытыхПриложений);	
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Завершение тестирования по исключению: %1", ОписаниеОшибки());
	КонецПопытки;
	МенеджерКонфигуратора.Деструктор();
	Лог.Информация("Завершение тестирования");
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);
	
	ПараметрыОпций = Работа1С.КонструкторТестированиеВанесса();

	ПараметрыКоманды = Работа1С.ПрочитатьПараметры(Команда, ПараметрыОпций);
	ПараметрыКоманды.Вставить("ПутьВанесса", ЧтениеОпций.ЗначениеОпции("pathvanessa", Истина));
	ПараметрыКоманды.Вставить("РабочийКаталогПроекта", ЧтениеОпций.ЗначениеОпции("workspace", Истина));
	ПараметрыКоманды.Вставить("ИмяФайлаНастроек", ЧтениеОпций.ЗначениеОпции("vanessasettings", Истина));

	ПараметрыКоманды.Вставить("ПутьКФичам", ЧтениеОпций.ЗначениеОпции("path", Ложь));		
	ПараметрыКоманды.Вставить("ОжидатьЗавершения", ЧтениеОпций.ЗначениеОпции("nowait", Ложь, Истина));	
	ПараметрыКоманды.Вставить("ТегиИгнорирования", ЧтениеОпций.ЗначениеОпции("tagsignore", Ложь));	
	ПараметрыКоманды.Вставить("ТегиФильтр", ЧтениеОпций.ЗначениеОпции("tagsfilter", Ложь));
	ПараметрыКоманды.Вставить("ДопКлючи", ЧтениеОпций.ЗначениеОпции("additionalkeys", Ложь));	

	Если НЕ ФайловыеОперации.КаталогСуществует(ПараметрыКоманды.РабочийКаталогПроекта) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Рабочий каталог проекта <%1> не найден",
			ПараметрыКоманды.РабочийКаталогПроекта);
	КонецЕсли;
	Если НЕ ФайловыеОперации.ФайлСуществует(ПараметрыКоманды.ИмяФайлаНастроек) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Файл с настройками <%1> не найден",
			ПараметрыКоманды.ИмяФайлаНастроек);
	КонецЕсли;
	ПараметрыКоманды.ИмяФайлаНастроек = ОбщегоНазначения.ПолныйПуть(ПараметрыКоманды.ИмяФайлаНастроек);
	ПараметрыКоманды.РабочийКаталогПроекта = ОбщегоНазначения.ПолныйПуть(ПараметрыКоманды.РабочийКаталогПроекта);
	ПараметрыКоманды.ПутьВанесса = ОбщегоНазначения.ПолныйПуть(ПараметрыКоманды.ПутьВанесса);

	ПутьКФичам = "";
	Если ЗначениеЗаполнено(ПараметрыКоманды.ПутьКФичам) Тогда
		ПутьКФичам = ПараметрыКоманды.ПутьКФичам;

		Если ПараметрыКоманды.Свойство("РежимЗапуска") Тогда
 			Ожидаем.Что(ПараметрыКоманды.РежимЗапуска = 1,
				"Нельзя одновременно указывать ключи запуска --ordinaryapp 1 и --path ПутьХХХ,
				|	т.к. Vanessa в толстом клиенте для обычных форм не поддерживает указание фич через командную строку.")
				.ЭтоЛожь();
		КонецЕсли;
	КонецЕсли;
	ПараметрыКоманды.ПутьКФичам = ПутьКФичам;
	ПараметрыКоманды.Вставить("ЗапускатьТолстыйКлиент", 
		ПараметрыКоманды.Свойство("РежимЗапуска") И ПараметрыКоманды.РежимЗапуска = 1);

	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции