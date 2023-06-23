﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	РаботаFTP.ОписаниеКоманды(Команда);
	
	ШаблонСтроки = "%1 %2";
	Текст = СтрШаблон(ШаблонСтроки,
			"Директория из которой будут отправляться файлы на FTP-сервер на локальном компьютере.",
			"Пример: ""C:\Path\"" (обязательный)");
	Команда.Опция("local", "", Текст)
		.ТСтрока();
	
	Текст = СтрШаблон(ШаблонСтроки,
			"Маска файлов для отправки на сервер. Если не указана, то используется маска ""*"".",
			"Пример: ""*.txt"" (необязательный)");
	Команда.Опция("mask m", "", Текст)
		.ТСтрока();
	
	Текст = СтрШаблон(ШаблонСтроки,
			"Имя директории на FTP-сервере, куда необходимо сохранить отправляемые файлы.",
			"Если не указано, то будет сохранено в корень ""/"" (необязательный)");
	Команда.Опция("remote r", "", Текст)
		.ТСтрока();
	
	Текст = СтрШаблон(ШаблонСтроки,
			"Флаг рекурсивного копирования файлов на FTP-сервер.",
			"По умолчанию копирование выполняется только с локальной директории (необязательный)");
	Команда.Опция("recursive r", "", Текст)
		.ТБулево();
	
КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруПараметров(Команда);
	РаботаFTP.ОтправкаФайлов(СтруктураПараметров);
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
		
	ПараметрыКоманды = РаботаFTP.ПолучитьСтруктуруПараметровFTPGetPut(Команда);
	
	Если НЕ ЗначениеЗаполнено(ПараметрыКоманды.ПутьЛокально) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Не задана опция ""--local""");
	КонецЕсли;
	
	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции